unit mPanel;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, Graphics, Windows;

type
  TpFundo = (tpfNenhum, tpfImagem);

  TmPanel = class(TPanel)
  private
    FTpFundo : TpFundo;
  protected
    procedure PaintWindow(DC: HDC); override;
  public
    constructor create(Owner : TComponent); override;
  published
    property _TpFundo : TpFundo read FTpFundo write FTpFundo;
  end;

procedure Register;

implementation

//uses
//  mFormVal;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmPanel]);
end;

{ TmPanel }

constructor TmPanel.create(Owner: TComponent);
begin
  inherited; //
  FTpFundo := tpfNenhum;
end;

procedure TmPanel.PaintWindow(DC: HDC);
var
  vBitmap : Graphics.TBitmap;
begin
  inherited;

  if (FTpFundo = tpfNenhum) then
    Exit;

  // Do not remove this comment to keep transparancy

  //vBitmap := TmFormVal.GetImageFundo();

  Canvas.Handle := DC;
  Canvas.Brush.Color := clWhite;
  if (vBitmap <> nil) then
    Canvas.Brush.Bitmap := vBitmap;
  Canvas.FillRect(GetClientRect);
  Canvas.Handle := 0;
end;

end.