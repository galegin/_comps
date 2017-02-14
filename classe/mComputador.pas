unit mComputador;

interface

uses
  Classes, SysUtils, StrUtils, Windows, Registry,
  IdBaseComponent, IdComponent, IdIPWatch;

type
  TmComputador = class(TComponent)
  private
    fIpComputador : String;
    fNomeComputador : String;
    fNomeProcessador : String;
    fNumeroDisco : String;
    fSistemaOperacional : String;
    fUsuarioSistema : String;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property IpComputador : String read fIpComputador;
    property NomeComputador : String read fNomeComputador;
    property NomeProcessador : String read fNomeProcessador;
    property NumeroDisco : String read fNumeroDisco;
    property SistemaOperacional : string read fSistemaOperacional;
    property UsuarioSistema : String read fUsuarioSistema;
  end;

  function Instance : TmComputador;

implementation

var
  _instance : TmComputador;

  function Instance : TmComputador;
  begin
    if not Assigned(_instance) then
      _instance := TmComputador.Create(nil);
    Result := _instance;
  end;

  //-- ip computador

  function GetIpComputador: String;
  begin
    with TIdIPWatch.Create(nil) do begin
      HistoryEnabled := False;
      Result := LocalIP;
      Free;
    end;
  end;

  //-- nome computador

  function GetNomeComputador: String;
  var
    Computer: PChar;
    CSize: DWORD;
  begin
    Result := '';
    Computer := #0;
    CSize := MAX_COMPUTERNAME_LENGTH + 1;
    try
      GetMem(Computer,CSize);
      if Windows.GetComputerName(Computer,CSize) then
        Result := StrPas(Computer);
    finally
      FreeMem(Computer);
    end;
  end;

  //-- nome processador

  function GetNomeProcessador: String;
  begin
    Result := '';
    with TRegistry.Create do begin
      try
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey('HARDWARE\DESCRIPTION\System\CentralProcessor\0', False) then begin
          Result := Trim(ReadString('ProcessorNameString'));
          CloseKey;
        end;
      finally
        Free;
      end;
    end;
  end;

  //-- numero disco

  function GetNumeroDisco(AUnidade : String = 'C') : String;
  var
    SerNumber, CompLen, SysFlags: DWORD;
    LabName: array[0..199] of Char;
    FileSys: array[0..19] of Char;
  begin
    Result := '';
    AUnidade := IfThen(AUnidade <> '', AUnidade, 'C') + ':\';
    if Windows.GetVolumeInformation(PChar(AUnidade), @LabName, 200, @SerNumber, CompLen, SysFlags, @FileSys, 20) then
      Result := Format('%.8x', [SerNumber]);
  end;

  //-- sistema operacional

  function GetSistemOperacional: String;
  begin
    Result := '';
    with TRegistry.Create do begin
      try
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey('SOFTWARE\Microsoft\Windows NT\CurrentVersion', False) then begin
          Result := Trim(ReadString('ProductName'));
          CloseKey;
        end;
      finally
        Free;
      end;
    end;
  end;

  //-- usuario sistema

  function GetUsuarioSistema: String;
  var
    I : DWord;
  begin
    I := 255;
    SetLength(Result, I);
    Windows.GetUserName(PChar(Result), I);
    Result := String(PChar(Result));
  end;

  //--

constructor TmComputador.Create(AOwner : TComponent);
begin
  fIpComputador := GetIpComputador;
  fNomeComputador := GetNomeComputador;
  fNomeProcessador := GetNomeProcessador;
  fNumeroDisco := GetNumeroDisco;
  fSistemaOperacional := GetSistemOperacional;
  fUsuarioSistema := GetUsuarioSistema;
end;

//--

end.