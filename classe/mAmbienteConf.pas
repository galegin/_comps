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
  published
    property CodigoAmbiente : String read fCodigoAmbiente;
    property CodigoEmpresa : Integer read fCodigoEmpresa;
    property CodigoTerminal : Integer read fCodigoTerminal;
    property CodigoUsuairo : Integer read fCodigoUsuario;
  end;

  function Instance : TmAmbienteConf;

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

constructor TmAmbienteConf.Create(AOwner : TComponent);
begin
  inherited;

  fCodigoAmbiente := TmIniFiles.PegarS('', '', 'Cd_Ambiente');
  fCodigoEmpresa := TmIniFiles.PegarI('', '', 'Cd_Empresa');
  fCodigoTerminal := TmIniFiles.PegarI('', '', 'Cd_Terminal');
  fCodigoUsuario := TmIniFiles.PegarI('', '', 'Cd_Usuario');
end;

end.