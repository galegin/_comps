unit mThread;

interface

uses
  Classes, SysUtils;

type
  TpThread = (tpaCmp, tpaCls, tpaObj);

  TmThread = class(TThread)
  private
    FTabelaLabel : TThreadMethod;
    FTabelaIncr : TThreadMethod;
  protected
    FLstXml : String;
    FQtAtual : Integer;
    FQtTotal : Integer;
    FTpThread : TpThread;

    procedure Execute; override;

    //procedure SetTabelaLabel();
    //procedure SetTabelaIncr();

    function GetStatus(pParams : String = '') : String;
  public
    constructor Create(CreateSuspended : Boolean);
  published
    property _LstXml : String read FLstXml write FLstXml;
    property _TabelaLabel : TThreadMethod read FTabelaLabel write FTabelaLabel;
    property _TabelaIncr : TThreadMethod read FTabelaIncr write FTabelaIncr;
    property _TpThread : TpThread read FTpThread write FTpThread;
  end;

var
  gInTerminado, gInParar : Boolean;

implementation

uses
  mActivate, mClasseExec, mFuncao, mTipoSts, mLogger, mItem, mXml;

{ TC_Thread }

constructor TmThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := True;
  FTpThread := tpaCmp;
end;

procedure TmThread.Execute;
const
  cMETHOD = 'TmThread.Execute()';
var
  vLstXml, vXml,
  vParams, vResult,
  vCdClasse, vCdMetodo, vDsParams : String;
begin
  vLstXml := FLstXml;
  if vLstXml = '' then 
    Exit;

  gInTerminado := False;

  FQtTotal := itemCountX(vLstXml);
  FQtAtual := 0;

  while vLstXml <> '' do begin
    vXml := getitemX(vLstXml);
    if vXml = '' then Break;
    delitemX(vLstXml);

    Inc(FQtAtual);

    mLogger.d(vXml + ' / ' + cMETHOD);

    // sincronizar label
    if Assigned(_TabelaLabel) then 
      Synchronize(_TabelaLabel);

    vCdClasse := itemX('CD_CLASSE', vXml);
    vCdMetodo := itemX('CD_METODO', vXml);
    vDsParams := itemX('DS_PARAMS', vXml);

    if vCdClasse = '' then
      raise Exception.create('Classe deve ser informada / ' + cMETHOD);
    if vCdMetodo = '' then
      raise Exception.create('Metodo deve ser informado / ' + cMETHOD);
    if vDsParams = '' then
      raise Exception.create('Parametro deve ser informado / ' + cMETHOD);

    try
      vParams := vDsParams;
      putitemX(vParams, 'IN_BACKGROUND', True);
      if (FTpThread = tpaCmp) then begin
        vResult := activateCmp(vCdClasse, vCdMetodo, vParams);
      end else if (FTpThread = tpaCls) then begin
        vResult := execClasse(vCdClasse, vCdMetodo, vParams);
      end else if (FTpThread = tpaObj) then begin
        vResult := execObjeto(vCdClasse, vCdMetodo, vParams);
      end;
      if itemXF('status', vResult) < 0 then
        mLogger.e(vResult + ' / ' + cMETHOD);
    except
      raise;
    end;

    // sincronizar incremento
    if Assigned(_TabelaIncr) then 
      Synchronize(_TabelaIncr);

    if (gInParar) or (Terminated) then
      Break;
  end;

  gInTerminado := True;
end;

(* procedure TmThread.SetTabelaLabel();
begin
  //if (FProgress = nil) then Exit;
  //FProgress.SetarLabel(cPROG_TABLE, 'Script ' + FDs);
  //FProgress.SetarLabel(cPROG_REGIS, 'Registro');
  //FProgress.SetarInit(cPROG_REGIS);
end; *)

(* procedure TmThread.SetTabelaIncr();
begin
  //if (FProgress = nil) then Exit;
  //FProgress.SetarIncr(cPROG_TABLE);
end; *)

function TmThread.GetStatus(pParams : String) : String;
begin
  Result := '';
  putitemX(Result, 'QT_TOTAL', FQtTotal);
  putitemX(Result, 'QT_ATUAL', FQtAtual);
end;

end.