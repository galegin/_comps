unit mFormIntf;

interface

uses
  mControlIntf,
  mOrientacaoFrame,
  mFrame;

type
  IForm = interface(IControl)
    ['{FDB74BCC-E955-4CF9-9D8B-E6D95C55E1DD}']

    function AddFrame(
      AOrientacao : TOrientacaoFrame) : TmFrame;
  end;

implementation

end.
