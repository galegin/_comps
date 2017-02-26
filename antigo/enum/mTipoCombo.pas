unit mTipoCombo; // mTipoDatabase

interface

uses
  Classes, SysUtils, TypInfo;

type
  TTipoCombo = (ALL, COD, DES);

  function lst() : String;
  function tip(pTip : String) : TTipoCombo;
  function str(pTip : TTipoCombo) : String;

implementation

uses
  mItem;

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoCombo)) to Ord(High(TTipoCombo)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoCombo), I));
end;

function tip(pTip : String) : TTipoCombo;
begin
  Result := TTipoCombo(GetEnumValue(TypeInfo(TTipoCombo), pTip));
  if ord(Result) = -1 then
    Result := ALL;
end;

function str(pTip : TTipoCombo) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoCombo), Integer(pTip));
end;

end.