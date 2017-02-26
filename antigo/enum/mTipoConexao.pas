unit mTipoConexao;

interface

uses
  Classes, SysUtils, TypInfo;

type
  TTipoConexao = (USUARIO, GLOBAL, LOGIN, CREATE, CONNECT);

  function lst() : String;
  function tip(pTip : String) : TTipoConexao;
  function str(pTip : TTipoConexao) : String;

implementation

uses
  mItem;

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoConexao)) to Ord(High(TTipoConexao)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoConexao), I));
end;

function tip(pTip : String) : TTipoConexao;
begin
  Result := TTipoConexao(GetEnumValue(TypeInfo(TTipoConexao), pTip));
  if ord(Result) = -1 then
    Result := USUARIO;
end;

function str(pTip : TTipoConexao) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoConexao), Integer(pTip));
end;

end.