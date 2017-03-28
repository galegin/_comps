unit mFieldCtrl;

interface

uses
  Classes, Controls, StdCtrls, ExtCtrls, ComCtrls, Forms,
  mTipoBinding, mTipoEstilo, mTipoMarging, mTipoPosition;

type
  TTipoFieldCtrl = (
    tfPanel,
    tfFrame,
    tfGrade,
    tfLabel,
    tfButton,
    tfCheckBox,
    tfComboBox,
    tfTextBox);

  TmFieldCtrl = class
  private
    fOwner : TComponent;
    fParent : TControl;

    fTipo : TTipoFieldCtrl;
    fNome : String;
    fDescricao : String;

    fEstilo : TTipoEstilo;
    fBinding : RTipoBinding;
    fMarging : RTipoMarging;
    fPosition : RTipoPosition;

    fClick : TNotifyEvent;
    fDblClick : TNotifyEvent;
    fEnter : TNotifyEvent;
    fExit : TNotifyEvent;
    fKeyDown : TKeyEvent;
    fKeyPress : TKeyPressEvent;

    fControlClass : TControlClass;
    fControl : TControl;
  public
    constructor Create(AOwner : TComponent; AParent : TControl);
    function GetControlClass : TControlClass;
    function GetControl: TControl;
  published
    property Tipo : TTipoFieldCtrl read fTipo write fTipo;
    property Nome : String read fNome write fNome;
    property Descricao : String read fDescricao write fDescricao;

    property Estilo : TTipoEstilo read fEstilo write fEstilo;
    property Binding : RTipoBinding read fBinding write fBinding;
    property Marging : RTipoMarging read fMarging write fMarging;
    property Position : RTipoPosition read fPosition write fPosition;

    property Click : TNotifyEvent read fClick write fClick;
    property DblClick : TNotifyEvent read fDblClick write fDblClick;
    property Enter : TNotifyEvent read fEnter write fEnter;
    property Exit : TNotifyEvent read fExit write fExit;
    property KeyDown : TKeyEvent read fKeyDown write fKeyDown;
    property KeyPress : TKeyPressEvent read fKeyPress write fKeyPress;

    property ControlClass : TControlClass read fControlClass write fControlClass;
    property Control : TControl read fControl write fControl;
  end;

  TmFieldCtrlList = class(TList)
  private
    function GetItem(Index: Integer): TmFieldCtrl;
    procedure SetItem(Index: Integer; const Value: TmFieldCtrl);
  public
    function Add : TmFieldCtrl; overload;
    property Items[Index : Integer] : TmFieldCtrl read GetItem write SetItem;
  end;

implementation

uses
  mPanel,
  mFrame,
  mGrade,
  mLabel,
  mButton,
  mCheckBox,
  mComboBox,
  mTextBox;

constructor TmFieldCtrl.Create(AOwner : TComponent; AParent: TControl);
begin
  fOwner := AOwner;
  fParent := AParent;
end;

function TmFieldCtrl.GetControlClass : TControlClass;
begin
  if not Assigned(fControlClass) then
    case fTipo of
      tfPanel :
        fControlClass := TmPanel;
      tfFrame :
        fControlClass := TmFrame;
      tfGrade :
        fControlClass := TmGrade;
      tfLabel :
        fControlClass := TmLabel;
      tfButton :
        fControlClass := TmButton;
      tfCheckBox :
        fControlClass := TmCheckBox;
      tfComboBox :
        fControlClass := TmComboBox;
      tfTextBox :
        fControlClass := TmTextBox;
    end;

  Result := fControlClass;
end;

function TmFieldCtrl.GetControl : TControl;
begin
  if not Assigned(fControl) then
    case fTipo of
      tfPanel :
        fControl := TmPanel.Create(fOwner);
      tfFrame :
        fControl := TmFrame.Create(fOwner);
      tfGrade :
        fControl := TmGrade.Create(fOwner);
      tfLabel :
        fControl := TmLabel.Create(fOwner);
      tfButton :
        fControl := TmButton.Create(fOwner);
      tfCheckBox :
        fControl := TmCheckBox.Create(fOwner);
      tfComboBox :
        fControl := TmComboBox.Create(fOwner);
      tfTextBox :
        fControl := TmTextBox.Create(fOwner);
    end;

  Result := fControl;
end;

{ TmFieldCtrlList }

function TmFieldCtrlList.Add: TmFieldCtrl;
begin
  Result := TmFieldCtrl.Create(nil, nil);
  Self.Add(Result);
end;

function TmFieldCtrlList.GetItem(Index: Integer): TmFieldCtrl;
begin
  Result := TmFieldCtrl(Self[Index]);
end;

procedure TmFieldCtrlList.SetItem(Index: Integer;
  const Value: TmFieldCtrl);
begin
  Self[Index] := Value;
end;

end.