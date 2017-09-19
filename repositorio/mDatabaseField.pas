unit mDatabaseField;

(* mDatabaseField *)

interface

uses
  Classes, SysUtils, StrUtils;

type
  TmDatabaseField = class(TComponent)
  private
    Fp_relation_name: String;
    Fp_field_name: String;
    procedure Setp_field_name(const Value: String);
    procedure Setp_relation_name(const Value: String);
  protected
  public
  published
    property p_relation_name: String read Fp_relation_name write Setp_relation_name;
    property p_field_name: String read Fp_field_name write Setp_field_name;
  end;

implementation

{ TmDatabaseField }

procedure TmDatabaseField.Setp_field_name(const Value: String);
begin
  Fp_field_name := Value;
end;

procedure TmDatabaseField.Setp_relation_name(const Value: String);
begin
  Fp_relation_name := Value;
end;

end.