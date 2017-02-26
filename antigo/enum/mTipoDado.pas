unit mTipoDado;

interface

uses
  Classes, SysUtils, TypInfo;

type
  TTipoDado =
    (ALFA, BOOLEANO, BINARIO, DATAHORA, IMAGE, INTEIRO, NUMERO, TEXTO);

  function lst() : String;
  function tip(pTip : String) : TTipoDado;
  function str(pTip : TTipoDado) : String;

implementation

uses
  mItem;

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoDado)) to Ord(High(TTipoDado)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoDado), I));
end;

function tip(pTip : String) : TTipoDado;
begin
  Result := TTipoDado(GetEnumValue(TypeInfo(TTipoDado), pTip));
  if ord(Result) = -1 then
    Result := ALFA;
end;

function str(pTip : TTipoDado) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoDado), Integer(pTip));
end;

end.