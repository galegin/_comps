unit mTipoFormatar;

interface

uses
  Classes, SysUtils, StrUtils, TypInfo;

type
  TTipoFormatar =
    (CEP, CNPJ, CPF, DATA, FONE, INSC, NUMERO, PLACA,
     EMAIL, SENHA, SITE,
     NULO);

  function tip(pTip : String) : TTipoFormatar;
  function str(pTip : TTipoFormatar) : String;
  function xml(pTip : TTipoFormatar) : String;
  function fmt(pTip : TTipoFormatar) : String;

implementation

{ TmFormatar }

uses
  mFuncao, mXml;

const
  cLST_FORMATAR =
    '<CEP     fmt="99.999-999"          />' +
    '<CNPJ    fmt="#99.999.999/9999-99" />' +
    '<CPF     fmt="999.999.999-99"      />' +
    '<DATA    fmt="99/99/9999"          />' +
    '<FONE    fmt="(###)##999-9999"     />' +
    '<INSC    fmt="999.999.999.999"     />' +
    '<NUMERO  fmt="#,###,###,##0"       />' +
    '<PLACA   fmt="ZZZ-9999"            />' +
    '<EMAIL   fmt=""                    />' +
    '<SENHA   fmt=""                    />' +
    '<SITE    fmt=""                    />' +
    '<NULO    fmt=""                    />' ;

function tip(pTip : String) : TTipoFormatar;
begin
  Result := TTipoFormatar(GetEnumValue(TypeInfo(TTipoFormatar), pTip));
end;

function str(pTip : TTipoFormatar) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoFormatar), Integer(pTip));
end;

function xml(pTip : TTipoFormatar) : String;
begin
  Result := itemX(str(pTip), cLST_FORMATAR);
end;

function fmt(pTip : TTipoFormatar) : String;
begin
  Result := itemA('fmt', xml(pTip));
end;

end.
