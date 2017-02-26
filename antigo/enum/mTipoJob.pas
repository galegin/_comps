unit mTipoJob; // mPagina / mReport

interface

uses
  Classes, SysUtils, StrUtils, TypInfo;

type
  //TipoJob
  TTipoJob = (A_CSV, A_EDI, A_XLS, A_HTM, A_PDF, A_TXT, A_XML,
              E_NOR, E_PDF, E_TXT, E_XML,
              W_IMP, W_TEL, W_VIS);

  //TipoJob
  function lst() : String;
  function tip(pTip : String) : TTipoJob;
  function str(pTip : TTipoJob) : String;

  function xml(pTip : TTipoJob) : String;
  function des(pTip : TTipoJob) : String;
  function ext(pTip : TTipoJob) : String;
  function fmt(pTip : TTipoJob) : String;
  function sai(pTip : TTipoJob) : String;

implementation

uses
  mFuncao, mItem, mXml;

const
  cLST_TPREPORT =
    '<A_CSV des="ARQUIVO CSV"                fmt="CSV" out="arq" />' +
    '<A_EDI des="ARQUIVO EDI"                fmt="EDI" out="arq" />' +
    '<A_XLS des="ARQUIVO EXCEL"              fmt="XLS" out="arq" />' +
    '<A_HTM des="ARQUIVO HTML"               fmt="HTM" out="arq" />' +
    '<A_PDF des="ARQUIVO PDF"                fmt="PDF" out="arq" />' +
    '<A_TXT des="ARQUIVO TEXTO"              fmt="TXT" out="arq" />' +
    '<A_XML des="ARQUIVO XML"                fmt="XML" out="arq" />' +

    '<E_NOR des="EMAIL"                      fmt="NOR" out="eml" />' +
    '<E_PDF des="EMAIL COM ANEXO PDF"        fmt="PDF" out="eml" />' +
    '<E_TXT des="EMAIL COM ANEXO TEXTO"      fmt="TXT" out="eml" />' +
    '<E_XML des="EMAIL COM ANEXO XML"        fmt="XML" out="eml" />' +

    '<W_IMP des="DIRETO PARA IMPRESSORA"     fmt="IMP" out="rel" />' +
    '<W_TEL des="VISUALIZAR EM TELA"         fmt="TEL" out="rel" />' +
    '<W_VIS des="SOMENTE VISUALIZAR EM TELA" fmt="VIS" out="rel" />' +
    '' ;

//TipoJob
function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoJob)) to Ord(High(TTipoJob)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoJob), I));
end;

function tip(pTip : String) : TTipoJob;
begin
  Result := TTipoJob(GetEnumValue(TypeInfo(TTipoJob), pTip));
  if (Ord(Result) = -1) then
    Result := W_TEL;
end;

function str(pTip : TTipoJob) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoJob), Integer(pTip));
end;

//Job
function xml(pTip : TTipoJob) : String;
begin
  Result := itemX(str(pTip), cLST_TPREPORT);
end;

//Job descricao
function des(pTip : TTipoJob) : String;
begin
  Result := itemA('des', xml(pTip));
end;

//Job estensao
function ext(pTip : TTipoJob) : String;
begin
  Result := LowerCase(itemA('fmt', xml(pTip)));
end;

//Job formato
function fmt(pTip : TTipoJob) : String;
begin
  Result := itemA('fmt', xml(pTip));
end;

//Job saida
function sai(pTip : TTipoJob) : String;
begin
  Result := itemA('out', xml(pTip));
end;

end.