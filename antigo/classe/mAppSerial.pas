{**
*  TcAppProtect
*
*  Copyright 1999, 2000 by Sebastião Elivaldo Ribeiro
*  http://www.utranet.com.br/~elivaldo
*  e-mail: elivaldo@utranet.com.br
*}

unit mAppSerial;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Registry;

type
  TmAppSerial = class(TComponent)
  private
    FIdApplication: Longint;
    FParams : String;
    FAmb : String;
    FEmp : Integer;
    FTer : Integer;
    FUsu : Integer;
    FNumDISC : String;
    FNumPROC : String;
    FNumREDE : String;
    procedure SetParams(const Value : String);
    function getAmb() : String;
    function getEmp() : String;
    function getTer() : String;
    function getUsu() : String;
    function getIpComp() : String;
    function getNmComp() : String;
    function getNmUser() : String;
  protected
  public
    constructor Create(AOwner: TComponent); override;

    class function GetNumberDisc() : String;
    class function GetNumberProc() : String;
    class function GetNumberRede() : String;

    class function GetSerial(pParams : String = '') : String;
    class function ValidaSerial(pParams : String = '') : String;
    class function GetSerialAmb(pParams : String = '') : String;
    class function ValidaSerialAmb(pParams : String = '') : String;
    class function GetSerialAcesso(pParams : String = '') : String;
    class function ValidaSerialAcesso(pParams : String = '') : String;
    class function GetSerialPc(pParams : String = '') : String;
    class function ValidaSerialPc(pParams : String = '') : String;

    class function ValidarSerial(pParams : String = '') : String;
  published
    property _Params : String read FParams write SetParams;

    property _Amb : String read getAmb;
    property _Emp : String read getEmp;
    property _Ter : String read getTer;
    property _Usu : String read getUsu;

    property _numDISC : String read FNumDISC;
    property _numPROC : String read FNumPROC;
    property _numREDE : String read FNumREDE;

    property _IpComp : String read GetIpComp;
    property _NmComp : String read GetNmComp;
    property _NmUser : String read GetNmUser;
  end;

procedure Register;

implementation

uses
  mDelphi, mString,
  mMensagem, mAppProtect,
  mCripto, mFuncao, mItem, mXml;

const
  ID_APLICACAO = 214375357;

  //--

  procedure TmAppSerial.SetParams(const Value : String);
  begin
    FParams := Value;

    (* FAmb := IfNull(itemX('CD_AMBIENTE', Value), TmParamIni.pegar('CD_AMBIENTE'));
    FEmp := IfNullI(IfNull(itemX('CD_EMPRESA', Value), TmParamIni.pegar('CD_EMPRESA')), 1);
    FTer := IfNullI(IfNull(itemX('CD_TERMINAL', Value), TmParamIni.pegar('CD_TERMINAL')), 1);
    FUsu := IfNullI(IfNull(itemX('CD_USUARIO', Value), TmParamIni.pegar('CD_USUARIO')), 1); *)

    FNumDISC := IfNull(itemX('NR_DISC', Value), GetNumberDisc());
    FNumPROC := IfNull(itemX('NR_PROC', Value), GetNumberProc());
    FNumREDE := IfNull(itemX('NR_REDE', Value), GetNumberRede());
  end;

  //--

  function TmAppSerial.getAmb() : String;
  begin
    Result := mString.StringToHexa(FAmb);
    Result := Result;
  end;

  function TmAppSerial.getEmp() : String;
  begin
    Result := Format('%.4x', [FEmp]);
    Result := Result;
  end;

  function TmAppSerial.getTer() : String;
  begin
    Result := Format('%.4x', [FTer]);
    Result := Result;
  end;

  function TmAppSerial.getUsu() : String;
  begin
    Result := Format('%.4x', [FUsu]);
    Result := Result;
  end;

  //--

  function TmAppSerial.getIpComp() : String;
  begin
    //Result := mComputador.GetIpComputador();
    Result := Result;
  end;

  function TmAppSerial.getNmComp() : String;
  begin
    //Result := mComputador.GetNmComputador();
    Result := Result;
  end;

  function TmAppSerial.getNmUser() : String;
  begin
    //Result := mComputador.SysUserName();
    Result := Result;
  end;

  //--

  // GetNumberDisc
  class function TmAppSerial.GetNumberDisc() : String;
  begin
    //Result := mComputador.GetNumberHD();
    Result := Result;
  end;

  // GetNumberProc
  class function TmAppSerial.GetNumberProc() : String;
  begin
    (* if TmParamIni.pegarB('IN_PROCESSOR_ID') then begin
      Result := TmProcessor.GetProcessorId();
      Exit;
    end;

    Result := TmProcessor.GetProcessor(); *)
    Result := Result;
  end;

  //GetNumberRede
  class function TmAppSerial.GetNumberRede() : String;
  begin
    (* if TmParamIni.pegarB('IN_PLACAREDE_IP') then begin
      Result := TmMacAddress.GetMacByIP();
      Exit;
    end;

    Result := TmMacAddress.GetMac(); *)
    Result := Result;
  end;

{ TmAppSerial }

//--
// Register
procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmAppSerial]);
end;

//--
// Create
constructor TmAppSerial.Create(AOwner: TComponent);
begin
  inherited;
  FIdApplication := ID_APLICACAO;
end;

//--
// GetSerial para uso na chamada entre programas
class function TmAppSerial.GetSerial(pParams : String) : String;
var
  Body : String;
begin
  with TmAppSerial.Create(nil) do begin
    _Params := pParams;
    Body := _numDISC + '|' + _numPROC + '|' + _numREDE;
    Result := TmAppProtect.Criptografe(Body, Format('%.x', [FIdApplication])) + TmAppProtect.GetKey(Body);
    Free;
  end;
end;

class function TmAppSerial.ValidaSerial(pParams : String) : String;
var
  Info, Body, Serial : String;
begin
  Info := IfNull(itemX('CD_SERIAL', pParams), pParams);
  Body := Copy(Info, 1, Length(Info) - 2);

  with TmAppSerial.Create(nil) do begin
    _Params := pParams;
    Serial := TmAppProtect.Uncriptografe(Body, Format('%.x', [FIdApplication]));
    Free;
  end;

  Result := '';
  putitemX(Result, 'disc', getitem(Serial, 1));
  putitemX(Result, 'proc', getitem(Serial, 2));
  putitemX(Result, 'rede', getitem(Serial, 3));
end;

//--
// GetSerialAmb para uso de validacao licenca de uso
class function TmAppSerial.GetSerialAmb(pParams : String) : String;
var
  Body : String;
begin
  with TmAppSerial.Create(nil) do begin
    _Params := pParams;
    Body := _Amb + _Emp + _Ter + _numDISC;
    Result :=
      TmAppProtect.Criptografe(Body, Format('%.x', [FIdApplication])) +
      TmAppProtect.GetKey(Body);
    Free;
  end;
end;

class function TmAppSerial.ValidaSerialAmb(pParams : String) : String;
var
  Body, Info : String;
begin
  Info := IfNull(itemX('CD_SERIALAMB', pParams), pParams);
  Body := Copy(Info, 1, Length(Info) - 2);

  with TmAppSerial.Create(nil) do begin
    _Params := pParams;
    Result := TmAppProtect.Uncriptografe(Body, Format('%.x', [FIdApplication]));
    Free;
  end;

  Result := mString.StringToHexa(Result);
end;

//--
// GetSerialAcesso para uso de validacao de acesso
class function TmAppSerial.GetSerialAcesso(pParams : String) : String;
var
  Body : String;
begin
  with TmAppSerial.Create(nil) do begin
    _Params := pParams;
    Body := _Amb + '|' + _Emp + '|' + _Ter;
    Body := mString.StringToHexa(Body);
    Result :=
      TmAppProtect.Criptografe(Body, Format('%.x', [FIdApplication])) +
      TmAppProtect.GetKey(Body);
    Free;
  end;
end;

class function TmAppSerial.ValidaSerialAcesso(pParams : String) : String;
var
  Body, Info, Serial : String;
begin
  Info := IfNull(itemX('CD_SERIALACESSO', pParams), pParams);
  Body := Copy(Info, 1, Length(Info) - 2);

  with TmAppSerial.Create(nil) do begin
    _Params := pParams;
    Serial := TmAppProtect.Uncriptografe(Body, Format('%.x', [FIdApplication]));
    Free;
  end;

  Serial := mString.StringToHexa(Serial);

  Result := '';
  putitemX(Result, 'amb', getitem(Serial, 1));
  putitemX(Result, 'emp', getitem(Serial, 2));
  putitemX(Result, 'ter', getitem(Serial, 3));
end;

//--
// GetSerialPc para uso de validacao do computador
class function TmAppSerial.GetSerialPc(pParams : String) : String;
var
  Body : String;
begin
  with TmAppSerial.Create(nil) do begin
    _Params := pParams;
    Body := _IpComp + '|' + _NmComp + '|' + _NmUser;
    Body := mString.HexaToString(Body);
    Result :=
      TmAppProtect.Criptografe(Body, Format('%.x', [FIdApplication])) +
      TmAppProtect.GetKey(Body);
    Free;
  end;
end;

class function TmAppSerial.ValidaSerialPc(pParams : String) : String;
var
  Body, Info, Serial : String;
begin
  Info := IfNull(itemX('CD_SERIALPC', pParams), pParams);
  Body := Copy(Info, 1, Length(Info) - 2);

  with TmAppSerial.Create(nil) do begin
    _Params := pParams;
    Serial := TmAppProtect.Uncriptografe(Body, Format('%.x', [FIdApplication]));
    Free;
  end;

  Serial := mString.StringToHexa(Serial);

  Result := '';
  putitemX(Result, 'ip', getitem(Serial, 1));
  putitemX(Result, 'host', getitem(Serial, 2));
  putitemX(Result, 'user', getitem(Serial, 3));
end;

// ValidaSerial
class function TmAppSerial.ValidarSerial(pParams : String) : String;
const
  cMETHOD = 'TmAppSerial.ValidarSerial()';
var
  vSen, vSer : String;
begin
  Result := '';

  if TmDelphi.isOpen() then
    Exit;

  try
    vSer := item('SER', {TmParamLine.getParamLine()} '');
    if vSer = '' then
      raise Exception.Create('Acesso nao permitido! / ' + cMETHOD);

    vSen := GetSerial();
    if vSer <> vSen then
      raise Exception.Create('Serial invalido! / ' + cMETHOD);

  except
    on E : Exception do begin
      Result := E.Message;
      mMensagem.mensagem(Result);
      TmAppProtect.execute();
    end;
  end;
end;

begin
  //TmAppSerial.ValidarSerial();

//--
end.
