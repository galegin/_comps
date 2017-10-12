unit mDatabaseFactory;

interface

uses
  Classes, SysUtils,
  mClasse, mIniFiles, mParametroDatabase, mTipoDatabase,
  mDatabaseIntf, mDatabase,
  mDatabaseA,
  mDatabaseB,
  mDatabaseX,
  mDatabaseZ;

type
  TmDatabaseFactory = class(TComponent)
  public
    class function GetDatabase() : IDatabaseIntf;
  end;

implementation

{ TmDatabaseFactory }

const
  TTipoDatabaseClasse : Array [TTipoDatabase] of string =
    ('TmDatabaseFirebird',
     'TmDatabaseMySql',
     'TmDatabaseOracle',
     'TmDatabasePostgre',
     'TmDatabaseSqlServer',
     'TmDatabaseDB2',
     'TmDatabaseDBase',
     'TmDatabaseParadox',
     'TmDatabaseMsAccess');

class function TmDatabaseFactory.GetDatabase: IDatabaseIntf;
var
  vClass : TClass;
  vParametro : TmParametroDatabase;
  vDatabase : TmDatabase;
begin
  vParametro := TmParametroDatabase.GetParametroDatabase();

  vClass := GetClass(TTipoDatabaseClasse[vParametro.Tp_Database]); // mObjeto
  vDatabase := TmDatabase(TmClasse.createObjeto(vClass, nil));
  vDatabase.Parametro := vParametro;

  Result := vDatabase;
end;

end.