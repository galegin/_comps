unit mCheckBox;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, StrUtils;

type
  TmCheckBox = class(TCheckBox)
  private
    FCampo : String;
    function GetValue: String;
    procedure SetValue(const Value: String);
  public
    constructor create(AOwner: TComponent); overload; override;
    constructor create(AOwner : TComponent; AParent : TWinControl; pParams : String); overload;
  published
    property _Campo : String read FCampo write FCampo;
    property _Value : String read GetValue write SetValue;
  end;

procedure Register;

implementation

uses
  mFuncao, mConst, mItem, mXml, mVar;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmCheckBox]);
end;

  function TmCheckBox.GetValue: String;
  begin
    Result := BoolToStr(Checked, True);
  end;

  procedure TmCheckBox.SetValue(const Value: String);
  begin
    Checked := IsStringTrue(Value);
  end;

{ TmCheckBox }

constructor TmCheckBox.create(AOwner: TComponent);
begin
  inherited create(AOwner);
end;

constructor TmCheckBox.create(AOwner: TComponent; AParent: TWinControl; pParams: String);
begin
  create(AOwner);
  Parent := AParent;
  Name := 'CheckBox' + itemA('cod', pParams);
  Caption := '';
  AutoSize := False;
  Height := cALT_EDT;
  Width := cALT_EDT;
  Font.Size := 16;
  _Campo := itemA('cod', pParams);
end;

end.