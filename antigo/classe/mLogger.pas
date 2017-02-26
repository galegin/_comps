unit mLogger;

interface

uses
  Classes, SysUtils, TypInfo,
  mTipoLogger;

  procedure log(pTip : TTipoLogger; pMensagem : String);

  procedure e(pMensagem : String);
  procedure d(pMensagem : String);
  procedure i(pMensagem : String);
  procedure w(pMensagem : String);

  function get() : String;

implementation

uses
  mIniFiles, mArquivo, mFuncao, mPath;

var
  gTipoLogger : TTipoLogger;
  gLog : TStringList;

  procedure getInstance();
  begin
    gTipoLogger := mTipoLogger.tip(mIniFiles.pegar('', '', 'tpLogger'));
    gLog := TStringList.Create;
 end;

procedure log(pTip : TTipoLogger; pMensagem : String);
var
  vArq, vCnt : String;
begin
  if pTip > gTipoLogger then
    Exit;

  vArq := mPath.log() + ChangeFileExt(ExtractFileName(ParamStr(0)), '.' + FormatDateTime('yyyy.mm.dd', Now)) + '.log';
  vCnt := '[ ' + DateTimeToStr(Now) + ' ] [' + mTipoLogger.str(pTip) + '] ' + pMensagem;
  mArquivo.adicionar(vArq, vCnt);

  gLog.Insert(0, vCnt);
  if gLog.Count > 1000 then
    gLog.Clear;
end;

procedure e(pMensagem : String);
begin
  mLogger.log(ERROR, pMensagem);
end;

procedure d(pMensagem : String);
begin
  mLogger.log(DEBUG, pMensagem);
end;

procedure i(pMensagem : String);
begin
  mLogger.log(INFO, pMensagem);
end;

procedure w(pMensagem : String);
begin
  mLogger.log(WARNING, pMensagem);
end;

function get() : String;
begin
  Result := gLog.Text;
end;

initialization
  getInstance();

end.