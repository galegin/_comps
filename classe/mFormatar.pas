unit mFormatar;

interface

uses
  Classes, SysUtils, StrUtils, TypInfo,
  mTipoFormato;

type
  TmFormatar = class
  public
    class function Conteudo(pTip: TTipoFormato; pCnt : String; pSub : String) : String;
    class function Remover(pCnt : String) : String;

    class function Documento(pCnt: String): String;
    class function Cnpj(pCnt : String) : String;
    class function Cpf(pCnt : String) : String;

    class function Cep(pCnt : String) : String;
    class function Data(pCnt : String) : String;
    class function Placa(pCnt : String) : String;
    class function Fone(pCnt : String) : String;

    class function Inscricao(pCnt, pTip : String) : String;
  end;

implementation

{ TmFormatar }

class function TmFormatar.Conteudo(pTip: TTipoFormato; pCnt: String; pSub: String): String;
begin
  case pTip of
    tfCep:
      Result := Cep(pCnt);
    tfCnpj:
      Result := Cnpj(pCnt);
    tfCpf:
      Result := Cpf(pCnt);
    tfData:
      Result := Data(pCnt);
    tfInscricao:
      Result := Inscricao(pCnt, pSub);
    tfPlaca:
      Result := Placa(pCnt);
    tfTelefone:
      Result := Fone(pCnt);
  else
    Result := pCnt;
  end;
end;

class function TmFormatar.Remover(pCnt : String) : String;
var
  I : Integer;
begin
  Result := '';
  for I := 0 to Length(pCnt) do
    if pCnt[I] in ['0'..'9', 'A'..'Z', 'a'..'z'] then
      Result := Result + pCnt[I];
end;

//--

class function TmFormatar.Documento(pCnt: String): String;
begin
  case Length(pCnt) of
    11: Result := TmFormatar.Inscricao(pCnt, 'CPF');
    14: Result := TmFormatar.Inscricao(pCnt, 'CNPJ');
  else
    Result := '';
  end;
end;

class function TmFormatar.Cpf(pCnt: String): String;
begin
  Result := TmFormatar.Inscricao(pCnt, 'CPF');
end;

class function TmFormatar.Cnpj(pCnt: String): String;
begin
  Result := TmFormatar.Inscricao(pCnt, 'CNPJ');
end;

//--

class function TmFormatar.Cep(pCnt: String): String;
begin
  Result := TmFormatar.Inscricao(pCnt, 'CPF');
end;

class function TmFormatar.Data(pCnt : String) : String;
begin
  Result := TmFormatar.Inscricao(pCnt, 'DATA');
end;

class function TmFormatar.Placa(pCnt : String) : String;
begin
  Result := TmFormatar.Inscricao(pCnt, 'PLACA');
end;

class function TmFormatar.Fone(pCnt : String) : String;
begin
  Result := TmFormatar.Inscricao(pCnt, 'FONE');
end;

//--

class function TmFormatar.Inscricao(pCnt, pTip : String) : String;
var
  M, I : Integer;
  vMas : String;
begin
  Result := '';

  if pCnt = '' then
    Exit;

  if      pTip = 'AC' then vMas := '**.***.***/***-**'
  else if pTip = 'AL' then vMas := '*********'
  else if pTip = 'AP' then vMas := '*********'
  else if pTip = 'AM' then vMas := '**.***.***-*'
  else if pTip = 'BA' then vMas := '******-**'
  else if pTip = 'CE' then vMas := '********-*'
  else if pTip = 'DF' then vMas := '***********-**'
  else if pTip = 'ES' then vMas := '*********'
  else if pTip = 'GO' then vMas := '**.***.***-*'
  else if pTip = 'MA' then vMas := '*********'
  else if pTip = 'MT' then vMas := '**********-*'
  else if pTip = 'MS' then vMas := '*********'
  else if pTip = 'MG' then vMas := '***.***.***/****'
  else if pTip = 'PA' then vMas := '**-******-*'
  else if pTip = 'PB' then vMas := '********-*'
  else if pTip = 'PR' then vMas := '********-**'
  else if pTip = 'PE' then vMas := '**.*.***.*******-*'
  else if pTip = 'PI' then vMas := '*********'
  else if pTip = 'RJ' then vMas := '**.***.**-*'
  else if pTip = 'RN' then vMas := '**.***.***-*'
  else if pTip = 'RS' then vMas := '***/*******'
  else if pTip = 'RO' then vMas := IfThen(Length(pCnt)=14,'**************','***.*****-*')
  else if pTip = 'RR' then vMas := '********-*'
  else if pTip = 'SC' then vMas := '***.***.***'
  else if pTip = 'SP' then vMas := '***.***.***.***'
  else if pTip = 'SE' then vMas := '*********-*'
  else if pTip = 'TO' then vMas := IfThen(Length(pCnt)=11,'***********','**.***.***-*')

  else if pTip = 'CEP' then vMas := '**.***-***'
  else if pTip = 'CNPJ' then vMas := '**.***.***/****-**'
  else if pTip = 'CPF' then vMas := '***.***.***-*'
  else if pTip = 'PLACA' then vMas := '***-****'

  else if pTip = 'DATA' then begin
    case Length(pCnt) of
      14 : vMas := '**/**/**** **:**:**';
       8 : vMas := '**/**/****';
       6 : vMas := '**:**:**';
    end;
  end

  else if pTip = 'FONE' then begin
    case Length(pCnt) of
      11 : vMas := '(**)*-****-****';
      10 : vMas := '(**)****-****';
       9 : vMas := '*-****-****';
       8 : vMas := '****-****';
    end;
  end

  ;

  I := 1;
  vMas := vMas + '****';

  for M := 1 to Length(vMas) do begin
    if vMas[M] = '*' then
      Result := Result + pCnt[I];
    if vMas[M] <> '*' then
      Result := Result + vMas[M];
    if vMas[M] = '*' then
      Inc(I);
  end;

  Result := Trim(Result);
end;

end.
