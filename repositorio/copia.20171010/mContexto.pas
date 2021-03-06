unit mContexto;

(* mContexto *)

interface

uses
  Classes, SysUtils, StrUtils, DB, TypInfo, Math,
  mDatabase, mMapping, mParametro;

type
  TmContexto = class(TComponent)
  private
    FParametro: TmParametro;
    FDatabase: TmDatabase;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    function GetLista(AClass : TClass; AWhere : String = ''; AClassList : TClass = nil) : TList;
    procedure SetLista(AList : TList);
    procedure RemLista(AList : TList);

    procedure GetListaRelacao(AObjeto : TmMapping);

    function GetObjeto(AClass : TClass; AWhere : String = '') : TObject;
    procedure SetObjeto(AObjeto : TObject);
    procedure RemObjeto(AObjeto : TObject);
  published
    property Parametro : TmParametro read FParametro write FParametro;
    property Database : TmDatabase read FDatabase write FDatabase;
  end;

  function Instance() : TmContexto;
  procedure Destroy();

implementation

uses
  mComando;

var
  _instance : TmContexto;

  function Instance() : TmContexto;
  begin
    if not Assigned(_instance) then
      _instance := TmContexto.Create(nil);
    Result := _instance;
  end;

  procedure Destroy();
  begin
    if Assigned(_instance) then
      _instance.Free;
  end;

(* mContexto *)

constructor TmContexto.Create(AOwner : TComponent);
begin
  inherited;

  FParametro := TmParametro.Create;

  FDatabase := TmDatabase.Create(Self);
  FDatabase.Conexao.Parametro := FParametro;
end;

destructor TmContexto.Destroy;
begin

  inherited;
end;

//-- lista

function TmContexto.GetLista(AClass: TClass; AWhere: String; AClassList : TClass): TList;
var
  vPropInfo : PPropInfo;
  vTipoBase : String;
  vDataSet : TDataSet;
  vObject : TObject;
  vSql : String;
  I : Integer;
begin
  if AClassList <> nil then
    Result := AClassList.NewInstance as TList
  else
    Result := TList.Create;

  vSql := TmComando.GetSelect(AClass, AWhere);

  vDataSet := FDatabase.Conexao.GetConsulta(vSql);
  with vDataSet do begin
    while not EOF do begin
      vObject := TComponentClass(AClass).Create(nil);
      Result.Add(vObject);

      for I := 0 to FieldCount - 1 do
        with Fields[I] do begin
          vPropInfo := GetPropInfo(vObject, FieldName);
          vTipoBase := vPropInfo^.PropType^.Name;
          if vTipoBase = 'Boolean' then // mObjeto
            SetOrdProp(vObject, FieldName, IfThen(AsString = 'T', 1, 0))
          else if vTipoBase = 'TDateTime' then
            SetFloatProp(vObject, FieldName, AsDateTime)
          else if vTipoBase = 'Real' then
            SetFloatProp(vObject, FieldName, AsFloat)
          else if vTipoBase = 'Integer' then
            SetOrdProp(vObject, FieldName, AsInteger)
          else if vTipoBase = 'String' then
            SetStrProp(vObject, FieldName, AsString);
        end;

      if vObject is TmMapping then
        GetListaRelacao(vObject as TmMapping);

      Next;
    end;
  end;
end;

procedure TmContexto.SetLista(AList: TList);
var
  vDataSet : TDataSet;
  vSql, vCmd : String;
  I : Integer;
begin
  for I := 0 to AList.Count - 1 do begin
    vSql := TmComando.GetSelect(TObject(AList[I]));
    vDataSet := FDatabase.Conexao.GetConsulta(vSql);
    if not vDataSet.IsEmpty then
      vCmd := TmComando.GetUpdate(AList[I])
    else
      vCmd := TmComando.GetInsert(AList[I]);
    FDatabase.Conexao.ExecComando(vCmd);
  end;
end;

procedure TmContexto.RemLista(AList: TList);
var
  vCmd : String;
  I : Integer;
begin
  for I := 0 to AList.Count - 1 do begin
    vCmd := TmComando.GetDelete(AList[I]);
    FDatabase.Conexao.ExecComando(vCmd);
  end;
end;

//-- relacao

procedure TmContexto.GetListaRelacao(AObjeto: TmMapping);
var
  vMapping : PmMapping;
  vLista : TList;
  vObjeto : TObject;
  vWhere : String;
  I, J : Integer;
begin
  vMapping := AObjeto.GetMapping();

  for I := 0 to vMapping.Relacoes.Count - 1 do begin
    with PmRelacao(vMapping.Relacoes.Items[I])^ do begin

      vWhere := '';
      for J := 0 to Campos.Count - 1 do
        with PmRelacaoCampo(Campos.Items[J])^ do
          AddString(vWhere, Atributo + ' = ' + GetValueStr(AObjeto, AtributoRel), ' and ', '');

      if (ClasseLista <> nil) then begin
        vLista := GetLista(Classe, vWhere, ClasseLista);
        SetObjectProp(AObjeto, Atributo, vLista);
        for J := 0 to vLista.Count - 1 do
          if TObject(vLista[J]) is TmMapping then
            GetListaRelacao(TObject(vLista[J]) as TmMapping);

      end else begin
        vObjeto := GetObjeto(Classe, vWhere);
        SetObjectProp(AObjeto, Atributo, vObjeto);
        if vObjeto is TmMapping then
          GetListaRelacao(vObjeto as TmMapping);

      end;
    end;

  end;

  FreeMapping(vMapping);
end;

//-- objeto

function TmContexto.GetObjeto(AClass : TClass; AWhere : String) : TObject;
var
  vLista : TList;
begin
  vLista := GetLista(AClass, AWhere);
  if Assigned(vLista) and (vLista.Count > 0) then
    Result := vLista[0]
  else
    Result := nil;
end;

procedure TmContexto.SetObjeto(AObjeto : TObject);
var
  vLista : TList;
begin
  vLista := TList.Create;
  vLista.Add(AObjeto);
  SetLista(vLista);
  vLista.Free;
end;

procedure TmContexto.RemObjeto(AObjeto : TObject);
var
  vLista : TList;
begin
  vLista := TList.Create;
  vLista.Add(AObjeto);
  RemLista(vLista);
  vLista.Free;
end;

//--

initialization
  //Instance();

finalization
  Destroy();

end.
