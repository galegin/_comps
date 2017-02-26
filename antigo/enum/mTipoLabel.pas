unit mTipoLabel;

interface

uses
  Classes, SysUtils, TypInfo,
  mFont;

type
  TTipoLabel = (NULO, BOTAO, EDICAO, ROTULO, DESCR, OPCAO, TITULO);

  function lst() : String;
  function tip(pTip : String) : TTipoLabel;
  function str(pTip : TTipoLabel) : String;
  function fnt(pTip : TTipoLabel) : TmFont;

implementation

uses
  mEstilo, mItem;

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoLabel)) to Ord(High(TTipoLabel)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoLabel), I));
end;

function tip(pTip : String) : TTipoLabel;
begin
  Result := TTipoLabel(GetEnumValue(TypeInfo(TTipoLabel), pTip));
  if (Ord(Result) = -1) then
    Result := ROTULO;
end;

function str(pTip : TTipoLabel) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoLabel), Integer(pTip));
end;

function fnt(pTip : TTipoLabel) : TmFont;
begin
  Result := mEstilo.getFont(str(pTip));
end;

end.
