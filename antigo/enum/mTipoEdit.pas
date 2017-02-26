unit mTipoEdit;

interface

uses
  Classes, SysUtils, TypInfo,
  mFont;

type
  TTipoEdit = (DESCR, EDICAO, CAMPO, TOTAL);

  function lst() : String;
  function tip(pTip : String) : TTipoEdit;
  function str(pTip : TTipoEdit) : String;
  function fnt(pTip : TTipoEdit) : TmFont;

implementation

uses
  mEstilo, mItem;

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoEdit)) to Ord(High(TTipoEdit)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoEdit), I));
end;

function tip(pTip : String) : TTipoEdit;
begin
  Result := TTipoEdit(GetEnumValue(TypeInfo(TTipoEdit), pTip));
  if (Ord(Result) = -1) then
    Result := CAMPO;
end;

function str(pTip : TTipoEdit) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoEdit), Integer(pTip));
end;

function fnt(pTip : TTipoEdit) : TmFont;
begin
  Result := mEstilo.getFont(str(pTip));
end;

end.
