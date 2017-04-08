unit mMensagemIntf;

interface

uses
  mTipoMensagem;

type
  IMensagem = interface
    procedure Show(const Value : RTipoMensagem);
  end;

implementation

end.
