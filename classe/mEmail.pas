unit mEmail;

interface

uses
  Classes, SysUtils, Forms,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdAttachmentFile, IdMessageClient, IdSMTP, IdMessage, IdSSLOpenSSL,
  mProxy, mServidorEmail, mString;

type
  TmEmail = class(TComponent)
  private
    fServidor : TmServidorEmail;

    fInRemet : Boolean;

    fEmailDe : String;
    fEmailPara : TmStringList;
    fEmailCC : TmStringList;
    fEmailCCO : TmStringList;

    fAssunto : String;
    fTipoConteudo : String;
    fConteudo : String;

    fLstAnexo : TmStringList;
  protected
    procedure Validar();
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Enviar();
  published
    property Servidor : TmServidorEmail read fServidor write fServidor;

    property InRemet : Boolean read fInRemet write fInRemet;

    property EmailDe : String read fEmailDe write fEmailDe;
    property EmailPara : TmStringList read fEmailPara write fEmailPara;
    property EmailCC : TmStringList read fEmailCC write fEmailCC;
    property EmailCCO : TmStringList read fEmailCCO write fEmailCCO;

    property Assunto : String read fAssunto write fAssunto;
    property TipoConteudo : String read fTipoConteudo write fTipoConteudo;
    property Conteudo : String read fConteudo write fConteudo;

    property LstAnexo : TmStringList read fLstAnexo write fLstAnexo;
  end;

  function Instance : TmEmail;
  procedure Destroy;

implementation

uses
  mIniFiles, mLogger;

var
  _instance : TmEmail;

  function Instance : TmEmail;
  begin
    if not Assigned(_instance) then
      _instance := TmEmail.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

const
  cLstTipoContent : Array [0..2] Of String = (
    'text/html', 'text/rtf', 'text/plain');

  procedure TmEmail.Validar();
  const
    cMETHOD = 'TmEmail.Validar()';
  begin
    //Verificar configuracao
    if fServidor.User = '' then
      raise Exception.Create('Username deve ser configurado! / ' + cMETHOD);
    if fServidor.Pass = '' then
      raise Exception.Create('Password deve ser configurado! / ' + cMETHOD);
    if fServidor.Host = '' then
      raise Exception.Create('Hostname deve ser configurado! / ' + cMETHOD);
    if fServidor.Port = '' then
      raise Exception.Create('Portname deve ser configurado! / ' + cMETHOD);

    //Verificar conteudo
    if FEmailDe = '' then
      raise Exception.Create('Email origem deve ser informado! / ' + cMETHOD);
    if fEmailPara.Count = 0 then
      raise Exception.Create('Email destino deve ser informado! / ' + cMETHOD);
    if FAssunto = '' then
      raise Exception.Create('Assunto deve ser informado! / ' + cMETHOD);
    if FConteudo = '' then
      raise Exception.Create('Conteudo deve ser informado! / ' + cMETHOD);
  end;

constructor TmEmail.create(AOwner: TComponent);
begin
  inherited; //

  fServidor := mServidorEmail.Instance;

  fInRemet := TmIniFiles.PegarB('', 'EMAIL', 'IN_REMET', False);

  fEmailDe := TmIniFiles.PegarS('', 'EMAIL', 'MAIL', '');
  fEmailPara := TmStringList.Create;
  fEmailCC := TmStringList.Create;
  fEmailCCO := TmStringList.Create;

  fAssunto := TmIniFiles.PegarS('', 'EMAIL', 'ASSUNTO', '');
  fTipoConteudo := TmIniFiles.PegarS('', 'EMAIL', 'TP_CONTEUDO', '');
  fConteudo := TmIniFiles.PegarS('', 'EMAIL', 'CONTEUDO', '');
  fLstAnexo := TmStringList.Create;
end;

destructor TmEmail.Destroy;
begin
  FreeAndNil(fEmailPara);
  FreeAndNil(fEmailCC);
  FreeAndNil(fEmailCCO);
  FreeAndNil(fLstAnexo);

  inherited;
end;

procedure TmEmail.Enviar;
const
  cMETHOD = 'TmEmail.Enviar()';
var
  IdSSLIOHandlerSocket : TIdSSLIOHandlerSocketOpenSSL;
  IdMessage : TIdMessage;
  IdSMTP : TIdSMTP;
  I : Integer;
begin
  //Validar email
  Validar();

  //Enviar copia do email para o remetente
  if fInRemet then
    fEmailCC.Add(fEmailDe);

  //Configuração do IdMessage (dados da mensagem)
  IdMessage := TIdMessage.Create(Application);

  IdMessage.AttachmentEncoding := 'MIME';
  IdMessage.ContentType := 'text/html';
  IdMessage.Encoding := meMIME;

  IdMessage.From.Address := FEmailDe;                               //e-mail do remetente
  IdMessage.Recipients.EMailAddresses := fEmailPara.GetString(';'); //e-mail do destinatário
  IdMessage.CCList.EMailAddresses := FEmailCC.GetString(';');       //e-mail com copia
  IdMessage.BCCList.EMailAddresses := FEmailCCO.GetString(';');     //e-mail com copia oculta
  IdMessage.Subject := FAssunto;                                    //assunto

  //Anexo
  IdMessage.MessageParts.Clear;
  for I := 0 to fLstAnexo.Count - 1 do
    TIdAttachmentFile.Create(IdMessage.MessageParts, fLstAnexo.Items[I]);

  //Tipo de conteudo
  if fTipoConteudo <> '' then
    IdMessage.ContentType := fTipoConteudo;

  //Conteudo
  IdMessage.Body.Text := TmString.IfNull(fConteudo, 'EMAIL GERADO AUTOMATICO');

  //Configuração do IdSMTP
  IdSMTP := TIdSMTP.Create(Application);
  IdSMTP.Host := fServidor.Host;                  // Host do SMTP
  IdSMTP.Port := StrToIntDef(fServidor.Port, 25); // Porta do SMTP
  IdSMTP.Username := fServidor.User;              // Login do usuário
  IdSMTP.Password := fServidor.Pass;              // Senha do usuário

  //-- requer autenticacao
  if fServidor.Auth then
    IdSMTP.AuthType := satSASL
  else
    IdSMTP.AuthType := satNone;

  //-- conexao segura SSL
  if fServidor.SSL then begin
    IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv3; //sslvTLSv1; //sslvSSLv2;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;  //sslmUnassigned;
    IdSMTP.IOHandler := IdSSLIOHandlerSocket;
  end else
    IdSMTP.IOHandler := nil;

  //Envia o email
  try
    IdSMTP.Connect; //(3000); //Estabelece a conexão
    //IdSMTP.Authenticate;    //Faz a autenticação
    if IdSMTP.Connected then
      IdSMTP.Send(IdMessage); //Envia a mensagem
  except
    on E : Exception do begin
      mLogger.Instance.Erro(cMETHOD, 'Erro ao enviar email! / Erro: ' + E.Message);
      raise;
    end;  
  end;

  IdSMTP.Free;
  IdMessage.Free;
end;

initialization
  //Instance();
  RegisterClass(TmEmail);

finalization
  Destroy();

end.