unit mButton;

interface

uses
  Classes, Controls, Graphics, StdCtrls, SysUtils;

type
  TmButton = class(TButton)
  private
    FParams : String;
  protected
  public
    constructor create(AOwner : TComponent); overload; override; 
    constructor create(AOwner : TComponent; AParent : TWinControl); overload;
  published
    property _Params : String read FParams write FParams;
  end;

  TmButtonList = class(TList)
  private
    function GetItem(Index: Integer): TmButton;
    procedure SetItem(Index: Integer; const Value: TmButton);
  public
    function Add : TmButton; overload;
    procedure Clear; override;
    property Items[Index : Integer] : TmButton read GetItem write SetItem;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmButton]);
end;

{ TmButton }

constructor TmButton.create(AOwner: TComponent);
begin
  inherited; //
  Height := 24;
  Width := 129;
  Font.Size := 16;
end;

constructor TmButton.create(AOwner: TComponent; AParent: TWinControl);
begin
  create(AOwner);
  Parent := AParent;
end;

{ TmButtonList }

function TmButtonList.Add: TmButton;
begin
  Result := TmButton.create(nil);
  Self.Add(Result);
end;

procedure TmButtonList.Clear;
var
  I : Integer;
begin
  for I := Count - 1 downto 0 do
    TObject(Self[I]).Free;

  inherited;
end;

function TmButtonList.GetItem(Index: Integer): TmButton;
begin
  Result := TmButton(Self[Index]);
end;

procedure TmButtonList.SetItem(Index: Integer; const Value: TmButton);
begin
  Self[Index] := Value;
end;

end.