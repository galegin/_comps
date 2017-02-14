unit mImage;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls;

type
  TmImage = class(TImage)
  private
  protected
  public
  published
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmImage]);
end;

end.