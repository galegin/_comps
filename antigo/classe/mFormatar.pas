unit mFormatar;

interface

uses
  Classes, SysUtils, StrUtils, TypInfo,
  mTipoFormatar;

  function cont(pTip: TTipoFormatar; pCnt : String; pDec : Integer = 0) : String;
  function reti(pTip: TTipoFormatar; pCnt : String) : String;
  function cnpj(pNum : String) : String;
  function data(pDat, pFmt : String; pInv : Boolean = False) : String;
  function insc(pIns, pEst : String) : String;

implementation

{ TmFormatar }

uses
  mFuncao, mXml;

function cont(pTip: TTipoFormatar; pCnt: String; pDec: Integer): String;
var
  vFmtNun, vFmt : String;
  I, C, F : Integer;
begin
  Result := '';

  vFmt := mTipoFormatar.fmt(pTip);

  if vFmt = '' then begin
    Result := pCnt;
    Exit;
  end;

  if (pTip in [NUMERO]) then begin
    pCnt := AnsiReplaceStr(SoDigitosFloat(pCnt), '.', ',');
    vFmtNun := '0' + IfThen(pDec>0,'.') + ReplicateStr('0',pDec);
    pCnt := FormatFloat(vFmtNun, StrToFloatDef(pCnt,0));
  end;

  if pTip in [mTipoFormatar.PLACA] then
    pCnt := AllTrim(pCnt)
  else
    pCnt := SoDigitos(pCnt);

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

function reti(pTip: TTipoFormatar; pCnt : String) : String;
var
  vFmt : String;
  I : Integer;
begin
  Result := '';

  vFmt := mTipoFormatar.fmt(pTip);

  if vFmt = '' then begin
    Result := pCnt;
    Exit;
  end;

  for I:=0 to Length(pCnt) do
    if pCnt[I] in ['0'..'9', 'A'..'Z', 'a'..'z'] then
      Result := Result + pCnt[I];
end;

function cnpj(pNum: String): String;
begin
  if Length(pNum) = 11 then
    Result := mFormatar.cont(mTipoFormatar.CPF, pNum)
  else
    Result := mFormatar.cont(mTipoFormatar.CNPJ, pNum);
end;

function data(pDat, pFmt: String; pInv: Boolean): String;
begin
  pDat := SoDigitos(pDat);

  // YYYY/MM/DD
  if (pInv) then begin
    if Length(pDat) = 6 then
      pDat := pDat + '01'
    else if Length(pDat) = 4 then
      pDat := pDat + '0101';
    pDat := mFormatar.cont(mTipoFormatar.DATA, pDat);

  // DD/MM/YYYY
  end else begin
    if Length(pDat) = 6 then
      pDat := '01' + pDat
    else if Length(pDat) = 4 then
      pDat := '0101' + pDat;
    pDat := mFormatar.cont(mTipoFormatar.DATA, pDat);

  end;

  if StrToDateTimeDef(pDat, 0) > 0 then
    pDat := FormatDateTime(pFmt, StrToDateTimeDef(pDat, 0));

  Result := pDat;
end;

function insc(pIns, pEst : String) : String;
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
