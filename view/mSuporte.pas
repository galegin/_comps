unit mSuporte;

(* mSuporte *)

interface

uses
  Classes, SysUtils, StrUtils, Windows, JPeg, Graphics;

type
  TTipoSuporte = (tsArquivo, tsEmail, tsSite);
  TTipoImageSuporte = (tiTela, tiErro);

  TmSuporte = class(TComponent)
  private
    fTipo : TTipoSuporte;
    fProtocolo : String;

    fDetalhe : TStringList;

    fArquivoPrt : String;
    fArquivoTela : String;
    fArquivoErro : String;
    fArquivoCtr : String;
    fArquivoDet : String;
    fArquivoLog : String;

    fImagemTela : TBitMap;
    fImagemErro : TBitMap;

    procedure SetProtocolo(const Value: String);
  protected
    procedure GerarArquivo(AMensagem : String);
    procedure GerarEmail();
    procedure GerarSite();
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Gerar(AMensagem : String);
    procedure SetarImage(ATipo : TTipoImageSuporte);
  published
    property Tipo : TTipoSuporte read fTipo write fTipo;
    property Protocolo : String read fProtocolo write SetProtocolo;

    property ArquivoPrt : String read fArquivoPrt write fArquivoPrt;
    property ArquivoScr : String read fArquivoTela write fArquivoTela;
    property ArquivoErr : String read fArquivoErro write fArquivoErro;
    property ArquivoCtr : String read fArquivoCtr write fArquivoCtr;
    property ArquivoDet : String read fArquivoDet write fArquivoDet;
    property ArquivoLog : String read fArquivoLog write fArquivoLog;

    property ImagemTela : TBitMap read fImagemTela write fImagemTela;
    property ImagemErro : TBitMap read fImagemErro write fImagemErro;
  end;

  function Instance : TmSuporte;
  procedure Destroy;

implementation

uses
  mAppProtect, mEmail,
  mParametroDatabase, mComputador, mProjeto, mAmbienteConf,
  mArquivo, mArquivoZip, mPath, mGuid, mLoggerMem, mLogger;

var
  _instance : TmSuporte;

  function Instance : TmSuporte;
  begin
    if not Assigned(_instance) then
      _instance := TmSuporte.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

  //Capturar Janela Ativa
  procedure ScreenShotActiveWindow(pBmp : TBitMap);
  var
    c : TCanvas;
    r, t : TRect;
    h : THandle;
  begin
    c := TCanvas.Create;
    c.Handle := GetWindowDC(GetDesktopWindow);
    h := GetForegroundWindow;
    if h <> 0 then GetWindowRect(h,t);
    try
      r := Rect(0, 0, t.Right - t.Left, t.Bottom - t.Top);
      pBmp.Width := t.Right - t.Left;
      pBmp.Height := t.Bottom - t.Top;
      pBmp.Canvas.CopyRect(r,c,t);
    finally
      ReleaseDC(0, c.Handle);
      c.Free;
    end;
  end;

  procedure TmSuporte.SetarImage(ATipo : TTipoImageSuporte);
  begin
    case ATipo of
      tiTela :
        ScreenShotActiveWindow(fImagemTela);
      tiErro :
        ScreenShotActiveWindow(fImagemErro);
    end;
  end;

  function GravarImagem(pArquivo : String; pBmp : TBitmap) : String;
  var
    vJpgImage : TJpegImage;
  begin
    vJpgImage := TJPEGImage.Create;

    vJpgImage.Assign(pBmp);
    vJpgImage.SaveToFile(pArquivo);

    FreeAndNil(vJpgImage);
  end;

(* mSuporte *)

constructor TmSuporte.Create(AOwner : TComponent);
begin
  inherited;

  fTipo := tsArquivo;
  fDetalhe := TStringList.Create;

  fImagemTela := TBitmap.Create;
  fImagemErro := TBitmap.Create;
end;

destructor TmSuporte.Destroy;
begin
  FreeAndNil(fDetalhe);

  FreeAndNil(fImagemTela);
  FreeAndNil(fImagemErro);

  inherited;
end;

procedure TmSuporte.SetProtocolo(const Value: String);
begin
  fProtocolo := Value;

  fArquivoPrt := TmPath.Suporte() + 'prt_' + fProtocolo + '.zip';
  fArquivoTela := TmPath.Suporte() + 'scr_' + fProtocolo + '.jpg';
  fArquivoErro := TmPath.Suporte() + 'err_' + fProtocolo + '.jpg';
  fArquivoCtr := TmPath.Suporte() + 'ctr_' + fProtocolo + '.txt';
  fArquivoDet := TmPath.Suporte() + 'det_' + fProtocolo + '.xml';
  fArquivoLog := TmPath.Suporte() + 'log_' + fProtocolo + '.txt';

  TmArquivo.Excluir([fArquivoPrt, fArquivoTela, fArquivoErro, fArquivoCtr,
    fArquivoDet, fArquivoLog]);
end;

//--

procedure TmSuporte.Gerar(AMensagem: String);
begin
  //MensagemBal('Gerando protocolo...');

  fProtocolo := TmGuid.Get();

  GerarArquivo(AMensagem);

  case fTipo of
    tsEmail :
      GerarEmail;
    tsSite :
      GerarSite;
  end;
end;

//--

procedure TmSuporte.GerarArquivo;
begin
  //MensagemBal('Gerando arquivo...');

  //-- imagem tela
  GravarImagem(fArquivoTela, fImagemTela);

  //-- imagem erro
  GravarImagem(fArquivoErro, fImagemErro);

  //-- conteudo CTRL+M
  TmArquivo.Gravar(fArquivoCtr, mLoggerMem.Instance.Conteudo);

  //-- usuario logado
  //mUsuario.Instance.Limpar();
  //mUsuario.Instance.Cd_Usuario := mAmbienteConf.Instance.CodigoUsuario;
  //mUsuario.Instance.Consultar(nil);

  //-- Detalhamento protocolo
  fDetalhe.Clear;
  with fDetalhe do begin
    Add('PROTOCOLO=' + fProtocolo);
    Add('MENSAGEM=' + AMensagem);
    Add('COMPONENTE=' + mProjeto.Instance.Codigo);
    Add('VERSAO=' + mProjeto.Instance.Versao);
    Add('AMBIENTE=' + mAmbienteConf.Instance.CodigoAmbiente);
    Add('EMPRESA=' + IntToStr(mAmbienteConf.Instance.CodigoEmpresa));
    Add('TERMINAL=' + IntToStr(mAmbienteConf.Instance.CodigoTerminal));
    Add('USUARIO=' + IntToStr(mAmbienteConf.Instance.CodigoUsuario));
    //Add('LOGIN=' + mUsuario.Instance.Nm_Login);
    //Add('NOME=' + mUsuario.Instance.Nm_Usuario);
    Add('SERIAL=' + TmAppProtect.GetSerNumber());
    Add('DISCO=' + mComputador.Instance.NumeroDisco);
    Add('PROC=' + mComputador.Instance.NumeroProcessador);
    Add('REDE=' + mComputador.Instance.NumeroPlacaRede);
    Add('HOST=' + mComputador.Instance.NomeComputador);
    Add('IP=' + mComputador.Instance.IpComputador);

    SaveToFile(fArquivoDet);
  end;

  //-- Arquivo LOG
  TmArquivo.Copiar(mLogger.Instance.ArquivoXml, fArquivoLog);

  //-- Arquivo ZIP do protocolo
  TmArquivoZip.Compactar(fArquivoPrt, [fArquivoTela, fArquivoErro, fArquivoCtr,
    fArquivoDet, fArquivoLog]);

  //-- Limpar arquivos
  TmArquivo.Excluir([fArquivoPrt, fArquivoTela, fArquivoErro, fArquivoCtr,
    fArquivoDet, fArquivoLog]);
end;

procedure TmSuporte.GerarEmail;
var
  vAssunto, vConteudo : String;
begin
  //MensagemBal('Gerando email...');

  // assunto
  vAssunto :=
    'PRT:' + fProtocolo + ' ' +
    'AMB:' + UpperCase(mAmbienteConf.Instance.CodigoAmbiente) + ' ' +
    'EMP:' + IntToStr(mAmbienteConf.Instance.CodigoEmpresa) + ' ' +
    'TER:' + IntToStr(mAmbienteConf.Instance.CodigoTerminal) + ' ' +
    'USU:' + IntToStr(mAmbienteConf.Instance.CodigoUsuario);

  // conteudo
  vConteudo := AnsiReplaceStr(fDetalhe.Text, '=', ': ');

  //MensagemBal('Enviando email...');

  with mEmail.Instance do begin
    with Servidor do begin
      Mail := 'report.virtualage@gmail.com';
      Pass := '123@report';
      Host := 'smtp.gmail.com';
      Port := '465';
      Auth := True;
      SSL := True;
    end;

    EmailDe := Servidor.Mail;
    EmailPara.Clear;
    EmailPara.Add(Servidor.Mail);

    Assunto := vAssunto;
    Conteudo := vConteudo;

    LstAnexo.Clear;
    LstAnexo.Add(fArquivoPrt);

    Enviar();
  end;
end;

procedure TmSuporte.GerarSite;
begin
  //MensagemBal('Gerando site...');

end;

initialization
  //Instance();

finalization
  Destroy();

end.
