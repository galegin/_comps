unit mFieldCtrl;

interface

uses
  Classes, Controls, StdCtrls, Grids,
  mTipoBinding, mTipoEstilo, mTipoMarging, mTipoPosition;

type
  TTipoField = (
    tfButton,
    tfCheckBox,
    tfComboBox,
    tfEdit,
    //tfGrid,
    tfLabel,
    tfMemo);

  RTipoField = record
    Tipo : TTipoField;
    Nome : String;
    Content : String;
    Text : String;
    //--
    Estilo : TTipoEstilo;
    Binding : RTipoBinding;
    Marging : RTipoMarging;
    Position : RTipoPosition;
    //--
    Click : TNotifyEvent;
    DblClick : TNotifyEvent;
    Enter : TNotifyEvent;
    Exit : TNotifyEvent;
    KeyDown : TKeyEvent;
    KeyPress : TKeyPressEvent;
    //--
    ControlClasse : TControlClass;
    Control : TControl;
  end;

  function GetClasseTipoField(const t : TTipoField) : TControlClass;

implementation

function GetClasseTipoField;
begin
  case t of
    tfButton : Result := TButton;
    tfCheckBox : Result := TCheckBox;
    tfComboBox : Result := TComboBox;
    tfEdit : Result := TEdit;
    //tfGrid : Result := TGrid;
    tfLabel : Result := TLabel;
    tfMemo : Result := TMemo;
  else
    Result := TEdit;
  end;
end;

end.