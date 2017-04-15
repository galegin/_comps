unit mMensagem;

(* mMensagem *)

interface

uses
  Classes, SysUtils, StrUtils,
  mTipoMensagem, mDialogIntf;

type
  TmMensagem = class(TComponent)
  private
    fDialog : IDialog;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Mensagem(ATipoMensagem : RTipoMensagem);
  published
    property Dialog : IDialog read fDialog write fDialog;
  end;

  function Instance : TmMensagem;

implementation

var
  _instance : TmMensagem;

  function Instance : TmMensagem;
  begin
    if not Assigned(_instance) then
      _instance := TmMensagem.Create(nil);
    Result := _instance;
  end;

(* mMensagem *)

constructor TmMensagem.Create(AOwner : TComponent);
begin
  inherited;

end;

destructor TmMensagem.Destroy;
begin

  inherited;
end;

procedure TmMensagem.Mensagem(ATipoMensagem : RTipoMensagem);
begin
  if Assigned(fDialog) then
    fDialog.Show(ATipoMensagem);
end;

end.
