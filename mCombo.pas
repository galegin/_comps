unit mCombo;

interface

uses
  SysUtils, Classes, Controls, StdCtrls,
  Windows, Messages, TypInfo,
  mStringList;

type
  TmCombo = class(TComboBox)
  private
    FLabel : TObject;
    FCampo : String;
    FLista : String;
    FMover : Boolean;
    function GetLista: String;
    procedure SetLista(const Value: String);
    function GetValue: String;
    procedure SetValue(const Value: String);
    function GetValueDs: String;
    procedure PosicaoLabel();
    function GetValueF: Real;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor create(AOwner: TComponent); overload; override;
    constructor create(AOwner : TComponent; AParent : TWinControl; pParams : String); overload;

    procedure Limpar;
    procedure Adicionar(pCod : String); overload;
    procedure Adicionar(pCod, pDes : String); overload;
    procedure AdicionarLst(pLst : String; pPad : String = '');
    procedure Retirar(pCod : String);

    function Pegar() : String;
    procedure Setar(const Value : String);
    function PegarObj() : TObject;
    procedure SetarObj(const Value : TObject);

    procedure _KeyPress(Sender : TObject; var Key: Char);
    procedure _KeyDown(Sender : TObject; var Key: Word; Shift: TShiftState);
  published
    property _Lista : String read GetLista write SetLista;
    property _Campo : String read FCampo write FCampo;
    property _Value : String read GetValue write SetValue;
    property _ValueF : Real read GetValueF;
    property _Label : TObject read FLabel write FLabel;
    property _Mover : Boolean read FMover write FMover;
    property _ValueDs : String read GetValueDs;
    //property _Values : TmVariant read FValues write FValues;
  end;

procedure Register;

implementation

uses
  mFuncao, mItem, mXml;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmCombo]);
end;

{ TmCombo }

constructor TmCombo.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  Style := csDropDownList;
  BevelKind := bkFlat;
  Sorted := True;
  OnKeyDown := _KeyDown;
  OnKeyPress := _KeyPress;
end;

constructor TmCombo.create(AOwner: TComponent; AParent : TWinControl; pParams: String);
begin
  create(AOwner);
  Parent := AParent;
  Name := 'Combo' + itemA('cod', pParams);
  Text := '';
  Font.Size := 10; //cTAM_FNT;
  _Campo := itemA('cod', pParams);
  _Lista := IfNull(itemA('cmb', pParams), itemA('lst', pParams));
  //_Mover := True;
  OnKeyDown := _KeyDown;
  OnKeyPress := _KeyPress;
end;

//--

function TmCombo.GetLista: String;
begin
  Result := TmStringList(Items).GetLista();
end;

procedure TmCombo.SetLista(const Value: String);
begin
  AdicionarLst(Value);
end;

//--

function TmCombo.GetValue: String;
begin
  Result := TmStringList(Items).getValueOf(ItemIndex);
end;

procedure TmCombo.SetValue(const Value: String);
begin
  if (Pos('=', _Lista) > 0) then begin
    if (Style = csDropDownList) then begin
      ItemIndex := TmStringList(Items).prcIndexOf(Value);
    end else begin
      Text := item(Value, _Lista);
    end;
  end else begin
    if (Style = csDropDownList) then begin
      ItemIndex := Items.IndexOf(Value);
    end else begin
      Text := Value;
    end;
  end;
end;

//--

function TmCombo.GetValueF: Real;
begin
  Result := StrToFloatDef(_Value, 0);
end;

//--

function TmCombo.GetValueDs: String;
begin
  Result := TmStringList(Items).GetValueDs(ItemIndex);
end;

//--

procedure TmCombo.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_MOVE = $F012;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (_Mover = False) then Exit;
  ReleaseCapture;
  Self.Perform(WM_SYSCOMMAND, SC_MOVE, 0);
  PosicaoLabel();
end;

//--

procedure TmCombo.PosicaoLabel();
begin
  Top := (Top div 4) * 4;
  Left := (Left div 4) * 4;
  if (FLabel <> nil) then begin
    with TWinControl(FLabel) do begin
      Top := Self.Top;
      Left := Self.Left - Width - 4;
    end;
  end;
end;

//--

procedure TmCombo.Limpar;
begin
  TmStringList(Items).Limpar();
end;

procedure TmCombo.Adicionar(pCod, pDes: String);
begin
  TmStringList(Items).Adicionar(pCod, pDes);
end;

procedure TmCombo.Adicionar(pCod: String);
begin
  TmStringList(Items).Adicionar(pCod);
end;

procedure TmCombo.AdicionarLst(pLst, pPad: String);
begin
  TmStringList(Items).AdicionarLst(pLst, pPad);
end;

procedure TmCombo.Retirar(pCod: String);
begin
  TmStringList(Items).Retirar(pCod);
end;

//--

function TmCombo.Pegar: String;
begin
  Result := Items[ItemIndex];
end;

procedure TmCombo.Setar(const Value : String);
begin
  ItemIndex := Items.IndexOf(Value);
end;

//--

function TmCombo.PegarObj: TObject;
begin
  Result := Items.Objects[ItemIndex];
end;

procedure TmCombo.SetarObj(const Value: TObject);
begin
  Items.AddObject(GetPropValue(Value, '_Cod'), Value);
end;

//--

procedure TmCombo._KeyPress(Sender : TObject; var Key: Char);
begin
  //
end;

procedure TmCombo._KeyDown(Sender : TObject; var Key: Word; Shift: TShiftState);
begin
  //Por motivo de a tecla F4 é padrão para consulta
  //Nesse caso não abrir o DROPDWON
  if (Key = VK_F4) then Key := 0;
  //
end;

end.
