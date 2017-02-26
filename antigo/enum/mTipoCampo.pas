unit mCampo;

interface

uses
  SysUtils, StrUtils;

  function TraduzCampo(pParams : String) : String;
  function TamanhoCampo(pParams : String) : Integer;
  function TamanhoCampoDec(pParams : String) : Integer;
  function TipoCampo(pParams : String) : String;
  function AtributoCampo(pParams : String) : String;

implementation

uses
  mString, mFuncao, mItem, mXml;

const
  cLST_TIPO =
    '<CD des="Cod." tpd="ftInteger"  tam="10" dec="0" />' +  // COD_
    '<DS des="Ds."  tpd="ftString"   tam="60" dec="0" />' +  // DESCR_
    '<DT des="Dt."  tpd="ftDate"     tam="10" dec="0" />' +  // DATA_
    '<DH des="Dh."  tpd="ftDateTime" tam="10" dec="0" />' +  // DATAHORA_
    '<HR des="Hr."  tpd="ftTime"     tam="10" dec="0" />' +  // HORA_
    '<IN des=""     tpd="ftChar"     tam="01" dec="0" />' +  // INDICA_
    '<KM des="Km."  tpd="ftFloat"    tam="10" dec="0" />' +  // KILOM_
    '<NM des="Nome" tpd="ftString"   tam="60" dec="0" />' +  // NOME_
    '<NR des="Nr."  tpd="ftFloat"    tam="10" dec="0" />' +  // NUMERO_
    '<PR des="Pr."  tpd="ftFloat"    tam="10" dec="3" />' +  // PERC_
    '<QT des="Qt."  tpd="ftFloat"    tam="10" dec="3" />' +  // QTDE_
    '<TP des="Tp."  tpd="ftInteger"  tam="10" dec="0" />' +  // TIPO_
    '<VL des="Vl."  tpd="ftFloat"    tam="15" dec="2" />' +  // VALOR_
    '<U  des=""     tpd="ftChar"     tam="01" dec="0" />' ;  // VERSION_

  function PriMaiuscula(S : String) : String;
  var
    I : Integer;
  begin
    Result := '';
    if (S = '') then Exit;
    for I:=1 to Length(S) do begin
      if (I = 1)
      or (Copy(S, I-1, 1) = ' ')
      or (Copy(S, I-1, 1) = '.') then
        Result := Result + UpperCase(Copy(S,I,1))
      else
        Result := Result + LowerCase(Copy(S,I,1));
    end;
  end;

function TraduzCampo(pParams : String) : String;
var
  vCampo, vConf, vPre, vDes : String;
begin
  Result := '';

  vCampo := IfNull(item('CD_CAMPO', pParams), pParams);
  if (vCampo = '') then Exit;

  vPre := GetLeftStr(vCampo, '_');
  vConf := itemX(vPre, cLST_TIPO);
  vDes := itemA('des', vConf);

  Result := vCampo;
  Result := AnsiReplaceStr(Result, vPre + '_', vDes + ' ');
  Result := AnsiReplaceStr(Result, '_', ' ');
  Result := AllTrim(Result);

  if itemB('IN_MAIUSCULA', pParams) then begin
    Result := UpperCase(Result);
  end else if itemB('IN_MINUSCULA', pParams) then begin
    Result := LowerCase(Result);
  end else begin
    Result := PriMaiuscula(Result);
  end;

  Result := AnsiReplaceStr(Result, 'cao', 'ção');
  Result := AnsiReplaceStr(Result, 'CAO', 'ÇÃO');

  if itemB('IN_RETESPACO', pParams) then begin
    Result := AnsiReplaceStr(Result, ' ', '');
  end;
end;

function TamanhoCampo(pParams : String) : Integer;
var
  vCampo, vConf, vPre : String;
begin
  Result := 0;

  vCampo := IfNull(item('CD_CAMPO',pParams), pParams);
  if (vCampo = '') then Exit;

  vPre := GetLeftStr(vCampo, '_');
  vConf := itemX(vPre, cLST_TIPO);
  Result := StrToIntDef(itemA('tam', vConf), 10);
end;

function TamanhoCampoDec(pParams : String) : Integer;
var
  vCampo, vConf, vPre : String;
begin
  Result := 0;

  vCampo := IfNull(item('CD_CAMPO', pParams), pParams);
  if (vCampo = '') then Exit;

  vPre := GetLeftStr(vCampo, '_');
  vConf := itemX(vPre, cLST_TIPO);
  Result := StrToIntDef(itemA('dec', vConf), 0);
end;

function TipoCampo(pParams : String) : String;
var
  vCampo, vConf, vPre : String;
begin
  Result := '';

  vCampo := IfNull(item('CD_CAMPO', pParams), pParams);
  if (vCampo = '') then Exit;

  vPre := GetLeftStr(vCampo, '_');
  vConf := itemX(vPre, cLST_TIPO);
  Result := IfNull(itemA('tpd', vConf), 'ftString');
end;

function AtributoCampo(pParams : String) : String;
var
  vCampo, vPre, vCod : String;
begin
  Result := '';

  vCampo := IfNull(item('CD_CAMPO', pParams), pParams);
  if (vCampo = '') then Exit;

  vPre := GetLeftStr(vCampo, '_');
  vCod := GetRightStr(vCampo, '_');

  Result := LowerCase(vPre) + PriMaiuscula(vCod);
end;

end.
