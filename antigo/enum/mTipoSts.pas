unit mTipoSts;

interface

uses
  StrUtils, SysUtils, TypInfo;

type
  TTipoSts = (STS_NORMAL,
              STS_EXEC,
              STS_CONF,
              STS_ALERTA,
              STS_AVISO,
              STS_INFO,
              STS_FOUND,

              STS_ERRORGENERIC,
              STS_ERRORCOMMIT,
              STS_ERRORPAUSE,
              STS_METHOD,
              STS_OBJECT,
              STS_CLASS,
              STS_LOCK,
              STS_DBLOCK,
              STS_STRUCT,
              STS_NOTFOUND,
              STS_ERROR,

              STS_FINAL_PAPEL,
              STS_POUCO_PAPEL,

              STS_DATABASE,
              STS_INTERNET,
              STS_PRINTER,
              STS_LIBRARY,

              STS_ERRTABLE,
              STS_ERRFIELD,
              STS_REQFIELD,
              STS_SQLERROR,
              STS_SSLERROR,

              STS_COMUNICACAO,

              STS_ECFERROR,
              STS_NFEERROR,
              STS_PAFERROR,
              STS_TEFERROR,
              STS_NFCERROR,

              STS_ACCESSVIOLATION);

  function lst() : String;
  function tip(pTip : String) : TTipoSts;
  function str(pTip : TTipoSts) : String;

  function xml(pTip : TTipoSts) : String;
  function typ(pTip : TTipoSts) : String;
  function msg(pTip : TTipoSts) : String;
  function dic(pTip : TTipoSts) : String;

  function err(pTip : TTipoSts) : Boolean;

  function cod(pTip : TTipoSts) : Integer;

  function dica(pStatus : Variant) : String;
  function dicaConf(pStatus : Variant) : String;

  function SetStatus(pStatus : Variant; pMsg, pMtd : String; pPar : String = '') : String; overload;
  function SetStatus(pStatus : Variant) : String; overload;

  procedure return(pStatus : Variant);

const
  cLST_STATUS =
    '<STS_NORMAL          tip="msg" msg="" dic="" />' + // 0
    '<STS_EXEC            tip="cnf" msg="" dic="" />' + // 1
    '<STS_CONF            tip="msg" msg="" dic="" />' + // 2
    '<STS_ALERTA          tip="msg" msg="" dic="" />' + // 3
    '<STS_AVISO           tip="msg" msg="" dic="" />' + // 4
    '<STS_INFO            tip="msg" msg="" dic="" />' + // 5
    '<STS_FOUND           tip="msg" msg="" dic="" />' + // 6

    '<STS_ERRORGENERIC    tip="err" msg="" dic="" />' +
    '<STS_ERRORCOMMIT     tip="err" msg="" dic="" />' +
    '<STS_ERRORPAUSE      tip="err" msg="" dic="" />' +
    '<STS_METHOD          tip="err" msg="" dic="" />' +
    '<STS_OBJECT          tip="err" msg="" dic="" />' +
    '<STS_CLASS           tip="err" msg="" dic="" />' +
    '<STS_LOCK            tip="err" msg="" dic="" />' +
    '<STS_DBLOCK          tip="err" msg="" dic="" />' +
    '<STS_STRUCT          tip="err" msg="" dic="" />' +
    '<STS_NOTFOUND        tip="err" msg="" dic="" />' +
    '<STS_ERROR           tip="err" msg="" dic="" />' +

    '<STS_FINAL_PAPEL     tip="err" msg="" dic="" />' +
    '<STS_POUCO_PAPEL     tip="err" msg="" dic="" />' +

    '<STS_DATABASE        tip="err" msg="Problema de conexão com o banco de dados!"   dic="Verifique a configuração!" />' +
    '<STS_INTERNET        tip="err" msg="Problema de comunicação com a internet!"     dic="Tente novamente após alguns minutos!" />' +
    '<STS_PRINTER         tip="err" msg="Problema de comunicação com a impressora!"   dic="Verifique se está ligada/conectada!" />' +
    '<STS_LIBRARY         tip="err" msg="Problema ao executar DLL!"                   dic="" />' +

    '<STS_ERRTABLE        tip="err" msg="Tabela não existe no banco de dados!"        dic="" />' +
    '<STS_ERRFIELD        tip="err" msg="Campo não existe na entidade!"               dic="" />' +
    '<STS_REQFIELD        tip="err" msg="Valor do campo requerido!"                   dic="" />' +
    '<STS_SQLERROR        tip="err" msg="Comando SQL gerado com erro!"                dic="" />' +
    '<STS_SSLERROR        tip="err" msg="Não foi possível carregar a biblioteca SSL!" dic="" />' +

    '<STS_COMUNICACAO     tip="err" msg="Problema de comunicação!"                    dic="Tente novamente!" />' +

    '<STS_ECFERROR        tip="err" msg="Problema de comunicação com ECF!"            dic="Verifique se está ligada/conectada!" />' +
    '<STS_NFEERROR        tip="err" msg="Problema de comunicação com NFE!"            dic="" />' +
    '<STS_PAFERROR        tip="err" msg="Problema de comunicação com PAF!"            dic="" />' +
    '<STS_NFEERROR        tip="err" msg="Problema de comunicação com TEF!"            dic="" />' +

    '<STS_ACCESSVIOLATION tip="err" msg="" dic="" />' ;

var
  xStatus : Variant;

implementation

uses
  mFuncao, mConst, mItem, mXml;

//--

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoSts)) to Ord(High(TTipoSts)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoSts), I));
end;

function tip(pTip : String) : TTipoSts;
begin
  Result := TTipoSts(GetEnumValue(TypeInfo(TTipoSts), pTip));
  if ord(Result) = -1 then
    Result := STS_ERROR;
end;

function str(pTip : TTipoSts) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoSts), Integer(pTip));
end;

//--

function xml(pTip : TTipoSts) : String;
begin
  Result := itemX(str(pTip), cLST_STATUS);
end;

function typ(pTip : TTipoSts) : String;
begin
  Result := itemA('tip', xml(pTip));
end;

function msg(pTip : TTipoSts) : String;
begin
  Result := itemA('msg', xml(pTip));
end;

function dic(pTip : TTipoSts) : String;
begin
  Result := itemA('dic', xml(pTip));
end;

//--


function err(pTip : TTipoSts) : Boolean;
begin
  Result := itemA('tip', xml(pTip)) = 'err';
end;

//--

function cod(pTip : TTipoSts) : Integer;
begin
  Result := ord(pTip) * IffThenI(err(pTip), -1, 1);
end;

//--

function SetStatus(pStatus : Variant; pMsg, pMtd, pPar : String) : String;
const
  cSETSTATUS =
    '<status>{STS}</status>' +
    '<message>{MSG}</message>' +
    '<mtd>{MTD}</mtd>' +
    '<par>{PAR}</par>' ;
begin
  Result := cSETSTATUS;
  Result := AnsiReplaceStrV(Result, '{STS}', mTipoSts.cod(pStatus));
  Result := AnsiReplaceStrV(Result, '{MSG}', pMsg);
  Result := AnsiReplaceStrV(Result, '{MTD}', pMtd);
  Result := AnsiReplaceStrV(Result, '{PAR}', pPar);
end;

function SetStatus(pStatus : Variant) : String;
begin
  Result := SetStatus(pStatus, '', '', '');
end;

//--

procedure return(pStatus : Variant);
begin
  xStatus := pStatus;
end;

//--

function dica(pStatus : Variant) : String;
begin
  Result := mTipoSts.dic(TTipoSts(pStatus));
end;

function dicaConf(pStatus : Variant) : String;
var
  vMsg, vDica : String;
begin
  vMsg := mTipoSts.msg(TTipoSts(pStatus));
  vDica := mTipoSts.dic(TTipoSts(pStatus));
  Result := vMsg + IfThen(vDica<>'', #13 + vDica);
end;

//--

end.
