unit mDelphi;

interface

uses
  Classes, SysUtils, Windows;

type
  TmDelphi = class
  public
    class function IsOpen() : Boolean;
  end;

implementation

uses
  mIniFiles;

{ TmDelphi }

class function TmDelphi.IsOpen: Boolean;
begin
  Result := (FindWindow('TAppBuilder', nil) > 0) and TmIniFiles.PegarB('', '', 'In_Debug');
end;

end.