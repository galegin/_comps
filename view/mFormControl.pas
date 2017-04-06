unit mFormControl;

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Graphics,
  mOrientacaoFrame, mFrame, mPanel, mGrade,
  mLabel, mButton, mComboBox, mCheckBox, mTextBox, mKeyValue,
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

    class procedure SetEstilo(
      AControl :  TControl);

    class function GetOrientacao(
      AControl :  TControl) : TOrientacaoFrame;

    class function GetLastControl(
      AControl :  TWinControl) : TControl;

    class procedure SetInitial(
      AControl :  TControl);

    class procedure SetSize(
      AControl :  TControl);

  published
  end;

implementation

uses
  mControl, mTipoEstilo;

{ TmFormControl }

class function TmFormControl.AddFrame;
begin
  Result := TmFrame.Create(AOwner);
  with Result do begin
    Name := TmControl.NewComponentName(AOwner, '_Frame');
    Parent := AParent;
    Orientacao := AOrientacao;
    case Orientacao of
      toHorizontal : begin
        Align := alTop;
        Height := 0;
      end;
    end;
  end;

  SetInitial(Result);
end;

class function TmFormControl.AddPanel;
begin
  Result := TmPanel.Create(AOwner);
  with Result do begin
    Name := TmControl.NewComponentName(AOwner, '_Panel');
    Parent := AParent;
    Orientacao := AOrientacao;
    Align := alTop;
    Height := 0;
  end;

  SetInitial(Result);
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

  SetEstilo(Result);
  SetSize(Result);
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

  SetEstilo(Result);
  SetSize(Result);
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

  SetEstilo(Result);
  SetSize(Result);
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

  SetEstilo(Result);
  SetSize(Result);
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

  SetEstilo(Result);
  SetSize(Result);
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

  SetEstilo(Result);
  SetSize(Result);
end;

//--

class procedure TmFormControl.SetEstilo;
var
  vEstilo : RTipoEstilo;
begin
  vEstilo := GetTipoEstiloFromClass(AControl);
  if vEstilo.Tipo = TTipoEstilo(Ord(-1)) then
    Exit;

  with AControl do begin
    Height := vEstilo.Altura;
    Width := vEstilo.Largura;

    if vEstilo.Requerido then
      if (AControl is TLabel) then begin
        with (AControl as TLabel) do
          Font.Style := Font.Style + [fsBold];
      end
      else if (AControl is TButton) then
        with (AControl as TButton) do
          Font.Style := Font.Style + [fsBold];
  end;
end;

//--

class function TmFormControl.GetOrientacao;
begin
  Result := toVertical;
  if (AControl is TmFrame) then begin
    with (AControl as TmFrame) do
      Result := Orientacao;
  end
  else if (AControl is TmPanel) then
    with (AControl as TmPanel) do
      Result := Orientacao;
end;

//--

class function TmFormControl.GetLastControl;
begin
  with AControl do
    if ControlCount > 1 then
      Result := Controls[ControlCount - 2]
    else
      Result := nil;
end;

//--

class procedure TmFormControl.SetInitial;
var
  vOrientacaoFrame : TOrientacaoFrame;
begin
  vOrientacaoFrame := GetOrientacao(AControl);

  with AControl do
    case vOrientacaoFrame of
      toHorizontal : begin
        //Align := alTop;
        Top := 0; //Parent.Height;
        Height := 0;
      end;
      toVertical : begin
        //Align := alLeft;
        Left := 0;
        Width := 0;
      end;
    end;

end;

class procedure TmFormControl.SetSize;
const
  iREC = 4;
var
  vOrientacaoFrame : TOrientacaoFrame;
  vLastControl : TControl;
  vParent : TWinControl;
begin
  vOrientacaoFrame := GetOrientacao(AControl.Parent);
  vLastControl := GetLastControl(AControl.Parent);
  vParent := AControl.Parent;

  with AControl do begin
    case vOrientacaoFrame of
      toHorizontal : begin
        Top := iREC;

        if Assigned(vLastControl) then begin
          Left := (vLastControl.Left + vLastControl.Width) + iREC;
        end else begin
          Left := iREC;
        end;

        vParent.Height := (Height + iREC);
        vParent.Width := vParent.Width + (Top + Height);

      end;

      toVertical : begin
        Left := iREC;

        if Assigned(vLastControl) then begin
          Top := (vLastControl.Top + vLastControl.Height) + iREC;
        end else begin
          Top := iREC;
        end;

        vParent.Height := vParent.Height + (Height + iREC);
        vParent.Width := vParent.Width + (Top + Height);

      end;

    end;

  end;

end;

end.
