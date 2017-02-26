unit mActivate;

interface

uses
  Classes, SysUtils, mThread;

  function activateCmp(pClasse, pMetodo, pParams : String) : String;
  function activateDll(pClasse, pMetodo, pParams : String) : String;
  function activateExe(pClasse, pMetodo, pParams : String) : String;

  function activateThrLst(pLstXml : String; pTpThread : TpThread = tpaCmp) : String;
  function activateThr(pClasse, pMetodo, pParams : String; pTpThread : TpThread = tpaCmp) : String;

implementation

uses
  mClasseExec, mArquivo, mIniFiles,
  mObjeto, mFuncao, mItem, mXml;

  function getObjetoCmp(pClasse : String) : TObject;
  const
    cLST_CLS = 'TC_|Tc|TF_|Tf|TS_|Ts|T_|T| ';
  var
    vClasse,
    vLstTip, vTip : String;
  begin
    Result := mObjeto.get(vClasse, nil);

    vLstTip := cLST_CLS;
    while vLstTip <> '' do begin
      vTip := getitem(vLstTip);
      if vTip = '' then Break;
      delitem(vLstTip);

      vClasse := AllTrim(vTip + pClasse);
      if GetClass(vClasse) <> nil then begin
        Result := mObjeto.get(vClasse, nil);
        Exit;
      end;
    end;
  end;

function activateCmp(pClasse, pMetodo, pParams : String) : String;
const
  cMETHOD = 'mActivate.activateCmp()';
var
  vPacote, vLibrary, vProgram : String;
  vObject : TObject;
begin
  Result := '';

  pClasse := mIniFiles.pegar('', 'COMPONENTE', pClasse, pClasse);

  vProgram := mIniFiles.pegar('', 'PROGRAM', pClasse, pClasse);
  if vProgram <> '' then begin
    Result := activateExe(vProgram, pMetodo, pParams);
    Exit;
  end;

  vLibrary := mIniFiles.pegar('', 'LIBRARY', pClasse, pClasse);
  if vLibrary <> '' then begin
    Result := execLibrary(vLibrary, pMetodo, pParams);
    Exit;
  end;

  vPacote := mIniFiles.pegar('', 'PACKAGE', pClasse, pClasse);
  if vPacote <> '' then begin
    Result := execPackage(vPacote, pClasse, pMetodo, pParams);
    Exit;
  end;

  vObject := mObjeto.get(pClasse, nil);
  if vObject <> nil then begin
    try
      Result := execObjeto(vObject, pMetodo, pParams);
    except
      FreeAndNil(vObject);
      raise;
    end;
    FreeAndNil(vObject);
    Exit;
  end;

  Result := execLibrary(pClasse, pMetodo, pParams);
end;

function activateDll(pClasse, pMetodo, pParams : String) : String;
begin
  Result := execLibrary(pClasse, pMetodo, pParams);
end;

function activateExe(pClasse, pMetodo, pParams : String) : String;
begin
  Result := execProgram(pClasse, pMetodo, pParams);
end;

function activateThrLst(pLstXml : String; pTpThread : TpThread) : String;
const
  cMETHOD = 'mActivate.activateThrLst()';
begin
  Result := '';

  if pLstXml = '' then
    raise Exception.create('XML deve ser informado! / ' + cMETHOD);

  with TmThread.Create(True) do begin
    _LstXml := pLstXml;
    _TpThread := pTpThread;
    FreeOnTerminate := True;
    Resume;
  end;
end;

function activateThr(pClasse, pMetodo, pParams : String; pTpThread : TpThread) : String;
const
  cMETHOD = 'mActivate.activateThr()';
var
  vLstXml, vXml, vParams : String;
begin
  Result := '';

  if pClasse = '' then
    raise Exception.create('Classe deve ser informada! / ' + cMETHOD);
  if pMetodo = '' then
    raise Exception.create('Metodo deve ser informado! / ' + cMETHOD);
  if pParams = '' then
    raise Exception.create('Parametro deve ser informado! / ' + cMETHOD);

  vLstXml := '';

  while pParams <> '' do begin
    vParams := getitemX(pParams);
    if vParams = '' then Break;
    delitemX(pParams);

    vXml := '';
    putitemX(vXml, 'CD_CLASSE', pClasse);
    putitemX(vXml, 'CD_METODO', pMetodo);
    putitemX(vXml, 'DS_PARAMS', vParams);
    putitemX(vLstXml, vXml);
  end;

  activateThrLst(vLstXml, pTpThread);
end;

end.