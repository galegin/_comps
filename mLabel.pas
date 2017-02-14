unit mLabel;

interface

uses
  Classes, Controls, Graphics, StdCtrls, SysUtils, TypInfo,
  mTipoLabelButton, mTipoLabel;

type
  TmLabel = class(TLabel)
  private
    FTpLabel: TTipoLabel;
    FEdit : TEdit;
    procedure SetTpLabel(const Value: TTipoLabel);
  protected
    procedure SetName(const Value: TComponentName); override;
  public
    constructor create(AOwner : TComponent); overload; override;
    constructor create(AOwner : TComponent; AParent : TWinControl; pParams : String); overload;
  published
    property _TpLabel : TTipoLabel read FTpLabel write SetTpLabel;
    property _Edit : TEdit read FEdit write FEdit;
  end;

  TmLabelColor = class(TmLabel)
  protected
    FItem : String;
    FLista : String;
    FListaCor : String;
    FListaCorFnt : String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Setar(pItem: String);
    function Pegar: String;
    function PegarDs() : String;
  published
    property _Lista : String read FLista write FLista;
    property _ListaCor : String read FListaCor write FListaCor;
    property _ListaCorFnt : String read FListaCorFnt write FListaCorFnt;
  end;

  TmLabelButton = class(TmLabel)
  private
    procedure SetTpLabelButton(const Value: TTipoLabelButton);
    procedure SetValue(const Value: String);
  protected
    FTpLabelButton : TTipoLabelButton;
    FValue : String;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property _TpLabelButton : TTipoLabelButton read FTpLabelButton write SetTpLabelButton;
    property _Value : String read FValue write SetValue;
  end;

procedure Register;

implementation

uses
  mDescr, mFont, mItem, mXml;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmLabel]);
  RegisterComponents('Comps MIGUEL', [TmLabelColor]);
  RegisterComponents('Comps MIGUEL', [TmLabelButton]);
end;

{ TmLabel }

constructor TmLabel.create(AOwner : TComponent);
begin
  inherited create(AOwner);
  AutoSize := False;
  Height := 24;
  Width := 129;
  Alignment := taCenter;
  Font.Size := 16;
  Layout := tlCenter;
  _TpLabel := mTipoLabel.ROTULO;
end;

constructor TmLabel.create(AOwner: TComponent; AParent : TWinControl; pParams: String);
begin
  create(AOwner);
  Alignment := taCenter;
  Layout := tlCenter;
  Parent := AParent;
  Name := 'Label' + itemA('cod', pParams);
  Caption := TmDescr.TraduzCampo(itemA('des', pParams));
  //Font.Size := cTAM_FNT;
  if Pos(itemA('tpf', pParams), 'key|req') > 0 then
    Caption := Caption + ' (*)';
end;

procedure TmLabel.SetName(const Value: TComponentName);
begin
  inherited; //
  if (Pos('_', Value) > 0) then begin
    Caption := Copy(Value, Pos('_', Value) + 1, Length(Value));
    Caption := TmDescr.TraduzCampo(Caption);
  end;
end;

procedure TmLabel.SetTpLabel(const Value: TTipoLabel);
var
  vFont : TmFont;
begin
  FTpLabel := Value;

  if (csDesigning in ComponentState) then
    Exit;

  if (FTpLabel = mTipoLabel.BOTAO) then
    Cursor := crHandPoint;

  vFont := mTipoLabel.fnt(FTpLabel);
  if (vFont <> nil) then begin
    Color := vFont._Cor;
    Font.Color := vFont._CorFnt;
  end;
end;

{ TcLabelColor }

constructor TmLabelColor.Create(AOwner: TComponent);
begin
  inherited;
  Transparent := False;
end;

procedure TmLabelColor.Setar(pItem : String);
begin
  FItem := pItem;
  Caption := item(pItem, FLista);
  Color := StringToColor(item(pItem, FListaCor));
  Font.Color := StringToColor(item(pItem, FListaCorFnt));
end;

function TmLabelColor.Pegar() : String;
begin
  Result := FItem;
end;

function TmLabelColor.PegarDs() : String;
begin
  Result := Caption;
end;

{ TmLabelButton }

constructor TmLabelButton.Create(AOwner: TComponent);
begin
  inherited;
  _TpLabelButton := mTipoLabelButton.ROTULO;
  Alignment := taCenter;
  AutoSize := False;
  Font.Size := 16;
  Layout := tlCenter;
  Transparent := False;
  Height := 33;
  Width := 129;
end;

procedure TmLabelButton.SetTpLabelButton(const Value: TTipoLabelButton);
var
  vFont : TmFont;
begin
  FTpLabelButton := Value;
  vFont := mTipoLabelButton.fnt(Value);
  Color := vFont._Cor;
  Font.Color := vFont._CorFnt;
  if FTpLabelButton in [mTipoLabelButton.ROTULO] then
    Cursor := crHandPoint;
end;

procedure TmLabelButton.SetValue(const Value: String);
begin
  FValue := Value;
  Caption := Value;
end;

end.