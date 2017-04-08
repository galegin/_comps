unit  mTipoTempo;

(* mTipoTempo *)

interface

uses
  Classes, SysUtils, StrUtils;

type
  TTipoTempo = (
    ttAno,
    ttMes,
    ttDia,
    ttHor,
    ttMin,
    ttSeg);

  RTipoTempo = record
    Tipo : TTipoTempo;
    Codigo : String;
    Multiplo : Real;
    Formato : String;
  end;

  function GetTipoTempo(const ACodigo : string) : RTipoTempo;
  function StrToTipoTempo(const ACodigo : string) : TTipoTempo;
  function TipoTempoToStr(const ATipo : TTipoTempo) : string;

implementation

const
  LTipoTempo : Array [TTipoTempo] of RTipoTempo = (
    (Tipo: ttAno; Codigo: 'A'; Multiplo: 60 * 24 * 365; Formato: 'aaa:mm'),
    (Tipo: ttMes; Codigo: 'M'; Multiplo: 60 * 24 * 30 ; Formato: 'mmm:dd'),
    (Tipo: ttDia; Codigo: 'D'; Multiplo: 60 * 24      ; Formato: 'ddd:hh'),
    (Tipo: ttHor; Codigo: 'H'; Multiplo: 60           ; Formato: 'hhh:nn'),
    (Tipo: ttMin; Codigo: 'N'; Multiplo: 1            ; Formato: 'nnn:ss'),
    (Tipo: ttSeg; Codigo: 'S'; Multiplo: 1 / 60       ; Formato: 'sss:mm'));

function GetTipoTempo(const ACodigo : string) : RTipoTempo;
var
  I : Integer;
begin
  Result.Tipo := TTipoTempo(Ord(-1));
  Result.Codigo := ACodigo;
  for I := Ord(Low(TTipoTempo)) to Ord(High(TTipoTempo)) do
    if LTipoTempo[TTipoTempo(I)].Codigo = ACodigo then
      Result := LTipoTempo[TTipoTempo(I)];
end;

function StrToTipoTempo(const ACodigo : string) : TTipoTempo;
begin
  Result := GetTipoTempo(ACodigo).Tipo;
end;

function TipoTempoToStr(const ATipo : TTipoTempo) : string;
begin
  Result := LTipoTempo[ATipo].Codigo;
end;

end.