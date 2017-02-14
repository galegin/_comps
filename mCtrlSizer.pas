unit mCtrlSizer;

interface

uses
 Classes, Windows, Messages, Controls, StdCtrls;

type
  TCtrlSizer = class (TCustomControl)
  private
    FControl: TControl;
    {FControl is set to the TLabel that will be moved and sized by this}
    FRectAry: array [1..8] of TRect;
    FPosAry: array [1..8] of Integer;
  public
     constructor Create (AOwner: TComponent; AControl: TControl);
     procedure CreateParams (var Params: TCreateParams); override;
     procedure NcHitTest (var Msg: TWmNcHitTest); message WM_NCHITTEST;
     procedure WmSize (var Msg: TWmSize); message WM_SIZE;
     procedure LButtonDown (var Msg: TWmLButtonDown); message WM_LBUTTONDOWN;
     procedure WmMove (var Msg: TWmMove); message WM_MOVE;
     procedure Paint; override;
  end;

implementation

uses
  Forms, Graphics;

constructor TCtrlSizer.Create(AOwner: TComponent; AControl: TControl);
var
  Rec: TRect;
begin
  inherited Create (AOwner);

  FControl := AControl;

  // set the size and position
  Rec := FControl.BoundsRect;
  InflateRect (Rec, 3, 3);
  BoundsRect := Rec;

  // set the parent to FControl parent
  Parent := FControl.Parent;

  // create an array of positions
  FPosAry[1] := htTopLeft;
  FPosAry[2] := htTop;
  FPosAry[3] := htTopRight;
  FPosAry[4] := htRight;
  FPosAry[5] := htBottomRight;
  FPosAry[6] := htBottom;
  FPosAry[7] := htBottomLeft;
  FPosAry[8] := htLeft;
end;

procedure TCtrlSizer.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle + WS_EX_Transparent;
  {the WS_EX_Transparent allows the control under this (FControl)
  to be Painted first and change the pixels on this control, ,
  then does not do an Erase Background}
end;

procedure TCtrlSizer.LButtonDown(var Msg: TWmLButtonDown);
begin
  {to mouse move this control use the Caption Hit Test
  message SC_DRAGMOVE, which is Hex $F012}
  Perform(wm_SysCommand, $F012, 0);
end;

procedure TCtrlSizer.Paint;
var
  i: Integer;
begin
  {this will paint 8 small black sixing rectangles}
  //Canvas.Brush.Color := clNavy;
  for i := 1 to  8 do
    Canvas.Rectangle(FRectAry[i].Left, FRectAry[i].Top,
          FRectAry[i].Right, FRectAry[i].Bottom);
end;

procedure TCtrlSizer.NcHitTest(var Msg: TWmNcHitTest);
var
  Pt1: TPoint;
  i: Integer;
begin
  Pt1 := Point(Msg.XPos, Msg.YPos);
  Pt1 := ScreenToClient(Pt1);
  Msg.Result := 0;
  for i := 1 to  8 do
    if PtInRect (FRectAry[i], Pt1) then
      Msg.Result := FPosAry[i];

  // if the return value was not set
  if Msg.Result = 0 then
  inherited;
end;

procedure TCtrlSizer.WmSize(var Msg: TWmSize);
var
  Rect1: TRect;
begin
  Rect1 := BoundsRect;
  InflateRect (Rect1, -3, -3);
  FControl.BoundsRect := Rect1;

  // setup Rectangle sizes
  FRectAry[1] := Rect(0, 0, 3, 3);
  FRectAry[2] := Rect(Width div 2 - 2, 0, Width div 2 + 1, 3);
  FRectAry[3] := Rect(Width - 3, 0, Width, 3);
  FRectAry[4] := Rect(Width - 3, Height div 2 - 2, Width, Height div 2 + 1);
  FRectAry[5] := Rect(Width - 3, Height - 3, Width, Height);
  FRectAry[6] := Rect(Width div 2 - 2, Height - 3, Width div 2 + 1, Height);
  FRectAry[7] := Rect(0, Height - 3, 3, Height);
  FRectAry[8] := Rect(0, Height div 2 - 2, 3, Height div 2 + 1);
end;

procedure TCtrlSizer.WmMove(var Msg: TWmMove);
var
  Rect1: TRect;
begin
  Rect1 := BoundsRect;
  InflateRect(Rect1, -3, -3);
  FControl.BoundsRect := Rect1;  // move the control
  Application.ProcessMessages;
  Paint;
end;

(* Obter o Handle sobre o cursor do Mouse
Para obter o Handle sobre o cursor do Mouse utilizando Delphi, iremos utilizar um Timer, três Edits e as seguintes funções:
  GetCursorPos - Obtém a posição do Mouse;
  WindowFromPoint - Retorna o Handle de acordo com a posição informada;
  GetWindowText - Obtém o Texto referente ao Handle;
  GetClassName - Obtém a Classe referente ao Handle;
O evento OnTimer do Timer ficará assim: *) {
procedure TfrmMain.tHandleTimer(Sender: TObject);
var
  Handle : Longint;
  Posicao : TPoint;
  Texto, Classe: array [0..255] of char;
begin
  GetCursorPos(Posicao);
  Handle := WindowFromPoint(Posicao);
  GetWindowText(Handle, Texto, SizeOf(Texto));
  GetClassName(Handle, Classe, SizeOf(Classe));
  edtHandle.Text := IntToStr(Handle); //TEdit
  edtTexto.Text := Texto; //TEdit
  edtClasse.Text := Classe; //TEdit
end; }

end.