unit mFormControl;

interface

uses
  Classes, SysUtils, Forms,
  mFrame, mPanel, mGrade,
  mLabel, mButton, mComboBox, mCheckBox, mTextBox,
  mCollectionItem, mTipoCampo, mFieldControl;

type
  TTipoOrientacao = (toHorizontal, toVertical);

  RComboBox = record
    Value : String;
    Display : String;
  end;

  TmFormControl = class(TForm)
  private
  protected
  public
    function AddFrame(AOrientacao : TTipoOrientacao) : TmFrame;

    function AddPanel(AOrientacao : TTipoOrientacao) : TmPanel;

    function AddGrade(AOrientacao : TTipoOrientacao) : TmGrade;

    function AddLabel(ALargura : Integer; ADescricao : String) : TmLabel;

    function AddButton(ALargura : Integer; ADescricao : String) : TmButton;

    function AddCheckBox(ALargura : Integer; AEntidade : TmCollectionItem;
      AAtributo : String) : TmCheckBox;
    function AddComboBox(ALargura : Integer; AEntidade : TmCollectionItem;
      AAtributo : String; ALista : Array Of RComboBox) : TmComboBox;
    function AddTextBox(ALargura : Integer; AEntidade : TmCollectionItem;
      AAtributo : String; ATipoCampo : TTipoCampo) : TmTextBox;
  published
  end;

implementation

{ TmFormControl }

function TmFormControl.AddFrame;
begin
  Result := TmFrame.create(Owner);
end;

function TmFormControl.AddPanel;
begin
  Result := TmPanel.create(Owner);
end;

//--

function TmFormControl.AddGrade;
begin
  Result := TmGrade.create(Owner);
end;

//--

function TmFormControl.AddLabel;
begin
  Result := TmLabel.create(Owner);
end;

function TmFormControl.AddButton;
begin
  Result := TmButton.create(Owner);
end;

//--

function TmFormControl.AddCheckBox;
begin
  Result := TmCheckBox.create(Owner);
end;

function TmFormControl.AddComboBox;
begin
  Result := TmComboBox.create(Owner);
end;

function TmFormControl.AddTextBox;
begin
  Result := TmTextBox.create(Owner);
end;

end.
