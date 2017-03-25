unit mTextBox;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, DB, Graphics, TypInfo, Messages, Forms,
  Windows, StrUtils, mTipoCampo, mProperty,
  mTipoFormatar, mFormatar, mValidar;

type
  TmTextBox = class(TEdit)
  private
    FAlignment : TAlignment;
    FLabel : TObject;
    FColorEnter : TColor;
    FColorExit : TColor;
    FCampo : TmProperty;
    FMover : Boolean;
    FTipoCampo : TTipoCampo;
    FTipoFormatar : TTipoFormatar;

    procedure Validar();

    procedure CMChanged(var Message: TMessage); message CM_CHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;

    procedure SetAlignment(const Value: TAlignment);
    procedure SetCampo(const Value: TmProperty);
    procedure SetTipoCampo(const Value: TTipoCampo);

    procedure PosicaoLabel();
    function GetValue: String;
    procedure SetValue(const Value: String);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor create(AOwner : TComponent); overload; override;
    constructor create(AOwner : TComponent; AParent : TWinControl); overload;
  published
    property _Alignment : TAlignment Read FAlignment Write SetAlignment Default taLeftJustify;
    property _Label : TObject read FLabel write FLabel;
    property _ColorEnter : TColor read FColorEnter write FColorEnter;
    property _ColorExit : TColor read FColorExit write FColorExit;
    property _Campo : TmProperty read FCampo write SetCampo;
    property _Value : String read GetValue write SetValue;
    property _Mover : Boolean read FMover write FMover;
    property _TipoCampo : TTipoCampo read FTipoCampo write SetTipoCampo;
    property _TipoFormatar : TTipoFormatar read FTipoFormatar write FTipoFormatar;
  end;

procedure Register;

implementation

uses
  mData, mFloat, mString;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmTextBox]);
end;

{ TmTextBox }

constructor TmTextBox.create(AOwner: TComponent);
begin
  inherited create(AOwner);

  FColorEnter := clYellow;
  FColorExit := clWhite;

  FTipoFormatar := TTipoFormatar(Ord(-1));

  AutoSize := False;
  Width := 129;
  Height := 24;
  BorderStyle := bsNone;
  Font.Size := 16;
end;

constructor TmTextBox.create(AOwner: TComponent; AParent : TWinControl);
begin
  create(AOwner);
  Parent := AParent;
end;

//--

procedure TmTextBox.Validar();
begin
  if (Text = '') then
    Exit;

  case FTipoFormatar of
    tfCnpj:
      if not TmValidar.Cnpj(Text) then
        raise Exception.Create('CNPJ invalida');
    tfCpf:
      if not TmValidar.Cpf(Text) then
        raise Exception.Create('CPF invalida');
    tfInscricao:
      if not TmValidar.Inscricao(Text) then
        raise Exception.Create('Inscricao invalida');

  else
    case FTipoCampo of
      tcDataHora:
        if TmData.GetDataHora(Text) = 0 then
          raise Exception.Create('Data invalida');
      tcNumero:
        if TmFloat.GetNumero(Text) = 0 then
          raise Exception.Create('Numero invalida');
      tcPercentual, tcQuantidade, tcValor:
        if TmFloat.GetValor(Text) = 0 then
          raise Exception.Create('Valor invalida');
    end;

  end;
end;

//--

procedure TmTextBox.CMChanged(var Message: TMessage);
begin
  if Parent <> nil then
    Parent.WindowProc(Message);
end;

procedure TmTextBox.CMEnter(var Message: TCMEnter);
begin
  if TabStop and not ReadOnly then
    Color := FColorEnter;

  if SysLocale.MiddleEast then
    if UseRightToLeftReading then begin
      if Application.BiDiKeyboard <> '' then
        LoadKeyboardLayout(PChar(Application.BiDiKeyboard), KLF_ACTIVATE);
    end else
      if Application.NonBiDiKeyboard <> '' then
        LoadKeyboardLayout(PChar(Application.NonBiDiKeyboard), KLF_ACTIVATE);

  SelectAll;

  DoEnter;
end;

procedure TmTextBox.CMExit(var Message: TCMExit);
begin
  if TabStop and not ReadOnly then
    Color := FColorExit;

  if (Text = '') then
    Exit;

  try
    Validar();

    case FTipoCampo of
      tcDataHora:
        Text := DateTimeToStr(TmData.GetDataHora(Text));
      tcNumero:
        Text := FloatToStr(TmFloat.GetNumero(Text));
      tcPercentual, tcQuantidade, tcValor:
        Text := FloatToStr(TmFloat.GetValor(Text));
    end;

  except
    on E : Exception do begin
      Text := '';
      SetFocus;
      raise;
    end;
  end;

  DoExit;
end;

procedure TmTextBox.KeyPress(var Key: Char);
var
  vLstDigitos : Set Of Char;
  vLstLetras : Set Of Char;
  vLstSimbolos : Set Of Char;
  vLstData : Set Of Char;
  vLstInteiro : Set Of Char;
  vLstNumero : Set Of Char;
  vLstTexto : Set Of Char;
  vLstEmail : Set Of Char;
  vLstSenha : Set Of Char;
  vLstSite : Set Of Char;
  vLstTecla : Set Of Char;
begin
  vLstDigitos := ['0'..'9'];
  vLstLetras := ['a'..'z', 'A'..'Z'];
  vLstSimbolos := ['.', ',', '!', '@', '#', '%', '$', '%', '&', '*', '(', ')',
    '[', ']', '{', '}', '_', '-', '+', '=', '/', '\', '?', '<', '>', ':', ' '];

  vLstData := vLstDigitos + ['/', ':', Chr(8)];
  vLstInteiro := vLstDigitos + [Chr(8)];
  vLstNumero := vLstDigitos + [',', Chr(8)];
  vLstTexto := vLstDigitos + vLstLetras + vLstSimbolos + [Chr(8)];
  vLstEmail := vLstDigitos + vLstLetras + ['@', '.', Chr(8)];
  vLstSenha := vLstDigitos + vLstLetras + ['!', '@', '#', '$', '%', '?', Chr(8)];
  vLstSite := vLstDigitos + vLstLetras + ['.', Chr(8)];

  vLstTecla := [];

  case FTipoFormatar of
    tfEmail:
      vLstTecla := vLstEmail;
    tfSenha:
      vLstTecla := vLstSenha;
    tfSite:
      vLstTecla := vLstSite;
  else
    case FTipoCampo of
      tcDataHora:
        vLstTecla := vLstData;
      tcNumero:
        vLstTecla := vLstInteiro;
      tcPercentual, tcQuantidade, tcValor:
        vLstTecla := vLstNumero;
      tcDescricao, tcNome:
        vLstTecla := vLstTexto;
    end;
  end;

  if vLstTecla <> [] then

  if not (Key in vLstTecla) then
    Key := #0;

  //DoKeyPress;
end;

procedure TmTextBox.SetValue(const Value: String);
begin
  Text := Value;
  if (Text = '') then
    Exit;

  case FTipoFormatar of
    tfCnpj, tfCpf, tfInscricao:
      Text := TmFormatar.Conteudo(FTipoFormatar, Value, '');
  else
    case FTipoCampo of
      tcDataHora:
        Text := FormatDateTime('dd/mm/yyyy', TmData.GetDataHora(Value));
      tcNumero:
        Text := FormatFloat('0', TmFloat.GetNumero(Value));
      tcPercentual, tcValor:
        Text := FormatFloat('0.00', TmFloat.GetValor(Value));
      tcQuantidade:
        Text := FormatFloat('0.000', TmFloat.GetValor(Value));
    end;
  end;
end;

function TmTextBox.GetValue(): String;
begin
  Result := Text;
  if (Result = '') then
    Exit;

  case FTipoFormatar of
    tfCnpj, tfCpf, tfInscricao:
      Result := TmFormatar.Remover(Text);
  else
    case FTipoCampo of
      tcDataHora:
        Result := FormatDateTime('dd/mm/yyyy', TmData.GetDataHora(Text));
      tcNumero:
        Result := FormatFloat('0', TmFloat.GetNumero(Text));
      tcPercentual, tcValor:
        Result := FormatFloat('0.00', TmFloat.GetValor(Text));
      tcQuantidade:
        Result := FormatFloat('0.000', TmFloat.GetValor(Text));
      tcDescricao, tcNome:
        Result := TmString.AllTrim(Text);
    end;
  end;
end;

procedure TmTextBox.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    if Handle <> 0 then
      Perform(CM_RECREATEWND, 0, 0);
  end;
end;

procedure TmTextBox.CreateParams(var Params: TCreateParams);
const
  Alignments: Array[TAlignment] of Cardinal = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style and (not 0) or (Alignments[FAlignment]);
end;

procedure TmTextBox.SetTipoCampo(const Value: TTipoCampo);
begin
  FTipoCampo := Value;

  case FTipoCampo of
    tcNumero, tcPercentual, tcQuantidade, tcValor:
      _Alignment := taRightJustify;
    tcDataHora:
      _Alignment := taCenter;
  end;
end;

procedure TmTextBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_MOVE = $F012;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if not _Mover then
    Exit;

  ReleaseCapture;
  Self.Perform(WM_SYSCOMMAND, SC_MOVE, 0);
  PosicaoLabel();
end;

procedure TmTextBox.PosicaoLabel();
begin
end;

procedure TmTextBox.SetCampo(const Value: TmProperty);
begin
  FCampo := Value;
end;

end.
