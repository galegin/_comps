unit mArquivoZip;

interface

uses
  Classes, SysUtils, Windows;

type
  TmArquivoZip = class(TComponent)
  published
    class procedure Compactar(AArqZip : String; ALstArq : Array Of String);
    class procedure DesCompactar(AArqZip, ADirDes : String);
  end;

implementation

uses
  mException,
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

class procedure TmArquivoZip.Compactar;
const
  cMETHOD = 'TmArquivoZip.Compactar';
var
  vtsqZip : TtsqZip;
  I : Integer;
begin
  if AArqZip = '' then
    raise TmException.Create('Arquivo ZIP deve ser informado', cMETHOD);
  if Length(ALstArq) = 0 then
    raise TmException.Create('Lista de arquivo deve ser informada', cMETHOD);

  backupCurrentDir(ExtractFileDir(vArqZip));

  vtsqZip := TtsqZip.Create(nil);
  vtsqZip.ZipFileName := ExtractFileName(AArqZip);
  vtsqZip.FilesToZip.Clear();
  for I := 0 to High(ALstArq) do
    vtsqZip.FilesToZip.Add(ExtractFileName(ALstArq[I]));
  vtsqZip.Execute();
  FreeAndNil(vtsqZip);

  restoreCurrentDir();
end;

class procedure TmArquivoZip.DesCompactar;
const
  cMETHOD = 'TmArquivoZip.DesCompactar';
var
  vtsqUnZip : TtsqUnZip;
begin
  if AArqZip = '' then
    raise TmException.Create('Arquivo ZIP deve ser informado', cMETHOD);
  if ADirDes = '' then
    raise TmException.Create('Dir destino deve ser informado', cMETHOD);

  backupCurrentDir(ExtractFileDir(AArqZip));

  vtsqUnZip := TtsqUnZip.Create(nil);
  vtsqUnZip.ZipFileName := ExtractFileName(AArqZip);
  vtsqUnZip.DirToExtractTo := ADirDes;
  vtsqUnZip.Execute();
  FreeAndNil(vtsqUnZip);

  restoreCurrentDir();
end;

initialization
  Classes.RegisterClass(TmArquivoZip);

end.