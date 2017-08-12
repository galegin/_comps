unit mConexao;

interface

uses
  Classes, SysUtils, StrUtils, TypInfo, DB,
  mConexaoIntf, mParametro, mTipoDatabase; //, mDataSet;

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
    Constraints : String;
  end;

  TmConexao = class(TComponent, IConexao)
  private
    fParametro : TmParametro;
  protected
    fConnection : TComponent;
  public
    constructor create(Aowner : TComponent); override;

    procedure ExecComando(ACmd : String); virtual; abstract;
    function GetConsulta(ASql : String) : TDataSet; virtual; abstract;

    procedure Transaction(); virtual; abstract;
    procedure Commit(); virtual; abstract;
    procedure Rollback(); virtual; abstract;

    function GetParametro() : TmParametro;
    procedure SetParametro(const Value : TmParametro);
  published
    property Parametro : TmParametro read GetParametro write SetParametro;
  end;

implementation

{ TmConexao }

  function GetDatabase(ATipoDatabase : TTipoDatabase) : TrDatabase;
  begin
    with Result do begin
      case ATipoDatabase of
        tpdDB2, tpdOracle : begin
          Limits := 'select * from ({sql}) where ROWNUM <= {qtde}';
          Metadata := 'select * from {entidade} where 1<>1';
          Constraints := 'select CONSTRAINT_NAME from USER_CONSTRAINTS';
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
          Constraints := 'select RDB$CONSTRAINT_NAME as CONSTRAINT_NAME from RDB$RELATION_CONSTRAINTS';
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
          Constraints := 'select CONSTRAINT_NAME from INFORMATION_SCHEMA.CONSTRAINTS where TABLE_SCHEMA = database()';
          Tables := 'select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = database()';
          Views := 'select VIEW_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_SCHEMA = database()';
        end;
        
      end;
    end;
  end;

constructor TmConexao.create(Aowner: TComponent);
begin
  inherited;
end;

//--

function TmConexao.GetParametro: TmParametro;
begin
  Result := fParametro;
end;

procedure TmConexao.SetParametro(const Value: TmParametro);
begin
  fParametro := Value;
end;

//--

end.