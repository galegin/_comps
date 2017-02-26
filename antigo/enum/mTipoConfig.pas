unit mTipoConfig; // mTipoDatabase

interface

uses
  Classes, SysUtils, TypInfo;

type
  TTipoConfig =
    (CD_AMBIENTE, TP_DATABASE, CD_DATABASE, CD_USERNAME, CD_PASSWORD, CD_HOSTNAME, CD_HOSTPORT);

  function lst() : String;
  function tip(pTip : String) : TTipoConfig;
  function str(pTip : TTipoConfig) : String;
  function xml(pTip : TTipoConfig) : String;
  function atr(pTip : TTipoConfig) : String;

implementation

uses
  mItem, mXml;

const
  cLST_CONFIG =
    '<CD_AMBIENTE atr="cdAmbiente" />' +
    '<TP_DATABASE atr="tpDatabase" />' +
    '<CD_DATABASE atr="cdDatabase" />' +
    '<CD_USERNAME atr="cdUsername" />' +
    '<CD_PASSWORD atr="cdPassword" />' +
    '<CD_HOSTNAME atr="cdHostname" />' +
    '<CD_HOSTPORT atr="cdHostport" />' ;

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoConfig)) to Ord(High(TTipoConfig)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoConfig), I));
end;

function tip(pTip : String) : TTipoConfig;
begin
  Result := TTipoConfig(GetEnumValue(TypeInfo(TTipoConfig), pTip));
  if ord(Result) = -1 then
    Result := CD_AMBIENTE;
end;

function str(pTip : TTipoConfig) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoConfig), Integer(pTip));
end;

function xml(pTip : TTipoConfig) : String;
begin
  Result := itemX(str(pTip), cLST_CONFIG);
end;

function atr(pTip : TTipoConfig) : String;
begin
  Result := itemA('atr', xml(pTip));
end;

end.