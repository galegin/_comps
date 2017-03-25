unit mFieldControl;

interface

uses
  Classes, Controls, StdCtrls,
  mFieldCtrl, mProperty, mTipoPosition, mTipoMarging;

type
  RTipoFieldArray = Array Of RTipoField;

  TmFieldControl = class
  public
    class procedure SetControls(AControl : TControl; AFields : RTipoFieldArray);

    class procedure SetPosition(AControl : TControl; APosition : RTipoPosition);
    class procedure SetMarging(AControl : TControl; AMarging : RTipoMarging);

    class procedure SetFrame(AField : RTipoField);
    class procedure SetPanel(AField : RTipoField);
    class procedure SetGrade(AField : RTipoField);
    class procedure SetLabel(AField : RTipoField);
    class procedure SetButton(AField : RTipoField);
    class procedure SetCheckBox(AField : RTipoField);
    class procedure SetComboBox(AField : RTipoField);
    class procedure SetTextBox(AField : RTipoField);

    class function GetValues(AControl : TControl; AFields : RTipoFieldArray) : TmPropertyList;
    class procedure SetValues(AControl : TControl; AFields : RTipoFieldArray; AValues : TmPropertyList);
  end;

implementation

uses
  mTipoBinding,
  mFrame, mPanel, mGrade,
  mLabel, mButton, mCheckBox, mComboBox, mTextBox;

{ TmFieldControl }

class procedure TmFieldControl.SetControls;
var
  I : Integer;
begin
  for I := Ord(Low(AFields)) to Ord(High(AFields)) do begin
    with AFields[I] do begin
      ControlClasse := GetClasseTipoField(Tipo);
      Control := TControlClass(ControlClasse).Create(AControl);

      case Tipo of
        tfFrame : SetFrame(AFields[I]);
        tfPanel : SetPanel(AFields[I]);
        tfGrade : SetGrade(AFields[I]);
        tfLabel : SetLabel(AFields[I]);
        tfButton : SetButton(AFields[I]);
        tfCheckBox : SetCheckBox(AFields[I]);
        tfComboBox : SetComboBox(AFields[I]);
        tfTextBox : SetTextBox(AFields[I]);
      end;
    end;
  end;
end;

//--

class procedure TmFieldControl.SetPosition;
begin
  with AControl do begin
    Top := APosition.Top;
    Left := APosition.Left;
    Height := APosition.Height;
    Width := APosition.Width;
  end;
end;

class procedure TmFieldControl.SetMarging;
begin
  with AControl do begin
    Top := Top + AMarging.Top;
    Left := Left + AMarging.Left;
    Height := Height - (AMarging.Right + AMarging.Top);
    Width := Width - (AMarging.Bottom + AMarging.Left);
  end;
end;

//--

class procedure TmFieldControl.SetFrame;
begin
  if (AField.Control is TmFrame) then
    with (AField.Control as TmFrame) do begin
      Name := AField.Nome;
      //Caption := AField.Content;
      //OnClick := AField.Click;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

class procedure TmFieldControl.SetPanel;
begin
  if (AField.Control is TmPanel) then
    with (AField.Control as TmPanel) do begin
      Name := AField.Nome;
      //Caption := AField.Content;
      //OnClick := AField.Click;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

class procedure TmFieldControl.SetGrade;
begin
  if (AField.Control is TmGrade) then
    with (AField.Control as TmGrade) do begin
      Name := AField.Nome;
      //Caption := AField.Content;
      //OnClick := AField.Click;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

//--

class procedure TmFieldControl.SetLabel;
begin
  if (AField.Control is TmLabel) then
    with (AField.Control as TmLabel) do begin
      Name := AField.Nome;
      Caption := AField.Content;
      OnClick := AField.Click;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

class procedure TmFieldControl.SetButton;
begin
  if (AField.Control is TmButton) then
    with (AField.Control as TmButton) do begin
      Name := AField.Nome;
      Caption := AField.Content;
      OnClick := AField.Click;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

class procedure TmFieldControl.SetCheckBox;
begin
  if (AField.Control is TmCheckBox) then
    with (AField.Control as TmCheckBox) do begin
      Name := AField.Nome;
      Caption := AField.Content;
      OnClick := AField.Click;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

class procedure TmFieldControl.SetComboBox;
begin
  if (AField.Control is TmComboBox) then
    with (AField.Control as TmComboBox) do begin
      Name := AField.Nome;
      OnClick := AField.Click;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

class procedure TmFieldControl.SetTextBox;
begin
  if (AField.Control is TmTextBox) then
    with (AField.Control as TmTextBox) do begin
      Name := AField.Nome;
      OnClick := AField.Click;
      OnDblClick := AField.DblClick;
      OnEnter := AField.Enter;
      OnExit := AField.Exit;
      OnKeyDown := AField.KeyDown;
      OnKeyPress := AField.KeyPress;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

//--

class function TmFieldControl.GetValues;
var
  I : Integer;
begin
  Result := TmPropertyList.Create;

  for I := Ord(Low(AFields)) to Ord(High(AFields)) do begin
    with AFields[I] do begin

      if Assigned(Binding.Entidade) then begin
        with Result.Add do begin

          Nome := Binding.Campo;

          case AFields[I].Tipo of
            mFieldCtrl.tfCheckBox : begin
              Tipo := tppBoolean;
              ValueBoolean := (Control as TmCheckBox).Checked;
            end;
            mFieldCtrl.tfComboBox : begin
              Tipo := tppInteger;
              ValueInteger := (Control as TmComboBox).ItemIndex;
            end;
            mFieldCtrl.tfTextBox : begin
              Tipo := tppBoolean;
              ValueString := (Control as TmTextBox)._Value;
            end;
          end;
          
        end;
      end;

    end;
  end;

end;

class procedure TmFieldControl.SetValues;
var
  vValue : TmProperty;
  I : Integer;
begin
  for I := Ord(Low(AFields)) to Ord(High(AFields)) do begin
    with AFields[I] do begin

      if Assigned(Binding.Entidade) then begin

        vValue := AValues.IndexOf(Binding.Campo);

        case AFields[I].Tipo of
          mFieldCtrl.tfCheckBox :
            (Control as TmCheckBox).Checked := vValue.ValueBoolean;
          mFieldCtrl.tfComboBox :
            (Control as TmComboBox).ItemIndex := vValue.ValueInteger;
          mFieldCtrl.tfTextBox :
            (Control as TmTextBox)._Value := vValue.ValueString;
        end;

      end;

    end;
  end;

end;

end.