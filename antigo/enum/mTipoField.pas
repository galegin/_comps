unit mTipoField; // mTipoDatabase

interface

uses
  Classes, SysUtils, TypInfo;

type
  TTipoField =
    (ALL, KEY, REQ, NUL);

  function lst() : String;
  function tip(pTip : String) : TTipoField;
  function str(pTip : TTipoField) : String;

implementation

uses
  mItem;

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoField)) to Ord(High(TTipoField)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoField), I));
end;

function tip(pTip : String) : TTipoField;
begin
  Result := TTipoField(GetEnumValue(TypeInfo(TTipoField), pTip));
  if ord(Result) = -1 then
    Result := ALL;
end;

function str(pTip : TTipoField) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoField), Integer(pTip));
end;

end.