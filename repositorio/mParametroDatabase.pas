unit mParametroDatabase;

interface

uses
  Classes, SysUtils,
  mTipoDatabase, mIniFiles;

type
  TmParametroDatabase = class
  private
    function GetFormatoDataHora: String;
  public
    Cd_Ambiente : String;
    Tp_Database : TTipoDatabase;
    Cd_Database : String;
    Cd_Username : String;
    Cd_Password : String;
    Cd_Hostname : String;
    Cd_Hostport : String;
    Cd_Protocol : String;

    property FormatoDataHora : String read GetFormatoDataHora;

    class function GetParametroDatabase() : TmParametroDatabase;
  end;

  function Instance : TmParametroDatabase;

implementation

const
  FormatoDataHoraArray : Array [TTipoDatabase] of string = // mTipoDatabase
    ('dd.mm.yyyy hh:nn:ss',
     'dd/mm/yyyy hh:nn:ss',
     'dd/mm/yyyy hh:nn:ss',
     'dd/mm/yyyy hh:nn:ss',
     'dd/mm/yyyy hh:nn:ss',
     'dd/mm/yyyy hh:nn:ss',
     'dd/mm/yyyy hh:nn:ss',
     'dd/mm/yyyy hh:nn:ss',
     'dd/mm/yyyy hh:nn:ss');

var
  _instance : TmParametroDatabase;

  function Instance : TmParametroDatabase;
  begin
    if not Assigned(_instance) then
      _instance := TmParametroDatabase.GetParametroDatabase();
    Result := _instance;
  end;

{ TmParametroDatabase }

function TmParametroDatabase.GetFormatoDataHora: String;
begin
  Result := FormatoDataHoraArray[Tp_Database];
end;

class function TmParametroDatabase.GetParametroDatabase: TmParametroDatabase;
begin
  Result := TmParametroDatabase.Create;
  with Result do begin
    Cd_Ambiente := TmIniFiles.PegarS('', '', 'Cd_Ambiente', '');
    Tp_Database := StrToTipoDatabase(TmIniFiles.PegarS('', '', 'Tp_Database', 'tpdFirebird'));
    Cd_Database := TmIniFiles.PegarS('', '', 'Cd_Database', '');
    Cd_Username := TmIniFiles.PegarS('', '', 'Cd_Username', '');
    Cd_Password := TmIniFiles.PegarS('', '', 'Cd_Password', '');
    Cd_Hostname := TmIniFiles.PegarS('', '', 'Cd_Hostname', '');
    Cd_Hostport := TmIniFiles.PegarS('', '', 'Cd_Hostport', '');
  end;
end;

end.