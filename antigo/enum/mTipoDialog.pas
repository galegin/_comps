unit mTipoDialog;

interface

uses
  Classes, SysUtils, TypInfo;

type
  TTipoDialog =
    (INPUT, MENSAGEM, PERGUNTA);

  function lst() : String;
  function tip(pTip : String) : TTipoDialog;
  function str(pTip : TTipoDialog) : String;
  function xml(pTip : TTipoDialog) : String;
  function des(pTip : TTipoDialog) : String;
  function opc(pTip : TTipoDialog) : String;

implementation

uses
  mItem, mXml;

const
  cLST_TPDIALOG =
    '<INPUT    des="Entrada"     opc="C&onfirmar|&Cancelar" />' +
    '<MENSAGEM des="Mensagem"    opc="&OK"                  />' +
    '<PERGUNTA des="Confirmação" opc="C&onfirmar|&Cancelar" />' ;

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoDialog)) to Ord(High(TTipoDialog)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoDialog), I));
end;

function tip(pTip : String) : TTipoDialog;
begin
  Result := TTipoDialog(GetEnumValue(TypeInfo(TTipoDialog), pTip));
  if ord(Result) = -1 then
    Result := MENSAGEM;
end;

function str(pTip : TTipoDialog) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoDialog), Integer(pTip));
end;

function xml(pTip : TTipoDialog) : String;
begin
  Result := itemX(str(pTip), cLST_TPDIALOG);
end;

function des(pTip : TTipoDialog) : String;
begin
  Result := itemA('des', xml(pTip));
end;

function opc(pTip : TTipoDialog) : String;
begin
  Result := itemA('opc', xml(pTip));
end;

end.
