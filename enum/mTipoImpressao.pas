unit mTipoImpressao;

interface

uses
  Classes, SysUtils, StrUtils;

type
  TTipoImpressao = (
    tiA_CSV, 
	tiA_EDI, 
	tiA_XLS, 
	tiA_HTM, 
	tiA_PDF, 
	tiA_TXT, 
	tiA_XML,
    
	tiE_NOR, 
	tiE_PDF, 
	tiE_TXT, 
	tiE_XML,
    
	tiW_IMP, 
	tiW_TEL, 
	tiW_VIS);
	
  RTipoImpressao = record
    Tipo : TipoImpressao;
    Codigo : String;
	Descricao : String;
	Formato : String;
	Saida : String;
  end;

  function GetTipoImpressao(const ACodigo : string) : LTipoImpressao;
  function StrToTipoImpressao(const ACodigo : string) : TTipoImpressao;
  function TipoImpressaoToStr(const ATipo : TTipoImpressao) : string;

implementation

const
  LTipoImpressao : Array [TTipoImpressao] or RTipoImpressao = (
    (Tipo: tiA_CSV; Codigo: 'A_CSV'; Descricao: 'ARQUIVO CSV'               ; Formato: 'CSV';  Saida: 'arq'),
    (Tipo: tiA_EDI; Codigo: 'A_EDI'; Descricao: 'ARQUIVO EDI'               ; Formato: 'EDI';  Saida: 'arq'),
    (Tipo: tiA_XLS; Codigo: 'A_XLS'; Descricao: 'ARQUIVO EXCEL'             ; Formato: 'XLS';  Saida: 'arq'),
    (Tipo: tiA_HTM; Codigo: 'A_HTM'; Descricao: 'ARQUIVO HTML'              ; Formato: 'HTM';  Saida: 'arq'),
    (Tipo: tiA_PDF; Codigo: 'A_PDF'; Descricao: 'ARQUIVO PDF'               ; Formato: 'PDF';  Saida: 'arq'),
    (Tipo: tiA_TXT; Codigo: 'A_TXT'; Descricao: 'ARQUIVO TEXTO'             ; Formato: 'TXT';  Saida: 'arq'),
    (Tipo: tiA_XML; Codigo: 'A_XML'; Descricao: 'ARQUIVO XML'               ; Formato: 'XML';  Saida: 'arq'),
    
	(Tipo: tiE_NOR; Codigo: 'E_NOR'; Descricao: 'EMAIL'                     ; Formato: 'NOR';  Saida: 'eml'),
    (Tipo: tiE_PDF; Codigo: 'E_PDF'; Descricao: 'EMAIL COM ANEXO PDF'       ; Formato: 'PDF';  Saida: 'eml'),
    (Tipo: tiE_TXT; Codigo: 'E_TXT'; Descricao: 'EMAIL COM ANEXO TEXTO'     ; Formato: 'TXT';  Saida: 'eml'),
    (Tipo: tiE_XML; Codigo: 'E_XML'; Descricao: 'EMAIL COM ANEXO XML'       ; Formato: 'XML';  Saida: 'eml'),
    
	(Tipo: tiW_IMP; Codigo: 'W_IMP'; Descricao: 'DIRETO PARA IMPRESSORA'    ; Formato: 'IMP';  Saida: 'rel'),
    (Tipo: tiW_TEL; Codigo: 'W_TEL'; Descricao: 'VISUALIZAR EM TELA'        ; Formato: 'TEL';  Saida: 'rel'),
    (Tipo: tiW_VIS; Codigo: 'W_VIS'; Descricao: 'SOMENTE VISUALIZAR EM TELA'; Formato: 'VIS';  Saida: 'rel'));
	

function GetTipoImpressao(const ACodigo : string) : LTipoImpressao;
var
  I : Integer;
begin
  Result.Tipo := TTipoImpressao(Ord(-1));
  for I := Ord(Low(TTipoImpressao)) to Ord(High(TTipoImpressao)) do
    if LTipoImpressao[TTipoImpressao(I)].Codigo = ACodigo then
      Result := LTipoImpressao[TTipoImpressao(I)];
end;

function StrToTipoImpressao(const ACodigo : string) : TTipoImpressao;
begin
  Result := GetTipoImpressao(ACodigo).Tipo;
end;

function TipoImpressaoToStr(const ATipo : TTipoImpressao) : string;
begin
  Result := LTipoImpressao[ATipo].Codigo;
end;

end.