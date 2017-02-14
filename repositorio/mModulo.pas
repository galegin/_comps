unit mModulo;

interface

uses
  Classes, SysUtils,
  mTipoConexao, mConexao, mTipoDatabase, mDatabase,
  mTnsNames, mParametroDatabase, mDatabaseFactory;

type
  TmModulo = class(TComponent)
  private
    fList_Conexao : TmConexaoList;
    function Get(ATipoConexao: TTipoConexao) : TmConexao;
    function GetConexaoAmbiente: TmConexao;
  public
    constructor Create(AOwner : TComponent); override;

    function GetConexao(
      ATipoConexao : TTipoConexao = tpcAmbiente) : TmConexao;

  published
    property List_Conexao : TmConexaoList read fList_Conexao write fList_Conexao;
    property Conexao : TmConexao read GetConexaoAmbiente;
  end;

  function Instance : TmModulo;

implementation

uses
  mDatabaseIntf;

var
  _instance : TmModulo;

  function Instance : TmModulo;
  begin
    if not Assigned(_instance) then
      _instance := TmModulo.Create(nil);
    Result := _instance;
  end;

  function TmModulo.Get(ATipoConexao: TTipoConexao) : TmConexao;
  var
    I : Integer;
  begin
    Result := nil;
    with List_Conexao do begin
      for I := 0 to Count - 1 do begin
        with Items[I] do begin
          if TipoConexao = ATipoConexao then begin
            Result := Items[I];
            Exit;
          end;
        end;
      end;
    end;
  end;

{ TmModulo }

constructor TmModulo.Create(AOwner: TComponent);
begin
  inherited;
  fList_Conexao := TmConexaoList.Create;
end;

function TmModulo.GetConexao(ATipoConexao: TTipoConexao): TmConexao;
var
  vUsername, vPassword : String;
  vParametro : TmParametroDatabase;
begin
  Result := Get(ATipoConexao);
  if Assigned(Result) then
    Exit;

  Result := TmConexao.Create(Self);
  Result.TipoConexao := ATipoConexao;
  Result.Database := TmDatabaseFactory.getDatabase();

  vParametro := Result.Database.Parametro;

  vUsername := TTipoConexaoUsername[ATipoConexao];
  vPassword := TTipoConexaoPassword[ATipoConexao];

  with vParametro do begin
    if (vUsername <> '') and (vPassword <> '') then begin
      Cd_Username := vUsername;
      Cd_Password := vPassword;
    end;
  end;

  if vParametro.Tp_Database in [tpdFirebird] then
    TmTnsNames.SetParametro(vParametro);

  List_Conexao.Add(Result);
end;

function TmModulo.GetConexaoAmbiente: TmConexao;
begin
  Result := GetConexao();
end;

end.
