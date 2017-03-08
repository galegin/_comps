unit mTipoCampo;

interface

uses
  SysUtils, StrUtils;

type
  TTipoCampo = (
    tcCodigo,
    tcDataHora,
    tcDescricao,
    tcIndicador,
    tcNome,
    tcNumero,
    tcPercentual,
    tcQuantidade,
    tcTipagem,
    tcValor,
    tcVersion);

  RTipoCampo = record
    Tipo : TTipoCampo;
    Codigo : String;
    Descricao : String;
    Tamanho : Integer;
    Decimal : Integer;
  end;

  function GetTipoCampo(const s : string) : RTipoCampo;
  function StrToTipoCampo(const s : string) : TTipoCampo;
  function TipoCampoToStr(const t : TTipoCampo) : string;

implementation

const
  LTipoCampo : Array [TTipoCampo] of RTipoCampo = (
    (Tipo: tcCodigo    ; Codigo: 'Cd_'; Descricao: 'Cod.'; Tamanho: 10; Decimal: 0),
    (Tipo: tcDataHora  ; Codigo: 'Dt_'; Descricao: 'Dt.' ; Tamanho: 10; Decimal: 0),
    (Tipo: tcDescricao ; Codigo: 'Ds_'; Descricao: 'Ds.' ; Tamanho: 60; Decimal: 0),
    (Tipo: tcIndicador ; Codigo: 'In_'; Descricao: ''    ; Tamanho: 01; Decimal: 0),
    (Tipo: tcNome      ; Codigo: 'Nm_'; Descricao: 'Nome'; Tamanho: 60; Decimal: 0),
    (Tipo: tcNumero    ; Codigo: 'Nr_'; Descricao: 'Nr.' ; Tamanho: 10; Decimal: 0),
    (Tipo: tcPercentual; Codigo: 'Pr_'; Descricao: 'Pr.' ; Tamanho: 06; Decimal: 3),
    (Tipo: tcQuantidade; Codigo: 'Qt_'; Descricao: 'Qt.' ; Tamanho: 08; Decimal: 3),
    (Tipo: tcTipagem   ; Codigo: 'Tp_'; Descricao: 'Tp.' ; Tamanho: 10; Decimal: 0),
    (Tipo: tcValor     ; Codigo: 'Vl_'; Descricao: 'Vl.' ; Tamanho: 15; Decimal: 2),
    (Tipo: tcVersion   ; Codigo: 'U_V'; Descricao: ''    ; Tamanho: 01; Decimal: 0));

function GetTipoCampo(const s : string) : RTipoCampo;
var
  I : Integer;
begin
  Result.Tipo := TTipoCampo(Ord(-1));
  for I := Ord(Low(TTipoCampo)) to Ord(High(TTipoCampo)) do
    if LTipoCampo[TTipoCampo(I)].Codigo = s then
      Result := LTipoCampo[TTipoCampo(I)];
end;

function StrToTipoCampo(const s : string) : TTipoCampo;
begin
  Result := GetTipoCampo(s).Tipo;
end;

function TipoCampoToStr(const t : TTipoCampo) : string;
begin
  Result := LTipoCampo[TTipoCampo(t)].Codigo;
end;

end.