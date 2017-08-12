unit mFtp;

(* mFtp *)

interface

uses
  Classes, SysUtils, StrUtils, Math,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdFTP,
  mString, mLogger;

type
  TTipoArquivoFtp = (tfArquivo, tfDiretorio);
  TTipoArquivoFtpSet = Set Of TTipoArquivoFtp;

  TmFtp = class(TComponent)
  private
    fIdFTP : TIdFTP;
    fHost : String;
    fUser : String;
    fPass : String;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    procedure Connectar;
    procedure DesConnectar;
    procedure ChangeDir(APasta : String);
    procedure List(APasta : String; ATipo : TTipoArquivoFtpSet; AExtensao : String; out AListaArquivo : TmStringList);
    procedure Get(APasta : String; AListaArquivo : TmStringList; ADiretorioDestino : String);
    procedure Put(APasta : String; AListaArquivo : TmStringList; ADiretorioOrigem : String);
    procedure Remove(APasta : String; AListaArquivo : TmStringList);
  published
    property Host : String read fHost write fHost;
    property User : String read fUser write fUser;
    property Pass : String read fPass write fPass;
  end;

  function Instance : TmFtp;
  procedure Destroy;

implementation

var
  _instance : TmFtp;

  function Instance : TmFtp;
  begin
    if not Assigned(_instance) then
      _instance := TmFtp.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

(* mFtp *)

constructor TmFtp.Create(AOwner : TComponent);
begin
  inherited;

  fIdFTP := TIdFTP.Create(nil);
end;

destructor TmFtp.Destroy;
begin
  FreeAndNil(fIdFTP);

  inherited;
end;

//--

procedure TmFtp.Connectar;
const
  cDS_METHOD = 'TmFtp.Conectar()';
begin
  if fHost = '' then
    raise Exception.create('Host deve ser informado / ' + cDS_METHOD);
  if fUser = '' then
    raise Exception.create('User deve ser informado / ' + cDS_METHOD);
  if fPass = '' then
    raise Exception.create('Pass deve ser informado / ' + cDS_METHOD);

  with fIdFTP do begin
    if (Connected) then
      Disconnect();
    Host := fHost;
    //Port := 21;
    Passive := True; //--
    Username := fUser;
    Password := fPass;
    Connect();
  end;

  if not fIdFTP.Connected then
    raise Exception.create('Erro ao connector ao FTP / ' + cDS_METHOD);
end;

procedure TmFtp.DesConnectar;
begin
  with fIdFTP do
    if Connected then
      Disconnect();
end;

procedure TmFtp.ChangeDir;
const
  cDS_METHOD = 'TmFtp.ChangeDir()';
begin
  if APasta = '' then
    raise Exception.create('Pasta deve ser informada / ' + cDS_METHOD);

  if not fIdFTP.Connected then
    raise Exception.create('FTP deve ser conectado / ' + cDS_METHOD);

  fIdFTP.ChangeDir(APasta);
end;

procedure TmFtp.List;
const
  cDS_METHOD = 'TmFtp.List()';
var
  vStringList : TStringList;
  vExtensao : String;
  I : Integer;

  function validaFiltro(pArq : String) : boolean;
  var
    vTipoArquivoFtp : TTipoArquivoFtp;
  begin
    Result := True;

    if (tfDiretorio in ATipo) or (tfArquivo in ATipo) then begin
      vTipoArquivoFtp := TTipoArquivoFtp(IfThen(Pos('.', pArq) > 0, Ord(tfArquivo), Ord(tfDiretorio)));
      if ((tfDiretorio in ATipo) and (vTipoArquivoFtp <> tfDiretorio))
      or ((tfArquivo in ATipo) and (vTipoArquivoFtp <> tfArquivo)) then
        Result := False;
    end;
  end;

begin
  vExtensao := TmString.IfNull(AExtensao, '*.*');

  if APasta = '' then
    raise Exception.create('Pasta deve ser informada / ' + cDS_METHOD);

  if not fIdFTP.Connected then
    raise Exception.create('FTP deve ser conectado / ' + cDS_METHOD);

  vStringList := TStringList.Create;

  fIdFTP.ChangeDir(APasta);

  fIdFTP.List(vStringList, vExtensao, True);

  if (vStringList.Count = 0) then
    raise Exception.create('Nenhum arquivo encontrado para baixa do FTP! / ' + cDS_METHOD);

  AListaArquivo := TmStringList.Create;

  for I:=0 to vStringList.Count-1 do
    if validaFiltro(vStringList[I]) then
      AListaArquivo.Add(vStringList[I]);

  vStringList.Free;
end;

procedure TmFtp.Get;
const
  cDS_METHOD = 'TmFtp.Get()';
var
  I : Integer;
begin
  if APasta = '' then
    raise Exception.create('Pasta deve ser informada / ' + cDS_METHOD);
  if AListaArquivo.Count = 0 then
    raise Exception.create('Lista de arquivo deve ser informada / ' + cDS_METHOD);
  if ADiretorioDestino = '' then
    raise Exception.create('Diretorio destino deve ser informado / ' + cDS_METHOD);

  if not fIdFTP.Connected then
    raise Exception.create('FTP deve ser conectado / ' + cDS_METHOD);

  fIdFTP.ChangeDir(APasta);

  for I := 0 to AListaArquivo.Count - 1 do begin
    fIdFTP.Get(AListaArquivo.Items[I], ADiretorioDestino, True);
    mLogger.Instance.Debug(cDS_METHOD, 'Copiando arquivo do FTP... ' + AListaArquivo.Items[I] + ' -> ' + ADiretorioDestino);
  end;
end;

procedure TmFtp.Put;
const
  cDS_METHOD = 'TmFtp.Put()';
var
  I : Integer;
begin
  if APasta = '' then
    raise Exception.create('Pasta deve ser informada / ' + cDS_METHOD);
  if AListaArquivo.Count = 0 then
    raise Exception.create('Lista de arquivo deve ser informada / ' + cDS_METHOD);
  if ADiretorioOrigem = '' then
    raise Exception.create('Diretorio origemmo deve ser informado / ' + cDS_METHOD);

  if not fIdFTP.Connected then
    raise Exception.create('FTP deve ser conectado / ' + cDS_METHOD);

  fIdFTP.ChangeDir(APasta);

  for I := 0 to AListaArquivo.Count - 1 do begin
    fIdFTP.Put(ADiretorioOrigem, AListaArquivo.Items[I], False);
    mLogger.Instance.Debug(cDS_METHOD, 'Copiando arquivo para o FTP... ' + ADiretorioOrigem + ' -> ' + AListaArquivo.Items[I]);
  end;
end;

procedure TmFtp.Remove;
const
  cDS_METHOD = 'TmFtp.Remove()';
var
  vStringArquivo : TStringList;
  I : Integer;
begin
  if APasta = '' then
    raise Exception.create('Pasta deve ser informada / ' + cDS_METHOD);
  if AListaArquivo.Count = 0 then
    raise Exception.create('Lista de arquivo deve ser informada / ' + cDS_METHOD);

  if not fIdFTP.Connected then
    raise Exception.create('FTP deve ser conectado / ' + cDS_METHOD);

  vStringArquivo := TStringList.Create;

  fIdFTP.ChangeDir(APasta);

  fIdFTP.List(vStringArquivo, '*.*', False);

  for I := 0 to AListaArquivo.Count - 1 do
    if vStringArquivo.IndexOf(AListaArquivo.Items[I]) > -1 then
      fIdFTP.Delete(AListaArquivo.Items[I]);

  vStringArquivo.Free;
end;

initialization
  //Instance();

finalization
  Destroy();

end.