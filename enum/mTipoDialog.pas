unit mTipoDialog;

interface

uses
  Classes, SysUtils, StrUtils;
  
type
  TmTipoDialog = (
    tdConfirmacao,
    tdInformacao);
    
  TmTipoDialogOpcao = (
    toConfirmar,
    toCancelar,
    toNao,
    toSim,
    toFechar);

  TArrayOfTmTipoDialogOpcao = Array Of TmTipoDialogOpcao;

const  
  TmTipoDialogOpcaoCaption : Array [TmTipoDialogOpcao] Of String = (
    'Confirmar',
    'Cancelar',
    'Nao',
    'Sim',
    'Fechar');
    
  TmTipoDialogOpcaoName : Array [TmTipoDialogOpcao] Of String = (
    'BtnConfirmar',
    'BtnCancelar',
    'BtnNao',
    'BtnSim',
    'BtnFechar');    

implementation

end.