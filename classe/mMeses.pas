unit mMeses;

interface

uses
  Classes, SysUtils, StrUtils;
  
type
  TmMeses = class
  public
    class function Codigo(ADescricao : String) : Integer;
    class function Descricao(ACodigo : Integer) : String;
  end;

implementation

const
  c  Meses : Array [1..12] of String = (
    'Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezempbro');

{ TmMeses }

class function TmMeses.Codigo(ADescricao: String): Integer;
var
  I : Integer;
begin
  Result := 0;
  for I := Low(cMeses) to High(cMeses) do
    if LowerCase(cMeses[I]) = LowerCase(ADescricao) then
      Result := I;
end;

class function TmMeses.Descricao(ACodigo: Integer): String;
begin
  Result := cMeses[ACodigo];
end;

end.