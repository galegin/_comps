unit mControlIntf;

interface

uses
  Classes,
  mOrientacaoFrame, mPanel, mGrade, mLabel, mButton,
  mCheckBox, mComboBox, mTextBox, mKeyValue, mValue, mTipoFormato;

type
  TmControlIntf = interface
    ['{5F6224AB-D18E-4D9A-90AD-F48479A8819E}']

    function AddPanel(
      AOrientacao : TOrientacaoFrame) : TmPanel;

    function AddGrade(
      ACollection : TCollection) : TmGrade;

    function AddLabel(
      ALargura : Integer;
      ADescricao : String) : TmLabel;

    function AddButton(
      ALargura : Integer;
      ADescricao : String) : TmButton;

    function AddCheckBox(
      ALargura : Integer;
      AEntidade : TCollectionItem;
      ACampo : String) : TmCheckBox;

    function AddComboBox(
      ALargura : Integer;
      AEntidade : TCollectionItem;
      ACampo : String;
      ALista : Array Of TmKeyValue) : TmComboBox;

    function AddTextBox(
      ALargura : Integer;
      AEntidade : TCollectionItem;
      ACampo : String;
      ATipo : TTipoValue;
      AFormato : TTipoFormato) : TmTextBox;
  end;

implementation

end.