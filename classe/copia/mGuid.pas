unit mGuid;

interface

uses
  ActiveX, ComObj;

type
  TmGuid = class
  public
    class function Get() : String;
  end;

implementation

{ TmGuid }

class function TmGuid.Get: String;
var
  ID : TGUID;
begin
  if CoCreateGuid(ID) = S_OK then
    Result := GUIDToString(ID)
  else
    Result := '';  
end;

end.
