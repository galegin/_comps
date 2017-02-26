unit mArquivoZip;

interface

uses
  Classes, SysUtils, Windows;

type
  TmArquivoZip = class(TComponent)
  published
    class function compactar(pParams : String) : String;
    class function descompactar(pParams : String) : String;
  end;

implementation

uses
  mFuncao, mItem, mXml,
  tsqZip, tsqUnZip;

var
  gCurrentDirAnt : String;

  procedure backupCurrentDir(pDir : String);
  begin
    gCurrentDirAnt := GetCurrentDir();
    SetCurrentDirectory(PChar(pDir));
  end;

  procedure restoreCurrentDir();
  begin
    SetCurrentDirectory(PChar(gCurrentDirAnt));
  end;

{ TmArquivoZip }

class function TmArquivoZip.compactar(pParams: String): String;
const
  cMETHOD = 'TmArquivoZip.compactar()';
var
  vtsqZip : TtsqZip;
  vArqZip, vLstArq, vArq : String;
begin
  Result := '';

  vArqZip := itemX('ARQ_ZIP', pParams);
  vLstArq := itemX('LST_ARQ', pParams);

  if vArqZip = '' then
    raise Exception.create('Arquivo ZIP deve ser informado! / ' + cMETHOD);
  if vLstArq = '' then
    raise Exception.create('Lista de arquivo deve ser informada! / ' + cMETHOD);

  backupCurrentDir(ExtractFileDir(vArqZip));

  vtsqZip := TtsqZip.Create(nil);
  vtsqZip.ZipFileName := ExtractFileName(vArqZip);
  vtsqZip.FilesToZip.Clear();

  while vLstArq <> '' do begin
    vArq := getitem(vLstArq);
    if vArq = '' then Break;
    delitem(vLstArq);
    vtsqZip.FilesToZip.Add(ExtractFileName(vArq));
  end;

  vtsqZip.Execute();
  FreeAndNil(vtsqZip);

  restoreCurrentDir();
end;

class function TmArquivoZip.descompactar(pParams: String): String;
const
  cMETHOD = 'TmArquivoZip.descompactar()';
var
  vtsqUnZip : TtsqUnZip;
  vArqZip, vDirDes : String;
begin
  Result := '';

  vArqZip := itemX('ARQ_ZIP', pParams);
  vDirDes := itemX('DIR_DES', pParams);

  if vArqZip = '' then
    raise Exception.create('Arquivo ZIP deve ser informado! / ' + cMETHOD);
  if vDirDes = '' then
    raise Exception.create('Dir destino deve ser informado! / ' + cMETHOD);

  backupCurrentDir(ExtractFileDir(vArqZip));

  vtsqUnZip := TtsqUnZip.Create(nil);
  vtsqUnZip.ZipFileName := ExtractFileName(vArqZip);
  vtsqUnZip.DirToExtractTo := vDirDes;
  vtsqUnZip.Execute();
  FreeAndNil(vtsqUnZip);

  restoreCurrentDir();
end;

initialization
  Classes.RegisterClass(TmArquivoZip);

end.