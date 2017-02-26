unit mTipoLabelButton;

interface

uses
  Classes, SysUtils, TypInfo,
  mFont;

type
  TTipoLabelButton = (BOTAO, EDICAO, ROTULO, DESCR);

  function lst() : String;
  function tip(pTip : String) : TTipoLabelButton;
  function str(pTip : TTipoLabelButton) : String;
  function fnt(pTip : TTipoLabelButton) : TmFont;

implementation

uses
  mItem;

const
  cLST_COLOR =
    '<BOTAO  cor="$00A56E3A" corfnt="clWhite" />' +
    '<EDICAO cor="clWhite"   corfnt="clBlack" />' +
    '<ROTULO cor="clGray"    corfnt="clWhite" />' +
    '<DESCR  cor="clSilver"  corfnt="clBlack" />';

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoLabelButton)) to Ord(High(TTipoLabelButton)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoLabelButton), I));
end;

function tip(pTip : String) : TTipoLabelButton;
begin
  Result := TTipoLabelButton(GetEnumValue(TypeInfo(TTipoLabelButton), pTip));
  if (Ord(Result) = -1) then
    Result := ROTULO;
end;

function str(pTip : TTipoLabelButton) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoLabelButton), Integer(pTip));
end;

function fnt(pTip : TTipoLabelButton) : TmFont;
begin
end;

end.
