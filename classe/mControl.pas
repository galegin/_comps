unit mControl;

interface

uses
  Classes, SysUtils, Controls, StdCtrls,
  mProperty;

type
  TmControl = class
  public
    class function GetValues(AControl : TControl) : TmPropertyList;
    class procedure SetValues(AControl : TControl; AValues : TmPropertyList);
  end;

implementation

{ TmControl }

class function TmControl.GetValues(AControl: TControl): TmPropertyList;
var
  I : Integer;
begin
  Result := TmPropertyList.Create;

  with AControl do begin
    for I := 0 to ComponentCount - 1 do begin

      if Components[I] is TCheckBox then begin
        with Result.Adicionar, (Components[I] as TCheckBox) do begin
          Nome := Name;
          Tipo := tppBoolean;
          ValueBoolean := Checked;
        end;

      end else if Components[I] is TComboBox then begin
        with Result.Adicionar, (Components[I] as TComboBox) do begin
          Nome := Name;
          Tipo := tppInteger;
          ValueInteger := ItemIndex;
        end;

      end else if Components[I] is TEdit then begin
        with Result.Adicionar, (Components[I] as TEdit) do begin
          Nome := Name;
          case TpProperty(Tag) of
            tppDateTime : begin
              Tipo := tppDateTime;
              ValueDateTime := StrToDateTimeDef(Text, 0);
            end;
            tppFloat : begin
              Tipo := tppFloat;
              ValueFloat := StrToFloatDef(Text, 0);
            end;
            tppInteger : begin
              Tipo := tppInteger;
              ValueInteger := StrToIntDef(Text, 0);
            end;
          else
            Tipo := tppString;
            ValueString := Text;
          end;
        end;

      end else if Components[I] is TListBox then begin
        with Result.Adicionar, (Components[I] as TListBox) do begin
          Nome := Name;
          Tipo := tppInteger;
          ValueInteger := ItemIndex;
        end;

      end else if Components[I] is TMemo then begin
        with Result.Adicionar, (Components[I] as TMemo) do begin
          Nome := Name;
          Tipo := tppString;
          ValueString := Text;
        end;

      end else if Components[I] is TRadioButton then begin
        with Result.Adicionar, (Components[I] as TRadioButton) do begin
          Nome := Name;
          Tipo := tppBoolean;
          ValueBoolean := Checked;
        end;

      end;
    end;
  end;
end;

class procedure TmControl.SetValues(AControl: TControl; AValues: TmPropertyList);
var
  vValue : TmProperty;
  I : Integer;
begin
  with AControl do begin
    for I := 0 to ComponentCount - 1 do begin

      if Components[I] is TCheckBox then begin
        with (Components[I] as TCheckBox) do begin
          vValue := AValues.IndexOf(Name);
          if Assigned(vValue) then
            Checked := vValue.ValueBoolean;
        end;

      end else if Components[I] is TComboBox then begin
        with (Components[I] as TComboBox) do begin
          vValue := AValues.IndexOf(Name);
          if Assigned(vValue) then
            ItemIndex := vValue.ValueInteger;
        end;

      end else if Components[I] is TEdit then begin
        with (Components[I] as TEdit) do begin
          vValue := AValues.IndexOf(Name);
          if Assigned(vValue) then begin
            case TpProperty(Tag) of
              tppDateTime : Text := DateTimeToStr(vValue.ValueDateTime);
              tppFloat : Text := FloatToStr(vValue.ValueFloat);
              tppInteger : Text := IntToStr(vValue.ValueInteger);
            else
              Text := vValue.ValueString;
            end;
          end;
        end;

      end else if Components[I] is TListBox then begin
        with (Components[I] as TListBox) do begin
          vValue := AValues.IndexOf(Name);
          if Assigned(vValue) then
            ItemIndex := vValue.ValueInteger;
        end;

      end else if Components[I] is TMemo then begin
        with (Components[I] as TMemo) do begin
          vValue := AValues.IndexOf(Name);
          if Assigned(vValue) then
            Text := vValue.ValueString;
        end;

      end else if Components[I] is TRadioButton then begin
        with (Components[I] as TRadioButton) do begin
          vValue := AValues.IndexOf(Name);
          if Assigned(vValue) then
            Checked := vValue.ValueBoolean;
        end;

      end;
    end;
  end;
end;

end.