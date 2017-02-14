unit mScrollBox;

interface

uses
  SysUtils, Classes, Controls,
  Forms, Windows, Graphics;

type
  TmScrollBox = class(TScrollBox)
    procedure CreateParams(var Params: TCreateParams); override;
    procedure PaintWindow(DC: HDC); override;
  private
    FDrow: Boolean;
    FCanvas: TControlCanvas;
    function GetCanvas: TCanvas;
  protected
  public
    constructor Create(AOwner:TComponent); override;
  published
    property _Drow : Boolean read FDrow write FDrow;
    property _Canvas : TCanvas read GetCanvas;
  end;

procedure Register;

implementation

uses
  mControl;

  function TmScrollBox.GetCanvas: TCanvas;
  begin
    Result := FCanvas;
  end;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmScrollBox]);
end;

constructor TmScrollBox.Create(AOwner: TComponent);
begin
  inherited;
  //Brush.Style := bsClear;
  FCanvas := TControlCanvas.Create();
end;

procedure TmScrollBox.CreateParams(var Params: TCreateParams);
begin
  inherited;
  //Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT or WS_EX_COMPOSITED;
end;

procedure TmScrollBox.PaintWindow(DC: HDC);
var
  vBitmap : TBitmap;
begin
  inherited;

  if not _Drow then
    Exit; 

  // Do not remove this comment to keep transparancy

  vBitmap := mControl.GetImageFundo();

  FCanvas.Handle := DC;
  FCanvas.Control := Self;
  FCanvas.Brush.Color := clWhite;
  if (vBitmap <> nil) then
    FCanvas.Brush.Bitmap := vBitmap;
  FCanvas.FillRect(GetClientRect);
  FCanvas.Handle := 0;
end;

end.
