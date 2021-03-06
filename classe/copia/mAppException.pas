unit mAppException;

interface

uses
  Classes, SysUtils, StrUtils, Forms;

type
  TmAppException = class(TComponent)
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure _OnException(Sender: TObject; E: Exception);
  end;

  function Instance : TmAppException;
  procedure Destroy;

implementation

uses
  mTipoMensagem, mLogger, mMensagem, mString, mException;

var
  _instance: TmAppException;

  function Instance : TmAppException;
  begin
    if not Assigned(_instance) then
      _instance := TmAppException.Create(nil);
    Result := _instance;
  end;

  procedure Destroy();
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

  procedure _trataRetorno(AMensagem : String; var ATipoMensagem : RTipoMensagem);
  const
    LIgnorar : Array [0..4] Of String = (
      'Missing query, table name or procedure name',
      'Access violation at address',
      'Could not load SSL library',
      'Field value required',
      'Token unknown');
  var
    I : Integer;
  begin
    ATipoMensagem.Status := tsErro;
    ATipoMensagem.Mensagem := AMensagem;

    for I := Low(LIgnorar) to High(LIgnorar) do
      if Pos(LIgnorar[I], AMensagem) > 0 then
        ATipoMensagem.Status := tsMensagem;
  end;

constructor TmAppException.Create(Aowner: TComponent);
begin
  inherited;

  Application.OnException := _OnException;
end;

destructor TmAppException.Destroy;
begin
  Application.OnException := nil;

  inherited;
end;

procedure TmAppException._OnException(Sender: TObject; E: Exception);
const
  cDS_METHOD = 'TmAppException._OnException';
var
  vTipoMensagem : RTipoMensagem;
  vMessage, vMetodo : String;
begin
  // exception
  if E is TmException then begin
    with E as TmException do begin
      vMessage := Message;
      vMetodo := Metodo;
    end;
  end else begin
    vMessage := TmString.IfNull(TmString.LeftStrInv(E.Message, ' / '), E.Message);
    vMetodo := TmString.IfNull(TmString.RightStrInv(E.Message, ' / '), cDS_METHOD);
  end;

  // trata erro
  _trataRetorno(vMessage, vTipoMensagem);
  mLogger.Instance.Erro(vMetodo, vMessage);

  // mensagem
  if vTipoMensagem.Status = tsErro then
    mMensagem.Instance.Mensagem(vTipoMensagem);

  //Show the exception
  //Application.ShowException(E);
end;

initialization
  Instance;

finalization
  Destroy;

end.