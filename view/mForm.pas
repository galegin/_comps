unit mForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StrUtils, ComCtrls, StdCtrls, ExtCtrls, DB,
  mFormIntf, mOrientacaoFrame, mTipoCampo, mFrame, mPanel, mGrade, mLabel,
  mButton, mCheckBox, mComboBox, mTextBox, mKeyValue;

type
  TmForm = class(TForm, TmFormIntf)
  private
  protected
  public
    constructor Create(Aowner : TComponent); override;

    function AddFrame(
      AOrientacao : TOrientacaoFrame) : TmFrame;

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
      ATipo : TTipoCampo) : TmTextBox;
  published

  end;

implementation

{$R *.dfm}

uses
  mFormControl;

{ TmForm }

constructor TmForm.Create(Aowner: TComponent);
begin
  inherited; //

end;

//--

function TmForm.AddFrame;
begin
  Result := TmFormControl.AddFrame(Owner, Self, AOrientacao);
end;

function TmForm.AddPanel;
begin
  Result := TmFormControl.AddPanel(Owner, Self, AOrientacao);
end;

function TmForm.AddGrade;
begin
  Result := TmFormControl.AddGrade(Owner, Self, ACollection);
end;

function TmForm.AddLabel;
begin
  Result := TmFormControl.AddLabel(Owner, Self, ALargura, ADescricao);
end;

function TmForm.AddButton;
begin
  Result := TmFormControl.AddButton(Owner, Self, ALargura, ADescricao);
end;

function TmForm.AddCheckBox;
begin
  Result := TmFormControl.AddCheckBox(Owner, Self, ALargura, AEntidade, ACampo);
end;

function TmForm.AddComboBox;
begin
  Result := TmFormControl.AddComboBox(Owner, Self, ALargura, AEntidade, ACampo, ALista);
end;

function TmForm.AddTextBox;
begin
  Result := TmFormControl.AddTextBox(Owner, Self, ALargura, AEntidade, ACampo, ATipo);
end;

end.
