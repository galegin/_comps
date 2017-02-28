unit mCollection;

interface

uses
  Classes, SysUtils, DB, StrUtils, TypInfo, Math,
  mCollectionIntf, mConexao, mSelect, mComando, mObjeto, mDataSet,
  mClasse, mProperty, mJson;

type
  TmCollection = class;
  TmCollectionClass = class of TmCollection;

  TmCollection = class(TCollection, ICollectionIntf)
  private
    fConexao : TmConexao;
    function GetConexao: TmConexao;
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    IsUpdate : Boolean;

    procedure Limpar();

    function Listar(AFiltros : TList) : TList;

    function Consultar(AFiltros : TList) : TObject;

    procedure Incluir();

    procedure Alterar();

    procedure Excluir();

    function ListaOrdenada(ACampos : String) : TStringList;

    function GetJson() : String;
    procedure SetJson(json : String);

    function Avg(ACampo : String) : Real;
    function Max(ACampo : String) : Real;
    function Min(ACampo : String) : Real;
    function Sum(ACampo : String) : Real;
  published
    property Conexao : TmConexao read GetConexao write fConexao;
  end;

implementation

uses
  mCollectionItem;

{ TmCollection }

//--

function TmCollection.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Result := 0;
end;

function TmCollection._AddRef: Integer;
begin
  Result := 0;
end;

function TmCollection._Release: Integer;
begin
  Result := 0;
end;

//--

function TmCollection.GetConexao: TmConexao;
begin
  if not Assigned(fConexao) then
    fConexao := mConexao.Instance;
  Result := fConexao;
end;

//--

procedure TmCollection.Limpar();
var
  I : Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I] <> nil then
      with TmCollectionItem(Items[I]) do
        Limpar();

  Clear();
end;

function TmCollection.Listar(AFiltros : TList) : TList;
var
  vCollectionItem, vCollectionAdd : TmCollectionItem;
  vDataSet : TDataSet;
  vSql : String;
begin
  Result := nil;
  vCollectionItem := TmClasse.CreateObjeto(ItemClass, nil) as TmCollectionItem;
  AFiltros := vCollectionItem.ValidateKey(AFiltros);
  vSql := TmSelect.getSelect(vCollectionItem, AFiltros);
  vDataSet := vCollectionItem.Conexao.GetConsulta(vSql);
  with vDataSet do begin
    while not EOF do begin
      vCollectionAdd := Add as TmCollectionItem;
      TmDataSet.ToObject(vDataSet, vCollectionAdd);
      vCollectionAdd.ConsultarDep();
      Next;
    end;
  end;
  FreeAndNil(vCollectionItem);
end;

function TmCollection.Consultar(AFiltros : TList) : TObject;
begin
  Result := Listar(AFiltros);
end;

procedure TmCollection.Incluir();
var
  I : Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I] <> nil then
      with TmCollectionItem(Items[I]) do
        Incluir();
end;

procedure TmCollection.Alterar();
var
  I : Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I] <> nil then
      with TmCollectionItem(Items[I]) do
        Alterar();
end;

procedure TmCollection.Excluir();
var
  I : Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I] <> nil then
      with TmCollectionItem(Items[I]) do
        Excluir();
end;

//--

function TmCollection.ListaOrdenada(ACampos: String): TStringList;
var
  vCampos : TStringList;
  vDsChave : String;
  I : Integer;

  function GetDsChave(AObjeto : TObject) : String;
  var
    vValues : TmPropertyList;
    vProperty : TmProperty;
    J : Integer;
  begin
    Result := '';

    vValues := TmObjeto.GetValues(AObjeto);

    for J := 0 to vCampos.Count - 1 do begin
      vProperty := vValues.IndexOf(vCampos[J]);
      if vProperty <> nil then
        Result := Result + IfThen(Result <> '', '#', '') +
          vProperty.ValueIntegracao;
    end;
  end;

begin
  Result := TStringList.Create;

  ACampos := AnsiReplaceStr(ACampos, ';', sLineBreak);
  ACampos := AnsiReplaceStr(ACampos, '|', sLineBreak);
  ACampos := AnsiReplaceStr(ACampos, ',', sLineBreak);

  vCampos := TStringList.Create;
  vCampos.Text := ACampos;

  for I := 0 to Count - 1 do begin
    vDsChave := GetDsChave(GetItem(I));
    Result.AddObject(vDsChave, GetItem(I));
  end;

  Result.Sort;
end;

function TmCollection.GetJson: String;
begin
  Result := TmJson.CollectionToJson(Self);
end;

procedure TmCollection.SetJson(json: String);
var
  vCollection : TCollection;
  I : Integer;
begin
  Clear();

  vCollection := TmJson.JsonToCollection(ItemClass, json);

  for I := 0 to vCollection.Count - 1 do
    TmObjeto.ToObjeto(vCollection.Items[I], Add);
end;

//--

function TmCollection.Avg(ACampo : String) : Real;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    Result := Result + GetFloatProp(GetItem(I), ACampo);
  Result := IfThen(Count > 0, Result / Count, 0);
end;

function TmCollection.Max(ACampo : String) : Real;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if (I = 0) or (GetFloatProp(Items[I], ACampo) > Result) then
      Result := GetFloatProp(Items[I], ACampo);
end;

function TmCollection.Min(ACampo : String) : Real;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if (I = 0) or (GetFloatProp(Items[I], ACampo) < Result) then
      Result := GetFloatProp(Items[I], ACampo);
end;

function TmCollection.Sum(ACampo : String) : Real;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    Result := Result + GetFloatProp(Items[I], ACampo);
end;

//--

end.