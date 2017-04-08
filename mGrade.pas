unit mGrade;

interface

uses
  Classes, SysUtils, ComCtrls,
  mField, mValue, mObjeto;

type
  TmGrade = class(TListView)
  private
    fFields : TmFieldList;
    fCollection : TCollection;
    procedure SetFields(const AFields : TmFieldList);
    procedure SetCollection(const ACollection : TCollection);
  public
    constructor Create(Owner : TComponent); override;
    procedure Clear;
    procedure Add(ACollectionItem : TCollectionItem);
  published
    property Collection : TCollection read fCollection write SetCollection;
    property Fields : TmFieldList read fFields write SetFields;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmGrade]);
end;

constructor TmGrade.Create(Owner: TComponent);
begin
  inherited;

end;

procedure TmGrade.SetFields(const AFields : TmFieldList);
var
  I : Integer;
begin
  fFields := AFields;

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

procedure TmGrade.SetCollection(const ACollection : TCollection);
var
  I : Integer;
begin
  fCollection := ACollection;

  Clear;

  with ACollection do
    for I := 0 to Count - 1 do
      Self.Add(Items[I]);
end;

procedure TmGrade.Clear;
begin
  Items.Clear;
end;

procedure TmGrade.Add(ACollectionItem : TCollectionItem);
var
  vValues : TmValueList;
  vValue : TmValue;
  I : Integer;
begin
  vValues := TmObjeto.GetValues(ACollectionItem);

  with Items.Add do
    for I := 0 to fFields.Count - 1 do begin
      vValue := vValues.IndexOf(fFields.Items[I].Nome);
      if not Assigned(vValue) then
        Continue;

      if I = 0 then
        Caption := vValue.ValueStr
      else
        SubItems.Add(vValue.ValueStr);
    end;
end;

end.
