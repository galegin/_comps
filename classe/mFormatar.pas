unit mFormatar;

interface

uses
  Classes, SysUtils, StrUtils, TypInfo,
  mTipoFormatar;

type
  TmFormatar = class
  public
    class function conteudo(pTip: TTipoFormatar; pCnt : String; pDec : Integer = 0) : String;
    class function retirar(pTip: TTipoFormatar; pCnt : String) : String;
    class function cnpj(pNum : String) : String;
    class function data(pDat, pFmt : String; pInv : Boolean = False) : String;
    class function inscricao(pIns, pEst : String) : String;
  end;

implementation

{ TmFormatar }

uses
  mString, mXml;

class function TmFormatar.conteudo(pTip: TTipoFormatar; pCnt: String; pDec: Integer): String;
var
  vFmtNun, vFmt : String;
  I, C, F : Integer;
begin
  Result := '';

  vFmt := TipoFormatarToStr(pTip);

  if vFmt = '' then begin
    Result := pCnt;
    Exit;
  end;

  if (pTip in [tfNumero]) then begin
    pCnt := AnsiReplaceStr(TmString.SoDigitosFloat(pCnt), '.', ',');
    vFmtNun := '0' + IfThen(pDec > 0, '.') + TmString.Replicate('0', pDec);
    pCnt := FormatFloat(vFmtNun, StrToFloatDef(pCnt,0));
  end;

  if pTip in [tfPlaca] then
    pCnt := TmString.AllTrim(pCnt)
  else
    pCnt := TmString.SoDigitos(pCnt);

  C := Length(pCnt);
  F := Length(vFmt);
  for I:=F downto 1 do
    if C > 0 then
      if vFmt[F] in ['9', 'Z', '#'] then begin
        Result := pCnt[C] + Result;
        Dec(C)
      end else begin
        Result := vFmt[F] + Result;
      end;

  Result := AnsiReplaceStr(Result, '#', '');
end;

class function TmFormatar.retirar(pTip: TTipoFormatar; pCnt : String) : String;
var
  vFmt : String;
  I : Integer;
begin
  Result := '';

  vFmt := TipoFormatarToStr(pTip);

  if vFmt = '' then begin
    Result := pCnt;
    Exit;
  end;

  for I:=0 to Length(pCnt) do
    if pCnt[I] in ['0'..'9', 'A'..'Z', 'a'..'z'] then
      Result := Result + pCnt[I];
end;

class function TmFormatar.cnpj(pNum: String): String;
begin
  if Length(pNum) = 11 then
    Result := TmFormatar.conteudo(tfCPF, pNum)
  else
    Result := TmFormatar.conteudo(tfCNPJ, pNum);
end;

class function TmFormatar.data(pDat, pFmt: String; pInv: Boolean): String;
begin
  pDat := TmString.SoDigitos(pDat);

  // YYYY/MM/DD
  if (pInv) then begin
    if Length(pDat) = 6 then
      pDat := pDat + '01'
    else if Length(pDat) = 4 then
      pDat := pDat + '0101';
    pDat := TmFormatar.conteudo(tfDATA, pDat);

  // DD/MM/YYYY
  end else begin
    if Length(pDat) = 6 then
      pDat := '01' + pDat
    else if Length(pDat) = 4 then
      pDat := '0101' + pDat;
    pDat := TmFormatar.conteudo(tfDATA, pDat);

  end;

  if StrToDateTimeDef(pDat, 0) > 0 then
    pDat := FormatDateTime(pFmt, StrToDateTimeDef(pDat, 0));

  Result := pDat;
end;

class function TmFormatar.inscricao(pIns, pEst : String) : String;
var
  M, I : Integer;
  vMas : String;
begin
  Result := '';

  if pIns = '' then
    Exit;

  if pEst = 'AC' then vMas := '**.***.***/***-**'
  else if pEst = 'AL' then vMas := '*********'
  else if pEst = 'AP' then vMas := '*********'
  else if pEst = 'AM' then vMas := '**.***.***-*'
  else if pEst = 'BA' then vMas := '******-**'
  else if pEst = 'CE' then vMas := '********-*'
  else if pEst = 'DF' then vMas := '***********-**'
  else if pEst = 'ES' then vMas := '*********'
  else if pEst = 'GO' then vMas := '**.***.***-*'
  else if pEst = 'MA' then vMas := '*********'
  else if pEst = 'MT' then vMas := '**********-*'
  else if pEst = 'MS' then vMas := '*********'
  else if pEst = 'MG' then vMas := '***.***.***/****'
  else if pEst = 'PA' then vMas := '**-******-*'
  else if pEst = 'PB' then vMas := '********-*'
  else if pEst = 'PR' then vMas := '********-**'
  else if pEst = 'PE' then vMas := '**.*.***.*******-*'
  else if pEst = 'PI' then vMas := '*********'
  else if pEst = 'RJ' then vMas := '**.***.**-*'
  else if pEst = 'RN' then vMas := '**.***.***-*'
  else if pEst = 'RS' then vMas := '***/*******'
  else if pEst = 'RO' then vMas := IfThen(Length(pIns)=14,'**************','***.*****-*')
  else if pEst = 'RR' then vMas := '********-*'
  else if pEst = 'SC' then vMas := '***.***.***'
  else if pEst = 'SP' then vMas := '***.***.***.***'
  else if pEst = 'SE' then vMas := '*********-*'
  else if pEst = 'TO' then vMas := IfThen(Length(pIns)=11,'***********','**.***.***-*');

  I := 1;
  vMas := vMas + '****';

  for M := 1 to Length(vMas) do begin
    if vMas[M] = '*' then
      Result := Result + pIns[I];
    if vMas[M] <> '*' then
      Result := Result + vMas[M];
    if vMas[M] = '*' then
      Inc(I);
  end;

  Result := Trim(Result);
end;

end.
