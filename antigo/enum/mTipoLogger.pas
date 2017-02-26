unit mTipoLogger;

interface

uses
  Classes, SysUtils, TypInfo;

type
  TTipoLogger = (ERROR, DEBUG, INFO, WARNING);

  function lst() : String;
  function tip(pTip : String) : TTipoLogger;
  function str(pTip : TTipoLogger) : String;

implementation

uses
  mItem;

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoLogger)) to Ord(High(TTipoLogger)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoLogger), I));
end;

function tip(pTip : String) : TTipoLogger;
begin
  Result := TTipoLogger(GetEnumValue(TypeInfo(TTipoLogger), pTip));
  if ord(Result) = -1 then
    Result := ERROR;
end;

function str(pTip : TTipoLogger) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoLogger), Integer(pTip));
end;

end.