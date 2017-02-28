unit mApplication;

interface

uses
  SysUtils, Classes, Forms;

type
  TmApplication = class(TComponent)
  public
    constructor Create(Aowner: TComponent); override;
    procedure _OnException(Sender: TObject; E: Exception);
  end;

  function getInstance() : TmApplication;
  procedure dropInstance();

implementation

uses
  mMensagem, mMetodo, mTipoSts, mLogger, mFuncao, mItem, mXml;

var
  instance: TmApplication;

  function getInstance() : TmApplication;
  begin
    if instance = nil then
      instance := TmApplication.Create(nil);

    Result := instance;
  end;

  procedure dropInstance();
  begin
    if instance <> nil then
      instance.Free;
  end;

  procedure _trataRetorno(pParams : String; var pStatus : Variant);
  const
    cLST_IGNORAR =
      'Missing query, table name or procedure name|' +
      'Access violation at address|' +
      'Could not load SSL library|' +
      'Field value required|' +
      'Token unknown|' ;
  var
    vLstErr, vErr : String;
  begin
    pStatus := STS_ERROR;

    vLstErr := cLST_IGNORAR;
    while vLstErr <> '' do begin
      vErr := getitem(vLstErr);
      if vErr = '' then Break;
      delitem(vLstErr);

      if Pos(vErr, pParams) > 0 then begin
        pStatus := STS_NORMAL;
        Exit;
      end;
    end;
  end;

constructor TmApplication.Create(Aowner: TComponent);
begin
  //Manipular as excecoes
  Application.OnException := _OnException;
end;

procedure TmApplication._OnException(Sender: TObject; E: Exception);
var
  vMessage, vParams : String;
  vStatus : Variant;
begin
  // trata erro
  _trataRetorno(E.Message, vStatus);
  vMessage := IfNull(mTipoSts.dica(vStatus), E.Message);

  // log
  vMessage := mMetodo.lst() + E.Message + IfNull(vMessage, E.ClassName);
  mLogger.e(vMessage);

  // mensagem
  if vStatus = STS_ERROR then begin
    vParams := '';
    putitemX(vParams, 'status', vStatus);
    putitemX(vParams, 'message', E.Message);
    mMensagem.mensagem(vParams);
  end;

  //Show the exception
  //Application.ShowException(E);
end;

initialization
  getInstance();

finalization
  dropInstance();

end.