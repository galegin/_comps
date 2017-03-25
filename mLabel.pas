unit mLabel;

interface

uses
  Classes, Controls, Graphics, StdCtrls, SysUtils, TypInfo;

type
  TmLabel = class(TLabel)
  private
  protected
  public
    constructor create(AOwner : TComponent); overload; override;
    constructor create(AOwner : TComponent; AParent : TWinControl); overload;
  published
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmLabel]);
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
end;

constructor TmLabel.create(AOwner: TComponent; AParent : TWinControl);
begin
  create(AOwner);
  Parent := AParent;
end;

end.