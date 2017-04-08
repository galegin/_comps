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

end.