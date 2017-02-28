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
  RAppSerial = record
    Ambiente : String;
    Empresa : String;
    Terminal : String;
    Usuario : String;
    
    Disco : String;
    Rede : String;
    Cpu : String;
    
    Ip : String;
    Computador : String;
    UsuarioSO : String;
	
	DataInicio : TDateTime;
	DataTermino : TDateTime;
  end;	
  
  TmAppSerial = class(TComponent)
  private
    fIdApplication: Longint;

    function GetAmbiente : String;
    function GetEmpresa : String;
    function GetTerminal : String;
    function GetUsuario : String;

    function GetDisco : String;
    function GetRede : String;
    function GetCpu : String;

    function GetIp : String;
    function GetComputador : String;
    function GetUsuarioSO : String;
  protected
  public
    constructor Create(AOwner: TComponent); override;

    class function GetSerial() : String;
    class function ValidaSerial(ASerial : String) : RAppSerial;

    class function GetSerialAmbiente() : String;
    class function ValidaSerialAmbiente(ASerial : String) : RAppSerial;

    class function GetSerialAcesso() : String;
    class function ValidaSerialAcesso(ASerial : String) : RAppSerial;

    class function GetSerialMaquina() : String;
    class function ValidaSerialMaquina(ASerial : String) : RAppSerial;

    class procedure ValidarSerial(ASerial : String);
  published
    property Ambiente : String read GetAmbiente;
    property Empresa : String read GetEmpresa;
    property Terminal : String read GetTerminal;
    property Usuario : String read GetUsuario;

    property Disco : String read GetDisco;
    property Rede : String read GetRede;
    property Cpu : String read GetCpu;

    property Ip : String read GetIp;
    property Computador : String read GetComputador;
    property UsuarioSO : String read GetUsuarioSO;
  end;

procedure Register;

implementation

uses
  mAmbienteConf, mAppProtect, mComputador, mException,
  mDelphi, mString, mCripto;

const
  ID_APLICACAO = 214375357;

  //--

  function TmAppSerial.GetAmbiente() : String;
  begin
    Result := TmString.StringToHexa(mAmbienteConf.Instance.CodigoAmbiente);
    Result := Result;
  end;

  function TmAppSerial.GetEmpresa() : String;
  begin
    Result := Format('%.4x', [mAmbienteConf.Instance.CodigoEmpresa]);
    Result := Result;
  end;

  function TmAppSerial.GetTerminal() : String;
  begin
    Result := Format('%.4x', [mAmbienteConf.Instance.CodigoTerminal]);
    Result := Result;
  end;

  function TmAppSerial.GetUsuario() : String;
  begin
    Result := Format('%.4x', [mAmbienteConf.Instance.CodigoUsuario]);
    Result := Result;
  end;

  //--

  function TmAppSerial.GetIp() : String;
  begin
    Result := mComputador.Instance.IpComputador;
    Result := Result;
  end;

  function TmAppSerial.GetComputador() : String;
  begin
    Result := mComputador.Instance.NomeComputador;
    Result := Result;
  end;

  function TmAppSerial.GetUsuarioSO() : String;
  begin
    Result := mComputador.Instance.UsuarioSistema;
    Result := Result;
  end;

  //--

  function TmAppSerial.GetDisco() : String;
  begin
    Result := mComputador.Instance.NumeroDisco;
    Result := Result;
  end;

  function TmAppSerial.GetRede() : String;
  begin
    Result := mComputador.Instance.NumeroPlacaRede;
    Result := Result;
  end;

  function TmAppSerial.GetCpu() : String;
  begin
    Result := mComputador.Instance.NumeroProcessador;
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
class function TmAppSerial.GetSerial() : String;
var
  Body : String;
begin
  with TmAppSerial.Create(nil) do begin
    Body := Disco + '#' + Rede + '#' + Cpu;
    Result := TmAppProtect.Criptografe(Body, Format('%.x', [FIdApplication])) + TmAppProtect.GetKey(Body);
    Free;
  end;
end;

class function TmAppSerial.ValidaSerial(ASerial : String) : RAppSerial;
var
  Info, Body, Serial : String;
  vSerialList : TmStringArray;
begin
  Info := ASerial;
  Body := Copy(Info, 1, Length(Info) - 2);

  with TmAppSerial.Create(nil) do begin
    Serial := TmAppProtect.Uncriptografe(Body, Format('%.x', [FIdApplication]));
    Free;
  end;

  vSerialList := TmString.Split(Serial, '#');
  Result.Disco := vSerialList[0];
  Result.Rede := vSerialList[1];
  Result.Cpu := vSerialList[2];
end;

//--
// GetSerialAmb para uso de validacao licenca de uso
class function TmAppSerial.GetSerialAmbiente() : String;
var
  Body : String;
begin
  with TmAppSerial.Create(nil) do begin
    Body := Ambiente + Empresa + Terminal + Disco;
    Result :=
      TmAppProtect.Criptografe(Body, Format('%.x', [FIdApplication])) +
      TmAppProtect.GetKey(Body);
    Free;
  end;
end;

class function TmAppSerial.ValidaSerialAmbiente(ASerial : String) : RAppSerial;
var
  Body, Info, Serial : String;
  vSerialList : TmStringArray;
begin
  Info := ASerial;
  Body := Copy(Info, 1, Length(Info) - 2);

  with TmAppSerial.Create(nil) do begin
    Serial := TmAppProtect.Uncriptografe(Body, Format('%.x', [FIdApplication]));
    Free;
  end;

  Serial := TmString.StringToHexa(Serial);
  
  vSerialList := TmString.Split(Serial, '#');
  Result.Ambiente := vSerialList[0];
  Result.Empresa := vSerialList[1];
  Result.Terminal := vSerialList[2];
  Result.Disco := vSerialList[3];
end;

//--
// GetSerialAcesso para uso de validacao de acesso
class function TmAppSerial.GetSerialAcesso() : String;
var
  Body : String;
begin
  with TmAppSerial.Create(nil) do begin
    Body := Ambiente + '#' + Empresa + '#' + Terminal;
    Body := TmString.StringToHexa(Body);
    Result :=
      TmAppProtect.Criptografe(Body, Format('%.x', [FIdApplication])) +
      TmAppProtect.GetKey(Body);
    Free;
  end;
end;

class function TmAppSerial.ValidaSerialAcesso(ASerial : String) : RAppSerial;
var
  Body, Info, Serial : String;
  vSerialList : TmStringArray;
begin
  Info := ASerial;
  Body := Copy(Info, 1, Length(Info) - 2);

  with TmAppSerial.Create(nil) do begin
    Serial := TmAppProtect.Uncriptografe(Body, Format('%.x', [FIdApplication]));
    Free;
  end;

  Serial := TmString.StringToHexa(Serial);

  vSerialList := TmString.Split(Serial, '#');
  Result.Ambiente := vSerialList[0];
  Result.Empresa := vSerialList[1];
  Result.Terminal := vSerialList[2];
end;

//--
// GetSerialMaquina para uso de validacao do computador
class function TmAppSerial.GetSerialMaquina() : String;
var
  Body : String;
begin
  with TmAppSerial.Create(nil) do begin
    Body := Ip + '#' + Computador + '#' + UsuarioSO;
    Body := TmString.HexaToString(Body);
    Result :=
      TmAppProtect.Criptografe(Body, Format('%.x', [FIdApplication])) +
      TmAppProtect.GetKey(Body);
    Free;
  end;
end;

class function TmAppSerial.ValidaSerialMaquina(ASerial : String) : RAppSerial;
var
  Body, Info, Serial : String;
  vSerialList : TmStringArray;
begin
  Info := ASerial;
  Body := Copy(Info, 1, Length(Info) - 2);

  with TmAppSerial.Create(nil) do begin
    Serial := TmAppProtect.Uncriptografe(Body, Format('%.x', [FIdApplication]));
    Free;
  end;

  Serial := TmString.StringToHexa(Serial);

  vSerialList := TmString.Split(Serial, '#');
  Result.Ip := vSerialList[0];
  Result.Computador := vSerialList[1];
  Result.UsuarioSO := vSerialList[2];
end;

// ValidaSerial
class procedure TmAppSerial.ValidarSerial(ASerial : String);
const
  cMETHOD = 'TmAppSerial.ValidarSerial()';
var
  vSerial : String;
begin
  if TmDelphi.IsOpen() then
    Exit;

  try
    vSerial := GetSerial();
    if vSerial <> ASerial then
      raise TmException.Create('Serial invalido', cMETHOD);
  except
    on E : Exception do begin
      TmAppProtect.execute();
    end;
  end;
end;

begin
  //TmAppSerial.ValidarSerial();

//--
end.