unit mComboBox;

interface

uses
  SysUtils, Classes, Controls, StdCtrls,
  Windows, Messages, TypInfo,
  mKeyValue;

type
  TmComboBox = class(TComboBox)
  private
    FLabel : TObject;
    FEntidade : TCollectionItem;
    FCampo : String;
    FMover : Boolean;
    FLista : TmKeyValueList;
    procedure SetLista(const Value: TmKeyValueList);
    function GetValue: TmKeyValue;
    procedure SetValue(const Value: TmKeyValue);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor create(AOwner: TComponent); overload; override;
    constructor create(AOwner : TComponent; AParent : TWinControl); overload;
    procedure ClrLista;
    procedure AddLista(const Value: TmKeyValue);
    procedure SetListaArray(const Value: Array Of TmKeyValue);
  published
    property _Label : TObject read FLabel write FLabel;
    property _Entidade : TCollectionItem read FEntidade write FEntidade;
    property _Campo : String read FCampo write FCampo;
    property _Lista : TmKeyValueList read FLista write SetLista;
    property _Mover : Boolean read FMover write FMover;
    property _Value : TmKeyValue read GetValue write SetValue;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmComboBox]);
end;

{ TmComboBox }

constructor TmComboBox.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  Style := csDropDownList;
  BevelKind := bkFlat;
  Sorted := True;
  FLista := TmKeyValueList.Create;
end;

constructor TmComboBox.create(AOwner: TComponent; AParent : TWinControl);
begin
  create(AOwner);
  Parent := AParent;
end;

//--

procedure TmComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_MOVE = $F012;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if not _Mover then
    Exit;

  ReleaseCapture;
  Self.Perform(WM_SYSCOMMAND, SC_MOVE, 0);
  //PosicaoLabel();
end;

procedure TmComboBox.KeyPress(var Key: Char);
begin
  //
end;

procedure TmComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  //Por motivo de a tecla F4 é padrão para consulta
  //Nesse caso não abrir o DROPDWON
  if (Key = VK_F4) then
    Key := 0;
  //
end;

//--

procedure TmComboBox.ClrLista;
begin
  FLista.Clear;
  Items.Clear;
end;

procedure TmComboBox.AddLista(const Value: TmKeyValue);
begin
  FLista.Add(Value);
  Items.AddObject(Value.Display, Value);
end;

//--

procedure TmComboBox.SetLista(const Value: TmKeyValueList);
var
  I : Integer;
begin
  ClrLista;
  with FLista do
    for I := 0 to Count - 1 do
      AddLista(Items[I]);
end;

procedure TmComboBox.SetListaArray(const Value: Array Of TmKeyValue);
var
  I : Integer;
begin
  ClrLista;
  with FLista do
    for I := 0 to High(Value) do
      AddLista(Value[I]);
end;

//--

function TmComboBox.GetValue: TmKeyValue;
begin
  Result := FLista.Items[ItemIndex];
end;

procedure TmComboBox.SetValue(const Value: TmKeyValue);
begin
  ItemIndex := FLista.IndexOf(Value);
end;

end.
