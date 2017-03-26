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
    Formato : String;
  end;

  function GetTipoCampo(const s : string) : RTipoCampo;
  function StrToTipoCampo(const s : string) : TTipoCampo;
  function TipoCampoToStr(const t : TTipoCampo) : string;
  function TipoCampoToDes(const t : TTipoCampo) : string;
  function TipoCampoToTam(const t : TTipoCampo) : integer;
  function TipoCampoToDec(const t : TTipoCampo) : integer;
  function TipoCampoToFmt(const t : TTipoCampo) : string;

implementation

const
  LTipoCampo : Array [TTipoCampo] of RTipoCampo = (
    (Tipo: tcCodigo    ; Codigo: 'Cd_'; Descricao: 'Cod.'; Tamanho: 10; Decimal: 0; Formato: ''),
    (Tipo: tcDataHora  ; Codigo: 'Dt_'; Descricao: 'Dt.' ; Tamanho: 10; Decimal: 0; Formato: 'dd/mm/yyyy'),
    (Tipo: tcDescricao ; Codigo: 'Ds_'; Descricao: 'Ds.' ; Tamanho: 60; Decimal: 0; Formato: ''),
    (Tipo: tcIndicador ; Codigo: 'In_'; Descricao: ''    ; Tamanho: 01; Decimal: 0; Formato: ''),
    (Tipo: tcNome      ; Codigo: 'Nm_'; Descricao: 'Nome'; Tamanho: 60; Decimal: 0; Formato: ''),
    (Tipo: tcNumero    ; Codigo: 'Nr_'; Descricao: 'Nr.' ; Tamanho: 10; Decimal: 0; Formato: '0'),
    (Tipo: tcPercentual; Codigo: 'Pr_'; Descricao: 'Pr.' ; Tamanho: 06; Decimal: 3; Formato: '0.00'),
    (Tipo: tcQuantidade; Codigo: 'Qt_'; Descricao: 'Qt.' ; Tamanho: 08; Decimal: 3; Formato: '0.000'),
    (Tipo: tcTipagem   ; Codigo: 'Tp_'; Descricao: 'Tp.' ; Tamanho: 10; Decimal: 0; Formato: ''),
    (Tipo: tcValor     ; Codigo: 'Vl_'; Descricao: 'Vl.' ; Tamanho: 15; Decimal: 2; Formato: '0.00'),
    (Tipo: tcVersion   ; Codigo: 'U_V'; Descricao: ''    ; Tamanho: 01; Decimal: 0; Formato: ''));

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

function TipoCampoToDes(const t : TTipoCampo) : string;
begin
  Result := LTipoCampo[TTipoCampo(t)].Descricao;
end;

function TipoCampoToTam(const t : TTipoCampo) : integer;
begin
  Result := LTipoCampo[TTipoCampo(t)].Tamanho;
end;

function TipoCampoToDec(const t : TTipoCampo) : integer;
begin
  Result := LTipoCampo[TTipoCampo(t)].Decimal;
end;

function TipoCampoToFmt(const t : TTipoCampo) : string;
begin
  Result := LTipoCampo[TTipoCampo(t)].Formato;
end;

end.