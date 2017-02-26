unit mTipoDatabase;

interface

uses
  Classes, SysUtils, TypInfo;

type
  TTipoDatabase = (DBASE, DB2, FIREBIRD, INFORMIX, INTERBASE,
                   MSACCESS, MSSQL, MYSQL, ORACLE, PARADOX,
                   POSTGRE, SQLSERVER);

  function lst() : String;
  function tip(pTip : String) : TTipoDatabase;
  function str(pTip : TTipoDatabase) : String;
  function xml(pTip : TTipoDatabase) : String;
  function cls(pTip : TTipoDatabase) : String;

implementation

uses
  mFuncao, mItem, mXml;

const
  cLST_DATABASE =

//--------------------------- DB2

    '<DB2 ConnectionName="" cls="TmConexaoDB2" ' +
         'DriverName="DB2" GetDriverFunc="getSQLDriverDB2" ' +
         'LibraryName="dbexpdb2.dll" VendorLib="db2cli.dll" >' +

      '<types></types>' +
      '<database>SYSIBM.SYSDUMMY1</database>' +
      '<sessions></sessions>' +
      '<limits>select * from ({CMD}) fetch first {QTD} rows only</limits>' +
      '<date>select date(current timestamp - 36 hours) from {DAT}</date>' +

      '<tables tbl="USER_TABLES" fld="TABLE_NAME" whr="" />' +
      '<views tbl="USER_VIEWS" fld="VIEW_NAME" whr="" />' +
      '<fields tbl="USER_TAB_COLUMNS" tab="TABLE_NAME" fld="COLUMN_NAME" />' +
      '<keys tbl="USER_CONSTRAINTS" fld="CONSTRAINT_NAME" whr="" />' +
      '<indexs tbl="USER_INDEXES" fld="INDEX_NAME" />' +
      '<procs tbl="USER_OBJECTS" fld="OBJECT_NAME" whr="OBJECT_TYPE = ''PROCEDURE''" />' +
      '<functs tbl="USER_OBJECTS" fld="OBJECT_NAME" whr="OBJECT_TYPE = ''FUNCTION''" />' +
      '<args></args>' +

      '<seqs tbl="USER_OBJECTS" fld="OBJECT_NAME" whr="OBJECT_TYPE = ''SEQ''" >' +
        '<create>CREATE SEQUENCE {SEQ}</create>' +
        '<exec>NEXT VALUE FOR {SEQ}</exec>' +
      '</seqs>' +

    '</DB2>' +

//--------------------------- FIREBIRD

    '<FIREBIRD ConnectionName="" cls="TmConexaoFirebird" ' +
              'DriverName="Firebird" GetDriverFunc="getSQLDriverINTERBASE" ' +
              'LibraryName="dbexpint.dll" VendorLib="fbclient.dll" >' +

      '<types>' +
        'ALFA=VARCHAR({tam});' +
        'BOOLEANO=CHAR(1);' +
        'CARACTER=CHAR({tam});' +
        'DATAHORA=TIMESTAMP;' +
        'NUMERO=NUMERIC({tam}{dec});' +
        'IMAGE=BLOB;' +
        'INTEIRO=INTEGER;' +
        'TEXTO=BLOB' +
      '</types>' +

      '<database>RDB$DATABASE</database>' +
      '<sessions>RDB$GET_CONTEXT(''SYSTEM'',''SESSION_ID'')</sessions>' +
      '<limits sql="select FIRST {QTD} * from ({CMD})" />' +
      '<date sql="select CURRENT_DATE from {DAT}" />' +
      '<tables tbl="RDB$RELATIONS" fld="RDB$RELATION_NAME" whr="RDB$SYSTEM_FLAG = 0 and RDB$VIEW_BLR is null" />' +
      '<views tbl="RDB$RELATIONS" fld="RDB$RELATION_NAME" whr="RDB$SYSTEM_FLAG = 0 and RDB$VIEW_BLR is not null" />' +
      '<fields tbl="RDB$RELATION_FIELDS" tab="RDB$RELATION_NAME" fld="RDB$FIELD_NAME" />' +
      '<keys tbl="RDB$RELATION_CONSTRAINTS" fld="RDB$CONSTRAINT_NAME" whr="RDB$CONSTRAINT_TYPE = ''PRIMARY KEY''" />' +
      '<indexs tbl="RDB$INDICES" fld="RDB$INDEX_NAME" whr="RDB$SYSTEM_FLAG = 0" />' +

      '<procs tbl="RDB$PROCEDURES" fld="RDB$PROCEDURE_NAME" whr="RDB$SYSTEM_FLAG = 0 and RDB$PROCEDURE_NAME like ''P_%''" >' +
        '<exec>execute procedure {PROC}({ARG})</exec>' +
      '</procs>' +

      '<functs tbl="RDB$FUNCTIONS" fld="RDB$FUNCTIONS_NAME" whr="RDB$SYSTEM_FLAG = 0 and RDB$PROCEDURE_NAME like ''F_%'' />' +
      '<args tbl="RDB$PROCEDURE_PARAMETERS" fld="RDB$PROCEDURE_NAME" />' +

      '<seqs tbl="RDB$GENERATORS" fld="RDB$GENERATOR_NAME" whr="RDB$SYSTEM_FLAG = 0" >' +
        '<create>CREATE SEQUENCE {SEQ}</create>' +
        '<exec>{SEQ}.NEXTVAL</exec>' +
      '</seqs>' +

      '<create_table cmd="create table {ENT} ({FLD})" />'+
      '<create_view cmd="create or alter view {COD} ({FLD}) as {SQL}" />'+

      '<params>' +
        'BlobSize=-1|' +
        'CommitRetain=False|' +
        'ErrorResourceFile=|' +
        'LocaleCode=0000|' +
        'RoleName=RoleName|' +
        'ServerCharSet=win1252|' +
        'SQLDialect=3|' +
        'Interbase TransIsolation=ReadCommited|' +
        'WaitOnLocks=True|' +
      '</params>' +

    '</FIREBIRD>' +

//--------------------------- INFORMIX

    '<INFORMIX ConnectionName="" cls="TmConexaoInformix" ' +
              'DriverName="Informix" GetDriverFunc="getSQLDriverINFORMIX" ' +
              'LibraryName="dbexpinf.dll" VendorLib="isqlb09a.dll" >' +

      '<types>' +
        'ALFA=VARCHAR({tam});' +
        'BOOLEANO=CHAR(1);' +
        'CARACTER=CHAR({tam});' +
        'DATAHORA=TIMESTAMP;' +
        'NUMERO=NUMERIC({tam}{dec});' +
        'IMAGE=BLOB;' +
        'INTEIRO=INTEGER;' +
        'TEXTO=BLOB' +
      '</types>' +

      '<database></database>' +
      '<sessions></sessions>' +
      '<limits></limits>' +
      '<date></date>' +

      '<tables tbl="" fld="" whr="" />' +
      '<views tbl="" fld="" whr="" />' +
      '<fields tbl="" tab="" fld="" />' +
      '<keys tbl="" fld="" whr="" />' +
      '<indexs tbl="" fld="" />' +
      '<procs tbl="" fld="" />' +
      '<functs tbl="" fld="" />' +
      '<args tbl="" fld="" />' +
      '<seqs tbl="" fld="" />' +

    '</INFORMIX>' +

//--------------------------- INTERBASE

    '<INTERBASE ig="FIREBIRD" />' +

//--------------------------- ORACLE

    '<ORACLE ConnectionName="" cls="TmConexaoOracle" ' +
            'DriverName="Oracle" GetDriverFunc="getSQLDriverORACLE" ' +
            'LibraryName="dbexpora.dll" VendorLib="oci.dll" >' +

      '<types>' +
        'ALFA=VARCHAR({tam});' +
        'BOOLEANO=CHAR(1);' +
        'CARACTER=CHAR({tam});' +
        'DATAHORA=DATE;' +
        'NUMERO=NUMBER({tam}{dec});' +
        'INTEIRO=INTEGER;' +
        'IMAGE=BLOB;' +
        'TEXTO=CLOB' +
      '</types>' +

      '<sessao>' +
        'ALTER SESSION SET NLS_LANGUAGE            = ''BRAZILIAN PORTUGUESE''|' +
        'ALTER SESSION SET NLS_TERRITORY           = ''BRAZIL''|' +
        'ALTER SESSION SET NLS_CURRENCY            = ''R$''|' +
        'ALTER SESSION SET NLS_ISO_CURRENCY        = ''BRAZIL''|' +
        'ALTER SESSION SET NLS_NUMERIC_CHARACTERS  = ''.,''|' +
        'ALTER SESSION SET NLS_CALENDAR            = ''GREGORIAN''|' +
        'ALTER SESSION SET NLS_DATE_FORMAT         = ''DD/MM/RR''|' +
        'ALTER SESSION SET NLS_DATE_LANGUAGE       = ''BRAZILIAN PORTUGUESE''|' +
        'ALTER SESSION SET NLS_TIME_FORMAT         = ''HH24:MI:SSXFF''|' +
        'ALTER SESSION SET NLS_TIMESTAMP_FORMAT    = ''DD/MM/RR HH24:MI:SSXFF''|' +
        'ALTER SESSION SET NLS_TIME_TZ_FORMAT      = ''HH24:MI:SSXFF TZR''|' +
        'ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = ''DD/MM/RR HH24:MI:SSXFF TZR''|' +
        'ALTER SESSION SET NLS_DUAL_CURRENCY       = ''Cr$''|' +
        'ALTER SESSION SET NLS_COMP                = ''BINARY''|' +
        'ALTER SESSION SET NLS_LENGTH_SEMANTICS    = ''BYTE''|' +
        'ALTER SESSION SET NLS_NCHAR_CONV_EXCP     = ''FALSE''|' +
      '</sessao>' +

      '<database>DUAL</database>' +
      '<sessions>userenv(''sessionid'')</sessions>' +
      '<limits>select * from ({CMD}) where ROWNUM <= {QTD}</limits>' +

      '<date>select SYSDATE from {DAT}</date>' +
      '<tables tbl="USER_TABLES" fld="TABLE_NAME" whr="" />' +
      '<views tbl="USER_VIEWS" fld="VIEW_NAME" whr="" />' +
      '<fields tbl="USER_TAB_COLS" tab="TABLE_NAME" fld="COLUMN_NAME" />' +
      '<keys tbl="USER_CONSTRAINTS" fld="CONSTRAINT_NAME" whr="CONSTRAINT_TYPE=''P''" />' +
      '<indexs tbl="USER_INDEXES" fld="INDEX_NAME" />' +

      '<procs tbl="USER_PROCEDURES" fld="OBJECT_NAME" whr="OBJECT_NAME like ''P_%'' and PROCEDURE_NAME is null" >' +
        '<exec>begin {PROC}({ARG}); end;</exec>' +
      '</procs>' +

      '<functs tbl="USER_PROCEDURES" fld="OBJECT_NAME" whr="OBJECT_NAME like ''F_%'' and PROCEDURE_NAME is null" />' +
      '<args tbl="USER_ARGUMENTS" fld="ARGUMENT_NAME" whr="ARGUMENT_NAME is not null" />' +

      '<seqs tbl="USER_SEQUENCES" fld="SEQUENCE_NAME" >' +
        '<create>CREATE SEQUENCE {SEQ} START WITH 1 INCREMENT BY 1 MAXVALUE 999999 CYCLE NOCACHE</create>' +
        '<exec>{SEQ}.NEXTVAL</exec>' +
      '</seqs>' +

      '<create_table>create table {ENT} ({FLD})</create_table>' +
      '<create_view>create or replace view {COD} as {SQL}</create_view>' +

    '</ORACLE>' +

//--------------------------- MSSQL

    '<MSSQL ConnectionName="" cls="TmConexaoMsSql" ' +
           'DriverName="MSSQL" GetDriverFunc="getSQLDriverMSSQL" ' +
           'LibraryName="dbexpmss.dll" VendorLib="oledb" >' +

      '<types>' +
        'ALFA=VARCHAR({tam});' +
        'BOOLEANO=CHAR(1);' +
        'CARACTER=CHAR({tam});' +
        'DATAHORA=DATE;' +
        'NUMERO=NUMBER({tam}{dec});' +
        'INTEIRO=INTEGER;' +
        'IMAGE=BLOB;' +
        'TEXTO=CLOB' +
      '</types>' +

      '<database></database>' +
      '<sessions></sessions>' +
      '<limits></limits>' +
      '<date></date>' +

      '<tables tbl="" fld="" whr="" />' +
      '<views tbl="" fld="" whr="" />' +
      '<fields tbl="" tab="" fld="" />' +
      '<keys tbl="" fld="" whr="" />' +
      '<indexs tbl="" fld="" />' +
      '<procs tbl="" fld="" />' +
      '<functs tbl="" fld="" />' +
      '<args tbl="" fld="" />' +
      '<seqs tbl="" fld="" />' +

    '</MSSQL>' +

//--------------------------- MYSQL

    '<MYSQL ConnectionName="MySQLConnection" cls="TmConexaoMySql" ' +
           'DriverName="MySQL" GetDriverFunc="getSQLDriverMYSQL" ' +
           'LibraryName="dbexpmysql.dll" VendorLib="libmysql.dll" >' +

      '<types>' +
        'ALFA=VARCHAR({tam});' +
        'BOOLEANO=CHAR(1);' +
        'CARACTER=CHAR({tam});' +
        'DATAHORA=TIMESTAMP;' +
        'NUMERO=NUMERIC({tam}{dec});' +
        'INTEIRO=INTEGER;' +
        'IMAGE=BLOB;' +
        'TEXTO=CLOB' +
      '</types>' +

      '<database>DUAL</database>' +
      '<sessions>connection_id()</sessions>' +
      '<limits>select * from ({CMD}) LIMIT {QTD}</limits>' +
      '<date></date>' +

      '<tables tbl="INFORMATION_SCHEMA.COLUMNS" fld="TABLE_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<views tbl="INFORMATION_SCHEMA.VIEWS" fld="TABLE_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<fields tbl="INFORMATION_SCHEMA.COLUMNS" tab="TABLE_NAME" fld="COLUMN_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<keys tbl="INFORMATION_SCHEMA.TABLE_CONSTRAINTS" fld="CONSTRAINT_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<indexs tbl="INFORMATION_SCHEMA.INDEXES" fld="INDEX_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<procs tbl="INFORMATION_SCHEMA.PROCEDURES" fld="TABLE_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<functs tbl="" fld="" />' +
      '<args tbl="" fld="" />' +
      '<seqs tbl="" fld="" />' +

    '</MYSQL>' +

//--------------------------- POSTGRE

    '<POSTGRE ConnectionName="" cls="TmConexaoPostgre" ' +
             'DriverName="DevartPostgreSQL" ' +
             'GetDriverFunc="getSQLDriverPostgreSQL" ' +
             'LibraryName="dbexpmysql.dll" VendorLib="dbexppgsql.dll" >' +

      '<types>' +
        'ALFA=VARCHAR({tam});' +
        'BOOLEANO=CHAR(1);' +
        'CARACTER=CHAR({tam});' +
        'DATAHORA=TIMESTAMP;' +
        'NUMERO=NUMERIC({tam}{dec});' +
        'INTEIRO=INTEGER;' +
        'IMAGE=BLOB;' +
        'TEXTO=CLOB' +
      '</types>' +

      '<database>DUAL</database>' +
      '<sessions>connection_id()</sessions>' +
      '<limits>select * from ({CMD}) LIMIT {QTD}</limits>' +
      '<date></date>' +

      '<tables tbl="INFORMATION_SCHEMA.TABLES" fld="TABLE_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<views tbl="INFORMATION_SCHEMA.VIEWS" fld="TABLE_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<fields tbl="INFORMATION_SCHEMA.COLUMNS" tab="TABLE_NAME" fld="COLUMN_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<keys tbl="INFORMATION_SCHEMA.CONSTRAINTS" fld="CONSTRAINT_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<indexs tbl="INFORMATION_SCHEMA.INDEXES" fld="INDEX_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<procs tbl="INFORMATION_SCHEMA.PROCEDURES" fld="TABLE_NAME" whr="TABLE_SCHEMA = database()" />' +
      '<functs tbl="" fld="" >' +
      '<args tbl="" fld="" >' +
      '<seqs tbl="" fld="" >' +

    '</POSTGRE>' +

//--------------------------- SQLSERVER

    '<SQLSERVER ConnectionName="" cls="TmConexaoSqlServer" ' +
               'DriverName="DevartSQLServer" GetDriverFunc="getSQLDriverSQLServer" ' +
               'LibraryName="dbexpsda.dll" VendorLib="sqloledb.dll" >' +

      '<types>' +
        'ALFA=VARCHAR({tam});' +
        'BOOLEANO=CHAR(1);' +
        'CARACTER=CHAR({tam});' +
        'DATAHORA=TIMESTAMP;' +
        'NUMERO=NUMERIC({tam}{dec});' +
        'INTEIRO=INTEGER;' +
        'IMAGE=BLOB;' +
        'TEXTO=CLOB' +
      '</types>' +

      '<database></database>' +
      '<sessions></sessions>' +
      '<limits></limits>' +
      '<date></date>' +

      '<tables tbl="" fld="" whr="" />' +
      '<views tbl="" fld="" whr="" />' +
      '<fields tbl="" tab="" fld="" />' +
      '<keys tbl="" fld="" whr="" />' +
      '<indexs tbl="" fld="" />' +
      '<procs tbl="" fld="" />' +
      '<functs tbl="" fld="" />' +
      '<args tbl="" fld="" />' +
      '<seqs tbl="" fld="" />' +

    '</SQLSERVER>';

//---------------------------

(*
DriverName="ODBC";
GetDriverFunc="getSQLDriverODBC";
LibraryName="dbexpmysql.DLL";
VendorLib = "odbc32.DLL";
*)

// 'select * from MyTableName where 1<>1 ';

{
POSTGREE / MYSQL - DATAYPES
---------------------------
Type / Use for / Size
TINYINT / A very small integer / The signed range is –128 to 127. The unsigned range is 0 to 255.
SMALLINT / A small integer / The signed range is –32768 to 32767. The unsigned range is 0 to 65535
MEDIUMINT / A medium-size integer / The signed range is –8388608 to 8388607. The unsigned range is 0 to 16777215
INT or INTEGER / A normal-size integer / The signed range is –2147483648 to 2147483647. The unsigned range is 0 to 4294967295
BIGINT / A large integer / The signed range is –9223372036854775808 to 9223372036854775807. The unsigned range is 0 to 18446744073709551615
FLOAT / A small (single-precision) floating-point number. Cannot be unsigned / Ranges are –3.402823466E+38 to –1.175494351E-38, 0 and 1.175494351E-38 to 3.402823466E+38. If the number of Decimals is not set or <= 24 it is a single-precision floating point number
DOUBLE, DOUBLE PRECISION, REAL / A normal-size (double-precision) floating-point number. Cannot be unsigned / Ranges are -1.7976931348623157E+308 to -2.2250738585072014E-308, 0 and 2.2250738585072014E-308 to 1.7976931348623157E+308. If the number of Decimals is not set or 25 <= Decimals <= 53 stands for a double-precision floating point number
DECIMAL, NUMERIC / An unpacked floating-point number. Cannot be unsigned / Behaves like a CHAR column: “unpacked” means the number is stored as a string, using one character for each digit of the value. The decimal point, and, for negative numbers, the ‘-‘ sign is not counted in Length. If Decimals is 0, values will have no decimal point or fractional part. The maximum range of DECIMAL values is the same as for DOUBLE, but the actual range for a given DECIMAL column may be constrained by the choice of Length and Decimals. If Decimals is left out it’s set to 0. If Length is left out it’s set to 10. Note that in MySQL 3.22 the Length includes the sign and the decimal point
DATE / A date / The supported range is ‘1000-01-01’ to ‘9999-12-31’. MySQL displays DATE values in ‘YYYY-MM-DD’ format
DATETIME / A date and time combination / The supported range is ‘1000-01-01 00:00:00’ to ‘9999-12-31 23:59:59’. MySQL displays DATETIME values in ‘YYYY-MM-DD HH:MM:SS’ format
TIMESTAMP / A timestamp / The range is ‘1970-01-01 00:00:00’ to sometime in the year 2037. MySQL displays TIMESTAMP values in YYYYMMDDHHMMSS, YYMMDDHHMMSS, YYYYMMDD or YYMMDD format, depending on whether M is 14 (or missing), 12, 8 or 6, but allows you to assign values to TIMESTAMP columns using either strings or numbers. A TIMESTAMP column is useful for recording the date and time of an INSERT or UPDATE operation because it is automatically set to the date and time of the most recent operation if you don’t give it a value yourself
TIME / A time / The range is ‘-838:59:59’ to ‘838:59:59’. MySQL displays TIME values in ‘HH:MM:SS’ format, but allows you to assign values to TIME columns using either strings or numbers
YEAR / A year in 2- or 4- digit formats (default is 4-digit) / The allowable values are 1901 to 2155, and 0000 in the 4 year format and 1970-2069 if you use the 2 digit format (70-69). MySQL displays YEAR values in YYYY format, but allows you to assign values to YEAR columns using either strings or numbers. (The YEAR type is new in MySQL 3.22.)
CHAR / A fixed-length string that is always right-padded with spaces to the specified length when stored / The range of Length is 1 to 255 characters. Trailing spaces are removed when the value is retrieved. CHAR values are sorted and compared in case-insensitive fashion according to the default character set unless the BINARY keyword is given
VARCHAR / A variable-length string. Note: Trailing spaces are removed when the value is stored (this differs from the ANSI SQL specification) / The range of Length is 1 to 255 characters. VARCHAR values are sorted and compared in case-insensitive fashion unless the BINARY keyword is given
TINYBLOB, TINYTEXT / A BLOB or TEXT column with a maximum length of 255 (2^8 - 1) characters
BLOB, TEXT / A BLOB or TEXT column with a maximum length of 65535 (2^16 - 1) characters
MEDIUMBLOB, MEDIUMTEXT / A BLOB or TEXT column with a maximum length of 16777215 (2^24 - 1) characters
LONGBLOB, LONGTEXT / A BLOB or TEXT column with a maximum length of 4294967295 (2^32 - 1) characters
ENUM / An enumeration / A string object that can have only one value, chosen from the list of values ‘value1’, ‘value2’, ..., or NULL. An ENUM can have a maximum of 65535 distinct values.
SET / A set / A string object that can have zero or more values, each of which must be chosen from the list of values ‘value1’, ‘value2’, ... A SET can have a maximum of 64 members
}

{
RESULT LIMITS

select * from T LIMIT 10 OFFSET 20             Netezza, MySQL, PostgreSQL (also supports the standard, since version 8.4), SQLite, HSQLDB, H2
select * from T where ROWNUM <= 10             Oracle (also supports the standard, since Oracle8i)
select FIRST 10 * from T                       Ingres
select FIRST 10 * from T order by a            Informix
select SKIP 20 FIRST 10 * from T order by c, d Informix (row numbers are filtered after order by is evaluated. SKIP clause was introduced in a v10.00.xC4 fixpack)
select TOP 10 * from T                         MS SQL Server, Sybase ASE, MS Access
select TOP 10 START AT 20 * from T             Sybase SQL Anywhere (also supports the standard, since version 9.0.1)
select FIRST 10 SKIP 20 * from T               Interbase, Firebird
select * from T ROWS 20 TO 30                  Firebird (since version 2.1)
select * from T
where ID_T > 10 FETCH FIRST 10 ROWS ONLY       DB2
select * from T
where ID_T > 20 FETCH FIRST 10 ROWS ONLY       DB2 (new rows are filtered after comparing with key column of table T)

1.To list databases aaccessible to user you connected with
  mysql: SHOW DATABASES
  postgresql: \l
  postgresql: SELECT datname FROM pg_database;
2.To list tables in your database
  mysql: SHOW TABLES
  postgresql: \d
  postgresql: SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
3.To list columns in particular table / schema use :
  mysql: SHOW COLUMNS
  postgresql: \d table
  postgresql: SELECT column_name FROM information_schema.columns WHERE table_name ='table‘;
}

{ FIREBIRD / INTERBASE
SELECT
  RDB$GET_CONTEXT('SYSTEM','DB_NAME') AS SYS_DBASE,
  RDB$GET_CONTEXT('SYSTEM','NETWORK_PROTOCOL') AS SYS_PROTOCOL,
  RDB$GET_CONTEXT('SYSTEM','CLIENT_ADDRESS') AS SYS_IP_ADDRESS,
  RDB$GET_CONTEXT('SYSTEM','CURRENT_USER') AS SYS_USER_ID,
  RDB$GET_CONTEXT('SYSTEM','SESSION_ID') AS SYS_SESSION,
  RDB$GET_CONTEXT('SYSTEM','TRANSACTION_ID') AS SYS_TTR,
  RDB$GET_CONTEXT('SYSTEM','ISOLATION_LEVEL') AS SYS_READ,
  CURRENT_DATE AS SYS_DTSERVER
FROM
  RDB$DATABASE
}

{ DB2
select * from SYSCAT.TABLES where TABSCHEMA = 'Myschema'
select * from SYSCAT.COLUMNS where TABSCHEMA = 'Myschema'
select * from SYSCAT.FUNCTIONS
select * from SYSCAT.COLUMNS where COLNAME = 'FOREIGNKEY'
select * from SYSIBM.SYSRELS where TBNAME = 'MYTABLE'
}

//--

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoDatabase)) to Ord(High(TTipoDatabase)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoDatabase), I));
end;

function tip(pTip : String) : TTipoDatabase;
begin
  Result := TTipoDatabase(GetEnumValue(TypeInfo(TTipoDatabase), pTip));
  if ord(Result) = -1 then
    Result := FIREBIRD;
end;

function str(pTip : TTipoDatabase) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoDatabase), Integer(pTip));
end;

function xml(pTip : TTipoDatabase) : String;
begin
  Result := itemX(str(pTip), cLST_DATABASE);
end;

function cls(pTip : TTipoDatabase) : String;
begin
  Result := itemA('cls', xml(pTip));
end;

//--

end.