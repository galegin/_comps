unit mFieldControl;

interface

uses
  Classes, Controls, StdCtrls,
  mFieldCtrl, mValue, mTipoPosition, mTipoMarging;

type
  TmFieldControl = class
  public
    class procedure SetControls(AControl : TControl; AFields : TmFieldCtrlList);

    class procedure SetPosition(AControl : TControl; APosition : RTipoPosition);
    class procedure SetMarging(AControl : TControl; AMarging : RTipoMarging);

    class procedure SetFrame(AField : TmFieldCtrl);
    class procedure SetPanel(AField : TmFieldCtrl);
    class procedure SetGrade(AField : TmFieldCtrl);
    class procedure SetLabel(AField : TmFieldCtrl);
    class procedure SetButton(AField : TmFieldCtrl);
    class procedure SetCheckBox(AField : TmFieldCtrl);
    class procedure SetComboBox(AField : TmFieldCtrl);
    class procedure SetTextBox(AField : TmFieldCtrl);

    class function GetValues(AControl : TControl; AFields : TmFieldCtrlList) : TmValueList;
    class procedure SetValues(AControl : TControl; AFields : TmFieldCtrlList; AValues : TmValueList);
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
  with AFields do
    for I := 0 to Count - 1 do
      case Items[I].Tipo of
        tfFrame : SetFrame(Items[I]);
        tfPanel : SetPanel(Items[I]);
        tfGrade : SetGrade(Items[I]);
        tfLabel : SetLabel(Items[I]);
        tfButton : SetButton(Items[I]);
        tfCheckBox : SetCheckBox(Items[I]);
        tfComboBox : SetComboBox(Items[I]);
        tfTextBox : SetTextBox(Items[I]);
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
      Caption := AField.Descricao;
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
      Caption := AField.Descricao;
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
      Caption := AField.Descricao;
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
  Result := TmValueList.Create;

  for I := 0 to AFields.Count - 1 do begin
    with AFields.Items[I] do begin

      if Assigned(Binding.Entidade) then begin

        case AFields.Items[I].Tipo of
          mFieldCtrl.tfCheckBox : begin
            Result.Add(TmValueBool.Create(Binding.Campo, (Control as TmCheckBox).Checked));
          end;
          mFieldCtrl.tfComboBox : begin
            Result.Add(TmValueInt.Create(Binding.Campo, (Control as TmComboBox).ItemIndex));
          end;
          mFieldCtrl.tfTextBox : begin
            Result.Add(TmValueStr.Create(Binding.Campo, (Control as TmTextBox)._Value));
          end;
        end;

      end;

    end;
  end;

end;

class procedure TmFieldControl.SetValues;
var
  vValue : TmValue;
  I : Integer;
begin
  for I := 0 to AFields.Count - 1 do begin
    with AFields.Items[I] do begin

      if Assigned(Binding.Entidade) then begin

        vValue := AValues.IndexOf(Binding.Campo);

        case AFields.Items[I].Tipo of
          mFieldCtrl.tfCheckBox :
            (Control as TmCheckBox).Checked := (vValue as TmValueBool).Value;
          mFieldCtrl.tfComboBox :
            (Control as TmComboBox).ItemIndex := (vValue as TmValueInt).Value;
          mFieldCtrl.tfTextBox :
            (Control as TmTextBox)._Value := (vValue as TmValueStr).Value;
        end;

      end;

    end;
  end;

end;

end.