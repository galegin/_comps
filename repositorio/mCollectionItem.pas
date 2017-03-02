unit mCollectionItem;

interface

uses
  Classes, SysUtils, DB,
  mCollectionItemIntf, mCollection, mModulo, mLogger,
  mConexao, mClasse, mSelect, mComando, mProperty, mObjeto, mDataSet, mJson;

type
  TmCollectionItem = class;
  TmCollectionItemClass = class of TmCollectionItem;

  TmCollectionItem = class(TCollectionItem, ICollectionItemIntf)
  private
    fConexao : TmConexao;
    function GetConexao: TmConexao;
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    function GetValuesKey(AObject : TObject) : TList;
    function GetValuesFiltro(AObject : TObject) : TList;
    //function GetValuesObjeto(AObject : TObject; AInherited : TClass) : TList; // mObjeto
  public
    IsUpdate : Boolean;
    IsCreate : Boolean;

    constructor Create(Collection: TCollection); override;

    function ValidateKey(AObject : TObject; AFiltros : TList) : TList; overload;
    function ValidateKey(AFiltros : TList) : TList; overload;

    procedure Limpar();
    procedure LimparDep();

    function Listar(AFiltros : TList) : TList;
    procedure ListarDep();

    function ConsultarAll(AFiltros : TList) : TObject;

    function Consultar(AFiltros : TList) : TObject;
    procedure ConsultarDep();

    procedure Incluir();
    procedure IncluirDep();

    procedure Alterar();
    procedure AlterarDep();

    procedure Salvar();

    procedure Excluir();
    procedure ExcluirDep();

    function IsChavePreenchida() : Boolean;

    function GetJson() : String;
    procedure SetJson(json : String);
  published
    property Conexao : TmConexao read GetConexao write fConexao;
  end;

implementation

{ TmCollection }

constructor TmCollectionItem.Create(Collection: TCollection);
begin
  inherited;
  fConexao := mModulo.Instance.Conexao;
end;

//--

function TmCollectionItem.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Result := 0;
end;

function TmCollectionItem._AddRef: Integer;
begin
  Result := 0;
end;

function TmCollectionItem._Release: Integer;
begin
  Result := 0;
end;

//--

function TmCollectionItem.GetConexao: TmConexao;
begin
  if not Assigned(fConexao) then
    fConexao := mConexao.Instance;
  Result := fConexao;
end;

//--

function TmCollectionItem.ValidateKey(AObject : TObject; AFiltros : TList) : TList;
var
  vKeys : TList;
  vKey : TmProperty;
  vFiltro : TmProperty;
  I : Integer;
begin
  Result := TList.Create;

  vKeys := GetValuesKey(AObject);

  for I := 0 to AFiltros.Count - 1 do begin
    vFiltro := TmProperty(AFiltros[I]);
    vKey := TmPropertyValue.IndexOf(vKeys, vFiltro.Nome);
    if Assigned(vKey) and vFiltro.IsValueDatabase then
      Result.Add(vFiltro);
  end;
end;

function TmCollectionItem.ValidateKey(AFiltros : TList) : TList;
begin
  Result := ValidateKey(Self, AFiltros);
end;

//--

function TmCollectionItem.GetValuesKey(AObject : TObject) : TList;
var
  vValues : TmPropertyList;
  I : Integer;
begin
  Result := TList.Create;

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do
      with Items[I] do
        if (TipoField in [tpfKey]) and IsValueDatabase then
          Result.Add(Items[I]);
end;

function TmCollectionItem.GetValuesFiltro(AObject : TObject) : TList;
var
  vValues : TmPropertyList;
  I : Integer;
begin
  Result := TList.Create;

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do
      with Items[I] do
        if IsValueFiltro then
          Result.Add(Items[I]);
end;

(* function TmCollectionItem.GetValuesObjeto(AObject : TObject; AInherited : TClass) : TList;
var
  vValues : TmPropertyList;
  I : Integer;
begin
  Result := TList.Create;

  if not Assigned(AObject) then
    Exit;
  if not (AObject is TmCollectionItem) then
    Exit;

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do
      with Items[I] do
        if IsValueObject then
          if Assigned(ValueObject) then
            if ValueObject.ClassType.InheritsFrom(AInherited) then
              Result.Add(ValueObject);
end; *)

//--

procedure TmCollectionItem.Limpar();
begin
  TmObjeto.ResetValues(Self);
  LimparDep();
end;

procedure TmCollectionItem.LimparDep();
var
  vValues : TList;
  I : Integer;
begin
  vValues := TmObjeto.GetValuesObjeto(Self, TmCollectionItem);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollectionItem(vValues[I]) do
        Limpar();

  vValues := TmObjeto.GetValuesObjeto(Self, TmCollection);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollection(vValues[I]) do
        Limpar();
end;

//--

function TmCollectionItem.Listar(AFiltros: TList): TList;
var
  vSql : String;
  vClass : TClass;
  vObject : TObject;
  vDataSet : TDataSet;
begin
  Result := TList.Create;

  vClass := Self.ClassType;

  if not Assigned(AFiltros) then
    AFiltros := GetValuesFiltro(Self);

  vSql := TmSelect.GetSelect(Self, AFiltros);
  vDataSet := Conexao.GetConsulta(vSql);
  with vDataSet do begin
    while not EOF do begin
      vObject := TmClasse.createObjeto(vClass, nil);
      TmDataSet.ToObject(vDataSet, vObject);
      Result.Add(vObject);
      Next;
    end;
  end;
end;

procedure TmCollectionItem.ListarDep();
var
  vFiltros : TList;
  vValues : TList;
  I : Integer;
begin
  vFiltros := GetValuesFiltro(Self);

  vValues := TmObjeto.GetValuesObjeto(Self, TmCollectionItem);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollectionItem(vValues[I]) do
        Listar(vFiltros);

  vValues := TmObjeto.GetValuesObjeto(Self, TmCollection);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollection(vValues[I]) do
        Listar(vFiltros);
end;

//--

function TmCollectionItem.ConsultarAll(AFiltros : TList) : TObject;
var
  vLista : TList;
begin
  Result := nil;
  vLista := Listar(AFiltros);
  if Assigned(vLista) and (vLista.Count > 0) then begin
    TmObjeto.ToObjeto(vLista[0], Self);
    Result := Self;
  end;
end;

//--

function TmCollectionItem.Consultar(AFiltros : TList): TObject;
var
  vSql : String;
  vDataSet : TDataSet;
begin
  Result := nil;

  if not Assigned(AFiltros) then
    AFiltros := GetValuesKey(Self);

  AFiltros := ValidateKey(Self, AFiltros);

  vSql := TmSelect.GetSelect(Self, AFiltros);
  vDataSet := Conexao.GetConsulta(vSql, 1);
  with vDataSet do begin
    if not IsEmpty then begin
      if IsCreate then
        Result := TmClasse.CreateObjeto(Self.ClassType, nil)
      else
        Result := Self;

      TmDataSet.ToObject(vDataSet, Result);

      if not IsCreate then
        ConsultarDep();
    end;
  end;
end;

procedure TmCollectionItem.ConsultarDep();
var
  vFiltros : TList;
  vValues : TList;
  I : Integer;
begin
  vFiltros := GetValuesFiltro(Self);

  vValues := TmObjeto.GetValuesObjeto(Self, TmCollectionItem);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollectionItem(vValues[I]) do
        Consultar(vFiltros);

  vValues := TmObjeto.GetValuesObjeto(Self, TmCollection);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollection(vValues[I]) do
        Consultar(vFiltros);
end;

//--

procedure TmCollectionItem.Incluir;
var
  vCmd : String;
begin
  vCmd := TmComando.GetInsert(Self);
  Conexao.ExecComando(vCmd);
  IncluirDep();
end;

procedure TmCollectionItem.IncluirDep;
var
  vValues : TList;
  I : Integer;
begin
  vValues := TmObjeto.GetValuesObjeto(Self, TmCollectionItem);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollectionItem(vValues[I]) do
        if IsUpdate and IsChavePreenchida then
          Incluir();

  vValues := TmObjeto.GetValuesObjeto(Self, TmCollection);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollection(vValues[I]) do
        if IsUpdate then
          Incluir();
end;

//--

procedure TmCollectionItem.Alterar;
var
  vCmd : String;
  vKeys : TList;
begin
  vKeys := GetValuesKey(Self);
  vCmd := TmComando.GetUpdate(Self, vKeys);
  Conexao.ExecComando(vCmd);
  AlterarDep();
end;

procedure TmCollectionItem.AlterarDep;
var
  vValues : TList;
  I : Integer;
begin
  vValues := TmObjeto.GetValuesObjeto(Self, TmCollectionItem);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollectionItem(vValues[I]) do
        if IsUpdate and IsChavePreenchida then
          Alterar();

  vValues := TmObjeto.GetValuesObjeto(Self, TmCollection);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollection(vValues[I]) do
        if IsUpdate then
          Alterar();
end;

//--

procedure TmCollectionItem.Salvar;
begin
  try
    IsCreate := True;

    if Consultar(nil) <> nil then
      Alterar()
    else
      Incluir();
  finally
    IsCreate := False;
  end;
end;

//--

procedure TmCollectionItem.Excluir;
var
  vCmd : String;
  vKeys : TList;
begin
  vKeys := GetValuesKey(Self);
  vCmd := TmComando.GetDelete(Self, vKeys);
  Conexao.ExecComando(vCmd);
  ExcluirDep();
end;

procedure TmCollectionItem.ExcluirDep;
var
  vValues : TList;
  I : Integer;
begin
  vValues := TmObjeto.GetValuesObjeto(Self, TmCollectionItem);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollectionItem(vValues[I]) do
        if IsUpdate and IsChavePreenchida then
          Excluir();

  vValues := TmObjeto.GetValuesObjeto(Self, TmCollection);
  for I := 0 to vValues.Count - 1 do
    if vValues[I] <> nil then
      with TmCollection(vValues[I]) do
        if IsUpdate then
          Excluir();
end;

//--

function TmCollectionItem.IsChavePreenchida: Boolean;
var
  vKeys : TList;
  I : Integer;
begin
  vKeys := GetValuesKey(Self);

  Result := vKeys.Count > 0;

  if Result then
    for I := 0 to vKeys.Count - 1 do
      with TmProperty(vKeys[I]) do
        if not IsValueFiltro then
          Result := False;
end;

//--

function TmCollectionItem.GetJson: String;
begin
  Result := TmJson.ObjectToJson(Self);
end;

procedure TmCollectionItem.SetJson(json: String);
var
  vObjeto : TObject;
begin
  vObjeto := TmJson.JsonToObject(ClassType, json);
  TmObjeto.ToObjeto(vObjeto, Self);
end;

//--

end.