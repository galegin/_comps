unit mCreateEnt;

(* classe servico *)

interface

uses
  Classes, SysUtils, StrUtils,
  mCollectionMap, mValue, mContexto, mObjeto, mClasse, mString;

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

    function GetColuna(
      AProperty: TmCollectionProp) : String;
    function GetTipo(
      AProperty: TmCollectionProp) : String;
    function GetRequerido(
      AProperty: TmCollectionProp) : String;

    function GetEntidadeForeign(
      AProperty: TmCollectionProp) : TmCollectionMap;
    function GetTabelaForeign(
      AProperty: TmCollectionProp) : String;
    function GetCamposForeign(
      AProperty: TmCollectionProp) : String;

    function GetEntidadeForeignRef(
      AProperty: TmCollectionProp) : TmCollectionMap;
    function GetTabelaForeignRef(
      AProperty: TmCollectionProp) : String;
    function GetCamposForeignRef(
      AProperty: TmCollectionProp) : String;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    function GetCreate(
      AContexto : TmContexto;
      AClasse: TmCollectionMapClass) : String;

    function GetAlter(
      AContexto : TmContexto;
      AClasse: TmCollectionMapClass) : TmStringList;

    function GetForeignKey(
      AContexto : TmContexto;
      AClasse: TmCollectionMapClass) : TmStringList;

  published
  end;

  function Instance : TmCreateEnt;
  procedure Destroy;

implementation

uses
  mCollectionItem, mCollection;

var
  _instance : TmCreateEnt;

  function Instance : TmCreateEnt;
  begin
    if not Assigned(_instance) then
      _instance := TmCreateEnt.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

{ TmCreateEnt }

constructor TmCreateEnt.Create;
begin
  inherited;

end;

destructor TmCreateEnt.Destroy;
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
  vProperties : TmValueList;
  I : Integer;
begin
  Result := '';

  vProperties := TmClasse.GetProperties(fObjeto.Classe);

  with vProperties do
    for I := 0 to Count - 1 do
      with Items[I] do
        if Nome = AProperty.PropName then
          Result := TipoBase;

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
      with TmValue(vProperties[J]) do
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

//--

function TmCreateEnt.GetEntidadeForeign;
begin
  Result := fObjeto;
end;

function TmCreateEnt.GetTabelaForeign;
var
  vCollectionMap : TmCollectionMap;
begin
  vCollectionMap := GetEntidadeForeign(AProperty);
  if Assigned(vCollectionMap) then
    Result := vCollectionMap.Table
  else
    Result := '';
end;

function TmCreateEnt.GetCamposForeign;
var
  vCollectionMap : TmCollectionMap;
  vCollectionProp : TmCollectionProp;
  I : Integer;
begin
  Result := '';
  vCollectionMap := GetEntidadeForeign(AProperty);
  if Assigned(vCollectionMap) then
    with AProperty.ForeignKeys do
      for I := 0 to Count - 1 do begin
        vCollectionProp := vCollectionMap.Propert(Items[I]);
        if Assigned(vCollectionProp) then
          Result := Result + IfThen(Result <> '', ', ') +
            vCollectionProp.ColumnName;
      end;
end;

//--

function TmCreateEnt.GetEntidadeForeignRef;
var
  vCollectionObjeto, vCollectionItem : TmCollectionItem;
begin
  Result := nil;

  vCollectionObjeto := TmCollectionItemClass(fObjeto.Classe).Create(nil);

  if Assigned(vCollectionObjeto) then begin
    vCollectionItem := TmObjeto.GetValuesObjetoName(vCollectionObjeto,
      TmCollectionItem, AProperty.PropName) as TmCollectionItem;

    if Assigned(vCollectionItem) then
      Result := fContexto.GetEntidade(vCollectionItem);
  end;
end;

function TmCreateEnt.GetTabelaForeignRef;
var
  vCollectionMap : TmCollectionMap;
begin
  vCollectionMap := GetEntidadeForeignRef(AProperty);
  if Assigned(vCollectionMap) then
    Result := vCollectionMap.Table
  else
    Result := '';  
end;

function TmCreateEnt.GetCamposForeignRef;
var
  vCollectionMap : TmCollectionMap;
  I : Integer;
begin
  Result := '';
  vCollectionMap := GetEntidadeForeignRef(AProperty);
  if Assigned(vCollectionMap) then
    with vCollectionMap do
      for I := Ord(Low(PrimaryKeys)) to Ord(High(PrimaryKeys)) do
        with PrimaryKeys[I] do
          Result := Result + IfThen(Result <> '', ', ') + ColumnName;
end;

//--

function TmCreateEnt.GetForeignKey;
var
  vTabela, vCampos, vTabelaRef, vCamposRef, vComando : String;
  I : Integer;
begin
  fContexto := AContexto;
  fClasse := AClasse;
  fObjeto := AClasse.Create(nil);

  Result := TmStringList.Create;

  with fObjeto do
    for I := Low(ForeignKeys) to High(ForeignKeys) do begin
      vTabela := GetTabelaForeign(ForeignKeys[I]);
      vCampos := GetCamposForeign(ForeignKeys[I]);
      vTabelaRef := GetTabelaForeignRef(ForeignKeys[I]);
      vCamposRef := GetCamposForeignRef(ForeignKeys[I]);

      if fContexto.Conexao.Database.ConstraintExiste(vTabela + '_' + vTabelaRef) then
        Continue;

      if (vTabela <> '') and (vCampos <> '')
      and (vTabelaRef <> '') and (vCamposRef <> '') then begin
        vComando :=
          'alter table {tabela} ' +
          'add constraint {tabela}_{tabela_ref} ' +
          'foreign key ({campos}) ' +
          'references {tabela_ref} ({campos_ref}) ';
        vComando := AnsiReplaceStr(vComando, '{tabela}', vTabela);
        vComando := AnsiReplaceStr(vComando, '{campos}', vCampos);
        vComando := AnsiReplaceStr(vComando, '{tabela_ref}', vTabelaRef);
        vComando := AnsiReplaceStr(vComando, '{campos_ref}', vCamposRef);

        Result.Add(vComando);
      end;
    end;
end;

initialization
  //Instance();

finalization
  Destroy();

end.