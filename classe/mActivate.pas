unit mActivate;

interface

uses
  Classes, SysUtils, mThread, mValue;

  function activateCmp(pClasse, pMetodo, pParams : String) : String;
  function activateDll(pClasse, pMetodo, pParams : String) : String;
  function activateExe(pClasse, pMetodo, pParams : String) : String;

  function activateThrLst(pLstParams : RParamThreadArray; pTpThread : TpThread = tpaCmp) : String;
  function activateThr(pParams : RParamThread; pTpThread : TpThread = tpaCmp) : String;

implementation

uses
  mClasseExec, mIniFiles, mArquivo, mClasse, mString;

  function getObjetoCmp(pClasse : String) : TObject;
  const
    cLstClasse : Array [0..7] Of String = (
      'TC_', 'Tc', 'TF_', 'Tf', 'TS_', 'Ts', 'T_', 'T');
  var
    vClasse : String;
    I : Integer;
  begin
    vClasse := pClasse;
    Result := TmClasse.CreateObjeto(GetClass(vClasse), nil);

    for I := 0 to High(cLstClasse) do begin
      vClasse := TmString.AllTrim(cLstClasse[I] + pClasse);
      if GetClass(vClasse) <> nil then begin
        Result := TmClasse.CreateObjeto(GetClass(vClasse), nil);
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

  pClasse := TmIniFiles.PegarS('', 'COMPONENTE', pClasse, pClasse);

  vProgram := TmIniFiles.PegarS('', 'PROGRAM', pClasse, pClasse);
  if vProgram <> '' then begin
    Result := activateExe(vProgram, pMetodo, pParams);
    Exit;
  end;

  vLibrary := TmIniFiles.PegarS('', 'LIBRARY', pClasse, pClasse);
  if vLibrary <> '' then begin
    Result := execLibrary(vLibrary, pMetodo, pParams);
    Exit;
  end;

  vPacote := TmIniFiles.PegarS('', 'PACKAGE', pClasse, pClasse);
  if vPacote <> '' then begin
    Result := execPackage(vPacote, pClasse, pMetodo, pParams);
    Exit;
  end;

  vObject := TmClasse.CreateObjeto(GetClass(pClasse), nil);
  if Assigned(vObject) then begin
    try
      Result := execObjeto(vObject, pMetodo, pParams);
    finally
      FreeAndNil(vObject);
    end;
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

function activateThrLst(pLstParams : RParamThreadArray; pTpThread : TpThread) : String;
const
  cMETHOD = 'mActivate.activateThrLst()';
begin
  Result := '';

  if Length(pLstParams) = 0 then
    raise Exception.create('Parametro deve ser informado! / ' + cMETHOD);

  with TmThread.Create(True) do begin
    _LstParams := pLstParams;
    _TpThread := pTpThread;
    FreeOnTerminate := True;
    Resume;
  end;
end;

function activateThr(pParams : RParamThread; pTpThread : TpThread) : String;
const
  cMETHOD = 'mActivate.activateThr()';
var
  vLstParams : RParamThreadArray;
begin
  Result := '';

  if pParams.Classe = '' then
    raise Exception.create('Classe deve ser informada! / ' + cMETHOD);
  if pParams.Metodo = '' then
    raise Exception.create('Metodo deve ser informado! / ' + cMETHOD);
  if pParams.Params = nil then
    raise Exception.create('Parametro deve ser informado! / ' + cMETHOD);

  SetLength(vLstParams, 1);

  vLstParams[0] := pParams;

  activateThrLst(vLstParams, pTpThread);
end;

end.