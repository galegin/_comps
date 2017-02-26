unit mLogger;

interface

uses
  Classes, SysUtils, StrUtils;

type
  TTipoLogger = (tpmDebug, tpmErro, tpmWarning);

  TmLogger = class(TComponent)
  private
    fArquivoXml : String;
  protected
  public
    constructor Create(AOwner : TComponent); override;

    function Log(ATipoMensagemLog : TTipoLogger; AMensagem : String; AMetodo : String = '') : String;

    procedure Debug(AMensagem : String; AMetodo : String = '');
    procedure Erro(AMensagem : String; AMetodo : String = '');
    procedure Warning(AMensagem : String; AMetodo : String = '');
  published
    property ArquivoXml : String read fArquivoXml write fArquivoXml;
  end;

  function Instance : TmLogger;

implementation

uses
  mProjeto, mArquivo, mPath;

const
  TTipoLogger_Codigo : Array [TTipoLogger] of string =
    ('Debug', 'Erro', 'Warning');

var
  _instance : TmLogger;

  function Instance : TmLogger;
  begin
    if not Assigned(_instance) then
      _instance := TmLogger.Create(nil);
    Result := _instance;
  end;

constructor TmLogger.Create(AOwner : TComponent);
begin
  inherited;
  fArquivoXml := TmPath.Log() + mProjeto.Instance.Codigo + FormatDateTime('yyyy.mm.dd', Date) + '.xml';
end;

//--

function TmLogger.Log(ATipoMensagemLog : TTipoLogger; AMensagem, AMetodo : String) : String;
begin
  Result :=
    '<log>' + sLineBreak +
    '<data_hora>' + DateTimeToStr(now) + '</data_hora>' + sLineBreak +
    '<tipo_mensagem>' + TTipoLogger_Codigo[ATipoMensagemLog] + '</tipo_mensagem>' + sLineBreak +
    '<mensagem>' + AMensagem + '</mensagem>' + sLineBreak +
    '<metodo>' + AMetodo + '</metodo>' + sLineBreak +
    '</log>' + sLineBreak ;

  TmArquivo.Adicionar(fArquivoXml, Result);

  //--

  Result := AMensagem + ' / ' + AMetodo;
end;

//--

procedure TmLogger.Debug(AMensagem, AMetodo : String);
begin
  Log(tpmDebug, AMensagem, AMetodo);
end;

procedure TmLogger.Erro(AMensagem, AMetodo : String);
begin
  Log(tpmErro, AMensagem, AMetodo);
end;

procedure TmLogger.Warning(AMensagem, AMetodo : String);
begin
  Log(tpmWarning, AMensagem, AMetodo);
end;

//--

end.
