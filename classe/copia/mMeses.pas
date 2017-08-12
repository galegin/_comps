unit mMeses;

interface

uses
  Classes, SysUtils, StrUtils;

  function MesToInt(const s : String) : Integer;
  function IntToMes(const i : Integer) : String;

implementation

const
  LMeses : Array [1..12] of String = (
    'Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro');

function MesToInt(const s : String) : Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := Low(LMeses) to High(LMeses) do
    if LowerCase(LMeses[I]) = LowerCase(s) then
      Result := I;
end;

function IntToMes(const i : Integer) : String;
begin
  Result := LMeses[i];
end;

end.