unit mTipoMessage;

interface

uses
  Classes, SysUtils, TypInfo, mFont;

type
  TTipoMessage =
    (AVISO, ERRO, INFO);

  function lst() : String;
  function tip(pTip : String) : TTipoMessage;
  function str(pTip : TTipoMessage) : String;
  function xml(pTip : TTipoMessage) : String;
  function des(pTip : TTipoMessage) : String;
  function fnt(pTip : TTipoMessage) : TmFont;
  function bep(pTip : TTipoMessage) : Integer;

implementation

uses
  mItem, mXml;

const
  cLST_TPMESSAGE =
    '<AVISO des="Aviso" beep="64" cor="clYellow"  corfnt="clBlack" />' +
    '<ERRO  des="Erro"  beep="16" cor="clRed"     corfnt="clWhite" />' +
    '<INFO  des="Info"  beep="00" cor="clTeal"    corfnt="clWhite" />' ;

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoMessage)) to Ord(High(TTipoMessage)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoMessage), I));
end;

function tip(pTip : String) : TTipoMessage;
begin
  Result := TTipoMessage(GetEnumValue(TypeInfo(TTipoMessage), pTip));
  if ord(Result) = -1 then
    Result := INFO;
end;

function str(pTip : TTipoMessage) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoMessage), Integer(pTip));
end;

function xml(pTip : TTipoMessage) : String;
begin
  Result := itemX(str(pTip), cLST_TPMESSAGE);
end;

function des(pTip : TTipoMessage) : String;
begin
  Result := itemA('des', xml(pTip));
end;

function fnt(pTip : TTipoMessage) : TmFont;
begin
  Result := TmFont.Create(itemA('cor', xml(pTip)), itemA('corfnt', xml(pTip)));
end;

function bep(pTip : TTipoMessage) : Integer;
begin
  Result := itemAI('beep', xml(pTip));
end;

end.