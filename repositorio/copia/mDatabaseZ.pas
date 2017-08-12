unit mDatabaseZ;

{
    ConexaoZEO: TZConnection;
    QueryZEO: TZQuery;
    TableZEO: TZTable;
}

interface

uses
  Classes, SysUtils, StrUtils, DB,
  mDatabaseIntf, mDatabase, mTipoDatabase, mString, mDataSet,
  ZConnection, ZDataset;

type
  TmDatabaseZ = class(TmDatabase)
  private
    procedure _BeforeConnect(Sender: TObject);
    procedure _AfterConnect(Sender: TObject);
  protected
  public
    constructor create(Aowner : TComponent); override;

    procedure ExecComando(ACmd : String); override;
    function GetConsulta(ASql : String; AOpen : Boolean) : TDataSet; override;

    procedure Transaction(); override;
    procedure Commit(); override;
    procedure Rollback(); override;
  published
  end;

  TmDatabaseMySql = class(TmDatabaseZ);
  TmDatabasePostgre = class(TmDatabaseZ);

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmDatabaseZ]);
end;

  procedure TmDatabaseZ._BeforeConnect(Sender: TObject);
  begin
    with TZConnection(fConnection) do begin
      Connected := False;
      Protocol := Parametro.Cd_Protocol;
      HostName := Parametro.Cd_Hostname;
      Database := Parametro.Cd_Database;
      User := Parametro.Cd_Username;
      Password := Parametro.Cd_Password;
      Port := StrToIntDef(Parametro.Cd_Hostport, 0);
      Connected := True;
    end;
  end;

  procedure TmDatabaseZ._AfterConnect(Sender: TObject);
  begin
  end;

{ TmDatabaseZ }

constructor TmDatabaseZ.create(Aowner: TComponent);
begin
  inherited;
  fConnection := TZConnection.Create(Self);
  with TZConnection(fConnection) do begin
    LoginPrompt := False;
    AfterConnect := _AfterConnect;
    BeforeConnect := _BeforeConnect;
  end;
end;

procedure TmDatabaseZ.ExecComando(ACmd: String);
const
  cMETHOD = 'TmDatabaseZ.ExecComando()';
begin
  if ACmd = '' then
    raise Exception.Create('Comando deve ser informado! / ' + cMETHOD);

  TZConnection(fConnection).ExecuteDirect(ACmd);
end;

function TmDatabaseZ.GetConsulta(ASql: String; AOpen : Boolean): TDataSet;
const
  cMETHOD = 'TmDatabaseZ.GetConsulta()';
var
  vQuery : TZQuery;
begin
  if ASql = '' then
    raise Exception.Create('SQL deve ser informado! / ' + cMETHOD);

  vQuery := TZQuery.create(Self);
  vQuery.Connection := TZConnection(fConnection);
  vQuery.SQL.Text := ASql;
  if AOpen then vQuery.Open;

  Result := vQuery;
end;

procedure TmDatabaseZ.Transaction;
begin
  TZConnection(fConnection).StartTransaction();
end;

procedure TmDatabaseZ.Commit;
begin
  TZConnection(fConnection).Commit();
end;

procedure TmDatabaseZ.Rollback;
begin
  TZConnection(fConnection).Rollback();
end;

initialization
  RegisterClass(TmDatabaseMySql);
  RegisterClass(TmDatabasePostgre);

{
ADO
  ZDbcAdo
    TZAdo
ASA
  ZDbcASA
    TZASA7 / TZASA8 / TZASA9 / TZASA12
DBLIB
  ZDbcDbLib
    TZDBLibMSSQL7
    TZDBLibSybaseASE125
    TZFreeTDS42MsSQL
    TZFreeTDS42Sybase
    TZFreeTDS50
    TZFreeTDS70
    TZFreeTDS71
    TZFreeTDS72
FIREBIRD
  ZDbcInterbase6
    TZFirebird10 / TZFirebird15 / TZFirebird20 / TZFirebird21 / TZFirebird25
    // embedded drivers
    TZFirebirdD15 / TZFirebirdD20 / TZFirebirdD21 / TZFirebirdD25
INTERBASE
  ZDbcInterbase6
    TZInterbase6
MYSQL
  ZDbcMySql
    TZMySQL / TZMySQL41 / TZMySQL5 / TZMySQLD41 / TZMySQLD5
ORACLE
  ZDbcOracle
    TZOracle / TZOracle9i
POSTGRESQL
  ZDbcPostgreSql
    TZPostgreSQL / TZPostgreSQL7 / TZPostgreSQL8 / TZPostgreSQL9
SQLITE
  ZDbcSqLite
    TZSQLite / TZSQLite3
}

end.