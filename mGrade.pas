unit mGrade;

interface

uses
  Classes, SysUtils, ComCtrls,
  mField, mValue, mObjeto;

type
  TmGrade = class(TListView)
  private
    fCollection : TCollection;
  public
    procedure SetColumns(AFields : TmFieldList);
    procedure ClrItems;
    procedure AddItems(AFields : TmFieldList; ACollectionItem : TCollectionItem);
    procedure SetItems(AFields : TmFieldList; ACollection : TCollection);
  published
    property Collection : TCollection read fCollection write fCollection;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmGrade]);
end;

procedure TmGrade.SetColumns(AFields : TmFieldList);
var
  I : Integer;
begin
  SortType := stText;
  ViewStyle := vsReport;

  Columns.Clear;

  for I := 0 to AFields.Count - 1 do
    with Columns.Add do begin
      Caption := AFields.Items[I].Descricao;
      Width := AFields.Items[I].Tamanho * 8;
      Tag := I;
    end;
end;

procedure TmGrade.ClrItems;
begin
  Items.Clear;
end;

procedure TmGrade.AddItems(AFields : TmFieldList; ACollectionItem : TCollectionItem);
var
  vValues : TmValueList;
  vValue : TmValue;
  I : Integer;
begin
  vValues := TmObjeto.GetValues(ACollectionItem);

  with Items.Add do
    for I := 0 to AFields.Count - 1 do begin
      vValue := vValues.IndexOf(AFields.Items[I].Nome);
      if not Assigned(vValue) then
        Continue;

      if I = 0 then
        Caption := vValue.ValueStr
      else
        SubItems.Add(vValue.ValueStr);
    end;
end;

procedure TmGrade.SetItems(AFields : TmFieldList; ACollection : TCollection);
var
  I : Integer;
begin
  ClrItems;

  with ACollection do
    for I := 0 to Count - 1 do
      AddItems(AFields, Items[I]);
end;

end.
