unit mEdit;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, DB, Graphics, TypInfo, Messages, Forms,
  Windows, StrUtils, mTipoFormatar, mFormatar, mTipoDado, mTipoEdit;

type
  TmEdit = class(TEdit)
  private
    FAlignment : TAlignment;
    FLabel : TObject;
    FDescr : TObject;
    FTipoDado : TTipoDado;
    FColorEnter : TColor;
    FColorExit : TColor;
    FCampo : String;
    FTam : Integer;
    FDec : Integer;
    FMover : Boolean;
    FFormat : String;
    FLstTeclas : String;
    FTipoEdit : TTipoEdit;
    FClasse : String;
    FTipoFormatar : TTipoFormatar;

    FNumSeq : String;

    FDefault : String;

    FonExit : TNotifyEvent;

    function desformatar(pText : String) : String;
    function formatar(pText : String) : String;
    function validar(pText : String) : Boolean;

    procedure CMChanged(var Message: TMessage); message CM_CHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetTipoDado(const Value: TTipoDado);
    procedure PosicaoLabel();
    procedure SetTipoEdit(const Value: TTipoEdit);
    function GetValue: String;
    procedure SetValue(const Value: String);
    function GetData: TDateTime;
    procedure SetData(const Value: TDateTime);
    function GetInteiro: Integer;
    procedure SetInteiro(const Value: Integer);
    function GetNumero: Real;
    procedure SetNumero(const Value: Real);
    function GetTrim: String;
    procedure SetCampo(const Value: String);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor create(AOwner : TComponent); overload; override;
    constructor create(AOwner : TComponent; AParent : TWinControl; pParams : String); overload;
    procedure SetarEditEnt();
    function getDia() : Real;
    function getMes() : Real;
    function getAno() : Real;
    function getFmt(pFmt : String) : String;
    function getNumber() : Real;
    function getDate() : TDateTime;
    function getExpr() : String;
  published
    property _Alignment : TAlignment Read FAlignment Write SetAlignment Default taLeftJustify;
    property _Label : TObject read FLabel write FLabel;
    property _Descr : TObject read FDescr write FDescr;
    property _TipoDado : TTipoDado read FTipoDado write SetTipoDado;
    property _ColorEnter : TColor read FColorEnter write FColorEnter;
    property _ColorExit : TColor read FColorExit write FColorExit;
    property _Tam : Integer read FTam write FTam;
    property _Dec : Integer read FDec write FDec;
    property _Campo : String read FCampo write SetCampo;
    property _Value : String read GetValue write SetValue;
    property _Mover : Boolean read FMover write FMover;
    property _Format : String read FFormat write FFormat;
    property _LstTeclas : String read FLstTeclas write FLstTeclas;
    property _TipoEdit : TTipoEdit read FTipoEdit write SetTipoEdit;
    property _Classe : String read FClasse write FClasse;
    property _TipoFormatar : TTipoFormatar read FTipoFormatar write FTipoFormatar;

    property _Data : TDateTime read GetData write SetData;
    property _Inteiro : Integer read GetInteiro write SetInteiro;
    property _Numero : Real read GetNumero write SetNumero;

    property _NumSeq : String read FNumSeq write FNumSeq;

    property _Default : String read FDefault write FDefault;

    property _Trim : String read GetTrim;

    property _onExit : TNotifyEvent read FonExit write FonExit;
  end;

procedure Register;

implementation

uses
  mMetadata, mMensagem, mValidar, mFuncao, //mCampo,
  mTipoMsg, mEstilo, mFont, mItem, mXml;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmEdit]);
end;

{ TmEdit }

constructor TmEdit.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FTipoDado := mTipoDado.ALFA;
  FColorEnter := clYellow;
  FColorExit := clWhite;
  FTipoEdit := mTipoEdit.EDICAO;
  FTipoFormatar := mTipoFormatar.NULO;

  AutoSize := False;
  Width := 129;
  Height := 24;
  BorderStyle := bsNone;
  Font.Size := 16;
end;

constructor TmEdit.create(AOwner: TComponent; AParent : TWinControl; pParams: String);
begin
  create(AOwner);
  Parent := AParent;
  Name := 'Edit' + itemA('cod', pParams);
  Text := '';
  CharCase := ecUpperCase;
  BorderStyle := bsNone;
  //Font.Size := cTAM_FNT;
  _Campo := itemA('cod', pParams);
  _TipoDado := mTipoDado.tip(itemA('tpd', pParams));
  _Tam := itemAI('tam', pParams);
  _Dec := itemAI('dec', pParams);
  _LstTeclas := itemA('lst_tecla', pParams);

  if (itemA('pwd', pParams) <> '') then
    PasswordChar := '*';

  if (itemA('fmt', pParams) <> '') then
    _TipoFormatar := mTipoFormatar.tip(itemA('fmt', pParams));

  if (itemA('chr', pParams) <> '') then
    //CharCase := GetTpCharCase(itemA('chr', pParams));
end;

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

  procedure getValueData();
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
  end;

begin
  if TabStop and not ReadOnly then begin
    Color := FColorExit;
  end;

  vTexto := GetValue();

  if (vTexto <> '') then begin
    vErro := '';

    if (FTipoFormatar = mTipoFormatar.NULO) then begin
      if (FTipoDado in [mTipoDado.DATAHORA]) then begin
        getValueData();

        if (StrToDateTimeDef(vTexto, -1) = -1) then
          vErro := mTipoMsg.str(mTipoMsg.DATE_INVALID);

      end else if (FTipoDado in [mTipoDado.NUMERO]) then begin
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
    FonExit(Self);

  DoExit;
end;

procedure TmEdit.KeyPress(var Key: Char);
var
  vLstTecla, vTecla : String;
  vKey : Boolean;
begin

  if (FTipoDado in [mTipoDado.DATAHORA]) then begin
    if not (Key in  ['0'..'9', '/', ':', Chr(8)]) then Key := #0;
  end else if (FTipoDado in [mTipoDado.NUMERO]) then begin
    if not (Key in  ['0'..'9', ',', Chr(8)]) then Key := #0;
  end else if (FTipoDado in [mTipoDado.INTEIRO]) then begin
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
  end;

  inherited; //
end;

procedure TmEdit.SetarEditEnt();
//var
//  vWidth : Integer;
begin
  //vWidth := TWinControl(Owner).Width;

  with TWinControl(_Descr) do begin
    Top := Self.Top;
    Left := Self.Left + Self.Width + 4;
    Height := Self.Height;

    //if ((Left + Width) > vWidth) then
	  //  Width := vWidth - Left - cREC_COL;
  end;
end;

procedure TmEdit.SetValue(const Value: String);
var
  vFormat : String;
begin
  Text := Value;

  if (Text = '') then
    Exit;

  if (FTipoFormatar = mTipoFormatar.NULO) then begin
    vFormat := IfNull(FFormat, FormatoCampo(FTipoDado, FTam, FDec));

    if (FTipoDado in [mTipoDado.DATAHORA]) and (FFormat <> '') then begin
      Text := FormatDateTime(vFormat, StrToDateTime(Text));
    end else if (FTipoDado in [mTipoDado.NUMERO]) then begin
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
    if (FTipoDado in [mTipoDado.DATAHORA]) then begin
      if (FFormat = 'mm/yyyy') then begin
        Result := '01/' + Result;
      end else if (FFormat = 'yyyy') then begin
        Result := '01/01/' + Result;
      end;

    end else if (FTipoDado in [mTipoDado.NUMERO]) then begin
      Result := AnsiReplaceStr(Result, '.', '');
      Result := FloatToStr(StrToFloatDef(Result,0));

    end else if (FTipoDado in [mTipoDado.ALFA]) then begin
      Result := AllTrim(Result);

    end;
  end;

  //if (PasswordChar <> #0) then
  //  Text := TmCripto.encrypt(Text, cCHAVE);

  Result := desformatar(Result);
end;

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

procedure TmEdit.SetTipoDado(const Value: TTipoDado);
begin
  FTipoDado := Value;

  if (FTipoDado in [mTipoDado.NUMERO]) then begin
    _Alignment := taRightJustify;
  end else if (FTipoDado in [mTipoDado.DATAHORA]) then begin
    _Alignment := taCenter;
  end;
end;

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
  Top := (Top div 4) * 4;
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
    end;
end;

function TmEdit.getDia() : Real;
begin
  Result := StrToFloatDef(FormatDateTime('dd', StrToDateTimeDef(_Value, 0)), 0);
end;

function TmEdit.getMes() : Real;
begin
  Result := StrToFloatDef(FormatDateTime('mm', StrToDateTimeDef(_Value, 0)), 0);
end;

function TmEdit.getAno() : Real;
begin
  Result := StrToFloatDef(FormatDateTime('yyyy', StrToDateTimeDef(_Value, 0)), 0);
end;

function TmEdit.getFmt(pFmt : String) : String;
begin
  Result := FormatDateTime(pFmt, StrToDateDef(_Value, Date));
end;

function TmEdit.getNumber() : Real;
begin
  Result := StrToFloatDef(_Value, 0);
end;

function TmEdit.getDate() : TDateTime;
begin
  Result := StrToDateTimeDef(_Value, 0);
end;

function TmEdit.getExpr() : String;
begin
  Result := AllTrim(Text);
  if (Result = '') then
    Exit;

  Result := '%' + AnsiReplaceStr(Result, ' ', '%') + '%';
end;

procedure TmEdit.SetTipoEdit(const Value: TTipoEdit);
var
  vFont : TmFont;
begin
  FTipoEdit := Value;

  if (csDesigning in ComponentState) then
    Exit;

  vFont := mTipoEdit.fnt(FTipoEdit);
  if vFont <> nil then begin
    Color := vFont._Cor;
    Font.Color := vFont._CorFnt;
  end;
end;

function TmEdit.desformatar(pText : String) : String;
begin
  Result := pText;
  if not (FTipoFormatar in [mTipoFormatar.NULO]) then
    Result := mFormatar.reti(FTipoFormatar, pText);
end;

function TmEdit.formatar(pText : String) : String;
begin
  Result := pText;
  if not (FTipoFormatar in [mTipoFormatar.NULO]) then
    Result := mFormatar.cont(FTipoFormatar, pText);
end;

function TmEdit.validar(pText : String) : Boolean;
begin
  Result := True;

  if (pText = '') then
    Exit;

  if (FTipoFormatar in [mTipoFormatar.CNPJ, mTipoFormatar.CPF]) then
    Result := mValidar.cnpjcpf(pText)
  else if (FTipoFormatar in [mTipoFormatar.INSC]) then
    Result := mValidar.inscricao(pText);

  if not Result then begin
    SetFocus;
    raise Exception.Create('Documento informado é invalido!');
  end;
end;

function TmEdit.GetData: TDateTime;
begin
  Result := StrToDateTimeDef(Text, 0);
end;

function TmEdit.GetInteiro: Integer;
var
  vText : String;
begin
  vText := AnsiReplaceStr(Text, '.', '');
  Result := StrToIntDef(vText, 0);
end;

function TmEdit.GetNumero: Real;
var
  vText : String;
begin
  vText := AnsiReplaceStr(Text, '.', '');
  Result := StrToFloatDef(vText, 0);
end;

procedure TmEdit.SetData(const Value: TDateTime);
begin
  if not (FTipoDado in [mTipoDado.DATAHORA]) then
    Exit;
  _Value := DateTimeToStr(Value);
end;

procedure TmEdit.SetInteiro(const Value: Integer);
begin
  if not (FTipoDado in [mTipoDado.INTEIRO]) then
    Exit;
  _Value := IntToStr(Value);
end;

procedure TmEdit.SetNumero(const Value: Real);
begin
  if not (FTipoDado in [mTipoDado.NUMERO]) then
    Exit;
  _Value := FloatToStr(Value);
end;

function TmEdit.GetTrim: String;
begin
  Result := AllTrim(Text);
end;

procedure TmEdit.SetCampo(const Value: String);
var
  vName : String;
begin
  FCampo := Value;

  if not (csDesigning in ComponentState) then
    Exit;

  if Pos('mEdit', Name) = 0 then
    Exit;

  if Pos('_', Value) = 0 then
    Exit;

  //vName := AtributoCampo(Value);
  if vName = '' then
    Exit;

  if (LowerCase(vName) <> LowerCase(Name)) then begin
    Name := vName;
    Text := '';
  end;
end;

end.
