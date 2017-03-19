unit mEdit;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, DB, Graphics, TypInfo, Messages, Forms,
  Windows, StrUtils, mTipoFormatar, mFormatar, mTipoCampo, mProperty;

type
  TmEdit = class(TEdit)
  private
    FAlignment : TAlignment;
    FLabel : TObject;
    FColorEnter : TColor;
    FColorExit : TColor;
    FCampo : TmProperty;
    FMover : Boolean;
    FTipoFormatar : TTipoFormatar;

    function DesFormatar(pText : String) : String;
    function Formatar(pText : String) : String;
    function Validar(pText : String) : Boolean;

    procedure CMChanged(var Message: TMessage); message CM_CHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;

    procedure SetAlignment(const Value: TAlignment);
    procedure SetCampo(const Value: TmProperty);

    procedure PosicaoLabel();
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
    property _Mover : Boolean read FMover write FMover;
    property _TipoFormatar : TTipoFormatar read FTipoFormatar write FTipoFormatar;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmEdit]);
end;

{ TmEdit }

constructor TmEdit.create(AOwner: TComponent);
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

constructor TmEdit.create(AOwner: TComponent; AParent : TWinControl);
begin
  create(AOwner);
  Parent := AParent;
end;

//--

procedure TmEdit.CMChanged(var Message: TMessage);
begin
  if Parent <> nil then
    Parent.WindowProc(Message);
end;

procedure TmEdit.CMEnter(var Message: TCMEnter);
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

procedure TmEdit.CMExit(var Message: TCMExit);
var
  vTexto, vErro : String;

  (* procedure getValueData();
  var
    vText : String;
  begin
    if (Pos('/', Text) > 0) then Exit;
    vText := SoDigitos(Text);
    if (Length(vText) = 2) then begin
      vTexto := vText + '/' + FormatDateTime('mm/yyyy', Date);
    end else if (Length(vText) = 4) then begin
      vTexto := Copy(vText,1,2) + '/' + Copy(vText,3,2) + '/' + FormatDateTime('yyyy', Date);
    end else if (Length(vText) = 6) then begin
      vTexto := Copy(vText,1,2) + '/' + Copy(vText,3,2) + '/' + Copy(vText,5,2);
      vTexto := FormatDateTime('dd/mm/yyyy', StrToDate(vTexto));
    end;
  end; *)

begin
  (* if TabStop and not ReadOnly then
    Color := FColorExit;

  vTexto := GetValue();

  if (vTexto <> '') then begin
    vErro := '';

    if (FTipoFormatar = mTipoFormatar.NULO) then begin
      if (FTipoCampo in [mTipoCampo.DATAHORA]) then begin
        getValueData();

        if (StrToDateTimeDef(vTexto, -1) = -1) then
          vErro := mTipoMsg.str(mTipoMsg.DATE_INVALID);

      end else if (FTipoCampo in [mTipoCampo.NUMERO]) then begin
        if (StrToFloatDef(vTexto, -1) = -1) then
          vErro := mTipoMsg.str(mTipoMsg.NUMBER_INVALID);

      end;
    end;

    if (vErro <> '') then begin
      mMensagem.mensagem(vErro);
      Text := '';
      SetFocus;
      Abort;
    end;

    _Value := vTexto;
  end;

  validar(vTexto);

  //SetFiltro();

  if Assigned(FonExit) then
    FonExit(Self); *)

  DoExit;
end;

procedure TmEdit.KeyPress(var Key: Char);
var
  vLstTecla, vTecla : String;
  vKey : Boolean;
begin

  (* if (FTipoCampo in [mTipoCampo.DATAHORA]) then begin
    if not (Key in  ['0'..'9', '/', ':', Chr(8)]) then Key := #0;
  end else if (FTipoCampo in [mTipoCampo.NUMERO]) then begin
    if not (Key in  ['0'..'9', ',', Chr(8)]) then Key := #0;
  end else if (FTipoCampo in [mTipoCampo.INTEIRO]) then begin
    if not (Key in  ['0'..'9', Chr(8)]) then Key := #0;
  end else begin
    //vLstTecla := IfNull(FLstTeclas, '0..9|A..Z|a..z|,|(|)|[|]|{|}|_|chr(32)|') + 'chr(8)|';
    vLstTecla := IfNull(FLstTeclas, '0..9|A..Z|a..z|.|,|!|@|#|%|$|%|&|*|(|)|[|]|{|}|_|-|+|=|/|\|?|&lt;|&gt;|:|chr(32)|') + 'chr(8)|';
    vKey := False;

    if (FTipoFormatar = mTipoFormatar.EMAIL) then begin
      vLstTecla := vLstTecla + '@|.|';
    end else if (FTipoFormatar = mTipoFormatar.SENHA) then begin
      vLstTecla := vLstTecla + '!|@|#|$|%|?|';
    end else if (FTipoFormatar = mTipoFormatar.SITE) then begin
      vLstTecla := vLstTecla + '.|';
    end else if (FTipoFormatar = mTipoFormatar.NULO) then begin
      Exit;
    end;

    while vLstTecla <> '' do begin
      vTecla := getitem(vLstTecla);
      if vTecla = '' then Break;
      delitem(vLstTecla);

      vTecla := XMLToString(vTecla);

      if (vTecla = '0..9') then begin
        if (Key in  ['0'..'9']) then vKey := True;
      end else if (vTecla = 'A..Z') then begin
        if (Key in  ['A'..'Z']) then vKey := True;
      end else if (vTecla = 'a..z') then begin
        if (Key in  ['a'..'z']) then vKey := True;
      end else if (Pos('chr', vTecla) > 0) then begin
        vTecla := SoDigitos(vTecla);
        if (Ord(Key) = StrToIntDef(vTecla,0)) then vKey := True;
      end else if (Key = vTecla) then begin
        vKey := True;
      end;
    end;

    if not vKey then begin
      Key := #0;
    end;
  end; *)

  inherited; //
end;

(* procedure TmEdit.SetValue(const Value: String);
var
  vFormat : String;
begin
  Text := Value;

  if (Text = '') then
    Exit;

  if (FTipoFormatar = mTipoFormatar.NULO) then begin
    vFormat := IfNull(FFormat, FormatoCampo(FTipoCampo, FTam, FDec));

    if (FTipoCampo in [mTipoCampo.DATAHORA]) and (FFormat <> '') then begin
      Text := FormatDateTime(vFormat, StrToDateTime(Text));
    end else if (FTipoCampo in [mTipoCampo.NUMERO]) then begin
      Text := FormatFloat(vFormat, StrToFloat(Text));
    end;
  end;

  //if (PasswordChar <> #0) then
  //  Text := TmCripto.decrypt(Text, cCHAVE);

  Text := formatar(Text);
end;

function TmEdit.GetValue(): String;
begin
  Result := Text;

  if (Result = '') then Exit;

  if (FTipoFormatar = mTipoFormatar.NULO) then begin
    if (FTipoCampo in [mTipoCampo.DATAHORA]) then begin
      if (FFormat = 'mm/yyyy') then begin
        Result := '01/' + Result;
      end else if (FFormat = 'yyyy') then begin
        Result := '01/01/' + Result;
      end;

    end else if (FTipoCampo in [mTipoCampo.NUMERO]) then begin
      Result := AnsiReplaceStr(Result, '.', '');
      Result := FloatToStr(StrToFloatDef(Result,0));

    end else if (FTipoCampo in [mTipoCampo.ALFA]) then begin
      Result := AllTrim(Result);

    end;
  end;

  //if (PasswordChar <> #0) then
  //  Text := TmCripto.encrypt(Text, cCHAVE);

  Result := desformatar(Result);
end; *)

procedure TmEdit.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    if Handle <> 0 then
      Perform(CM_RECREATEWND, 0, 0);
  end;
end;

procedure TmEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: Array[TAlignment] of Cardinal = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style and (not 0) or (Alignments[FAlignment]);
end;

(* procedure TmEdit.SetTipoCampo(const Value: TTipoCampo);
begin
  FTipoCampo := Value;

  if (FTipoCampo in [mTipoCampo.NUMERO]) then begin
    _Alignment := taRightJustify;
  end else if (FTipoCampo in [mTipoCampo.DATAHORA]) then begin
    _Alignment := taCenter;
  end;
end; *)

procedure TmEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TmEdit.PosicaoLabel();
begin
  (* Top := (Top div 4) * 4;
  Left := (Left div 4) * 4;
  if FLabel <> nil then
    with TWinControl(FLabel) do begin
      Top := Self.Top;
      Left := Self.Left - Width - 4;
    end;
  if FDescr <> nil then
    with TWinControl(FDescr) do begin
      Top := Self.Top;
      Left := Self.Left + Self.Width + 4;
    end; *)
end;

function TmEdit.DesFormatar(pText : String) : String;
begin
  Result := pText;
  (* if not (FTipoFormatar in [mTipoFormatar.NULO]) then
    Result := mFormatar.reti(FTipoFormatar, pText); *)
end;

function TmEdit.Formatar(pText : String) : String;
begin
  Result := pText;
  (* if not (FTipoFormatar in [mTipoFormatar.NULO]) then
    Result := mFormatar.cont(FTipoFormatar, pText); *)
end;

function TmEdit.Validar(pText : String) : Boolean;
begin
  Result := True;

  if (pText = '') then
    Exit;

  (* if (FTipoFormatar in [mTipoFormatar.CNPJ, mTipoFormatar.CPF]) then
    Result := mValidar.cnpjcpf(pText)
  else if (FTipoFormatar in [mTipoFormatar.INSC]) then
    Result := mValidar.inscricao(pText); *)

  if not Result then begin
    SetFocus;
    raise Exception.Create('Documento informado é invalido!');
  end;
end;

procedure TmEdit.SetCampo(const Value: TmProperty);
begin
  FCampo := Value;
end;

end.
