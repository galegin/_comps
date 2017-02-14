{------------------------------------------------------------------------------}
{ component  : AdvancedPanel                                                   }
{ version    : 1.0                                                             }
{ last update: 98/06/13                                                        }
{ written for: Borland Delphi 3.0                                              }
{ written by : Geir Wikran                                                     }
{ e-mail     : gwikran@online.no                                               }
{------------------------------------------------------------------------------}

unit mAdvancedPanel;

{==============================================================================}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms;

const
  Register_AdvancedControls = 'Installed';

  cl3DHiLight  = COLOR_3DHILIGHT or $80000000;
  cl3DLight    = COLOR_3DLIGHT or $80000000;
  cl3DFace     = COLOR_3DFACE or $80000000;
  cl3DShadow   = COLOR_3DSHADOW or $80000000;
  cl3DDkShadow = COLOR_3DDKSHADOW or $80000000;

type
  TPanelSides = set of (psLeft,psRight,psTop,psBottom,
                        psAlign,psAlignOpposite,
                        psNonAlignFirst,psNonAlignLast,
                        psNonAlignPrev,psNonAlignNext);

{ PanelBorder }

  TpPanelBorderStyle = (bsNone,bsLowered,bsRaised,bsRound,bsFlat);

  TmPanelBorder = class(TPersistent)
  private
    FSides   : TPanelSides;
    FStyle   : TpPanelBorderStyle;
    FOnChange: TNotifyEvent;
    procedure SetSides(Value: TPanelSides);
    procedure SetStyle(Value: TpPanelBorderStyle);
  protected
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Paint(Canvas: TCanvas; Rect: TRect; RectSides: TPanelSides);
    procedure InflateRect(var Rect: TRect; RectSides: TPanelSides);
    property  OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property  Sides: TPanelSides read FSides write SetSides;
    property  Style: TpPanelBorderStyle read FStyle write SetStyle;
  end;

{ PanelBevel }

  TpPanelBevelStyle = (bvNone,bvLowered,bvRaised,bvGroove,bvBump,
                       bvFlatHiLight,bvFlatShadow,bvFlatDkShadow);
  TpPanelBevelDepth = 1..MaxInt;
  TpPanelBevelSpace = 0..MaxInt;

  TmPanelBevel = class(TPersistent)
  private
    FSides     : TPanelSides;
    FStyle     : TpPanelBevelStyle;
    FDepth     : TpPanelBevelDepth;
    FSpaceOuter: TpPanelBevelSpace;
    FSpaceInner: TpPanelBevelSpace;
    FOnChange  : TNotifyEvent;
    procedure SetSides(Value: TPanelSides);
    procedure SetStyle(Value: TpPanelBevelStyle);
    procedure SetDepth(Value: TpPanelBevelDepth);
    procedure SetSpaceOuter(Value: TpPanelBevelSpace);
    procedure SetSpaceInner(Value: TpPanelBevelSpace);
  protected
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Paint(Canvas: TCanvas; Rect: TRect; RectSides: TPanelSides);
    procedure InflateRect(var Rect: TRect; RectSides: TPanelSides);
    property  OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property  Sides: TPanelSides read FSides write SetSides;
    property  Style: TpPanelBevelStyle read FStyle write SetStyle;
    property  Depth: TpPanelBevelDepth read FDepth write SetDepth;
    property  SpaceOuter: TpPanelBevelSpace read FSpaceOuter write SetSpaceOuter;
    property  SpaceInner: TpPanelBevelSpace read FSpaceInner write SetSpaceInner;
  end;

{ PanelWallpaper }

  TpPanelWallpaperStyle = (wpNone,wpCenter,wpStretch,wpTile);

  TmPanelWallpaper = class(TPersistent)
  private
    FBitmap  : TBitmap;
    FStyle   : TpPanelWallpaperStyle;
    FOnChange: TNotifyEvent;
    procedure SetBitmap(Value: TBitmap);
    procedure SetStyle(Value: TpPanelWallpaperStyle);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Paint(Canvas: TCanvas; Rect: TRect; Color: TColor);
    property  OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property  Bitmap: TBitmap read FBitmap write SetBitmap;
    property  Style: TpPanelWallpaperStyle read FStyle write SetStyle;
  end;

{ SimplePanel }

  TpWorkspaceChange = (wcSizeChange,wcPanelChange);

  TmCustomSimplePanel = class(TCustomControl)
  private
    FLocked     : Boolean;
    FBorderStyle: TBorderStyle;
    FOnResize   : TNotifyEvent;
    procedure SetBorderStyle(Value: TBorderStyle);
  protected
    procedure CMIsToolControl(var Message: TMessage); message CM_IsToolControl;
    procedure WMSize(var Message: TWMSize); message WM_Size;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WindowPosChanged;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_EraseBkgnd;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure Paint; override;
    procedure PaintOutline; virtual;
    procedure Resize; dynamic;
    function  ActiveSides(Sides: TPanelSides): TPanelSides;
    procedure WorkspaceChange(Cause: TpWorkspaceChange); virtual;
    function  GetWorkspace: TRect; virtual;
    procedure SetWorkspace(AWidth,AHeight: Integer); virtual;
    property  Locked: Boolean read FLocked write FLocked default false;
    property  OnResize: TNotifyEvent read FOnResize write FOnResize;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

{ AdvancedPanel }

  TmCustomAdvancedPanel = class(TmCustomSimplePanel)
  private
    FBorder    : TmPanelBorder;
    FBevelOuter: TmPanelBevel;
    FBevelInner: TmPanelBevel;
    FWallpaper : TmPanelWallpaper;
    procedure SetBorder(Value: TmPanelBorder);
    procedure SetBevelOuter(Value: TmPanelBevel);
    procedure SetBevelInner(Value: TmPanelBevel);
    procedure SetWallpaper(Value: TmPanelWallpaper);
  protected
    procedure Paint; override;
    function  GetWorkspace: TRect; override;
    procedure PanelChange(Sender: TObject); virtual;
    property  Border: TmPanelBorder read FBorder write SetBorder;
    property  BevelOuter: TmPanelBevel read FBevelOuter write SetBevelOuter;
    property  BevelInner: TmPanelBevel read FBevelInner write SetBevelInner;
    property  Wallpaper: TmPanelWallpaper read FWallpaper write SetWallpaper;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

  TmAdvancedPanel = class(TmCustomAdvancedPanel)
  private
  protected
  public
  published
  {republished}
    property  Align;
    property  Visible;
    property  Color;
    property  ParentColor;
    property  Border;
    property  BevelOuter;
    property  BevelInner;
    property  Wallpaper;
    property  OnResize;
  end;

{ SimpleScroller }

  TmCustomSimpleScroller = class(TScrollBox{ingWinControl})
  private
    FCanvas     : TCanvas;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_EraseBkgnd;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    procedure PaintWindow(DC: HDC); override;
    procedure Paint; virtual;
    function  GetWorkspace: TRect; virtual;
    procedure SetWorkspace(AWidth,AHeight: Integer); virtual;
    property  Canvas: TCanvas read FCanvas;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

{ AdvancedScroller }

  TmCustomAdvancedScroller = class(TmCustomSimpleScroller)
  private
    FWallpaper : TmPanelWallpaper;
    procedure SetWallpaper(Value: TmPanelWallpaper);
  protected
    procedure Paint; override;
    procedure WallpaperChange(Sender: TObject);
    property  Wallpaper: TmPanelWallpaper read FWallpaper write SetWallpaper;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

  TmAdvancedScroller = class(TmCustomAdvancedScroller)
  private
  protected
  public
  published
  {republished}
    property  Align;
    property  Visible;
    property  Color;
    property  ParentColor;
    property  BorderStyle;
    property  Wallpaper;
    property  OnResize;
  end;

procedure Register;

{==============================================================================}
implementation

{- TmPanelBorder ---------------------------------------------------------------}

constructor TmPanelBorder.Create;
begin
  inherited;
  FSides := [psLeft,psRight,psTop,psBottom];
  FStyle := bsNone;
  FOnChange := nil;
end;

procedure TmPanelBorder.Assign;
begin
  if Source is TmPanelBorder then begin
    FSides := TmPanelBorder(Source).Sides;
    FStyle := TmPanelBorder(Source).Style;
    if Assigned(FOnChange) then FOnChange(Self);
  end
  else inherited;
end;

procedure TmPanelBorder.SetSides;
begin
  if FSides <> Value then begin
    FSides := Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TmPanelBorder.SetStyle;
begin
  if FStyle <> Value then begin
    FStyle := Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TmPanelBorder.Paint;
var
  TopColor   : TColor;
  BottomColor: TColor;

  procedure PaintRect(RectWidth: Integer);
  begin
    with Canvas do begin
      while RectWidth > 0 do begin
        Pen.Color := TopColor;
        MoveTo(Rect.Left,Rect.Bottom-1);
        if psLeft in RectSides then LineTo(Rect.Left,Rect.Top-1);
        MoveTo(Rect.Left,Rect.Top);
        if psLeft in RectSides then  Inc(Rect.Left);
        if psTop in RectSides then LineTo(Rect.Right,Rect.Top);
        MoveTo(Rect.Right-1,Rect.Top);
        if psTop in RectSides then Inc(Rect.Top);
        Pen.Color := BottomColor;
        if psRight in RectSides then LineTo(Rect.Right-1,Rect.Bottom);
        MoveTo(Rect.Right-1,Rect.Bottom-1);
        if psRight in RectSides then Dec(Rect.Right);
        if psBottom in RectSides then LineTo(Rect.Left-2,Rect.Bottom-1);
        MoveTo(Rect.Left-1,Rect.Bottom-1);
        if psBottom in RectSides then Dec(Rect.Bottom);
        Dec(RectWidth);
      end;
    end;
  end;

  procedure PaintLowered;
  begin
    TopColor := cl3DShadow;
    BottomColor := cl3DHiLight;
    PaintRect(1);
    TopColor := cl3DDkShadow;
    BottomColor := cl3DLight;
    PaintRect(1);
  end;

  procedure PaintRaised;
  begin
    TopColor := cl3DLight;
    BottomColor := cl3DDkShadow;
    PaintRect(1);
    TopColor := cl3DHiLight;
    BottomColor := cl3DShadow;
    PaintRect(1);
  end;

  procedure PaintRound;
  begin
    TopColor := cl3DHiLight;
    BottomColor := cl3DDkShadow;
    PaintRect(1);
    TopColor := cl3DLight;
    BottomColor := cl3DShadow;
    PaintRect(1);
    TopColor := cl3DFace;
    BottomColor := cl3DFace;
    PaintRect(2);
    TopColor := cl3DShadow;
    BottomColor := cl3DHiLight;
    PaintRect(1);
    TopColor := cl3DDkShadow;
    BottomColor := cl3DLight;
    PaintRect(1);
  end;

  procedure PaintFlat(AColor: TColor);
  begin
    TopColor := AColor;
    BottomColor := AColor;
    PaintRect(1);
  end;

begin
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Width := 1;
  case FStyle of
    bsLowered: PaintLowered;
    bsRaised : PaintRaised;
    bsRound  : PaintRound;
    bsFlat   : PaintFlat(cl3DDkShadow);
  end;
end;

procedure TmPanelBorder.InflateRect;
var
  TempWidth: Integer;
begin
  if FStyle = bsNone then Exit;
  if FStyle = bsFlat then TempWidth := 1
  else if FStyle in [bsLowered,bsRaised] then TempWidth := 2
  else if FStyle = bsRound then TempWidth := 6;
  if psLeft in RectSides then Inc(Rect.Left,TempWidth);
  if psRight in RectSides then Dec(Rect.Right,TempWidth);
  if psTop in RectSides then Inc(Rect.Top,TempWidth);
  if psBottom in RectSides then Dec(Rect.Bottom,TempWidth);
end;

{- TmPanelBevel ----------------------------------------------------------------}

constructor TmPanelBevel.Create;
begin
  inherited;
  FSides := [psLeft,psRight,psTop,psBottom];
  FStyle := bvNone;
  FDepth := 1;
  FSpaceOuter := 0;
  FSpaceInner := 0;
  FOnChange := nil;
end;

procedure TmPanelBevel.Assign;
begin
  if Source is TmPanelBevel then begin
    FSides := TmPanelBevel(Source).Sides;
    FStyle := TmPanelBevel(Source).Style;
    FDepth := TmPanelBevel(Source).Depth;
    FSpaceOuter := TmPanelBevel(Source).SpaceOuter;
    FSpaceInner := TmPanelBevel(Source).SpaceInner;
    if Assigned(FOnChange) then FOnChange(Self);
  end
  else inherited;
end;

procedure TmPanelBevel.SetStyle;
begin
  if FStyle <> Value then begin
    FStyle := Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TmPanelBevel.SetSides;
begin
  if FSides <> Value then begin
    FSides := Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TmPanelBevel.SetDepth;
begin
  if FDepth <> Value then begin
    FDepth := Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TmPanelBevel.SetSpaceOuter;
begin
  if FSpaceOuter <> Value then begin
    FSpaceOuter := Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TmPanelBevel.SetSpaceInner;
begin
  if FSpaceInner <> Value then begin
    FSpaceInner := Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TmPanelBevel.Paint;
var
  TopColor   : TColor;
  BottomColor: TColor;

  procedure PaintSpace(SpaceWidth: Integer);
  var
    SpaceRect: TRect;
  begin
    with Canvas do begin
      Brush.Color := cl3DFace;
      Brush.Style := bsSolid;
      if psLeft in RectSides then begin
        SpaceRect := Rect;
        SpaceRect.Right := Rect.Left+SpaceWidth;
        FillRect(SpaceRect);
        Inc(Rect.Left,SpaceWidth);
      end;
      if psTop in RectSides then begin
        SpaceRect := Rect;
        SpaceRect.Bottom := Rect.Top+SpaceWidth;
        FillRect(SpaceRect);
        Inc(Rect.Top,SpaceWidth);
      end;
      if psRight in RectSides then begin
        SpaceRect := Rect;
        SpaceRect.Left := Rect.Right-SpaceWidth;
        FillRect(SpaceRect);
        Dec(Rect.Right,SpaceWidth);
      end;
      if psBottom in RectSides then begin
        SpaceRect := Rect;
        SpaceRect.Top := Rect.Bottom-SpaceWidth;
        FillRect(SpaceRect);
        Dec(Rect.Bottom,SpaceWidth);
      end;
    end;
  end;

  procedure PaintRect(RectWidth: Integer);
  begin
    with Canvas do begin
      while RectWidth > 0 do begin
        Pen.Color := TopColor;
        MoveTo(Rect.Left,Rect.Bottom-1);
        if psLeft in RectSides then LineTo(Rect.Left,Rect.Top-1);
        MoveTo(Rect.Left,Rect.Top);
        if psLeft in RectSides then Inc(Rect.Left);
        if psTop in RectSides then LineTo(Rect.Right,Rect.Top);
        MoveTo(Rect.Right-1,Rect.Top);
        if psTop in RectSides then Inc(Rect.Top);
        Pen.Color := BottomColor;
        if psRight in RectSides then LineTo(Rect.Right-1,Rect.Bottom);
        MoveTo(Rect.Right-1,Rect.Bottom-1);
        if psRight in RectSides then Dec(Rect.Right);
        if psBottom in RectSides then LineTo(Rect.Left-2,Rect.Bottom-1);
        MoveTo(Rect.Left-1,Rect.Bottom-1);
        if psBottom in RectSides then Dec(Rect.Bottom);
        Dec(RectWidth);
      end;
    end;
  end;

  procedure PaintLowered;
  begin
    TopColor := cl3DShadow;
    BottomColor := cl3DHiLight;
    PaintRect(FDepth);
  end;

  procedure PaintRaised;
  begin
    TopColor := cl3DHiLight;
    BottomColor := cl3DShadow;
    PaintRect(FDepth);
  end;

  procedure PaintFlat(AColor: TColor);
  begin
    TopColor := AColor;
    BottomColor := AColor;
    PaintRect(FDepth);
  end;

begin
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Width := 1;
  if FSpaceOuter > 0 then PaintSpace(FSpaceOuter);
  case FStyle of
    bvLowered     : PaintLowered;
    bvRaised      : PaintRaised;
    bvGroove      : begin PaintLowered; PaintRaised; end;
    bvBump        : begin PaintRaised; PaintLowered; end;
    bvFlatHiLight : PaintFlat(cl3DHiLight);
    bvFlatShadow  : PaintFlat(cl3DShadow);
    bvFlatDkShadow: PaintFlat(cl3DDkShadow);
  end;
  if FSpaceInner > 0 then PaintSpace(FSpaceInner);
end;

procedure TmPanelBevel.InflateRect;
var
  TempWidth: Integer;
begin
  if FStyle = bvNone then TempWidth := 0
  else TempWidth := FDepth;
  if FStyle in [bvGroove,bvBump] then Inc(TempWidth,FDepth);
  Inc(TempWidth,FSpaceOuter);
  Inc(TempWidth,FSpaceInner);
  if psLeft in RectSides then Inc(Rect.Left,TempWidth);
  if psRight in RectSides then Dec(Rect.Right,TempWidth);
  if psTop in RectSides then Inc(Rect.Top,TempWidth);
  if psBottom in RectSides then Dec(Rect.Bottom,TempWidth);
end;

{- TmPanelWallpaper ------------------------------------------------------------}

constructor TmPanelWallpaper.Create;
begin
  inherited;
  FBitmap := TBitmap.Create;
  FStyle := wpTile;
  FOnChange := nil;
end;

destructor TmPanelWallpaper.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TmPanelWallpaper.Assign;
begin
  if Source is TmPanelWallpaper then begin
    FBitmap.Assign(TmPanelWallpaper(Source).Bitmap);
    FStyle := TmPanelWallpaper(Source).Style;
    if Assigned(FOnChange) then FOnChange(Self);
  end
  else inherited;
end;

procedure TmPanelWallpaper.SetBitmap;
begin
  FBitmap.Assign(Value);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TmPanelWallpaper.SetStyle;
begin
  if FStyle <> Value then begin
    FStyle := Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TmPanelWallpaper.Paint;
var
  SrcRect  : TRect;
  SrcWidth : Integer;
  SrcHeight: Integer;
  DstRect  : TRect;
  DstWidth : Integer;
  DstHeight: Integer;
  SrcDC    : HDC;
  DstDC    : HDC;

  procedure PaintRect(X1,Y1,X2,Y2: Integer);
  begin
    if X1 < Rect.Left then X1 := Rect.Left;
    if Y1 < Rect.Top then Y1 := Rect.Top;
    if X2 > Rect.Right then X2 := Rect.Right;
    if Y2 > Rect.Bottom then Y2 := Rect.Bottom;
    if (X1 < X2) and (Y1 < Y2) then with Canvas do begin
      Brush.Color := Color;
      Brush.Style := bsSolid;
      FillRect(Bounds(X1,Y1,X2-X1,Y2-Y1));
    end;
  end;

begin
  if FBitmap.Empty then PaintRect(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom)
  else begin
    DstRect := Rect;
    DstDC := Canvas.Handle;
    SrcDC := FBitmap.Canvas.Handle;
    case FStyle of
      wpNone: begin
        BitBlt(DstDC,DstRect.Left,DstRect.Top,
               DstRect.Right-DstRect.Left,DstRect.Bottom-DstRect.Top,
               SrcDC,0,0,SRCCOPY);
        PaintRect(Rect.Left+FBitmap.Width,Rect.Top,Rect.Right,Rect.Top+FBitmap.Height);
        PaintRect(Rect.Left,Rect.Top+FBitmap.Height,Rect.Right,Rect.Bottom);
      end;
      wpCenter: begin
        SrcRect := Bounds(0,0,FBitmap.Width,FBitmap.Height);
        SrcWidth := SrcRect.Right-SrcRect.Left;
        DstWidth := DstRect.Right-DstRect.Left;
        if SrcWidth > DstWidth then
          SrcRect.Left := SrcRect.Left+((SrcWidth-DstWidth) div 2)
        else if SrcWidth < DstWidth then begin
          DstRect.Left := DstRect.Left+((DstWidth-SrcWidth) div 2);
          DstRect.Right := DstRect.Left+SrcWidth;
        end;
        SrcHeight := SrcRect.Bottom-SrcRect.Top;
        DstHeight := DstRect.Bottom-DstRect.Top;
        if SrcHeight > DstHeight then
          SrcRect.Top := SrcRect.Top+((SrcHeight-DstHeight) div 2)
        else if SrcHeight < DstHeight then begin
          DstRect.Top := DstRect.Top+((DstHeight-SrcHeight) div 2);
          DstRect.Bottom := DstRect.Top+SrcHeight;
        end;
        BitBlt(DstDC,DstRect.Left,DstRect.Top,
               DstRect.Right-DstRect.Left,DstRect.Bottom-DstRect.Top,
               SrcDC,SrcRect.Left,SrcRect.Top,SRCCOPY);
        PaintRect(Rect.Left,Rect.Top,Rect.Right,DstRect.Top);
        PaintRect(Rect.Left,DstRect.Top,DstRect.Left,DstRect.Bottom);
        PaintRect(DstRect.Right,DstRect.Top,Rect.Right,DstRect.Bottom);
        PaintRect(Rect.Left,DstRect.Bottom,Rect.Right,Rect.Bottom);
      end;
      wpStretch: begin
        SetStretchBltMode(DstDC,COLORONCOLOR);
        StretchBlt(DstDC,DstRect.Left,DstRect.Top,
                   DstRect.Right-DstRect.Left,DstRect.Bottom-DstRect.Top,
                   SrcDC,0,0,FBitmap.Width,FBitmap.Height,SRCCOPY);
      end;
      wpTile: begin
        while DstRect.Top < DstRect.Bottom do begin
          BitBlt(DstDC,DstRect.Left,DstRect.Top,
                 DstRect.Right-DstRect.Left,DstRect.Bottom-DstRect.Top,
                 SrcDC,0,0,SRCCOPY);
          Inc(DstRect.Left,FBitmap.Width);
          if DstRect.Left >= DstRect.Right then begin
            DstRect.Left := Rect.Left;
            Inc(DstRect.Top,FBitmap.Height);
          end;
        end;
      end;
    end;
  end;
end;

{- TmCustomSimplePanel ---------------------------------------------------------}

constructor TmCustomSimplePanel.Create;
begin
  inherited;
  ControlStyle := [csAcceptsControls,csCaptureMouse,csClickEvents,csSetCaption,
                   csOpaque,csDoubleClicks,csReplicatable];
  Width := 145;
  Height := 145;
end;

destructor TmCustomSimplePanel.Destroy;
begin
  inherited;
end;

procedure TmCustomSimplePanel.CreateParams;
const
  BorderStyles: array[TBorderStyle] of Longint = (0, WS_BORDER);
begin
  inherited;
  with Params do begin
    Style := Style or BorderStyles[FBorderStyle];
    WindowClass.style := WindowClass.style and not (CS_HRedraw or CS_VRedraw);
  end;
end;

procedure TmCustomSimplePanel.SetBorderStyle;
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TmCustomSimplePanel.CMIsToolControl;
begin
  if not FLocked then Message.Result := 1;
end;

procedure TmCustomSimplePanel.Resize;
begin
  if Assigned(FOnResize) then FOnResize(Self);
end;

procedure TmCustomSimplePanel.WMWindowPosChanged;
begin
  Invalidate;
  inherited;
  if not (csLoading in ComponentState) then Resize;
end;

procedure TmCustomSimplePanel.WMEraseBkgnd;
begin
  Message.Result := 1;
end;

procedure TmCustomSimplePanel.AlignControls;
begin
  Rect := GetWorkspace;
  inherited AlignControls(AControl,Rect);
end;

procedure TmCustomSimplePanel.Paint;
begin
  with Canvas do begin
    Brush.Color := Color;
    Brush.Style := bsSolid;
    FillRect(GetWorkspace);
  end;
  if csDesigning in ComponentState then PaintOutline;
end;

procedure TmCustomSimplePanel.PaintOutline;
var
  Rect: TRect;
begin
  with Canvas do begin
    Brush.Color := Color;
    Brush.Style := bsSolid;
    Pen.Color := cl3DShadow;
    Pen.Style := psDot;
    Rect := GetClientRect;
    MoveTo(Rect.Left,Rect.Bottom-1);
    LineTo(Rect.Left,Rect.Top);
    LineTo(Rect.Right-1,Rect.Top);
    LineTo(Rect.Right-1,Rect.Bottom-1);
    LineTo(Rect.Left,Rect.Bottom-1);
  end;
end;

procedure TmCustomSimplePanel.WMSize;
begin
  inherited;
  WorkspaceChange(wcSizeChange);
end;

function TmCustomSimplePanel.ActiveSides;
begin
  Result := Sides;
  if psAlign in Sides then
    case Align of
      alLeft   : Result := Result+[psLeft];
      alRight  : Result := Result+[psRight];
      alTop    : Result := Result+[psTop];
      alBottom : Result := Result+[psBottom];
      alClient : Result := Result+[psLeft,psRight,psTop,psBottom];
    end;
  if psAlignOpposite in Sides then
    case Align of
      alLeft   : Result := Result+[psRight];
      alRight  : Result := Result+[psLeft];
      alTop    : Result := Result+[psBottom];
      alBottom : Result := Result+[psTop];
      alNone   : Result := Result+[psLeft,psRight,psTop,psBottom];
    end;
  if psNonAlignFirst in Sides then
    case Align of
      alLeft,alRight : Result := Result+[psTop];
      alTop,alBottom : Result := Result+[psLeft];
    end;
  if psNonAlignLast in Sides then
    case Align of
      alLeft,alRight : Result := Result+[psBottom];
      alTop,alBottom : Result := Result+[psRight];
    end;
  if psNonAlignPrev in Sides then
    case Align of
      alLeft   : Result := Result+[psBottom];
      alRight  : Result := Result+[psTop];
      alTop    : Result := Result+[psLeft];
      alBottom : Result := Result+[psRight];
    end;
  if psNonAlignNext in Sides then
    case Align of
      alLeft   : Result := Result+[psTop];
      alRight  : Result := Result+[psBottom];
      alTop    : Result := Result+[psRight];
      alBottom : Result := Result+[psLeft];
    end;
end;

procedure TmCustomSimplePanel.WorkspaceChange;
begin
  if Cause <> wcSizeChange then Realign;
end;

function TmCustomSimplePanel.GetWorkspace;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := ClientWidth;
  Result.Bottom := ClientHeight;
end;

procedure TmCustomSimplePanel.SetWorkspace;
var
  TempRect: TRect;
begin
  TempRect := GetWorkspace;
  if AWidth <> TempRect.Right-TempRect.Left then
    AWidth := AWidth+(ClientWidth-(TempRect.Right-TempRect.Left));
  if AHeight <> TempRect.Bottom-TempRect.Top then
    AHeight := AHeight+(ClientHeight-(TempRect.Bottom-TempRect.Top));
  SetBounds(Left,Top,AWidth,AHeight);
end;

{- TmCustomAdvancedPanel -------------------------------------------------------}

constructor TmCustomAdvancedPanel.Create;
begin
  inherited;
  FBorder := TmPanelBorder.Create;
  FBorder.OnChange := PanelChange;
  FBevelOuter := TmPanelBevel.Create;
  FBevelOuter.Style := bvRaised;
  FBevelOuter.OnChange := PanelChange;
  FBevelInner := TmPanelBevel.Create;
  FBevelInner.OnChange := PanelChange;
  FWallpaper := TmPanelWallpaper.Create;
  FWallpaper.OnChange := PanelChange;
end;

destructor TmCustomAdvancedPanel.Destroy;
begin
  FBorder.Free;
  FBevelOuter.Free;
  FBevelInner.Free;
  FWallpaper.Free;
  inherited;
end;

procedure TmCustomAdvancedPanel.SetBorder;
begin
  FBorder.Assign(Value);
end;

procedure TmCustomAdvancedPanel.SetBevelOuter;
begin
  FBevelOuter.Assign(Value);
end;

procedure TmCustomAdvancedPanel.SetBevelInner;
begin
  FBevelInner.Assign(Value);
end;

procedure TmCustomAdvancedPanel.SetWallpaper;
begin
  FWallpaper.Assign(Value);
end;

procedure TmCustomAdvancedPanel.Paint;
var
  Rect: TRect;
begin
  Rect := GetClientRect;
  FBorder.Paint(Canvas,Rect,ActiveSides(FBorder.Sides));
  FBorder.InflateRect(Rect,ActiveSides(FBorder.Sides));
  FBevelOuter.Paint(Canvas,Rect,ActiveSides(FBevelOuter.Sides));
  FBevelOuter.InflateRect(Rect,ActiveSides(FBevelOuter.Sides));
  FBevelInner.Paint(Canvas,Rect,ActiveSides(FBevelInner.Sides));
  FBevelInner.InflateRect(Rect,ActiveSides(FBevelInner.Sides));
  FWallpaper.Paint(Canvas,Rect,Color);
  if (csDesigning in ComponentState)
  and (FBorder.Style = bsNone)
  and (FBevelInner.Style = bvNone)
  and (FBevelOuter.Style = bvNone)
  then PaintOutline;
end;

function TmCustomAdvancedPanel.GetWorkspace;
begin
  Result := inherited GetWorkspace;
  FBorder.InflateRect(Result,ActiveSides(FBorder.Sides));
  FBevelOuter.InflateRect(Result,ActiveSides(FBevelOuter.Sides));
  FBevelInner.InflateRect(Result,ActiveSides(FBevelInner.Sides));
end;

procedure TmCustomAdvancedPanel.PanelChange;
begin
  WorkspaceChange(wcPanelChange);
  Invalidate;
end;

{- TmCustomSimpleScroller ------------------------------------------------------}

constructor TmCustomSimpleScroller.Create;
begin
  inherited;
  ControlStyle := [csAcceptsControls,csCaptureMouse,csClickEvents,csSetCaption,
                   csDoubleClicks];
  HorzScrollBar.Tracking := true;
  VertScrollBar.Tracking := true;
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  Width := 145;
  Height := 145;
end;

destructor TmCustomSimpleScroller.Destroy;
begin
  FCanvas.Free;
  inherited;
end;

procedure TmCustomSimpleScroller.WMEraseBkgnd;
begin
  Message.Result := 1;
end;

procedure TmCustomSimpleScroller.WMPaint;
begin
  PaintHandler(Message);
end;

procedure TmCustomSimpleScroller.PaintWindow;
begin
  FCanvas.Lock;
  try
    FCanvas.Handle := DC;
    try
      Paint;
    finally
      FCanvas.Handle := 0;
    end;
  finally
    FCanvas.Unlock;
  end;
end;

procedure TmCustomSimpleScroller.Paint;
begin
end;

function TmCustomSimpleScroller.GetWorkspace;
begin
  Result := ClientRect;
  if HorzScrollBar.Visible then begin
    Result.Right := Result.Left+HorzScrollBar.Range;
    Result.Left := 0-HorzScrollBar.Position;
  end;
  if VertScrollBar.Visible then begin
    Result.Top := 0-VertScrollBar.Position;
    Result.Bottom := Result.Top+VertScrollBar.Range;
  end;
end;

procedure TmCustomSimpleScroller.SetWorkspace;
begin
  if AWidth <> HorzScrollBar.Range then HorzScrollBar.Range := AWidth;
  if AHeight <> VertScrollBar.Range then VertScrollBar.Range := AHeight;
end;

{- TmCustomAdvancedScroller ----------------------------------------------------}

constructor TmCustomAdvancedScroller.Create;
begin
  inherited;
  FWallpaper := TmPanelWallpaper.Create;
  FWallpaper.OnChange := WallpaperChange;
end;

destructor TmCustomAdvancedScroller.Destroy;
begin
  FWallpaper.Free;
  inherited;
end;

procedure TmCustomAdvancedScroller.SetWallpaper;
begin
  FWallpaper.Assign(Value);
end;

procedure TmCustomAdvancedScroller.Paint;
var
  Rect: TRect;
begin
  Rect := GetClientRect;
  if HorzScrollBar.Visible then Dec(Rect.Left,HorzScrollBar.Position);
  if VertScrollBar.Visible then Dec(Rect.Top,VertScrollBar.Position);
  FWallpaper.Paint(Canvas,Rect,Color);
end;

procedure TmCustomAdvancedScroller.WallpaperChange;
begin
  Invalidate;
end;

{- Register -------------------------------------------------------------------}

procedure Register;
begin
  RegisterComponents('Comps MIGUEL',[TmAdvancedPanel]);
  RegisterComponents('Comps MIGUEL',[TmAdvancedScroller]);
end;

end.