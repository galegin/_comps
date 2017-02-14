unit mTnsNames; // cTnsNames

interface

uses
  Classes, SysUtils,
  mParametroDatabase, mIniFiles, mPath;

type
  TmTnsNames = class
  public
    class procedure SetParametro(AParametroDatabase : TmParametroDatabase);
  end;

implementation

{ TmTnsNames }

class procedure TmTnsNames.SetParametro(AParametroDatabase : TmParametroDatabase);
var
  vArquivo, vCaminho : String;
begin
  with AParametroDatabase do begin
    vArquivo := TmPath.Current() + 'tnsNames.tns';
    vCaminho := TmIniFiles.PegarS(vArquivo, 'DATABASE', Cd_Database, '');
    if vCaminho <> '' then begin
      Cd_Database := vCaminho + Cd_Username + '.fdb';
      Cd_Username := 'SYSDBA';
      Cd_Password := 'masterkey';
    end;
  end;
end;

end.