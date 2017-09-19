unit mDatabaseConstraint;

(* mDatabaseConstraint *)

interface

uses
  Classes, SysUtils, StrUtils;

type
  TmDatabaseConstraint = class(TComponent)
  private
    Fp_constraint_corr: String;
    Fp_field_name: String;
    Fp_constraint_name: String;
    Fp_references_table: String;
    Fp_relation_name: String;
    Fp_references_field: String;
    procedure Setp_constraint_corr(const Value: String);
    procedure Setp_constraint_name(const Value: String);
    procedure Setp_field_name(const Value: String);
    procedure Setp_references_field(const Value: String);
    procedure Setp_references_table(const Value: String);
    procedure Setp_relation_name(const Value: String);
  protected
  public
  published
    property p_constraint_name: String read Fp_constraint_name write Setp_constraint_name;
    property p_constraint_corr: String read Fp_constraint_corr write Setp_constraint_corr;
    property p_relation_name: String read Fp_relation_name write Setp_relation_name;
    property p_field_name: String read Fp_field_name write Setp_field_name;
    property p_references_table: String read Fp_references_table write Setp_references_table;
    property p_references_field: String read Fp_references_field write Setp_references_field;
  end;

implementation

{ TmDatabaseConstraint }

procedure TmDatabaseConstraint.Setp_constraint_corr(const Value: String);
begin
  Fp_constraint_corr := Value;
end;

procedure TmDatabaseConstraint.Setp_constraint_name(const Value: String);
begin
  Fp_constraint_name := Value;
end;

procedure TmDatabaseConstraint.Setp_field_name(const Value: String);
begin
  Fp_field_name := Value;
end;

procedure TmDatabaseConstraint.Setp_references_field(const Value: String);
begin
  Fp_references_field := Value;
end;

procedure TmDatabaseConstraint.Setp_references_table(const Value: String);
begin
  Fp_references_table := Value;
end;

procedure TmDatabaseConstraint.Setp_relation_name(const Value: String);
begin
  Fp_relation_name := Value;
end;

end.