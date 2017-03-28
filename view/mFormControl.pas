unit mFormControl;

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls,
  mOrientacaoFrame, mFrame, mPanel, mGrade,
  mLabel, mButton, mComboBox, mCheckBox, mTextBox, mTipoCampo, mKeyValue,
  mTipoFormato, mValue;

type
  TmFormControl = class
  private
  protected
  public
    class function AddFrame(
      AOwner : TComponent;
      AParent : TWinControl;
      AOrientacao : TOrientacaoFrame) : TmFrame;

    class function AddPanel(
      AOwner : TComponent;
      AParent : TWinControl;
      AOrientacao : TOrientacaoFrame) : TmPanel;

    class function AddGrade(
      AOwner : TComponent;
      AParent : TWinControl;
      ACollection : TCollection) : TmGrade;

    class function AddLabel(
      AOwner : TComponent;
      AParent : TWinControl;
      ALargura : Integer;
      ADescricao : String) : TmLabel;

    class function AddButton(
      AOwner : TComponent;
      AParent : TWinControl;
      ALargura : Integer;
      ADescricao : String) : TmButton;

    class function AddCheckBox(
      AOwner : TComponent;
      AParent : TWinControl;
      ALargura : Integer;
      AEntidade : TCollectionItem;
      ACampo : String) : TmCheckBox;

    class function AddComboBox(
      AOwner : TComponent;
      AParent : TWinControl;
      ALargura : Integer;
      AEntidade : TCollectionItem;
      ACampo : String;
      ALista : Array Of TmKeyValue) : TmComboBox;

    class function AddTextBox(
      AOwner : TComponent;
      AParent : TWinControl;
      ALargura : Integer;
      AEntidade : TCollectionItem;
      ACampo : String;
      ATipo : TTipoValue;
      AFormato : TTipoFormato) : TmTextBox;

  published
  end;

implementation

uses
  mControl;

{ TmFormControl }

class function TmFormControl.AddFrame;
begin
  Result := TmFrame.Create(AOwner);
  with Result do begin
    Name := TmControl.NewComponentName(AOwner, '_Frame');
    Parent := AParent;
    Orientacao := AOrientacao;
  end;
end;

class function TmFormControl.AddPanel;
begin
  Result := TmPanel.Create(AOwner);
  with Result do begin
    Name := TmControl.NewComponentName(AOwner, '_Panel');
    Parent := AParent;
    Orientacao := AOrientacao;
  end;
end;

//--

class function TmFormControl.AddGrade;
begin
  Result := TmGrade.Create(AOwner);
  with Result do begin
    Name := TmControl.NewComponentName(AOwner, '_Grade');
    Parent := AParent;
    Collection := ACollection;
  end;
end;

//--

class function TmFormControl.AddLabel;
begin
  Result := TmLabel.Create(AOwner);
  with Result do begin
    Name := TmControl.NewComponentName(AOwner, '_Label');
    Parent := AParent;
    Width := ALargura;
    Caption := ADescricao;
  end;
end;

class function TmFormControl.AddButton;
begin
  Result := TmButton.Create(AOwner);
  with Result do begin
    Name := TmControl.NewComponentName(AOwner, '_Button');
    Parent := AParent;
    Width := ALargura;
    Caption := ADescricao;
  end;
end;

//--

class function TmFormControl.AddCheckBox;
begin
  Result := TmCheckBox.Create(AOwner);
  with Result do begin
    Name := TmControl.NewComponentName(AOwner, '_CheckBox');
    Parent := AParent;
    Width := ALargura;
    _Entidade := AEntidade;
    _Campo := ACampo;
  end;
end;

class function TmFormControl.AddComboBox;
begin
  Result := TmComboBox.Create(AOwner);
  with Result do begin
    Name := TmControl.NewComponentName(AOwner, '_ComboBox');
    Parent := AParent;
    Width := ALargura;
    _Entidade := AEntidade;
    _Campo := ACampo;
    SetListaArray(ALista);
  end;
end;

class function TmFormControl.AddTextBox;
begin
  Result := TmTextBox.Create(AOwner);
  with Result do begin
    Name := TmControl.NewComponentName(AOwner, '_TextBox');
    Parent := AParent;
    Width := ALargura;
    _Entidade := AEntidade;
    _Campo := ACampo;
    _Tipo := ATipo;
  end;
end;

end.
