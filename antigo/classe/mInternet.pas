unit mInternet;

interface

uses
  Classes, SysUtils, StrUtils, Windows, TypInfo,
  WinInet, Winsock, IdIcmpClient;

type
  TpStatusRede = (tprNaoConectada, tprConectada);
  TpStatusPing = (tppNaoRecebido, tppRecebido);
  TpStatusSite = (tpsNaoEncontrado, tpsEncontrado);
  TpStatusServ = (tpsNaoAutorizado, tpsAutorizado);

  TmInternet = class
  public
    class function GetUrlSoap(pParams : String) : String;
    class function GetUrlWsdl(pParams : String) : String;

    class function GetIpPing(pParams: String = '') : String;
    class function GetIpHost(pParams: String = '') : String;

    class function GetStatusRede(pParams : String = '') : String;
    class function GetStatusPing(pParams : String = '') : String;
    class function GetStatusSite(pParams : String = '') : String;
    class function GetStatusServ(pParams : String = '') : String;
  end;

  function GetTpStatusRede(pTpStatusRede : String) : TpStatusRede;
  function GetTpStatusRedeStr(pTpStatusRede : TpStatusRede) : String;

  function GetTpStatusPing(pTpStatusPing : String) : TpStatusPing;
  function GetTpStatusPingStr(pTpStatusPing : TpStatusPing) : String;

  function GetTpStatusSite(pTpStatusSite : String) : TpStatusSite;
  function GetTpStatusSiteStr(pTpStatusSite : TpStatusSite) : String;

  function GetTpStatusServ(pTpStatusServ : String) : TpStatusServ;
  function GetTpStatusServStr(pTpStatusServ : TpStatusServ) : String;

implementation

uses
  mActivate, mParamIni, mExecute, mString, mStatus, mFuncao, mXml;

  //--

  function GetTpStatusRede(pTpStatusRede : String) : TpStatusRede;
  begin
    Result := TpStatusRede(GetEnumValue(TypeInfo(TpStatusRede), pTpStatusRede));
    if ord(Result) = -1 then Result := tprNaoConectada;
  end;

  function GetTpStatusRedeStr(pTpStatusRede : TpStatusRede) : String;
  begin
    Result := GetEnumName(TypeInfo(TpStatusRede), Integer(pTpStatusRede));
  end;

  //--

  function GetTpStatusPing(pTpStatusPing : String) : TpStatusPing;
  begin
    Result := TpStatusPing(GetEnumValue(TypeInfo(TpStatusPing), pTpStatusPing));
    if ord(Result) = -1 then Result := tppNaoRecebido;
  end;

  function GetTpStatusPingStr(pTpStatusPing : TpStatusPing) : String;
  begin
    Result := GetEnumName(TypeInfo(TpStatusPing), Integer(pTpStatusPing));
  end;

  //--

  function GetTpStatusServ(pTpStatusServ : String) : TpStatusServ;
  begin
    Result := TpStatusServ(GetEnumValue(TypeInfo(TpStatusServ), pTpStatusServ));
    if ord(Result) = -1 then Result := tpsNaoAutorizado;
  end;

  function GetTpStatusServStr(pTpStatusServ : TpStatusServ) : String;
  begin
    Result := GetEnumName(TypeInfo(TpStatusServ), Integer(pTpStatusServ));
  end;

  //--

  function GetTpStatusSite(pTpStatusSite : String) : TpStatusSite;
  begin
    Result := TpStatusSite(GetEnumValue(TypeInfo(TpStatusSite), pTpStatusSite));
    if ord(Result) = -1 then Result := tpsNaoEncontrado;
  end;

  function GetTpStatusSiteStr(pTpStatusSite : TpStatusSite) : String;
  begin
    Result := GetEnumName(TypeInfo(TpStatusSite), Integer(pTpStatusSite));
  end;

  //--

  class function TmInternet.GetUrlSoap(pParams : String) : String;
  begin
    Result := AnsiReplaceStr(pParams, '/wsdl/', '/soap/');
  end;

  class function TmInternet.GetUrlWsdl(pParams : String) : String;
  begin
    Result := AnsiReplaceStr(pParams, '/soap/', '/wsdl/');
  end;

  //--

  class function TmInternet.GetIpPing(pParams : String) : String;
  begin
    Result :=  TmParamIni.pegarP('IP_SITE_PING');
    if (Result = '') then Result := TmParamIni.pegarP('DS_SITE_SOAP');
    if (Result = '') then Result := 'www.google.com';

    if (Pos('/wbsStoreage/', Result) > 0) then begin
      Result := GetLeftStr(Result, '/wbsStoreage/');
    end;

    Result := AnsiReplaceStr(Result, 'https://', '');
    Result := AnsiReplaceStr(Result, 'http://', '');
  end;

  class function TmInternet.GetIpHost(pParams : String) : String;
  var
    WSAData: TWSAData;
    R: PHostEnt;
    A: TInAddr;
  begin
    Result := '';

    WSAStartup($101, WSAData);
    R := Winsock.GetHostByName(PAnsiChar(pParams));
    if not Assigned(R) then
      Exit;

    A := PInAddr(r^.h_Addr_List^)^;
    Result := string(WinSock.inet_ntoa(A));

    return(1); exit;
  end;

  //--

//-- REDE

//uses
//  WinInet;
class function TmInternet.GetStatusRede(pParams : String) : String;
var
  vTpStatusRede : TpStatusRede;
  vFlags : DWORD;
begin
  Result := '';

  vTpStatusRede := tprNaoConectada;

  (* Value	Meaning
  INTERNET_CONNECTION_MODEM      0x01 Local system uses a modem to connect to the Internet.
  INTERNET_CONNECTION_LAN        0x02 Local system uses a local area network to connect to the Internet.
  INTERNET_CONNECTION_PROXY      0x04 Local system uses a proxy server to connect to the Internet.
  INTERNET_CONNECTION_MODEM_BUSY 0x08 No longer used.
  INTERNET_RAS_INSTALLED         0x10 Local system has RAS installed.
  INTERNET_CONNECTION_OFFLINE    0x20 Local system is in offline mode.
  INTERNET_CONNECTION_CONFIGURED 0x40 Local system has a valid connection to the Internet, but it might or might not be currently connected. *)

  if InternetGetConnectedState(@vFlags, 0) then begin
    (* if vFlags and INTERNET_CONNECTION_LAN <> 0 then begin
      vTpStatusRede := tprConectada;
    end else if vFlags and INTERNET_CONNECTION_MODEM <> 0 then begin
      vTpStatusRede := tprConectada;
    end else if vFlags and INTERNET_CONNECTION_PROXY <> 0 then begin
      vTpStatusRede := tprConectada;
    end; *)
    vTpStatusRede := tprConectada;
  end;

  putitemX(Result, 'TP_STATUSREDE', GetTpStatusRedeStr(vTpStatusRede));
end;

//-- PING

//uses
//  IdIcmpClient;
class function TmInternet.GetStatusPing(pParams : String) : String;
var
  IdICMPClient : TIdIcmpClient;
  vTpStatusPing : TpStatusPing;
  vReceived : Boolean;
  vHost : String;
begin
  Result := '';

  vHost := IfNull(itemX('DS_HOST', pParams), GetIpPing());

  if (vHost = '') then
    raise Exception.Create('HOST deve ser informado! / ' + ClassName + '.GetStatusPing()');

  vTpStatusPing := tppNaoRecebido;

  try
    IdICMPClient := TIdICMPClient.Create(nil);
    IdICMPClient.Host := vHost;
    IdICMPClient.ReceiveTimeout := 500;
    IdICMPClient.Ping;

    if (IdICMPClient.ReplyStatus.BytesReceived > 0) then
      vTpStatusPing := tppRecebido;
      
  finally
    IdICMPClient.Free;
  end;

  putitemX(Result, 'TP_STATUSPING', GetTpStatusPingStr(vTpStatusPing));
end;

//-- SITE

//uses
//  WinInet;
class function TmInternet.GetStatusSite(pParams: String): String;
var
  vTpStatusSite : TpStatusSite;
  vSite : String;
begin
  Result := '';

  vSite := IfNull(itemX('DS_SITE', pParams), GetIpPing());

  if (vSite = '') then
    raise Exception.Create('Site deve ser informado! / ' + ClassName + '.GetStatusSite()');

  vSite := IfThen(Pos('http://', vSite) = 0, 'http://') + vSite;

  vTpStatusSite := tpsNaoEncontrado;

  if InternetCheckConnection(PAnsiChar(vSite), 1, 0) then begin
    vTpStatusSite := tpsEncontrado;
  end;

  putitemX(Result, 'TP_STATUSSITE', GetTpStatusSiteStr(vTpStatusSite));
end;

//-- SERV

class function TmInternet.GetStatusServ(pParams: String): String;
var
  vCdSerialAmb, vParams, vResult : String;
  vTpStatusServ : TpStatusServ;
begin
  Result := '';

  vCdSerialAmb := TmParamIni.pegarP('CD_SERIALAMB');

  if (vCdSerialAmb = '') then
    raise Exception.Create('Serial deve ser informado / ' + ClassName + '.GetStatusServ()');

  vTpStatusServ := tpsNaoAutorizado;

  // verificar se liberado no servidor
  vParams := '';
  putitemX(vParams, 'CD_SERIALAMB', vCdSerialAmb);
  vResult := activateCmp('WEBSVCO003', 'validarSerial', vParams);
  if (xStatus < 0) then begin
    Result := vResult; Exit;
  end else if (itemX('CD_SERIAL', vResult) <> '') then begin
    vTpStatusServ := tpsAutorizado;
  end;

  putitemX(Result, 'TP_STATUSSERV', GetTpStatusServStr(vTpStatusServ));
end;

//--

end.
