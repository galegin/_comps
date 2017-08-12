unit mAmbienteConf;

interface

uses
  Classes, SysUtils, StrUtils;

type
  TmAmbienteConf = class(TComponent)
  private
    fCodigoAmbiente : String;
    fCodigoEmpresa : Integer;
    fCodigoTerminal : Integer;
    fCodigoUsuario : Integer;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property CodigoAmbiente : String read fCodigoAmbiente;
    property CodigoEmpresa : Integer read fCodigoEmpresa;
    property CodigoTerminal : Integer read fCodigoTerminal;
    property CodigoUsuario : Integer read fCodigoUsuario;
  end;

  function Instance : TmAmbienteConf;
  procedure Destroy;

implementation

uses
  mIniFiles;

var
  _instance : TmAmbienteConf;

  function Instance : TmAmbienteConf;
  begin
    if not Assigned(_instance) then
      _instance := TmAmbienteConf.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

constructor TmAmbienteConf.Create(AOwner : TComponent);
begin
  inherited;

  fCodigoAmbiente := TmIniFiles.PegarS('', '', 'Cd_Ambiente');
  fCodigoEmpresa := TmIniFiles.PegarI('', '', 'Cd_Empresa');
  fCodigoTerminal := TmIniFiles.PegarI('', '', 'Cd_Terminal');
  fCodigoUsuario := TmIniFiles.PegarI('', '', 'Cd_Usuario');
end;

destructor TmAmbienteConf.Destroy;
begin

  inherited;
end;

initialization
  //Instance();

finalization
  Destroy();

end.