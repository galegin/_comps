{ Property editors for TtsqZip and TTsqUnzip
  Copyright (c) 2003, Siqing Tang
  Email: tsq@softhome.net
}

unit tsqZipUnZipPropertyEditor;

interface

uses
  Classes, DesignEditors, DesignIntf;

type
  TReadOnlyStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure Register;

implementation

uses
 tsqZip, tsqUnZip;

{ TReadOnlyStringProperty }

function TReadOnlyStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paReadOnly];
end;

procedure Register;
begin
  RegisterPropertyEditor(
  		TypeInfo(string),
  		TtsqZip,
      'Zip32DLLVersion',
      TReadOnlyStringProperty);
  RegisterPropertyEditor(
  		TypeInfo(string),
  		TtsqZip,
      'Version',
      TReadOnlyStringProperty);

  RegisterPropertyEditor(
  		TypeInfo(string),
  		TZipOptions,
      'Encryption',
      TReadOnlyStringProperty);

  RegisterPropertyEditor(
  		TypeInfo(string),
  		TtsqUnzip,
      'Unzip32DLLVersion',
      TReadOnlyStringProperty);

  RegisterPropertyEditor(
  		TypeInfo(string),
  		TtsqUnzip,
      'Version',
      TReadOnlyStringProperty);
end;

end.
