unit mCreateEnt;

(* classe servico *)

interface

uses
  Classes, SysUtils, StrUtils,
  mCollectionMap, mProperty, mClasse, mContexto, mString;

type
  TmCreateEnt = class(TComponent)
  private
    fContexto : TmContexto;
    fClasse : TmCollectionMapClass;
    fObjeto : TmCollectionMap;
  protected
    function GetEntidade() : String;
    function GetCampos() : String;
    function GetKeys() : String;
    function GetColuna(AProperty: TmCollectionProp) : String;
    function GetTipo(AProperty: TmCollectionProp) : String;
    function GetRequerido(AProperty: TmCollectionProp) : String;
  public
    constructor Create(AOwner : TComponent); override;

    function GetCreate(
      AContexto : TmContexto;
      AClasse: TmCollectionMapClass) : String;

    function GetAlter(
      AContexto : TmContexto;
      AClasse: TmCollectionMapClass) : TmStringList;

  published
  end;

  function Instance : TmCreateEnt;

implementation

var
  _instance : TmCreateEnt;

  function Instance : TmCreateEnt;
  begin
    if not Assigned(_instance) then
      _instance := TmCreateEnt.Create(nil);
    Result := _instance;
  end;

{ TmCreateEnt }

constructor TmCreateEnt.Create;
begin
  inherited;
end;

//--

function TmCreateEnt.GetEntidade;
begin
  Result := fObjeto.Table;
end;

function TmCreateEnt.GetCampos;
var
  vComando : String;
  I : Integer;
begin
  Result := '';
  with fObjeto do
    for I := Low(Properties) to High(Properties) do
      with Properties[I] do
        if InCreate then begin
          vComando := '{coluna} {tipo} {requerido}';
          vComando := AnsiReplaceStr(vComando, '{coluna}', GetColuna(Properties[I]));
          vComando := AnsiReplaceStr(vComando, '{tipo}', GetTipo(Properties[I]));
          vComando := AnsiReplaceStr(vComando, '{requerido}', GetRequerido(Properties[I]));

          Result := Result + IfThen(Result <> '', ', ', '') + vComando;
        end;
end;

function TmCreateEnt.GetKeys;
var
  I : Integer;
begin
  Result := '';
  with fObjeto do
    for I := Low(PrimaryKeys) to High(PrimaryKeys) do
      with PrimaryKeys[I] do
        Result := Result + IfThen(Result <> '', ', ', '') + ColumnName;
end;

//--

function TmCreateEnt.GetColuna;
begin
  Result := AProperty.ColumnName;
end;

function TmCreateEnt.GetTipo;
var
  vProperties : TmPropertyList;
  I : Integer;
begin
  Result := '';

  vProperties := TmClasse.GetProperties(fObjeto.Classe);

  with vProperties do
    for I := 0 to Count - 1 do
      with Items[I] do
        if Nome = AProperty.PropName then
          Result := TipoDatabase;

  if Pos('{tamanho}', Result) > 0 then
    Result := AnsiReplaceStr(Result, '{tamanho}', IntToStr(AProperty.Length));
  if Pos('{decimal}', Result) > 0 then
    Result := AnsiReplaceStr(Result, '{decimal}', IntToStr(AProperty.Precision));
end;

function TmCreateEnt.GetRequerido;
begin
  Result := IfThen(AProperty.InRequired, 'NOT NULL', '');
end;

//--

function TmCreateEnt.GetCreate;
begin
  fContexto := AContexto;
  fClasse := AClasse;
  fObjeto := AClasse.Create(nil);

  Result := 'create table {entidade} ({campos}, constraint {entidade}P1 primary key ({keys}))';
  Result := AnsiReplaceStr(Result, '{entidade}', GetEntidade());
  Result := AnsiReplaceStr(Result, '{campos}', GetCampos());
  Result := AnsiReplaceStr(Result, '{keys}', GetKeys());
end;

function TmCreateEnt.GetAlter;
var
  vProperties : TList;
  vComando : String;
  I : Integer;

  function ExisteNome(ANome : String) : Boolean;
  var
    J : Integer;
  begin
    Result := False;
    for J := 0 to vProperties.Count - 1 do
      with TmProperty(vProperties[J]) do
        if ANome = Nome then begin
          Result := True;
          Exit;
        end;
  end;

begin
  fContexto := AContexto;
  fClasse := AClasse;
  fObjeto := AClasse.Create(nil);

  vProperties := fContexto.Conexao.Database.GetMetadata(fObjeto.Table);

  Result := TmStringList.Create;

  with fObjeto do
    for I := Low(Properties) to High(Properties) do
      with Properties[I] do
        if InCreate and not ExisteNome(ColumnName) then begin
          vComando := 'alter table {entidade} add {coluna} {tipo} {requerido}';
          vComando := AnsiReplaceStr(vComando, '{entidade}', GetEntidade());
          vComando := AnsiReplaceStr(vComando, '{coluna}', GetColuna(Properties[I]));
          vComando := AnsiReplaceStr(vComando, '{tipo}', GetTipo(Properties[I]));
          vComando := AnsiReplaceStr(vComando, '{requerido}', GetRequerido(Properties[I]));

          Result.Add(vComando);
        end;
end;

end.