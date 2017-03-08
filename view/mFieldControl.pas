unit mFieldControl;

interface

uses
  Classes, Controls, StdCtrls,
  mField, mProperty, mTipoPosition, mTipoMarging;

type
  RTipoFieldArray = Array Of RTipoField;

  TmFieldControl = class
  public
    class procedure SetControls(AControl : TControl; AFields : RTipoFieldArray);

    class procedure SetPosition(AControl : TControl; APosition : RTipoPosition);
    class procedure SetMarging(AControl : TControl; AMarging : RTipoMarging);

    class procedure SetButton(AField : RTipoField);
    class procedure SetEdit(AField : RTipoField);
    class procedure SetCheckBox(AField : RTipoField);
    class procedure SetComboBox(AField : RTipoField);
    class procedure SetLabel(AField : RTipoField);
    class procedure SetMemo(AField : RTipoField);

    class function GetValues(AControl : TControl; AFields : RTipoFieldArray) : TmPropertyList;
    class procedure SetValues(AControl : TControl; AFields : RTipoFieldArray; AValues : TmPropertyList);
  end;

implementation

uses mTipoBinding;

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
        tfButton : SetButton(AFields[I]);
        tfCheckBox : SetCheckBox(AFields[I]);
        tfComboBox : SetComboBox(AFields[I]);
        tfEdit : SetEdit(AFields[I]);
        tfLabel : SetLabel(AFields[I]);
        tfMemo : SetMemo(AFields[I]);
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

class procedure TmFieldControl.SetButton;
begin
  if (AField.Control is TButton) then
    with (AField.Control as TButton) do begin
      Name := AField.Nome;
      Caption := AField.Content;
      OnClick := AField.Click;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

class procedure TmFieldControl.SetCheckBox;
begin
  if (AField.Control is TCheckBox) then
    with (AField.Control as TCheckBox) do begin
      Name := AField.Nome;
      Caption := AField.Content;
      OnClick := AField.Click;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

class procedure TmFieldControl.SetComboBox;
begin
  if (AField.Control is TComboBox) then
    with (AField.Control as TComboBox) do begin
      Name := AField.Nome;
      OnClick := AField.Click;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

class procedure TmFieldControl.SetEdit;
begin
  if (AField.Control is TEdit) then
    with (AField.Control as TEdit) do begin
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

class procedure TmFieldControl.SetLabel;
begin
  if (AField.Control is TLabel) then
    with (AField.Control as TLabel) do begin
      Name := AField.Nome;
      Caption := AField.Content;
      OnClick := AField.Click;
      SetPosition(AField.Control, AField.Position);
      SetMarging(AField.Control, AField.Marging);
    end;
end;

class procedure TmFieldControl.SetMemo;
begin
  if (AField.Control is TMemo) then
    with (AField.Control as TMemo) do begin
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
        with Result.Adicionar do begin

          Nome := Binding.Campo;

          case AFields[I].Tipo of
            mField.tfCheckBox : begin
              Tipo := tppBoolean;
              ValueBoolean := (Control as TCheckBox).Checked;
            end;
            mField.tfComboBox : begin
              Tipo := tppInteger;
              ValueInteger := (Control as TComboBox).ItemIndex;
            end;
            mField.tfEdit : begin
              Tipo := tppBoolean;
              ValueString := (Control as TEdit).Text;
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
          mField.tfCheckBox :
            (Control as TCheckBox).Checked := vValue.ValueBoolean;
          mField.tfComboBox :
            (Control as TComboBox).ItemIndex := vValue.ValueInteger;
          mField.tfEdit :
            (Control as TEdit).Text := vValue.ValueString;
        end;

      end;

    end;
  end;

end;

end.