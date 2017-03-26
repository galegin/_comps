unit mCheckBox;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, StrUtils;

type
  TmCheckBox = class(TCheckBox)
  private
    FEntidade : TCollectionItem;
    FCampo : String;
    function GetValue: String;
    procedure SetValue(const Value: String);
  public
    constructor create(AOwner: TComponent); overload; override;
    constructor create(AOwner : TComponent; AParent : TWinControl); overload;
  published
    property _Entidade : TCollectionItem read FEntidade write FEntidade;
    property _Campo : String read FCampo write FCampo;
    property _Value : String read GetValue write SetValue;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmCheckBox]);
end;

  function TmCheckBox.GetValue: String;
  begin
    Result := IfThen(Checked, 'T', 'F');
  end;

  procedure TmCheckBox.SetValue(const Value: String);
  begin
    Checked := (Value = 'T');
  end;

{ TmCheckBox }

constructor TmCheckBox.create(AOwner: TComponent);
begin
  inherited create(AOwner);
end;

constructor TmCheckBox.create(AOwner: TComponent; AParent: TWinControl);
begin
  create(AOwner);
  Parent := AParent;
end;

end.