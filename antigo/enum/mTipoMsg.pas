unit mTipoMsg;

interface

uses
  Classes, SysUtils, TypInfo;

type
  TTipoMsg = (
    NENHUMA              ,

    FINALIZAR_PROGRAMA   ,
    FINALIZAR_PAGAMENTO  ,
    FINALIZAR_SISTEMA    ,
    FINALIZADA_VENDA     ,

    ALTERACAO_PENDENTE   ,
    MESSAGE_OBRIGATORIO  ,
    PRODUTO_NOTFOUND     ,
    NUMBER_INVALID       ,
    DATE_INVALID         ,

    CONFIRM_ABERTURA     ,
    CONFIRM_ALTERACAO    ,
    CONFIRM_BACKUP       ,
    CONFIRM_BAIXAR_FTP   ,
    CONFIRM_BLOQUEADO    ,
    CONFIRM_CANCELAMENTO ,
    CONFIRM_CARREGAMENTO ,
    CONFIRM_COMANDO      ,
    CONFIRM_CONSULTA     ,
    CONFIRM_CONTAGEM     ,
    CONFIRM_EMAIL        ,
    CONFIRM_ESTOQUE      ,
    CONFIRM_EXCLUSAO     ,
    CONFIRM_EXPORTACAO   ,
    CONFIRM_FECHTO       ,
    CONFIRM_FINALIZAR    ,
    CONFIRM_GERACAO      ,
    CONFIRM_GRAVACAO     ,
    CONFIRM_IGNORAR      ,
    CONFIRM_IMPORTACAO   ,
    CONFIRM_IMPRESSAO    ,
    CONFIRM_LANCTO       ,
    CONFIRM_LIBERACAO    ,
    CONFIRM_LIMPEZA      ,
    CONFIRM_PADRAO       ,
    CONFIRM_PUBLIC_FTP   ,
    CONFIRM_SUPRIMENTO   ,
    CONFIRM_RESTORE      ,
    CONFIRM_RETIRADA     ,
    CONFIRM_VALIDACAO    ,
    CONFIRM_VISUALIZAR   ,

    AGUARDE_CARREGANDO   ,
    AGUARDE_CANCELANDO   ,
    AGUARDE_CONSULTANDO  ,
    AGUARDE_LISTANDO     ,
    AGUARDE_PROCESSANDO  ,
    AGUARDE_VENDA        ,

    MESSAGE_ABERTURA     ,
    MESSAGE_ALTERACAO    ,
    MESSAGE_BACKUP       ,
    MESSAGE_BAIXAR_FTP   ,
    MESSAGE_BLOQUEADO    ,
    MESSAGE_CANCELADA    ,
    MESSAGE_CANCELAMENTO ,
    MESSAGE_CARREGAMENTO ,
    MESSAGE_COMANDO      ,
    MESSAGE_CONSULTA     ,
    MESSAGE_CONTAGEM     ,
    MESSAGE_DESCONTO     ,
    MESSAGE_EMAIL        ,
    MESSAGE_ESTOQUE      ,
    MESSAGE_EXCLUSAO     ,
    MESSAGE_EXPORTACAO   ,
    MESSAGE_FECHTO       ,
    MESSAGE_FINALIZADO   ,
    MESSAGE_GERACAO      ,
    MESSAGE_GRAVACAO     ,
    MESSAGE_IGNORAR      ,
    MESSAGE_IMPORTACAO   ,
    MESSAGE_IMPRESSAO    ,
    MESSAGE_LANCTO       ,
    MESSAGE_LIBERACAO    ,
    MESSAGE_LIMPEZA      ,
    MESSAGE_NOTFOUND     ,
    MESSAGE_PADRAO       ,
    MESSAGE_PARAM        ,
    MESSAGE_PUBLIC_FTP   ,
    MESSAGE_SUPRIMENTO   ,
    MESSAGE_RESTORE      ,
    MESSAGE_RETIRADA     ,
    MESSAGE_VALIDACAO    ,

    ECF_INSTALADA        ,
    ECF_TESTADA          ,

    PDF_GERANDO          ,

    CAPTCHA_CARREGANDO   ,

    USUARIO_SEM_PERMISSAO);

  function lst() : String;
  function tip(pTip : String) : TTipoMsg;
  function str(pTip : TTipoMsg) : String;

  function xml(pTip : TTipoMsg) : String;
  function msg(pTip : TTipoMsg) : String;

implementation

uses
  mItem, mXml;

const
  cLST_MESSAGE =
    '<NENHUMA               msg="" />' +

    '<FINALIZAR_PROGRAMA    msg="Alteração pendente! Finalizar programa?" />' +
    '<FINALIZAR_SISTEMA     msg="Finalizar sistema?" />' +
    '<FINALIZAR_PAGAMENTO   msg="Finalizando pagamento" />' +
    '<FINALIZADA_VENDA      msg="Venda finalizada com sucesso" />' +

    '<ALTERACAO_PENDENTE    msg="Alteração pendente! Continuar?" />' +
    '<MESSAGE_OBRIGATORIO   msg="O campo "%s" deve ser informado" />' +
    '<PRODUTO_NOTFOUND      msg="Produto nao cadastrado" />' +
    '<NUMBER_INVALID        msg="Valor invalido" />' +
    '<DATE_INVALID          msg="Data invalida" />' +

    '<CONFIRM_ABERTURA      msg="Confirma abertura?" />' +
    '<CONFIRM_ALTERACAO     msg="Confirma alteracao?" />' +
    '<CONFIRM_BACKUP        msg="Confirma backup?" />' +
    '<CONFIRM_BAIXAR_FTP    msg="Confirma baixar do FTP?" />' +
    '<CONFIRM_BLOQUEADO     msg="Confirma bloqueio?" />' +
    '<CONFIRM_CANCELAMENTO  msg="Confirma cancelamento?" />' +
    '<CONFIRM_CARREGAMENTO  msg="Confirma carregamento?" />' +
    '<CONFIRM_COMANDO       msg="Confirma comando?" />' +
    '<CONFIRM_CONSULTA      msg="Confirma consulta?" />' +
    '<CONFIRM_CONTAGEM      msg="Confirma contagem?" />' +
    '<CONFIRM_EMAIL         msg="Confirma envio email?" />' +
    '<CONFIRM_ESTOQUE       msg="Confirma estoque?" />' +
    '<CONFIRM_EXCLUSAO      msg="Confirma exclusao?" />' +
    '<CONFIRM_EXPORTACAO    msg="Confirma exportacao?" />' +
    '<CONFIRM_FECHTO        msg="Confirma fechamento?" />' +
    '<CONFIRM_FINALIZAR     msg="Confirma finalizar?" />' +
    '<CONFIRM_GERACAO       msg="Confirma geracao?" />' +
    '<CONFIRM_GRAVACAO      msg="Confirma gravacao?" />' +
    '<CONFIRM_IGNORAR       msg="Confirma ignorar?" />' +
    '<CONFIRM_IMPORTACAO    msg="Confirma importacao?" />' +
    '<CONFIRM_IMPRESSAO     msg="Confirma impressao?" />' +
    '<CONFIRM_LANCTO        msg="Confirma lancamento?" />' +
    '<CONFIRM_LIBERACAO     msg="Confirma liberacao?" />' +
    '<CONFIRM_LIMPEZA       msg="Confirma limpeza?" />' +
    '<CONFIRM_PADRAO        msg="Confirma valor padrao?" />' +
    '<CONFIRM_PUBLIC_FTP    msg="Confirma publicar no FTP?" />' +
    '<CONFIRM_SUPRIMENTO    msg="Confirma suprimento?" />' +
    '<CONFIRM_RESTORE       msg="Confirma restore?" />' +
    '<CONFIRM_RETIRADA      msg="Confirma retirada?" />' +
    '<CONFIRM_VALIDACAO     msg="Confirma validacao?" />' +
    '<CONFIRM_VISUALIZAR    msg="Confirma visualizar?" />' +

    '<AGUARDE_CARREGANDO    msg="Carregando... aguarde..." />' +
    '<AGUARDE_CANCELANDO    msg="Cancelando... aguarde..." />' +
    '<AGUARDE_CONSULTANDO   msg="Consultando... aguarde..." />' +
    '<AGUARDE_LISTANDO      msg="Listando... aguarde..." />' +
    '<AGUARDE_PROCESSANDO   msg="Processando... aguarde..." />' +
    '<AGUARDE_VENDA         msg="Iniciando venda... aguarde..." />' +

    '<MESSAGE_ABERTURA      msg="Abertura efetuada com sucesso" />' +
    '<MESSAGE_ALTERACAO     msg="Alteracao efetuada com sucesso" />' +
    '<MESSAGE_BACKUP        msg="Backup efetuado com sucesso" />' +
    '<MESSAGE_BAIXAR_FTP    msg="Baixa FTP efetuada com sucesso" />' +
    '<MESSAGE_BLOQUEADO     msg="Bloqueado com sucesso" />' +
    '<MESSAGE_CANCELADA     msg="Operacao cancelada" />' +
    '<MESSAGE_CANCELAMENTO  msg="Cancelamento efetuado com sucesso" />' +
    '<MESSAGE_CARREGAMENTO  msg="Carregamento efetuado com sucesso" />' +
    '<MESSAGE_COMANDO       msg="Comando executado com sucesso" />' +
    '<MESSAGE_CONSULTA      msg="Consulta efetuada com sucesso" />' +
    '<MESSAGE_CONTAGEM      msg="Contagem efetuada com sucesso" />' +
    '<MESSAGE_DESCONTO      msg="Desconto efetuado com sucesso" />' +
    '<MESSAGE_EMAIL         msg="Emial enviado com sucesso" />' +
    '<MESSAGE_ESTOQUE       msg="Estoque gravado com sucesso" />' +
    '<MESSAGE_EXCLUSAO      msg="Exclusao efetuada com sucesso" />' +
    '<MESSAGE_EXPORTACAO    msg="Exportacao efetuada com sucesso" />' +
    '<MESSAGE_FECHTO        msg="Fechamento efetuado com sucesso" />' +
    '<MESSAGE_FINALIZADO    msg="Finalizacao efetuada com sucesso" />' +
    '<MESSAGE_GERACAO       msg="Geracao efetuada com sucesso" />' +
    '<MESSAGE_GRAVACAO      msg="Gravacao efetuada com sucesso" />' +
    '<MESSAGE_IGNORAR       msg="Ignorar efetuado com sucesso" />' +
    '<MESSAGE_IMPORTACAO    msg="Importacao efetuado com sucesso" />' +
    '<MESSAGE_IMPRESSAO     msg="Impressao efetuada com sucesso" />' +
    '<MESSAGE_LANCTO        msg="Lancamento efetuado com sucesso" />' +
    '<MESSAGE_LIBERACAO     msg="Liberacao efetuada com sucesso" />' +
    '<MESSAGE_LIMPEZA       msg="Limpeza efetuada com sucesso" />' +
    '<MESSAGE_NOTFOUND      msg="Nenhum registro encontrado" />' +
    '<MESSAGE_PADRAO        msg="Valor padrao gravado com sucesso" />' +
    '<MESSAGE_PARAM         msg="Parametro nao informado" />' +
    '<MESSAGE_PUBLIC_FTP    msg="Publicacao FTP efetuada com sucesso" />' +
    '<MESSAGE_SUPRIMENTO    msg="Suprimento efetuado com sucesso" />' +
    '<MESSAGE_RESTORE       msg="Restore efetuado com sucesso" />' +
    '<MESSAGE_RETIRADA      msg="Retirada efetuada com sucessoa" />' +
    '<MESSAGE_VALIDACAO     msg="Validacao efetuada com sucesso" />' +

    '<ECF_INSTALADA         msg="ECF instalada com sucesso" />' +
    '<ECF_TESTADA           msg="ECF testada com sucesso" />' +

    '<PDF_GERANDO           msg="Gerando PDF... aguarde..." />' +

    '<CAPTCHA_CARREGANDO    msg="Carregando captcha... aguarde..." />' +

    '<USUARIO_SEM_PERMISSAO msg="Usuario sem permissao" />' ;

function lst() : String;
var
  I : Integer;
begin
  Result := '';
  for I:=Ord(Low(TTipoMsg)) to Ord(High(TTipoMsg)) do
    putitem(Result, GetEnumName(TypeInfo(TTipoMsg), I));
end;

function tip(pTip : String) : TTipoMsg;
begin
  Result := TTipoMsg(GetEnumValue(TypeInfo(TTipoMsg), pTip));
  if ord(Result) = -1 then
    Result := NENHUMA;
end;

function str(pTip : TTipoMsg) : String;
begin
  Result := GetEnumName(TypeInfo(TTipoMsg), Integer(pTip));
end;

function xml(pTip : TTipoMsg) : String;
begin
  Result := itemX(str(pTip), cLST_MESSAGE);
end;

function msg(pTip : TTipoMsg) : String;
begin
  Result := itemA('msg', xml(pTip));
end;

end.