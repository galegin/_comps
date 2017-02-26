unit mDelphi; // mAppProtect mLogin

interface

uses
  Classes, SysUtils, Windows;

type
  TmDelphi = class
  public
    class function isOpen() : Boolean;
  end;

implementation

{ TmDelphi }

class function TmDelphi.isOpen: Boolean;
begin
  Result := (FindWindow('TAppBuilder', nil) > 0); //and TmParamIni.pegarB('IN_DEBUG');
end;

end.