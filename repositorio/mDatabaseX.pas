unit mDatabaseX;

{
    ConexaoDBX: TSQLConnection;
    QueryDBX: TSQLQuery;
    TableDBX: TSQLTable;
}

interface

uses
  Classes, SysUtils, StrUtils, DB,
  mDatabaseIntf, mDatabase, mTipoDatabase, mString, mDataSet,
  SqlExpr, DBXpress;

type
  TrDatabaseX = record
    ConnectionName : String;
    DriverName : String;
    GetDriverFunc : String;
    LibraryName : String;
    VendorLib : String;
    Parametro : String;
    Sessao : String;
  end;

  TmDatabaseX = class(TmDatabase)
  private
    FTransDesc : TTransactionDesc;
  protected
    procedure _BeforeConnect(Sender: TObject);
    procedure _AfterConnect(Sender: TObject);
  public
    constructor create(Aowner : TComponent); override;

    procedure ExecComando(ACmd : String); override;
    function GetConsulta(ASql : String; AOpen : Boolean) : TDataSet; override;

    procedure Transaction(); override;
    procedure Commit(); override;
    procedure Rollback(); override;
  published
  end;

  TmDatabaseDB2 = class(TmDatabaseX);
  TmDatabaseFirebird = class(TmDatabaseX);
  TmDatabaseInformix = class(TmDatabaseX);
  TmDatabaseInterbase = class(TmDatabaseX);
  TmDatabaseMsSql = class(TmDatabaseX);
  TmDatabaseOracle = class(TmDatabaseX);

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmDatabaseX]);
end;

  function GetDatabaseX(ATipoDatabase : TTipoDatabase) : TrDatabaseX;
  begin
    with Result do begin
      case ATipoDatabase of
        tpdFirebird : begin
          ConnectionName := '';
          DriverName := 'Firebird';
          GetDriverFunc := 'getSQLDriverINTERBASE';
          LibraryName := 'dbexpint.dll';
          VendorLib := 'fbclient.dll';
          Parametro := 'BlobSize=-1;CommitRetain=False;ServerCharSet=win1252;SQLDialect=3;Interbase TransIsolation=ReadCommited;WaitOnLocks=True';
        end;

        tpdMySql : begin
          ConnectionName := '';
          DriverName := '';
          GetDriverFunc := 'getSQLDriverMYSQL';
          LibraryName := 'dbexpmysql.dll';
          VendorLib := 'libmysql.dll';
        end;

        tpdOracle : begin
          ConnectionName := '';
          DriverName := 'Oracle';
          GetDriverFunc := 'getSQLDriverORACLE';
          LibraryName := 'dbexpora.dll';
          VendorLib := 'oci.dll';
        end;

        tpdPostgre : begin
          ConnectionName := '';
          DriverName := '';
          GetDriverFunc := 'getSQLDriverPostgreSQL';
          LibraryName := 'dbexpmysql.dll';
          VendorLib := 'dbexppgsql.dll';
        end;

        tpdSqlServer : begin
          ConnectionName := '';
          DriverName := '';
          GetDriverFunc := 'getSQLDriverSQLServer';
          LibraryName := 'dbexpsda.dll';
          VendorLib := 'sqloledb.dll';
        end;
      end;
    end;
  end;

  procedure TmDatabaseX._BeforeConnect(Sender: TObject);
  var
    vDatabaseX : TrDatabaseX;
    vParams : TStringList;
    vCod, vVal : String;
    I : Integer;
  begin
    vDatabaseX := GetDatabaseX(Parametro.Tp_Database);

    with TSQLConnection(fConnection) do begin
      ConnectionName := vDatabaseX.ConnectionName;
      DriverName := vDatabaseX.DriverName;
      GetDriverFunc := vDatabaseX.GetDriverFunc;
      LibraryName := vDatabaseX.LibraryName;
      VendorLib := vDatabaseX.VendorLib;
      TableScope := [tsTable, tsView];
      LoginPrompt := False;
      with Params do begin
        Clear();
        Params.Values['DataBase'] := Parametro.Cd_Database;
        Params.Values['User_Name'] := Parametro.Cd_Username;
        Params.Values['Password'] := Parametro.Cd_Password;
      end;

      vParams := TStringList.Create;
      vParams.Text := AnsiReplaceStr(vDatabaseX.Parametro, ';', sLineBreak);
      for I := 0 to vParams.Count - 1 do begin
        vCod := TmString.LeftStr(vParams[I], '=');
        vVal := TmString.RightStr(vParams[I], '=');
        Params.Values[vCod] := vVal;
      end;
    end;
  end;

  procedure TmDatabaseX._AfterConnect(Sender: TObject);
  var
    vDatabaseX : TrDatabaseX;
    vSessao : TStringList;
    I : Integer;
  begin
    vDatabaseX := GetDatabaseX(Parametro.Tp_Database);

    vSessao := TStringList.Create;
    vSessao.Text := AnsiReplaceStr(vDatabaseX.Sessao, ';', sLineBreak);
    for I := 0 to vSessao.Count - 1 do
      ExecComando(vSessao[I]);
  end;

{ TmDatabaseX }

constructor TmDatabaseX.create(Aowner: TComponent);
begin
  inherited;
  fConnection := TSQLConnection.Create(Self);
  with TSQLConnection(fConnection) do begin
    LoginPrompt := False;
    AfterConnect := _AfterConnect;
    BeforeConnect := _BeforeConnect;
  end;
end;

procedure TmDatabaseX.ExecComando(ACmd: String);
const
  cMETHOD = 'TmDatabaseX.ExecComando()';
begin
  if ACmd = '' then
    raise Exception.Create('Comando deve ser informado! / ' + cMETHOD);

  TSQLConnection(fConnection).ExecuteDirect(ACmd);
end;

function TmDatabaseX.GetConsulta(ASql: String; AOpen : Boolean): TDataSet;
const
  cMETHOD = 'TmDatabaseX.GetConsulta()';
var
  vQuery : TSQLQuery;
begin
  if ASql = '' then
    raise Exception.Create('SQL deve ser informado! / ' + cMETHOD);

  vQuery := TSQLQuery.create(Self);
  vQuery.SQLConnection := TSQLConnection(fConnection);
  vQuery.SQL.Text := ASql;
  if AOpen then vQuery.Open;

  Result := vQuery;
end;

procedure TmDatabaseX.Transaction;
begin
  Randomize;
  FTransDesc.TransactionID := 1;
  FTransDesc.IsolationLevel := xilREADCOMMITTED;
  TSQLConnection(fConnection).StartTransaction(FTransDesc);
end;

procedure TmDatabaseX.Commit;
begin
  TSQLConnection(fConnection).Commit(FTransDesc);
end;

procedure TmDatabaseX.Rollback;
begin
  TSQLConnection(fConnection).Rollback(FTransDesc);
end;

initialization
  RegisterClass(TmDatabaseDB2);
  RegisterClass(TmDatabaseFirebird);
  RegisterClass(TmDatabaseInformix);
  RegisterClass(TmDatabaseInterbase);
  RegisterClass(TmDatabaseMsSql);
  RegisterClass(TmDatabaseOracle);

end.