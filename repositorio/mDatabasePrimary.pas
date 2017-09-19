unit mDatabasePrimary;

(* mDatabasePrimary *)

interface

uses
  Classes, SysUtils, StrUtils;

type
  TmDatabasePrimary = class(TComponent)
  private
    Fp_field_name: String;
    Fp_relation_name: String;
    Fp_constraint_name: String;
    procedure Setp_constraint_name(const Value: String);
    procedure Setp_field_name(const Value: String);
    procedure Setp_relation_name(const Value: String);
  protected
  public
  published
    property p_constraint_name: String read Fp_constraint_name write Setp_constraint_name;
    property p_relation_name: String read Fp_relation_name write Setp_relation_name;
    property p_field_name: String read Fp_field_name write Setp_field_name;
  end;

implementation

{ TmDatabasePrimary }

procedure TmDatabasePrimary.Setp_constraint_name(const Value: String);
begin
  Fp_constraint_name := Value;
end;

procedure TmDatabasePrimary.Setp_field_name(const Value: String);
begin
  Fp_field_name := Value;
end;

procedure TmDatabasePrimary.Setp_relation_name(const Value: String);
begin
  Fp_relation_name := Value;
end;

end.