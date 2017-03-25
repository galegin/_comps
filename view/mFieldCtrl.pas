unit mFieldCtrl;

interface

uses
  Classes, Controls, StdCtrls, ExtCtrls, ComCtrls, Forms,
  mTipoBinding, mTipoEstilo, mTipoMarging, mTipoPosition;

type
  TTipoField = (
    tfPanel,
    tfFrame,
    tfGrade,
    tfLabel,
    tfButton,
    tfCheckBox,
    tfComboBox,
    tfTextBox);

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
    tfPanel : Result := TPanel;
    tfFrame : Result := TFrame;
    tfGrade : Result := TListView;
    tfLabel : Result := TLabel;
    tfButton : Result := TButton;
    tfCheckBox : Result := TCheckBox;
    tfComboBox : Result := TComboBox;
    tfTextBox : Result := TEdit;
  else
    Result := TEdit;
  end;
end;

end.