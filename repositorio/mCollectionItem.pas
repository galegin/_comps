unit mCollectionItem;

interface

uses
  Classes, SysUtils, DB,
  mCollectionItemIntf, mCollection, mModulo, mLogger,
  mConexao, mClasse, mSelect, mComando, mValue, mObjeto, mDataSet, mJson;

type
  TmCollectionItem = class;
  TmCollectionItemClass = class of TmCollectionItem;
  TmCollectionItemArray = array of TmCollectionItem;

  TmCollectionItem = class(TCollectionItem, ICollectionItemIntf)
  private
    fConexao : TmConexao;
    function GetConexao: TmConexao;
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    function GetValuesKey(AObject : TObject) : TmValueList;
    function GetValuesFiltro(AObject : TObject) : TmValueList;

    function GetValuesCollection(AObject : TObject) : TmCollectionArray;
    function GetValuesCollectionItem(AObject : TObject) : TmCollectionItemArray;
  public
    IsUpdate : Boolean;
    IsCreate : Boolean;

    constructor Create(Collection: TCollection); override;

    function ValidateKey(AObject : TObject; AFiltros : TmValueList) : TmValueList; overload;
    function ValidateKey(AFiltros : TmValueList) : TmValueList; overload;

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

function TmCollectionItem.ValidateKey(AObject : TObject; AFiltros : TmValueList) : TmValueList;
var
  vKeys : TmValueList;
  vKey : TmValue;
  vFiltro : TmValue;
  I : Integer;
begin
  Result := TmValueList.Create;

  vKeys := GetValuesKey(AObject);

  for I := 0 to AFiltros.Count - 1 do begin
    vFiltro := TmValue(AFiltros[I]);
    vKey := vKeys.IndexOf(vFiltro.Nome);
    if Assigned(vKey) and (vFiltro is TmValueBase) then
      Result.Add(vFiltro);
  end;
end;

function TmCollectionItem.ValidateKey(AFiltros : TmValueList) : TmValueList;
begin
  Result := ValidateKey(Self, AFiltros);
end;

//--

function TmCollectionItem.GetValuesKey(AObject : TObject) : TmValueList;
var
  vValues : TmValueList;
  I : Integer;
begin
  Result := TmValueList.Create;

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do
      with Items[I] do
        if (TipoField in [tfKey]) and (Items[I] Is TmValueBase) then
          Result.Add(Items[I]);
end;

function TmCollectionItem.GetValuesFiltro(AObject : TObject) : TmValueList;
var
  vValues : TmValueList;
  I : Integer;
begin
  Result := TmValueList.Create;

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do
      with Items[I] do
        if IsFiltro then
          Result.Add(Items[I]);
end;

//--

function TmCollectionItem.GetValuesCollection;
var
  vValues : TmValueList;
  I : Integer;
begin
  SetLength(Result, 0);

  if not Assigned(AObject) then
    Exit;

  vValues := TmObjeto.GetValuesObjeto(AObject, TmCollection);

  with vValues do
    for I := 0 to Count - 1 do
      if Items[I] is TmValueObj then
        with Items[I] as TmValueObj do
          if Assigned(Value) then begin
            SetLength(Result, Length(Result) + 1);
            Result[High(Result)] := Value as TmCollection;
          end;
end;

function TmCollectionItem.GetValuesCollectionItem;
var
  vValues : TmValueList;
  I : Integer;
begin
  SetLength(Result, 0);

  if not Assigned(AObject) then
    Exit;

  vValues := TmObjeto.GetValuesObjeto(AObject, TmCollectionItem);

  with vValues do
    for I := 0 to Count - 1 do
      if Items[I] is TmValueObj then
        with Items[I] as TmValueObj do
          if Assigned(Value) then begin
            SetLength(Result, Length(Result) + 1);
            Result[High(Result)] := Value as TmCollectionItem;
          end;
end;

//--

procedure TmCollectionItem.Limpar();
begin
  TmObjeto.ResetValues(Self);
  LimparDep();
end;

procedure TmCollectionItem.LimparDep();
var
  vCollectionItemArray : TmCollectionItemArray;
  vCollectionArray : TmCollectionArray;
  I : Integer;
begin
  vCollectionItemArray := GetValuesCollectionItem(Self);
  for I := Low(vCollectionItemArray) to High(vCollectionItemArray) do
    vCollectionItemArray[I].Limpar();

  vCollectionArray := GetValuesCollection(Self);
  for I := Low(vCollectionArray) to High(vCollectionArray) do
    vCollectionArray[I].Limpar();
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
  vCollectionItemArray : TmCollectionItemArray;
  vCollectionArray : TmCollectionArray;
  vFiltros : TList;
  I : Integer;
begin
  vFiltros := GetValuesFiltro(Self);

  vCollectionItemArray := GetValuesCollectionItem(Self);
  for I := Low(vCollectionItemArray) to High(vCollectionItemArray) do
    vCollectionItemArray[I].Listar(vFiltros);

  vCollectionArray := GetValuesCollection(Self);
  for I := Low(vCollectionArray) to High(vCollectionArray) do
    vCollectionArray[I].Listar(vFiltros);
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

  if (AFiltros is TmValueList) then
    AFiltros := ValidateKey(Self, AFiltros as TmValueList);

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
  vCollectionItemArray : TmCollectionItemArray;
  vCollectionArray : TmCollectionArray;
  vFiltros : TList;
  I : Integer;
begin
  vFiltros := GetValuesFiltro(Self);

  vCollectionItemArray := GetValuesCollectionItem(Self);
  for I := Low(vCollectionItemArray) to High(vCollectionItemArray) do
    vCollectionItemArray[I].Consultar(vFiltros);

  vCollectionArray := GetValuesCollection(Self);
  for I := Low(vCollectionArray) to High(vCollectionArray) do
    vCollectionArray[I].Consultar(vFiltros);
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
  vCollectionItemArray : TmCollectionItemArray;
  vCollectionArray : TmCollectionArray;
  I : Integer;
begin
  vCollectionItemArray := GetValuesCollectionItem(Self);
  for I := Low(vCollectionItemArray) to High(vCollectionItemArray) do
    with vCollectionItemArray[I] do
      if IsUpdate and IsChavePreenchida then
        Incluir();

  vCollectionArray := GetValuesCollection(Self);
  for I := Low(vCollectionArray) to High(vCollectionArray) do
    with vCollectionArray[I] do
      if IsUpdate then
        Incluir();
end;

//--

procedure TmCollectionItem.Alterar;
var
  vCmd : String;
  vKeys : TmValueList;
begin
  vKeys := GetValuesKey(Self);
  vCmd := TmComando.GetUpdate(Self, vKeys);
  Conexao.ExecComando(vCmd);
  AlterarDep();
end;

procedure TmCollectionItem.AlterarDep;
var
  vCollectionItemArray : TmCollectionItemArray;
  vCollectionArray : TmCollectionArray;
  I : Integer;
begin
  vCollectionItemArray := GetValuesCollectionItem(Self);
  for I := Low(vCollectionItemArray) to High(vCollectionItemArray) do
    with vCollectionItemArray[I] do
      if IsUpdate and IsChavePreenchida then
        Alterar();

  vCollectionArray := GetValuesCollection(Self);
  for I := Low(vCollectionArray) to High(vCollectionArray) do
    with vCollectionArray[I] do
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
  vKeys : TmValueList;
begin
  vKeys := GetValuesKey(Self);
  vCmd := TmComando.GetDelete(Self, vKeys);
  Conexao.ExecComando(vCmd);
  ExcluirDep();
end;

procedure TmCollectionItem.ExcluirDep;
var
  vCollectionItemArray : TmCollectionItemArray;
  vCollectionArray : TmCollectionArray;
  I : Integer;
begin
  vCollectionItemArray := GetValuesCollectionItem(Self);
  for I := Low(vCollectionItemArray) to High(vCollectionItemArray) do
    with vCollectionItemArray[I] do
      if IsUpdate and IsChavePreenchida then
        Excluir();

  vCollectionArray := GetValuesCollection(Self);
  for I := Low(vCollectionArray) to High(vCollectionArray) do
    with vCollectionArray[I] do
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
      with TmValue(vKeys[I]) do
        if not IsFiltro then
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