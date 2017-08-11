unit mHttp;

(* mHttp *)

interface

uses
  Classes, SysUtils, StrUtils,
  IdHTTP, mString;

type
  TmHttp = class(TComponent)
  private
    fIdHTTP : TIdHTTP;
    fUrl : String;
    fListParam : TmStringList;
    fRetorno : String;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Get(AUrl : String; AListParam : Array Of String);
    procedure Post(AUrl : String; AContent : String);
  published
    property Url : String read fUrl write fUrl;
    property ListParam : TmStringList read fListParam write fListParam;
    property Retorno : String read fRetorno write fRetorno;
  end;

  function Instance : TmHttp;
  procedure Destroy;

implementation

uses
  mLogger;

var
  _instance : TmHttp;

  function Instance : TmHttp;
  begin
    if not Assigned(_instance) then
      _instance := TmHttp.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

(* mHttp *)

constructor TmHttp.Create(AOwner : TComponent);
begin
  inherited;

  fIdHTTP := TIdHTTP.Create;
  fListParam := TmStringList.Create;
end;

destructor TmHttp.Destroy;
begin
  FreeAndNil(fIdHTTP);
  FreeAndNil(fListParam);

  inherited;
end;

procedure TmHttp.Get;
var
  vListParam, vUrl : String;
begin
  vListParam := fListParam.GetString('&');

  vUrl := fUrl + IfThen(vListParam <> '', '?') + vListParam;

  fIdHTTP := TIdHTTP.Create(nil);
  fIdHTTP.Request.UserAgent := 'Mozilla/3.0 (compatible; IndyLibrary)';
  fIdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  fIdHTTP.HandleRedirects := True;
  fIdHTTP.Request.Accept := 'text/html, */*';

  try
    fRetorno := fIdHTTP.Get(vUrl);
  except
    on E : Exception do
      mLogger.Instance.Erro('TmHttp.Get', E.Message);
  end;
end;

procedure TmHttp.Post;
var
  vListParam : TStringList;
  I : Integer;
begin
  vListParam := TStringList.Create;

  // Add(vCod + '=' + vVal);
  for I := 0 to fListParam.Count - 1 do
    fListParam.Add(fListParam.Items[I]);

  fIdHTTP := TIdHTTP.Create(nil);
  fIdHTTP.Request.UserAgent := 'Mozilla/3.0 (compatible; IndyLibrary)';
  fIdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  fIdHTTP.HandleRedirects := True;
  fIdHTTP.Request.Accept := 'text/html, */*';

  try
    fRetorno := fIdHTTP.Post(fUrl, vListParam);
  except
    on E : Exception do
      mLogger.Instance.Erro('TmHttp.Post', E.Message);
  end;

  FreeAndNil(vListParam);
end;

initialization
  //Instance();

finalization
  Destroy();

end.