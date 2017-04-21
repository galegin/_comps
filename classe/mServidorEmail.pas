unit mServidorEmail;

(* mServidorEmail *)

interface

uses
  Classes, SysUtils, StrUtils;

type
  TmServidorEmail = class(TComponent)
  private
    fMail : String;
    fUser : String;
    fPass : String;
    fHost : String;
    fPort : String;
    fAuth : Boolean;
    fSSL : Boolean;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property Mail : String read fMail write fMail;
    property User : String read fUser write fUser;
    property Pass : String read fPass write fPass;
    property Host : String read fHost write fHost;
    property Port : String read fPort write fPort;
    property Auth : Boolean read fAuth write fAuth;
    property SSL : Boolean read fSSL write fSSL;
  end;

  function Instance : TmServidorEmail;
  procedure Destroy;

implementation

uses
  mIniFiles;

var
  _instance : TmServidorEmail;

  function Instance : TmServidorEmail;
  begin
    if not Assigned(_instance) then
      _instance := TmServidorEmail.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

(* mServidorEmail *)

constructor TmServidorEmail.Create(AOwner : TComponent);
begin
  inherited;

  fMail := TmIniFiles.PegarS('', 'EMAIL', 'MAIL', '');
  fUser := TmIniFiles.PegarS('', 'EMAIL', 'USER', '');
  fPass := TmIniFiles.PegarS('', 'EMAIL', 'PASS', '');
  fHost := TmIniFiles.PegarS('', 'EMAIL', 'HOST', '');
  fPort := TmIniFiles.PegarS('', 'EMAIL', 'PORT', '');
  fAuth := TmIniFiles.PegarB('', 'EMAIL', 'AUTH', True);
  fSSL := TmIniFiles.PegarB('', 'EMAIL', 'SSL', False);
end;

destructor TmServidorEmail.Destroy;
begin

  inherited;
end;

initialization
  //Instance();

finalization
  Destroy();

end.