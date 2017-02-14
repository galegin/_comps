unit mDatabaseB;

{
    ConexaoDBE: TDatabase;
    QueryBDE: TQuery;
    TableBDE: TTable;
}

interface

uses
  Classes, SysUtils, StrUtils, DB,
  mDatabaseIntf, mDatabase, mTipoDatabase, mString, mDataSet,
  DBTables;

type
  TrDatabaseB = record
    Driver : String;
    Caminho : String;
    Username : String;
    Password : String;
  end;

  TmDatabaseB = class(TmDatabase)
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

  TmDatabaseDBase = class(TmDatabaseB);
  TmDatabaseParadox = class(TmDatabaseB);

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmDatabaseB]);
end;

  function GetDatabaseB(ATipoDatabase : TTipoDatabase) : TrDatabaseB;
  begin
    with Result do begin
      case ATipoDatabase of
        tpdDBase : begin
          Driver := 'DBASE';
        end;
        
        tpdParadox : begin
          Driver := 'PARADOX';
        end;
      end;
    end;
  end;

  procedure TmDatabaseB._BeforeConnect(Sender: TObject);
  var
    vDatabaseB : TrDatabaseB;

    procedure createAlias();
    var
      vLstParam : TStrings;
    begin
      {
      Params:
        Session.GetAliasParams(AliasName, Lista);
      Exists:
        Session.IsAlias(eAlias.Text);
      Add:
        Session.AddStandardAlias(eAlias.Text, Edit1.Text, 'Paradox');
        Session.SaveConfigFile;
      }

      (* Session.GetDriverNames(vLstDriver);
      for I := 0 to vLstDriver.Count - 1 do begin
        Session.GetDriverParams(vLstDriver[I], vLstParam);
        vLstParam.SaveToFile('params.' + vLstDriver[I] + '.txt');
      end; *)

      vLstParam := TStringList.Create;

      if Session.IsAlias(Parametro.Cd_Ambiente) then begin
        Session.GetAliasParams(Parametro.Cd_Ambiente, vLstParam);
        if vLstParam.Values[vDatabaseB.Caminho] <> Parametro.Cd_Database then
          Session.DeleteAlias(Parametro.Cd_Ambiente);
      end;

      if Parametro.Tp_Database in [tpdDBase, tpdParadox] then begin
        Session.AddStandardAlias(Parametro.Cd_Ambiente, Parametro.Cd_Database, vDatabaseB.Driver);
      end else begin
        vLstParam.Clear();
        vLstParam.Values[vDatabaseB.Caminho] := Parametro.Cd_Database;
        vLstParam.Values[vDatabaseB.Username] := Parametro.Cd_Username;
        Session.AddAlias(Parametro.Cd_Ambiente, vDatabaseB.Driver, vLstParam);
      end;

      Session.SaveConfigFile;
    end;

  begin
    inherited;

    vDatabaseB := GetDatabaseB(Parametro.Tp_Database);

    createAlias();

    with TDatabase(fConnection) do begin
      Connected := False;
      AliasName := Parametro.Cd_Ambiente;
      Params.Values[vDatabaseB.Password] := Parametro.Cd_Password;
      Connected := True;
    end;
  end;

  procedure TmDatabaseB._AfterConnect(Sender: TObject);
  begin
  end;

{ TmDatabaseB }

constructor TmDatabaseB.create(Aowner: TComponent);
begin
  inherited;
  fConnection := TDatabase.Create(Self);
  with TDatabase(fConnection) do begin
    DatabaseName := 'TmDatabaseBAliasName';
    LoginPrompt := False;
    AfterConnect := _AfterConnect;
    BeforeConnect := _BeforeConnect;
  end;
end;

procedure TmDatabaseB.ExecComando(ACmd: String);
const
  cMETHOD = 'TmDatabaseB.ExecComando()';
begin
  if ACmd = '' then
    raise Exception.Create('Comando deve ser informado! / ' + cMETHOD);

  TDatabase(fConnection).Execute(ACmd);
end;

function TmDatabaseB.GetConsulta(ASql: String; AOpen : Boolean): TDataSet;
const
  cMETHOD = 'TmDatabaseB.GetConsulta()';
var
  vQuery : TQuery;
begin
  if ASql = '' then
    raise Exception.Create('SQL deve ser informado! / ' + cMETHOD);

  vQuery := TQuery.create(Self);
  vQuery.DatabaseName := TDatabase(fConnection).AliasName;
  vQuery.SQL.Text := ASql;
  if AOpen then vQuery.Open;

  Result := vQuery;
end;

procedure TmDatabaseB.Transaction;
begin
  TDatabase(fConnection).StartTransaction();
end;

procedure TmDatabaseB.Commit;
begin
  TDatabase(fConnection).Commit();
end;

procedure TmDatabaseB.Rollback;
begin
  TDatabase(fConnection).Rollback();
end;

initialization
  RegisterClass(TmDatabaseDBase);
  RegisterClass(TmDatabaseParadox);

end.