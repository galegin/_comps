unit mImageList;

interface

uses
  SysUtils, Classes, ImgList, Controls;

type
  TmImageList = class(TImageList)
  private
  protected
  public
  published
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmImageList]);
end;

end.