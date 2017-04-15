unit mAppException;

interface

uses
  Classes, SysUtils, StrUtils, Forms;

type
  TmAppException = class(TComponent)
  public
    constructor Create(Aowner: TComponent); override;
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

    for I := Low(LIgnorar) to High(LIgnorar) do begin
      if Pos(LIgnorar[I], AMensagem) > 0 then begin
        ATipoMensagem.Status := tsMensagem;
        Exit;
      end;
    end;
  end;

constructor TmAppException.Create(Aowner: TComponent);
begin
  //Manipular as excecoes
  Application.OnException := _OnException;
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
    vMessage := TmString.IfNull(TmString.LeftStr(E.Message, ' / '), E.Message);
    vMetodo := TmString.IfNull(TmString.RightStr(E.Message, ' / '), cDS_METHOD);
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