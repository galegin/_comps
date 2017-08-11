unit mThread;

interface

uses
  Classes, SysUtils;

type
  TpThread = (tpaCmp, tpaCls, tpaObj);

  RParamThread = record
    Classe : String;
    Metodo : String;
    Params : TObject;
  end;

  RParamThreadArray = Array Of RParamThread;

  TmThread = class(TThread)
  private
    FTabelaLabel : TThreadMethod;
    FTabelaIncr : TThreadMethod;
  protected
    FLstParams : RParamThreadArray;
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
    property _LstParams : RParamThreadArray read FLstParams write FLstParams;
    property _TabelaLabel : TThreadMethod read FTabelaLabel write FTabelaLabel;
    property _TabelaIncr : TThreadMethod read FTabelaIncr write FTabelaIncr;
    property _TpThread : TpThread read FTpThread write FTpThread;
  end;

var
  gInTerminado, gInParar : Boolean;

implementation

uses
  mActivate, mClasseExec, mLogger, mJson;

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
  vParams, vResult : String;
  vObjParams : RParamThread;
  I : Integer;
begin
  gInTerminado := False;

  FQtTotal := Length(FLstParams);
  FQtAtual := 0;

  for I := 0 to High(FLstParams) do begin
    Inc(FQtAtual);

    vObjParams := FLstParams[I];

    mLogger.Instance.Info(cMETHOD, 'Classe -> ' + vObjParams.Classe + '.' + vObjParams.Metodo);

    // sincronizar label
    if Assigned(_TabelaLabel) then
      Synchronize(_TabelaLabel);

    if vObjParams.Classe = '' then
      raise Exception.create('Classe deve ser informada / ' + cMETHOD);
    if vObjParams.Metodo = '' then
      raise Exception.create('Metodo deve ser informado / ' + cMETHOD);
    if vObjParams.Params = nil then
      raise Exception.create('Parametro deve ser informado / ' + cMETHOD);

    try
      vParams := TmJson.ObjectToJson(vObjParams.Params);
      //putitemX(vParams, 'IN_BACKGROUND', True);
      case FTpThread of
        tpaCmp :
          vResult := activateCmp(vObjParams.Classe, vObjParams.Metodo, vParams);
        tpaCls :
          vResult := execClasse(vObjParams.Classe, vObjParams.Metodo, vParams);
        tpaObj :
          vResult := execObjeto(vObjParams.Classe, vObjParams.Metodo, vParams);
      end;
    except
      on E : Exception do begin
        mLogger.Instance.Erro(cMETHOD, E.Message);
        raise;
      end;
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
  //putitemX(Result, 'QT_TOTAL', FQtTotal);
  //putitemX(Result, 'QT_ATUAL', FQtAtual);
end;

end.