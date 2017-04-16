unit mDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StrUtils, ComCtrls, StdCtrls, ExtCtrls, DB, mTipoMensagem,
  mDialogIntf, mOrientacaoFrame, mFrame, mPanel, mGrade, mLabel, mTipoDialog,
  mButton, mCheckBox, mComboBox, mTextBox, mKeyValue, mTipoFormato, mValue;

type
  RStatusCor = record
    CorFonte : TColor;
    CorFundo : TColor;
  end;

  TmDialog = class(TForm, IDialog)
    LabelTitulo: TLabel;
    LabelMensagem: TLabel;
    PanelOpcao: TPanel;
    BevelSpace: TBevel;
    LabelDetalhar: TLabel;
    LabelSuporte: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LabelDetalharDblClick(Sender: TObject);
    procedure LabelSuporteClick(Sender: TObject);
  private
    fButtonList : TmButtonList;
    fStatusCor : RStatusCor;
    fOpcao : TmTipoDialogOpcao;
    fTipo: RTipoMensagem;
    procedure SetDialogCor(const Value: RStatusCor);
    procedure SetTipo(const Value: RTipoMensagem);
  protected
    procedure SetOpcao(AOpcao : Array Of TmTipoDialogOpcao);
    procedure BtnExecutarClick(Sender : TObject);
  public
    constructor Create(Aowner : TComponent); override;
    procedure Show(const ATipo : RTipoMensagem);
    function ShowDialog(const ATipo : RTipoMensagem; const AOpcao : Array Of TmTipoDialogOpcao) : TmTipoDialogOpcao;
  published
    property Tipo : RTipoMensagem read fTipo write SetTipo;
    property DialogCor : RStatusCor read fStatusCor write SetDialogCor;
    property Opcao : TmTipoDialogOpcao read fOpcao write fOpcao;
  end;

  function Instance : TmDialog;

implementation

{$R *.dfm}

uses
  mMensagem;

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

  TStatusMensagemCor : Array [TStatusMensagem] Of RStatusCor = (
    (CorFonte: clBlack; CorFundo: clYellow),  // 'Alerta',
    (CorFonte: clWhite; CorFundo: clBlue  ),  // 'Aviso',
    (CorFonte: clBlack; CorFundo: clYellow),  // 'Confirmação',
    (CorFonte: clWhite; CorFundo: clRed   ),  // 'Erro',
    (CorFonte: clBlack; CorFundo: clYellow),  // 'Informação',
    (CorFonte: clWhite; CorFundo: clGreen ),  // 'Mensagem',
    (CorFonte: clBlack; CorFundo: clWhite )); // 'Sucesso'

{ TmDialog }

constructor TmDialog.Create(Aowner: TComponent);
begin
  inherited; //

  fButtonList := TmButtonList.Create;

  mMensagem.Instance.Dialog := Self;
end;

procedure TmDialog.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : Close;
  end;
end;

procedure TmDialog.SetTipo(const Value: RTipoMensagem);
begin
  fTipo := Value;
  DialogCor := TStatusMensagemCor[Value.Status];
  LabelTitulo.Caption := TStatusMensagemTitulo[Value.Status];
  LabelMensagem.Caption := Value.Mensagem + IfThen(Value.Dica <> '', sLineBreak) + Value.Dica;
end;

procedure TmDialog.SetDialogCor(const Value: RStatusCor);
begin
  fStatusCor := Value;
  Color := fStatusCor.CorFundo;
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

function TmDialog.ShowDialog(const ATipo : RTipoMensagem; const AOpcao : Array Of TmTipoDialogOpcao) : TmTipoDialogOpcao;
begin
  Tipo := ATipo;

  if Length(AOpcao) > 0 then
    SetOpcao(AOpcao)
  else
    SetOpcao(GetOpcao(ATipo.Status));

  if ShowModal = mrOk then
    Result := Self.Opcao
  else
    Result := TmTipoDialogOpcao(Ord(-1));
end;

procedure TmDialog.Show(const ATipo: RTipoMensagem);
begin
  ShowDialog(ATipo, [toFechar]);
end;

procedure TmDialog.SetOpcao(AOpcao: Array Of TmTipoDialogOpcao);
const
  iLARGURA = 120;
var
  I, vLeft : Integer;
begin
  vLeft := (PanelOpcao.Width div 2) - ((Length(AOpcao) * iLARGURA) div 2);

  fButtonList.Clear;

  for I := 0 to High(AOpcao) do begin
    with fButtonList.Add do begin
      Left := vLeft;
      Height := PanelOpcao.Height;
      Width := iLARGURA;
      ParentFont := True;
      Font.Color := fStatusCor.CorFonte;
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
  Opcao := TmTipoDialogOpcao(TmButton(Sender).ModalResult);
  ModalResult := mrOk;
end;

procedure TmDialog.LabelDetalharDblClick(Sender: TObject);
begin
  //mVisualizar.Instance.ShowDialog(mLogger.Instance.Conteudo);
end;

procedure TmDialog.LabelSuporteClick(Sender: TObject);
begin
  //mSuporte.Instance.ShowDialog();
  // - mLoggerMem
  // - mLogger
  // - mImagemTela
  // - mImagemDialog
  // - mParametro
end;

procedure Testar;
begin
  if Instance.ShowDialog(GetTipoMensagemStr(tsConfirmacao, 'Continuar'),
      [toCancelar, toConfirmar]) = toConfirmar  then
    Instance.Show(GetTipoMensagemStr(tsMensagem, 'Confirmado'))
  else
    Instance.Show(GetTipoMensagemStr(tsErro, 'Cancelado'));
end;

initialization
  Testar();

end.