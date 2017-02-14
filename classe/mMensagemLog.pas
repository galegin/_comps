unit mMensagemLog;

interface

uses
  Classes, SysUtils, StrUtils;

type
  TTipoMensagemLog = (tpmDebug, tpmErro, tpmWarning);

  TmMensagemLog = class(TComponent)
  private
    //fArquivoLog : String;
    fArquivoXml : String;
  protected
  public
    constructor Create(AOwner : TComponent); override;

    function Log(ATipoMensagemLog : TTipoMensagemLog; AMensagem : String; AMetodo : String = '') : String;

    procedure Debug(AMensagem : String; AMetodo : String = '');
    procedure Erro(AMensagem : String; AMetodo : String = '');
    procedure Warning(AMensagem : String; AMetodo : String = '');

    procedure ErroException(AMensagem : String; AMetodo : String = ''); overload;
    procedure ErroException(AException : Exception; AMetodo : String = ''); overload;
  published
    //property ArquivoLog : String read fArquivoLog write fArquivoLog;
    property ArquivoXml : String read fArquivoXml write fArquivoXml;
  end;

  function Instance : TmMensagemLog;

implementation

uses
  mProjeto, mArquivo, mPath;

const
  TTipoMensagemLog_Codigo : Array [TTipoMensagemLog] of string =
    ('Debug', 'Erro', 'Warning');

var
  _instance : TmMensagemLog;

  function Instance : TmMensagemLog;
  begin
    if not Assigned(_instance) then
      _instance := TmMensagemLog.Create(nil);
    Result := _instance;
  end;

constructor TmMensagemLog.Create(AOwner : TComponent);
begin
  inherited;
  //fArquivoLog := TmPath.Log() + mProjeto.Instance.Codigo + FormatDateTime('yyyy.mm.dd', Date) + '.log';
  fArquivoXml := TmPath.Log() + mProjeto.Instance.Codigo + FormatDateTime('yyyy.mm.dd', Date) + '.xml';
end;

//--

function TmMensagemLog.Log(ATipoMensagemLog : TTipoMensagemLog; AMensagem, AMetodo : String) : String;
begin
  { Result :=
    '[ ' + DateTimeToStr(now) + ' ] ' +
    TTipoMensagemLog_Codigo[ATTipoMensagemLog] + ' - ' +
    AMensagem + ' / ' + AMetodo;

  TmArquivo.Adicionar(fArquivoLog, Result); }

  //--

  Result :=
    '<log>' + sLineBreak +
    '<data_hora>' + DateTimeToStr(now) + '</data_hora>' + sLineBreak +
    '<tipo_mensagem>' + TTipoMensagemLog_Codigo[ATipoMensagemLog] + '</tipo_mensagem>' + sLineBreak +
    '<mensagem>' + AMensagem + '</mensagem>' + sLineBreak +
    '<metodo>' + AMetodo + '</metodo>' + sLineBreak +
    '</log>' + sLineBreak ;

  TmArquivo.Adicionar(fArquivoXml, Result);

  //--

  Result := AMensagem + ' / ' + AMetodo;
end;

//--

procedure TmMensagemLog.Debug(AMensagem, AMetodo : String);
begin
  Log(tpmDebug, AMensagem, AMetodo);
end;

procedure TmMensagemLog.Erro(AMensagem, AMetodo : String);
begin
  Log(tpmErro, AMensagem, AMetodo);
end;

procedure TmMensagemLog.Warning(AMensagem, AMetodo : String);
begin
  Log(tpmWarning, AMensagem, AMetodo);
end;

//--

procedure TmMensagemLog.ErroException(AMensagem, AMetodo : String);
begin
  raise Exception.Create(Log(tpmErro, AMensagem, AMetodo));
end;

procedure TmMensagemLog.ErroException(AException : Exception; AMetodo : String);
begin
  Log(tpmErro, AException.Message, AMetodo);
end;

//--

end.