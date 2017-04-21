unit mHttp;

(* mHttp *)

interface

uses
  Classes, SysUtils, StrUtils,
  IdHTTP, mString;

type
  TmHttp = class(TComponent)
  private
    fHTTP : TIdHTTP;
    fUrl : String;
    fParamList : TmStringList;
    fRetorno : String;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Get(AUrl : String; AParamList : Array Of String);
    procedure Post(AUrl : String; AContent : String);
  published
    property Url : String read fUrl write fUrl;
    property ParamList : TmStringList read fParamList write fParamList;
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

  fHTTP := TIdHTTP.Create;
  fParamList := TmStringList.Create;
end;

destructor TmHttp.Destroy;
begin
  FreeAndNil(fHTTP);
  FreeAndNil(fParamList);

  inherited;
end;

procedure TmHttp.Get;
var
  vParamList, vUrl : String;
begin
  vParamList := fParamList.GetString('&');

  vUrl := fUrl + IfThen(vParamList <> '', '?') + vParamList;

  fHTTP := TIdHTTP.Create(nil);
  fHTTP.Request.UserAgent := 'Mozilla/3.0 (compatible; IndyLibrary)';
  fHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  fHTTP.HandleRedirects := True;
  fHTTP.Request.Accept := 'text/html, */*';

  try
    fRetorno := fHTTP.Get(vUrl);
  except
    on E : Exception do
      mLogger.Instance.Erro('TmHttp.Get', E.Message);
  end;
end;

procedure TmHttp.Post;
var
  vParamList : TStringList;
  I : Integer;
begin
  vParamList := TStringList.Create;

  // Add(vCod + '=' + vVal);
  for I := 0 to fParamList.Count - 1 do
    fParamList.Add(fParamList.Items[I]);

  fHTTP := TIdHTTP.Create(nil);
  fHTTP.Request.UserAgent := 'Mozilla/3.0 (compatible; IndyLibrary)';
  fHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  fHTTP.HandleRedirects := True;
  fHTTP.Request.Accept := 'text/html, */*';

  try
    fRetorno := fHTTP.Post(fUrl, vParamList);
  except
    on E : Exception do
      mLogger.Instance.Erro('TmHttp.Post', E.Message);
  end;

  FreeAndNil(vParamList);
end;

initialization
  //Instance();

finalization
  Destroy();

end.