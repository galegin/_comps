unit mListView;

interface

uses
  Classes, SysUtils, ComCtrls, DB,
  mCollection, mCollectionItem, mValue, mClasse, mObjeto, mField;

type
  TmListView = class(TListView)
  public
    class procedure SetColumns(AListView : TListView;
      AFields : TmFieldList);

    class procedure ClrItems(AListView : TListView);

    class procedure AddItems(AListView : TListView;
      AFields : TmFieldList;
      ACollectionItem : TCollectionItem);

    class procedure SetItems(AListView : TListView;
      AFields : TmFieldList;
      ACollection : TCollection);
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmListView]);
end;

{ TmListView }

class procedure TmListView.SetColumns(AListView: TListView;
  AFields : TmFieldList);
var
  I : Integer;
begin
  with AListView do begin
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
end;

class procedure TmListView.ClrItems(AListView : TListView);
begin
  with AListView do begin
    Items.Clear;
  end;
end;

class procedure TmListView.AddItems(AListView : TListView;
  AFields : TmFieldList;
  ACollectionItem : TCollectionItem);
var
  vValues : TmValueList;
  vValue : TmValue;
  I : Integer;
begin
  with AListView do begin

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
end;

class procedure TmListView.SetItems(AListView: TListView;
  AFields : TmFieldList;
  ACollection : TCollection);
var
  I : Integer;
begin
  ClrItems(AListView);

  with ACollection do
    for I := 0 to Count - 1 do
      AddItems(AListView, AFields, Items[I]);
end;

end.
