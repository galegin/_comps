unit mSpeedButton;

interface

uses
  SysUtils, Classes, Controls, Buttons;

type
  TmSpeedButton = class(TSpeedButton)
  private
  protected
  public
  published
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmSpeedButton]);
end;

end.