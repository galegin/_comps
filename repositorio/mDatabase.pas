unit mDatabase;

interface

uses
  Classes, SysUtils, StrUtils, TypInfo, DB,
  mDatabaseIntf, mParametroDatabase, mTipoDatabase, mDataSet;

type
  TrDatabase_Sequence = record
    Create : String;
    Exists : String;
    Execute : String;
  end;

  TrDatabase = record
    Limits : String;
    Metadata : String;
    Sequences : TrDatabase_Sequence;
    Tables : String;
    Views : String;
  end;

  TmDatabase = class(TComponent, IDatabaseIntf)
  private
    fParametro : TmParametroDatabase;
  protected
    fConnection : TComponent;
  public
    constructor create(Aowner : TComponent); override;

    procedure ExecComando(ACmd : String); virtual; abstract;

    function GetConsulta(ASql : String; AOpen : Boolean) : TDataSet; virtual; abstract;
    function GetLimits(ASql : String; AQtde : Integer) : String; virtual;
    function GetMetadata(AEntidade : String) : TList; virtual;
    function GetTables(AFiltro : String) : TStringList; virtual;
    function GetViews(AFiltro : String) : TStringList; virtual;

    function GetSequence(ASequence : String) : Integer; virtual;

    function TableExiste(ATable : String) : Boolean; virtual;
    function ViewExiste(AView : String) : Boolean; virtual;

    procedure Transaction(); virtual; abstract;
    procedure Commit(); virtual; abstract;
    procedure Rollback(); virtual; abstract;

    function GetParametro() : TmParametroDatabase;
    procedure SetParametro(const Value : TmParametroDatabase);
  published
    property Parametro : TmParametroDatabase read GetParametro write SetParametro;
  end;

implementation

{ TmDatabase }

  function GetDatabase(ATipoDatabase : TTipoDatabase) : TrDatabase;
  begin
    with Result do begin
      case ATipoDatabase of
        tpdDB2, tpdOracle : begin
          Limits := 'select * from ({sql}) where ROWNUM <= {qtde}';
          Metadata := 'select * from {entidade} where 1<>1';
          Tables := 'select TABLE_NAME from USER_TABLES';
          Views := 'select VIEW_NAME from USER_VIEWS';
          with Sequences do begin
            Create := 'create sequence {sequence} start with 1 increment by 1 maxvalue 999999 cycle nocache';
            Execute := 'select {sequence}.NEXTVAL as PROXIMO from DUAL';
            Exists := 'select SEQUENCE_NAME from USER_SEQUENCES where SEQUENCE_NAME = ''{sequence}''';
          end;
        end;

        tpdFirebird : begin
          Limits := 'select FIRST {qtde} * from ({sql})';
          Metadata := 'select * from {entidade} where 1<>1';
          Tables := 'select RDB$RELATION_NAME as TABLE_NAME from RDB$RELATIONS where RDB$SYSTEM_FLAG = 0 and RDB$VIEW_BLR is null';
          Views := 'select RDB$RELATION_NAME as VIEW_NAME from RDB$RELATIONS where RDB$SYSTEM_FLAG = 0 and RDB$VIEW_BLR is not null';
          with Sequences do begin
            Create := 'create sequence {sequence}';
            Execute := 'select GEN_ID({sequence}, 1) as PROXIMO from RDB$DATABASE';
            Exists := 'select RDB$GENERATOR_NAME as SEQUENCE_NAME from RDB$GENERATORS where RDB$GENERATOR_NAME = ''{sequence}'' and RDB$SYSTEM_FLAG = 0';
          end;
        end;

        tpdMySql, tpdPostgre : begin
          Limits := 'select * from ({sql}) LIMIT {qtde}';
          Metadata := 'select * from {entidade} where 1<>1';
          Tables := 'select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = database()';
          Views := 'select VIEW_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_SCHEMA = database()';
        end;
        
      end;
    end;
  end;

constructor TmDatabase.create(Aowner: TComponent);
begin
  inherited;
end;

//--

function TmDatabase.GetParametro: TmParametroDatabase;
begin
  Result := fParametro;
end;

procedure TmDatabase.SetParametro(const Value: TmParametroDatabase);
begin
  fParametro := Value;
end;

//--

function TmDatabase.GetLimits(ASql : String; AQtde : Integer) : String;
begin
  Result := GetDatabase(Parametro.Tp_Database).Limits;
  Result := AnsiReplaceStr(Result, '{sql}', ASql);
  Result := AnsiReplaceStr(Result, '{qtde}', IntToStr(AQtde));
end;

function TmDatabase.GetMetadata(AEntidade : String) : TList;
var
  vSql : String;
  vDataSet : TDataSet;
begin
  vSql := GetDatabase(Parametro.Tp_Database).Metadata;
  vSql := AnsiReplaceStr(vSql, '{entidade}', AEntidade);
  vDataSet := GetConsulta(vSql, True);
  Result := TmDataSet.GetValues(vDataSet);
end;

function TmDatabase.GetSequence(ASequence : String) : Integer;
var
  vSql : String;
  vDataSet : TDataSet;
begin
  vSql := GetDatabase(Parametro.Tp_Database).Sequences.Exists;
  vSql := AnsiReplaceStr(vSql, '{sequence}', ASequence);
  vDataSet := GetConsulta(vSql, True);
  if TmDataSet.PegarS(vDataSet, 'SEQUENCE_NAME') = '' then begin
    vSql := GetDatabase(Parametro.Tp_Database).Sequences.Create;
    vSql := AnsiReplaceStr(vSql, '{sequence}', ASequence);
    ExecComando(vSql);
  end;

  vSql := GetDatabase(Parametro.Tp_Database).Sequences.Execute;
  vSql := AnsiReplaceStr(vSql, '{sequence}', ASequence);
  vDataSet := GetConsulta(vSql, True);
  Result := TmDataSet.PegarI(vDataSet, 'PROXIMO');
end;

function TmDatabase.GetTables(AFiltro : String) : TStringList;
var
  vSql : String;
  vDataSet : TDataSet;
begin
  Result := TStringList.Create;
  vSql := GetDatabase(Parametro.Tp_Database).Tables;
  vDataSet := GetConsulta(vSql, True);
  with vDataSet do begin
    while not EOF do begin
      Result.Add(Trim(FieldByName('TABLE_NAME').AsString));
      Next;
    end;
  end;
end;

function TmDatabase.GetViews(AFiltro : String) : TStringList;
var
  vSql : String;
  vDataSet : TDataSet;
begin
  Result := TStringList.Create;
  vSql := GetDatabase(Parametro.Tp_Database).Views;
  vDataSet := GetConsulta(vSql, True);
  with vDataSet do begin
    while not EOF do begin
      Result.Add(Trim(FieldByName('VIEW_NAME').AsString));
      Next;
    end;
  end;
end;

//--

function TmDatabase.TableExiste;
begin
  Result := (GetTables(ATable).IndexOf(ATable) > -1);
end;

function TmDatabase.ViewExiste;
begin
  Result := (GetViews(AView).IndexOf(AView) > -1);
end;

//--

end.