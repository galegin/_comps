unit mTipoFormato;

interface

uses
  SysUtils, StrUtils;

type
  TTipoFormato = (
    tfCodigo,
    tfData,
    tfDataHora,
    tfDescricao,
    tfIndicador,
    tfNome,
    tfNumero,
    tfPercentual,
    tfQuantidade,
    tfTipagem,
    tfValor,
    tfVersion,

    tfCep,
    tfCnpj,
    tfCpf,
    tfInscricao,
    tfPlaca,
    tfTelefone,
    tfEmail,
    tfSite,
    tfSenha);

  RTipoFormato = record
    Tipo : TTipoFormato;
    Codigo : String;
    Descricao : String;
    Tamanho : Integer;
    Decimal : Integer;
    Formato : String;
  end;

  function GetTipoFormato(const ACodigo : string) : RTipoFormato;
  function StrToTipoFormato(const ACodigo : string) : TTipoFormato;
  function TipoFormatoToStr(const ATipo : TTipoFormato) : string;
  function TipoFormatoToDes(const ATipo : TTipoFormato) : string;
  function TipoFormatoToTam(const ATipo : TTipoFormato) : integer;
  function TipoFormatoToDec(const ATipo : TTipoFormato) : integer;
  function TipoFormatoToFmt(const ATipo : TTipoFormato) : string;

implementation

const
  LTipoFormato : Array [TTipoFormato] of RTipoFormato = (
    (Tipo: tfCodigo    ; Codigo: 'Cd_'     ; Descricao: 'Cod.' ; Tamanho: 10; Decimal: 0; Formato: ''),
    (Tipo: tfData      ; Codigo: 'Dt_'     ; Descricao: 'Dt.'  ; Tamanho: 10; Decimal: 0; Formato: 'dd/mm/yyyy'),
    (Tipo: tfDataHora  ; Codigo: 'Dh_'     ; Descricao: 'Dh.'  ; Tamanho: 10; Decimal: 0; Formato: 'dd/mm/yyyy hh:nn:ss'),
    (Tipo: tfDescricao ; Codigo: 'Ds_'     ; Descricao: 'Ds.'  ; Tamanho: 60; Decimal: 0; Formato: ''),
    (Tipo: tfIndicador ; Codigo: 'In_'     ; Descricao: ''     ; Tamanho: 01; Decimal: 0; Formato: ''),
    (Tipo: tfNome      ; Codigo: 'Nm_'     ; Descricao: 'Nome' ; Tamanho: 60; Decimal: 0; Formato: ''),
    (Tipo: tfNumero    ; Codigo: 'Nr_'     ; Descricao: 'Nr.'  ; Tamanho: 10; Decimal: 0; Formato: '0'),
    (Tipo: tfPercentual; Codigo: 'Pr_'     ; Descricao: 'Pr.'  ; Tamanho: 06; Decimal: 3; Formato: '0.00'),
    (Tipo: tfQuantidade; Codigo: 'Qt_'     ; Descricao: 'Qt.'  ; Tamanho: 08; Decimal: 3; Formato: '0.000'),
    (Tipo: tfTipagem   ; Codigo: 'Tp_'     ; Descricao: 'Tp.'  ; Tamanho: 10; Decimal: 0; Formato: ''),
    (Tipo: tfValor     ; Codigo: 'Vl_'     ; Descricao: 'Vl.'  ; Tamanho: 15; Decimal: 2; Formato: '0.00'),
    (Tipo: tfVersion   ; Codigo: 'U_V'     ; Descricao: ''     ; Tamanho: 01; Decimal: 0; Formato: ''),

    (Tipo: tfCep       ; Codigo: 'Cd_Cep'  ; Descricao: 'Cep'  ; Tamanho: 10; Decimal: 0; Formato: '**.***-***'),
    (Tipo: tfCnpj      ; Codigo: 'Nr_Cnpj' ; Descricao: 'Cnpj' ; Tamanho: 20; Decimal: 0; Formato: '**.***.***/****-**'),
    (Tipo: tfCpf       ; Codigo: 'Nr_Cpf'  ; Descricao: 'Cpf'  ; Tamanho: 20; Decimal: 0; Formato: '***.***.***-**'),
    (Tipo: tfInscricao ; Codigo: 'Nr_Insc' ; Descricao: 'Insc.'; Tamanho: 20; Decimal: 0; Formato: '***.***.***.***'),
    (Tipo: tfPlaca     ; Codigo: 'Nr_Placa'; Descricao: 'Placa'; Tamanho: 10; Decimal: 0; Formato: '***-****'),
    (Tipo: tfTelefone  ; Codigo: 'Nr_Fone' ; Descricao: 'Fone' ; Tamanho: 20; Decimal: 0; Formato: '(**)*-****-****'),
    (Tipo: tfEmail     ; Codigo: 'Ds_Email'; Descricao: 'Email'; Tamanho: 80; Decimal: 0; Formato: 'x@x.x'),
    (Tipo: tfSite      ; Codigo: 'Ds_Site' ; Descricao: 'Site' ; Tamanho: 80; Decimal: 0; Formato: 'x.x'),
    (Tipo: tfSenha     ; Codigo: 'Ds_Senha'; Descricao: 'Senha'; Tamanho: 20; Decimal: 0; Formato: 'x'));

function GetTipoFormato(const ACodigo : string) : RTipoFormato;
var
  I : Integer;
begin
  Result.Tipo := TTipoFormato(Ord(-1));
  for I := Ord(Low(TTipoFormato)) to Ord(High(TTipoFormato)) do
    if LTipoFormato[TTipoFormato(I)].Codigo = ACodigo then
      Result := LTipoFormato[TTipoFormato(I)];
end;

function StrToTipoFormato(const ACodigo : string) : TTipoFormato;
begin
  Result := GetTipoFormato(ACodigo).Tipo;
end;

function TipoFormatoToStr(const ATipo : TTipoFormato) : string;
begin
  Result := LTipoFormato[ATipo].Codigo;
end;

function TipoFormatoToDes(const ATipo : TTipoFormato) : string;
begin
  Result := LTipoFormato[ATipo].Descricao;
end;

function TipoFormatoToTam(const ATipo : TTipoFormato) : integer;
begin
  Result := LTipoFormato[ATipo].Tamanho;
end;

function TipoFormatoToDec(const ATipo : TTipoFormato) : integer;
begin
  Result := LTipoFormato[ATipo].Decimal;
end;

function TipoFormatoToFmt(const ATipo : TTipoFormato) : string;
begin
  Result := LTipoFormato[ATipo].Formato;
end;

end.