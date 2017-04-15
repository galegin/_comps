unit mMensagemIntf;

interface

uses
  mTipoMensagem, mTipoDialog;

type
  IMensagem = interface
    procedure Show(const Value : RTipoMensagem);
    function ShowDialog(const Value : RTipoMensagem; const Opcao : Array Of TmTipoDialogOpcao) : TmTipoDialogOpcao;
  end;

implementation

end.