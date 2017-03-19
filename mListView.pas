unit mListView;

interface

uses
  Classes, SysUtils, ComCtrls,
  mCollection, mCollectionItem, mProperty, mClasse, mObjeto;

type
  TmListView = class(TListView)
  public
    class procedure SetColumns(AListView : TListView;
      ACollectionItemClass : TCollectionItemClass);

    class procedure ClrItems(AListView : TListView);

    class procedure AddItems(AListView : TListView;
      ACollectionItem : TCollectionItem);

    class procedure SetItems(AListView : TListView;
      ACollection : TCollection);
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmListView]);
end;

  function GetValuesDat(AValues : TmPropertyList) : TmPropertyList;
  var
    I : Integer;
  begin
    Result := TmPropertyList.Create;
    for I := 1 to AValues.Count - 1 do
      if AValues.Items[I].IsValueDatabase then
        Result.Add(AValues.Items[I]);
   end;

{ TmListView }

class procedure TmListView.SetColumns(AListView: TListView;
  ACollectionItemClass : TCollectionItemClass);
var
  vValues : TmPropertyList;
  I : Integer;
begin
  vValues := TmClasse.GetProperties(ACollectionItemClass);
  vValues := GetValuesDat(vValues);

  with AListView do begin
    SortType := stText;
    ViewStyle := vsReport;

    Columns.Clear;

    for I := 0 to vValues.Count - 1 do
      with Columns.Add do
        Caption := vValues.Items[I].Nome;
  end;
end;

class procedure TmListView.ClrItems(AListView : TListView);
begin
  with AListView do begin
    Items.Clear;
  end;
end;

class procedure TmListView.AddItems(AListView : TListView;
  ACollectionItem : TCollectionItem);
var
  vValues : TmPropertyList;
  I : Integer;
begin
  with AListView do begin

    vValues := TmObjeto.GetValues(ACollectionItem);
    vValues := GetValuesDat(vValues);

    with Items.Add do
      for I := 0 to vValues.Count - 1 do
        if I = 0 then
          Caption := vValues.Items[I].ValueStr
        else
          SubItems.Add(vValues.Items[I].ValueStr);

  end;
end;

class procedure TmListView.SetItems(AListView: TListView;
  ACollection : TCollection);
var
  I : Integer;
begin
  ClrItems(AListView);

  with ACollection do
    for I := 0 to Count - 1 do
      AddItems(AListView, Items[I]);
end;

end.
