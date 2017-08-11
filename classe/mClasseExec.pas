unit mClasseExec;

interface

uses
  Classes, SysUtils, StrUtils, Windows, Forms, Math;

type
  TpOpcao = (tpClasse, tpClasseResult, tpObjeto, tpObjetoResult);

  function execClasse(pClasse, pMetodo : String; pParams : String) : String;

  function execObjeto(pClasse, pMetodo, pParams : String; pOwner : TComponent = nil) : String; overload;
  function execObjeto(pObject : TObject; pMetodo, pParams : String) : String; overload;

  function execLibrary(pLibrary, pMetodo, pParams : String) : String; overload;
  function execLibrary(pLibrary, pClasse, pMetodo, pParams : String) : String; overload;

  function execPackage(pPackage, pMetodo, pParams : String) : String; overload;
  function execPackage(pPackage, pClasse, pMetodo, pParams : String) : String; overload;

  function execProgram(pProgram, pMetodo, pParams : String) : String;
  function execRequest(pClasse, pMetodo, pParams : String; var pExec : Boolean) : String;

implementation

uses
  mRetorno, mRetornoIntf,
  mAppSerial, mIniFiles, mLibrary, //mMetodo,
  mArquivo, mModulo, mPath, mObjeto,
  mLogger; //, mTipoSts, mFuncao, mItem, mXml;

resourcestring
  ClasseNotFound = 'Classe "%s" nao encontrada';
  ClasseUnInformed = 'Classe nao informada';
  ObjectNotCreated = 'Objeto nao instanciado para a classe "%s"';
  ObjectUnInformed = 'Objeto nao informado';
  MethodNotFound = 'Metodo "%s" nao encontrado na %s classe';
  LibraryNotExits = 'Library "%s" nao existe';
  LibraryNotFound = 'Library "%s" nao encontrada';
  LibraryUnInformed = 'Library nao informada';
  PackageNotExits = 'Pacote "%s" nao existe';
  PackageNotFound = 'Pacote "%s" nao encontrado';
  PackageUnInformed = 'Pacote nao informado';

type
  TExecuteMethod = function(pParams : String) : String of object;

  THandleArray = Array Of THandle;

var
  gLibraryList : TmLibraryList;
  gPackageList : TmLibraryList;

  //--

  procedure dropInstance();
  var
    I : Integer;
  begin
    with gLibraryList do
      for I := 0 to Count - 1 do
        FreeLibrary(Items[I].Handle);
  end;

//-- CLASSE

function execClasse(pClasse, pMetodo, pParams : String) : String;
const
  cMETHOD = 'mExecute.execClasse()';
var
  vMethod : TMethod;
  vExecute : TExecuteMethod;
begin
  pClasse := TmIniFiles.PegarS('', 'CLASSNAME', pClasse, pClasse);

  //vMethod := mObjeto.mtd(pClasse, pMetodo);

  //mMetodo.add(pClasse + '.' + pMetodo + '()');
  //if pParams <> '' then
    //mLogger.d('pParams: ' + pParams + '/' + pClasse + '.' + pMetodo + '()');

  vExecute := TExecuteMethod(vMethod);
  Result := vExecute(pParams);

  //if (Result <> '') then
  //  mLogger.d('Result: ' + Result + '/' + pClasse + '.' + pMetodo + '()');

  //mMetodo.dec();
end;

//-- OBJETO

function execObjeto(pClasse, pMetodo, pParams : String; pOwner : TComponent) : String;
const
  cMETHOD = 'mExecute.execObjeto()';
var
  vObject : TObject;
begin
  //vObject := mObjeto.get(pClasse, pOwner);

  //if vObject = nil then
  //  raise Exception.create(Format(ObjectNotCreated, [pClasse]) + ' / ' + cMETHOD);

  try
    Result := execObjeto(vObject, pMetodo, pParams);
  finally
    FreeAndNil(vObject);
  end;
end;

function execObjeto(pObject : TObject; pMetodo, pParams : String) : String;
const
  cMETHOD = 'mExecute.execObjeto[obj]()';
var
  vMethod : TMethod;
  vExecute : TExecuteMethod;
begin
  //vMethod := mObjeto.mtd(pObject, pMetodo);

  //mMetodo.add(pObject.ClassName + '.' + pMetodo + '()');
  //if (pParams <> '') then
  //  mLogger.d('pParams: ' + pParams + '/' + pObject.ClassName + '.' + pMetodo + '()');

  vExecute := TExecuteMethod(vMethod);
  Result := vExecute(pParams);

  //if (Result <> '') then
  //  mLogger.d('Result: ' + Result + '/' + pObject.ClassName + '.' + pMetodo + '()');

  //mMetodo.dec();
end;

//-- LIBRARY

function execLibrary(pLibrary, pMetodo, pParams : String) : String;
type
  TDLLFunc = function(pGlobal, pMetodo, pParams : PChar) : IRetorno; StdCall;
const
  cMETHOD = 'mExecute.execLibrary()';
  DLLFunc : TDLLFunc = nil;
var
  DLLName, DLLPath : String;
  DLLHandle : THandle;
  vRetorno : IRetorno;
  vGlobal : String;
begin
  Result := '';

  if pLibrary = '' then
    raise Exception.create(LibraryUnInformed + ' / ' + cMETHOD);

  pLibrary := TmIniFiles.PegarS('', 'LIBRARY', pLibrary, pLibrary);

  DLLPath := TmPath.Current();
  DLLName := DLLPath + pLibrary + '.dll';

  if not FileExists(DLLName) then
    raise Exception.create(Format(LibraryNotFound, [pLibrary]) + ' / ' + cMETHOD);

  DLLHandle := LoadLibrary(PChar(DLLName));

  if DLLHandle < HINSTANCE_ERROR then
    raise Exception.create(Format(LibraryNotFound, [pLibrary]) + ' / ' + cMETHOD);

  try
    try
      @DLLFunc := GetProcAddress(DLLHandle, 'execute');
      if Assigned(DLLFunc) then begin
        vRetorno := DLLFunc(PChar(vGlobal), PChar(pMetodo), PChar(pParams));
        Result := vRetorno.Mensagem;
      end;
    except
      on E : Exception do
        raise Exception.create(E.Message + ' / ' + pLibrary + '.' + pMetodo + '()' + ' / ' + pParams);
    end;
  finally
    FreeLibrary(DLLHandle);
  end;
end;

function execLibrary(pLibrary, pClasse, pMetodo, pParams : String) : String;
type
  TDLLFunc = function(pGlobal, pComponent, pMetodo, pParams : PChar) : IRetorno; StdCall;
const
  cMETHOD = 'mExecute.execLibraryCls()';
  DLLFunc : TDLLFunc = nil;
var
  DLLName, DLLPath : String;
  DLLHandle : THandle;
  vRetorno : IRetorno;
  vGlobal : String;
begin
  Result := '';

  if pLibrary = '' then
    raise Exception.create(LibraryUnInformed + ' / ' + cMETHOD);

  pLibrary := TmIniFiles.PegarS('', 'LIBRARY', pLibrary, pLibrary);

  DLLPath := TmPath.Current();
  DLLName := DLLPath + pLibrary + '.dll';

  if not FileExists(DLLName) then
    raise Exception.create(Format(LibraryNotExits, [pLibrary]) + ' / ' + cMETHOD);

  DLLHandle := LoadLibrary(PChar(DLLName));

  if DLLHandle < HINSTANCE_ERROR then
    raise Exception.create(Format(LibraryNotFound, [pLibrary]) + ' / ' + cMETHOD);

  try
    try
      @DLLFunc := GetProcAddress(DLLHandle, 'execute');
      if Assigned(DLLFunc) then begin
        vRetorno := DLLFunc(PChar(vGlobal), PChar(pClasse), PChar(pMetodo), PChar(pParams));
        Result := vRetorno.Mensagem;
      end;
    except
      on E : Exception do
        raise Exception.create(E.Message + ' / ' + pLibrary + ' >> ' + pClasse + '.' + pMetodo + '()' + ' / ' + pParams);
    end;
  finally
    FreeLibrary(DLLHandle);
  end;
end;

//-- PACKAGE

function execPackage(pPackage, pMetodo, pParams : String) : String;
type
  TPKGFunc = function(pGlobal, pParams : String) : String;
const
  cMETHOD = 'mExecute.execPackage()';
var
  PKGName, PKGPath : String;
  PKGHandle : HModule;
  PKGFunc : TPKGFunc;
begin
  Result := '';

  if pPackage = '' then
    raise Exception.create(PackageUnInformed + ' / ' + cMETHOD);

  pPackage := TmIniFiles.PegarS('', 'PACKAGE', pPackage, pPackage);

  PKGPath := TmPath.Current();
  PKGName := PKGPath + pPackage + '.bpl';

  if not FileExists(PKGName) then
    raise Exception.create(Format(PackageNotExits, [pPackage]) + ' / ' + cMETHOD);

  PKGHandle := LoadPackage(PKGName);

  //Tenta carregar o pacote...
  if PKGHandle = 0 then
    raise Exception.create(Format(PackageNotFound, [pPackage]) + ' / ' + cMETHOD);

  //se carregou, tenta localizar o procedure
  try
    try
      @PKGFunc := GetProcAddress(PKGHandle, PChar(pMetodo));
      if Assigned(PKGFunc) then
        Result := PKGFunc({TmParamVar.param()} '', pParams);
    except
      on E : Exception do
        raise Exception.create(E.Message + ' / ' + pPackage + '.' + pMetodo + '()' + ' / ' + pParams);
    end;
  finally
    UnloadPackage(PKGHandle);
  end;
end;

function execPackage(pPackage, pClasse, pMetodo, pParams : String) : String;
const
  cMETHOD = 'mExecute.execPackageCls()';
var
  PKGName, PKGPath : String;
  PKGHandle : HModule;
  PKGObject : TObject;
begin
  Result := '';

  if pPackage = '' then
    raise Exception.create(PackageUnInformed + ' / ' + cMETHOD);

  pPackage := TmIniFiles.PegarS('', 'PACKAGE', pPackage, pPackage);

  PKGPath := TmPath.Current();
  PKGName := PKGPath + pPackage + '.bpl';

  if not FileExists(PKGName) then
    raise Exception.create(Format(PackageNotExits, [pPackage]) + ' / ' + cMETHOD);

  PKGHandle := LoadPackage(PKGName);

  //Tenta carregar o pacote...
  if PKGHandle = 0 then
    raise Exception.create(Format(PackageNotFound, [pPackage]) + ' / ' + cMETHOD);

  //se carregou, tenta localizar a classe
  //PKGObject := mObjeto.get(pClasse, nil);
  //if PKGObject = nil then
  //  raise Exception.create(Format(ObjectNotCreated, [pClasse]) + ' / ' + cMETHOD);

  try
    try
      Result := execObjeto(PKGObject, pMetodo, pParams);
    except
      on E : Exception do
        raise Exception.create(E.Message + ' / ' + pPackage + ' >> ' + pClasse + '.' + pMetodo + '()' + ' / ' + pParams);
    end;
  finally
    UnloadPackage(PKGHandle);
  end;
end;

//--

function execProgram(pProgram, pMetodo, pParams : String) : String;
const
  cMETHOD = 'mExecute.execProgram()';
(* var
  vParams, vPath,
  vConteudoReq, vConteudoRes,
  vArquivoExe, vArquivoReq, vArquivoRes : String; *)
begin
  Result := '';

  (* pProgram := TmIniFiles.PegarS('', 'PROGRAM', pProgram, pProgram);

  vArquivoExe := vPath + pProgram + '.exe';

  if not FileExists(vArquivoExe) then
    raise Exception.create('Programa ' + pProgram +' nao encontrado!' + ' / ' + cMETHOD);

  vArquivoReq := vPath + pProgram + '.req';
  vArquivoRes := vPath + pProgram + '.res';

  vConteudoReq := pParams;
  putitemX(vConteudoReq, 'TP_FUNCAO', pMetodo);
  putitemX(vConteudoReq, 'CD_ARQUIVORES', vArquivoRes);
  mArquivo.descarregar(vArquivoReq, vConteudoReq);

  mArquivo.excluir(vArquivoRes);

  vParams := '';
  putitem(vParams, 'ARQ', vArquivoReq);
  ExecAndWait(vArquivoExe, vParams, SW_SHOW);

  vConteudoRes := mArquivo.carregar(vArquivoRes);

  mArquivo.excluir(vArquivoReq);
  mArquivo.excluir(vArquivoRes);

  Result := vConteudoRes; *)
end;

//--

function execRequest(pClasse, pMetodo, pParams : String; var pExec : Boolean) : String;
const
  cMETHOD = 'mExecute.execRequest()';
//var
//  vArquivoRes, vArquivo, vConteudo, vMetodo : String;
begin
  Result := '';
  (* pExec := False;

  //vArquivo := item('ARQ', PARAM_CMD);
  if not FileExists(vArquivo) then
    Exit;

  try
    vConteudo := mArquivo.carregar(vArquivo);
    if vConteudo = '' then
      raise Exception.Create('Conteudo de requisicao deve ser informado! / ' + cMETHOD);

    vArquivoRes := item('CD_ARQUIVORES', vConteudo);
    if vArquivoRes = '' then
      raise Exception.Create('Arquivo de resposta deve ser informado! / ' + cMETHOD);

    vMetodo := item('TP_FUNCAO', vConteudo);
    if vMetodo = '' then
      raise Exception.Create('Tipo funcao deve ser informado! / ' + cMETHOD);

    Result := execObjeto(pClasse, vMetodo, vConteudo);
  except
    on E : Exception do begin
      putitemX(Result, 'status', STS_ERROR);
      putitemX(Result, 'message', E.Message);
      putitemX(Result, 'metodo', pClasse + '.' + vMetodo + '()');
    end;
  end;

  mArquivo.descarregar(vArquivoRes, Result);

  pExec := True;
  Result := Result; *)
end;

//--

initialization

finalization
  dropInstance();

end.