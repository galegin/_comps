unit mControl;

interface

uses
  Classes, SysUtils, Controls, StdCtrls,
  mValue;

type
  TmControl = class
  public
    class function GetValues(AControl : TControl) : TmValueList;
    class procedure SetValues(AControl : TControl; AValues : TmValueList);
    class function NewControlName(AControl: TWinControl; AName: String): String;
    class function ControlNameExists(AControl: TWinControl; AName: String): Boolean;
    class function NewComponentName(AComponent: TComponent; AName: String): String;
    class function ComponentNameExists(AComponent: TComponent; AName: String): Boolean;
  end;

implementation

{ TmControl }

class function TmControl.GetValues(AControl: TControl): TmValueList;
var
  I : Integer;
begin
  Result := TmValueList.Create;

  with AControl do begin
    for I := 0 to ComponentCount - 1 do begin

      if Components[I] is TCheckBox then begin
        Result.AddB(Name, (Components[I] as TCheckBox).Checked);

      end else if Components[I] is TComboBox then begin
        Result.AddI(Name, (Components[I] as TComboBox).ItemIndex);

      end else if Components[I] is TEdit then begin
        case TTipoValue(Tag) of
          tvDateTime : begin
            Result.AddD(Name, StrToDateTimeDef((Components[I] as TEdit).Text, 0));
          end;
          tvFloat : begin
            Result.AddF(Name, StrToFloatDef((Components[I] as TEdit).Text, 0));
          end;
          tvInteger : begin
            Result.AddI(Name, StrToIntDef((Components[I] as TEdit).Text, 0));
          end;
        else
          Result.AddS(Name, (Components[I] as TEdit).Text);
        end;

      end else if Components[I] is TListBox then begin
        Result.AddI(Name, (Components[I] as TListBox).ItemIndex);

      end else if Components[I] is TMemo then begin
        Result.AddS(Name, (Components[I] as TMemo).Text);

      end else if Components[I] is TRadioButton then begin
        Result.AddB(Name, (Components[I] as TRadioButton).Checked);

      end;
    end;
  end;
end;

class procedure TmControl.SetValues(AControl: TControl; AValues: TmValueList);
var
  vValue : TmValue;
  I : Integer;
begin
  with AControl do begin
    for I := 0 to ComponentCount - 1 do begin

      if Components[I] is TCheckBox then begin
        with (Components[I] as TCheckBox) do begin
          vValue := AValues.IndexOf(Name);
          if (vValue is TmValueBool) then
            Checked := (vValue as TmValueBool).Value;
        end;

      end else if Components[I] is TComboBox then begin
        with (Components[I] as TComboBox) do begin
          vValue := AValues.IndexOf(Name);
          if (vValue is TmValueInt) then
            ItemIndex := (vValue as TmValueInt).Value;
        end;

      end else if Components[I] is TEdit then begin
        with (Components[I] as TEdit) do begin
          vValue := AValues.IndexOf(Name);
          if (vValue is TmValue) then begin
            case TTipoValue(Tag) of
              tvDateTime : Text := vValue.ValueStr;
              tvFloat : Text := vValue.ValueStr;
              tvInteger : Text := vValue.ValueStr;
            else
              Text := vValue.ValueStr;
            end;
          end;
        end;

      end else if Components[I] is TListBox then begin
        with (Components[I] as TListBox) do begin
          vValue := AValues.IndexOf(Name);
          if (vValue is TmValueInt) then
            ItemIndex := (vValue as TmValueInt).Value;
        end;

      end else if Components[I] is TMemo then begin
        with (Components[I] as TMemo) do begin
          vValue := AValues.IndexOf(Name);
          if (vValue is TmValueStr) then
            Text := (vValue as TmValueStr).Value;
        end;

      end else if Components[I] is TRadioButton then begin
        with (Components[I] as TRadioButton) do begin
          vValue := AValues.IndexOf(Name);
          if (vValue is TmValueBool) then
            Checked := (vValue as TmValueBool).Value;
        end;

      end;
    end;
  end;
end;

//--

class function TmControl.NewControlName(AControl: TWinControl; AName: String): String;
var X : Integer;
begin
  X := 0;
  repeat
    Inc(X);
    Result := AName + IntToStr(X);
  until not ControlNameExists(AControl, Result);
end;

class function TmControl.ControlNameExists(AControl: TWinControl; AName: String): Boolean;
var X : Integer;
begin
  Result := False;
  with AControl do begin
    for X := 0 to ControlCount-1 do begin
      if UpperCase(Controls[X].Name) = UpperCase(AName) then begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

//--

class function TmControl.NewComponentName(AComponent: TComponent; AName: String): String;
var X : Integer;
begin
  X := 0;
  repeat
    Inc(X);
    Result := AName + IntToStr(X);
  until not ComponentNameExists(AComponent, Result);
end;

class function TmControl.ComponentNameExists(AComponent: TComponent; AName: String): Boolean;
var X : Integer;
begin
  Result := False;
  with AComponent do begin
    for X := 0 to ComponentCount-1 do begin
      if UpperCase(Components[X].Name) = UpperCase(AName) then begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

end.