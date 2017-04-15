unit mDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StrUtils, ComCtrls, StdCtrls, ExtCtrls, DB, mTipoMensagem,
  mDialogIntf, mOrientacaoFrame, mFrame, mPanel, mGrade, mLabel, mTipoDialog,
  mButton, mCheckBox, mComboBox, mTextBox, mKeyValue, mTipoFormato, mValue;

type
  TmDialog = class(TForm, IDialog)
    LabelTitulo: TLabel;
    LabelMensagem: TLabel;
    PanelOpcao: TPanel;
    BevelSpace: TBevel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  protected
    procedure SetOpcao(AOpcao : Array Of TmTipoDialogOpcao);
    procedure BtnExecutarClick(Sender : TObject);
  public
    constructor Create(Aowner : TComponent); override;
    procedure Show(const Value : RTipoMensagem);
    function ShowDialog(const Value : RTipoMensagem; const Opcao : Array Of TmTipoDialogOpcao) : TmTipoDialogOpcao;
  published
  end;

  function Instance : TmDialog;

implementation

{$R *.dfm}

var
  _instance : TmDialog;

  function Instance : TmDialog;
  begin
    if not Assigned(_instance) then
      _instance := TmDialog.Create(nil);
    Result := _instance;
  end;

const
  TStatusMensagemTitulo : Array [TStatusMensagem] Of String = (
    'Alerta',
    'Aviso',
    'Confirmação',
    'Erro',
    'Informação',
    'Mensagem',
    'Sucesso');

{ TmDialog }

constructor TmDialog.Create(Aowner: TComponent);
begin
  inherited; //

end;

procedure TmDialog.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : Close;
  end;
end;

//--

  function GetOpcao(ATipo : TStatusMensagem) : TArrayOfTmTipoDialogOpcao;
  begin
    case ATipo of
      tsAlerta, tsAviso, tsErro, tsInformacao, tsMensagem, tsSucesso : begin
        SetLength(Result, 1);
        Result[0] := toFechar;
      end;
      tsConfirmacao : begin
        SetLength(Result, 2);
        Result[0] := toSim;
        Result[1] := toNao;
      end;
    end;
  end;

function TmDialog.ShowDialog(const Value : RTipoMensagem; const Opcao : Array Of TmTipoDialogOpcao) : TmTipoDialogOpcao;
begin
  with TmDialog.Create(nil) do begin
    try
      LabelTitulo.Caption := TStatusMensagemTitulo[Value.Status];
      LabelMensagem.Caption := Value.Mensagem + IfThen(Value.Dica <> '', sLineBreak) + Value.Dica;

      if Length(Opcao) > 0 then
        SetOpcao(Opcao)
      else
        SetOpcao(GetOpcao(Value.Status));

      Result := TmTipoDialogOpcao(Ord(ShowModal));
    finally
      Free;
    end;
  end;
end;

procedure TmDialog.Show(const Value: RTipoMensagem);
begin
  ShowDialog(Value, [toFechar]);
end;

procedure TmDialog.SetOpcao(AOpcao: Array Of TmTipoDialogOpcao);
const
  iLARGURA = 120;
var
  I, vLeft : Integer;
begin
  vLeft := (PanelOpcao.Width div 2) - ((Length(AOpcao) * iLARGURA) div 2);

  for I := 0 to High(AOpcao) do begin
    with TmButton.Create(Self) do begin
      Top := 0;
      Left := vLeft;
      Height := PanelOpcao.Height;
      Width := iLARGURA;
      Caption := TmTipoDialogOpcaoCaption[AOpcao[I]];
      Name := TmTipoDialogOpcaoName[AOpcao[I]];
      OnClick := BtnExecutarClick;
      Parent := PanelOpcao;
      ModalResult := TModalResult(AOpcao[I]);
    end;

    Inc(vLeft, iLARGURA);
  end;
end;

procedure TmDialog.BtnExecutarClick(Sender : TObject);
begin
  ModalResult := TmButton(Sender).ModalResult;
  Close;
end;

procedure Testar;
var
  vValue: RTipoMensagem;
begin
  vValue.Tipo := tmErroInformeOCodigo;
  vValue.Status := tsErro;
  vValue.Mensagem := 'Mensagem';
  Instance.Show(vValue);

  vValue.Tipo := tmErroInformeOCodigo;
  vValue.Status := tsConfirmacao;
  vValue.Mensagem := 'Mensagem';
  Instance.ShowDialog(vValue, []);
end;

initialization
  Testar();

end.