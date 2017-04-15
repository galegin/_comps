unit mForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StrUtils, ComCtrls, StdCtrls, ExtCtrls, DB,
  mFormIntf, mOrientacaoFrame, mFrame, mPanel, mGrade, mLabel,
  mButton, mCheckBox, mComboBox, mTextBox, mKeyValue, mTipoFormato, mValue;

type
  TmForm = class(TForm, IForm)
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
      ATipo : TTipoValue;
      AFormato : TTipoFormato) : TmTextBox;
  published

  end;

implementation

{$R *.dfm}

uses
  mFormCtrl;

{ TmForm }

constructor TmForm.Create(Aowner: TComponent);
begin
  inherited; //

end;

//--

function TmForm.AddFrame;
begin
  Result := TmFormCtrl.AddFrame(Owner, Self, AOrientacao);
end;

function TmForm.AddPanel;
begin
  Result := TmFormCtrl.AddPanel(Owner, Self, AOrientacao);
end;

function TmForm.AddGrade;
begin
  Result := TmFormCtrl.AddGrade(Owner, Self, ACollection);
end;

function TmForm.AddLabel;
begin
  Result := TmFormCtrl.AddLabel(Owner, Self, ALargura, ADescricao);
end;

function TmForm.AddButton;
begin
  Result := TmFormCtrl.AddButton(Owner, Self, ALargura, ADescricao);
end;

function TmForm.AddCheckBox;
begin
  Result := TmFormCtrl.AddCheckBox(Owner, Self, ALargura, AEntidade, ACampo);
end;

function TmForm.AddComboBox;
begin
  Result := TmFormCtrl.AddComboBox(Owner, Self, ALargura, AEntidade, ACampo, ALista);
end;

function TmForm.AddTextBox;
begin
  Result := TmFormCtrl.AddTextBox(Owner, Self, ALargura, AEntidade, ACampo, ATipo, AFormato);
end;

end.
