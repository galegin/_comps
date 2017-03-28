unit mClientDataSet;

interface

uses
  Classes, SysUtils, StrUtils, DBClient, DB, MidasLib, Math,
  mValue, mField;

type
  TmClientDataSet = class(TComponent)
  public
    class procedure SetFields(AClientDataSet: TClientDataSet;
      AFields : TmFieldList);
  end;

implementation

{ TmClientDataSet }

class procedure TmClientDataSet.SetFields(AClientDataSet: TClientDataSet;
  AFields: TmFieldList);
var
  I : Integer;
begin
  with AClientDataSet do begin
    FieldDefs.Clear();

    for I := 0 to AFields.Count - 1 do
      with AFields.Items[I] do
        FieldDefs.Add(Nome, Tipo, IfThen(Tipo in [ftString], 1000, 0), Requerido);

    CreateDataSet;
  end;

  with AClientDataSet do
    for I := 0 to AFields.Count - 1 do
      with AFields.Items[I] do begin
        with FieldByName(Nome) do begin
          Visible := AFields.Items[I].Visible;
          if Descricao <> '' then
            DisplayLabel := Descricao;
          if Tamanho > 0 then
            DisplayWidth := Tamanho;
          if Requerido then
            Required := Requerido;
        end;
      end;
end;

end.