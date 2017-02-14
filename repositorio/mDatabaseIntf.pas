unit mDatabaseIntf;

interface

uses
  Classes, DB, // mConexaoIntf / mConexao
  mParametroDatabase;

type
  IDatabaseIntf = interface
    ['{469904F8-A4F1-45BA-9EE9-89FFC08A9C0C}']

    procedure ExecComando(ACmd : String);

    function GetConsulta(ASql : String; AOpen : Boolean) : TDataSet;
    function GetLimits(ASql : String; AQtde : Integer) : String;
    function GetMetadata(AEntidade : String) : TList;
    function GetTables(AFiltro : String) : TStringList;
    function GetViews(AFiltro : String) : TStringList;

    function GetSequence(ASequence : String) : Integer;

    function TableExiste(ATable : String) : Boolean;
    function ViewExiste(AView : String) : Boolean;

    procedure Transaction();
    procedure Commit();
    procedure Rollback();

    function GetParametro() : TmParametroDatabase;
    procedure SetParametro(const Value : TmParametroDatabase);

    property Parametro : TmParametroDatabase read GetParametro write SetParametro;
  end;

implementation

end.