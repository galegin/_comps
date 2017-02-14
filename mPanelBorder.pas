unit mPanelBorder;

interface

uses
  Windows, Messages, 
  SysUtils, Classes, Controls, ExtCtrls, mPanel;

type
  TpPanelBorder = (tpbTop, tpbLeft, tpbRight, tpbBottom);
  TpPanelBorders = set of TpPanelBorder;

  TmPanelBorder = class(TmPanel)
  private
    FBevelTop,
    FBevelLeft,
    FBevelRight,
    FBevelBottom : TBevel;
    FTpPanelBorders: TpPanelBorders;
    procedure SetTpPanelBorders(const Value: TpPanelBorders);
  protected
    procedure createComp();
    procedure SetName(const NewName: TComponentName); override;
  public
    constructor create(Aowner : TComponent); override;
    procedure PanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  published
    property _TpPanelBorders : TpPanelBorders read FTpPanelBorders write SetTpPanelBorders;  
  end;

procedure Register;

implementation

uses
  mControl;

const
  cREC_LIN = 4;
  cREC_COL = 4;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmPanelBorder]);
end;

{ TmPanelBorder }

  procedure TmPanelBorder.createComp();
  begin
    if not (Assigned(FBevelTop)) then begin
      FBevelTop := TBevel.Create(Self);
      with FBevelTop do begin
        Parent := Self;
        Align := alTop;
        Height := cREC_LIN;
        Shape := bsSpacer;
      end;
    end;

    if not (Assigned(FBevelLeft)) then begin
      FBevelLeft := TBevel.Create(Self);
      with FBevelLeft do begin
        Parent := Self;
        Align := alLeft;
        Width := cREC_COL;
        Shape := bsSpacer;
      end;
    end;

    if not (Assigned(FBevelRight)) then begin
      FBevelRight := TBevel.Create(Self);
      with FBevelRight do begin
        Parent := Self;
        Align := alRight;
        Width := cREC_COL;
        Shape := bsSpacer;
      end;
    end;

    if not (Assigned(FBevelBottom)) then begin
      FBevelBottom := TBevel.Create(Self);
      with FBevelBottom do begin
        Parent := Self;
        Align := alBottom;
        Height := cREC_LIN;
        Shape := bsSpacer;
      end;
    end;
  end;

constructor TmPanelBorder.create(Aowner: TComponent);
begin
  inherited; //
  BevelOuter := bvNone;
  createComp();
end;

procedure TmPanelBorder.SetName(const NewName: TComponentName);
begin
  inherited;

  if (Assigned(FBevelTop)) then begin
    //FBevelTop.Name := TmFormVal.NewControlName(Self, NewName + 'BevelTop');
    FBevelTop.Name := NewName + 'BevelTop';
  end;
  if (Assigned(FBevelLeft)) then begin
    //FBevelLeft.Name := TmFormVal.NewControlName(Self, NewName + 'BevelLeft');
    FBevelLeft.Name := NewName + 'BevelLeft';
  end;
  if (Assigned(FBevelRight)) then begin
    //FBevelRight.Name := TmFormVal.NewControlName(Self, NewName + 'BevelRight');
    FBevelRight.Name := NewName + 'BevelRight';
  end;
  if (Assigned(FBevelBottom)) then begin
    //FBevelBottom.Name := TmFormVal.NewControlName(Self, NewName + 'BevelBottom');
    FBevelBottom.Name := NewName + 'BevelBottom';
  end;
end;

procedure TmPanelBorder.SetTpPanelBorders(const Value: TpPanelBorders);
begin
  FTpPanelBorders := Value;

  if (Assigned(FBevelTop)) then begin
    FBevelTop.Visible := tpbTop in FTpPanelBorders;
  end;
  if (Assigned(FBevelLeft)) then begin
    FBevelLeft.Visible := tpbLeft in FTpPanelBorders;
  end;
  if (Assigned(FBevelRight)) then begin
    FBevelRight.Visible := tpbRight in FTpPanelBorders;
  end;
  if (Assigned(FBevelBottom)) then begin
    FBevelBottom.Visible := tpbBottom in FTpPanelBorders;
  end;
end;

procedure TmPanelBorder.PanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_MOVE = $F012;
begin
  //inherited MouseDown(Button, Shift, X, Y);
  ReleaseCapture;
  Self.Perform(WM_SYSCOMMAND, SC_MOVE, 0);
end;

end.
