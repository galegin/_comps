unit mMensagemIntf;

interface

uses
  mTipoMensagem, mTipoDialog;

type
  IMensagem = interface
    procedure Show(const ATipo : RTipoMensagem);
    function ShowDialog(const ATipo : RTipoMensagem; const AOpcao : Array Of TmTipoDialogOpcao) : TmTipoDialogOpcao;
  end;

implementation

end.