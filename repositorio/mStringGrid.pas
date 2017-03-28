unit mStringGrid;

(* mStringGrid *)

interface

uses
  Classes, SysUtils, StrUtils, Grids, DB,
  mValue, mObjeto, mClasse;

type
  TmStringGrid = class(TComponent)
  private
    class function GetPropertiesClass(
      ACollectionItemClass : TCollectionItemClass) : TmValueList;
    class function GetProperties(
      ACollectionItem : TCollectionItem) : TmValueList;
  public
    class procedure ClrCollection(
      AStringGrid : TStringGrid; ACollection : TCollection);
    class procedure SetCollection(
      AStringGrid : TStringGrid; ACollection : TCollection);
  end;

  function Instance : TmStringGrid;

implementation

var
  _instance : TmStringGrid;

  function Instance : TmStringGrid;
  begin
    if not Assigned(_instance) then
      _instance := TmStringGrid.Create(nil);
    Result := _instance;
  end;

(* mStringGrid *)

class function TmStringGrid.GetPropertiesClass;
var
  vProperties : TmValueList;
  I : Integer;
begin
  Result := TmValueList.Create;
  vProperties := TmClasse.GetProperties(ACollectionItemClass);
  with vProperties do
    for I := 0 to Count - 1 do
      with Items[I] do
        if IsValueDataBase then
          Result.Adicionar(Items[I]);
end;

class function TmStringGrid.GetProperties;
var
  vProperties : TmValueList;
  I : Integer;
begin
  Result := TmValueList.Create;
  vProperties := TmObjeto.GetValues(ACollectionItem);
  with vProperties do
    for I := 0 to Count - 1 do
      with Items[I] do
        if IsValueDataBase then
          Result.Adicionar(Items[I]);
end;

//--

class procedure TmStringGrid.ClrCollection;
var
  vProperties : TmValueList;
  C : Integer;
begin
  vProperties := GetPropertiesClass(ACollection.ItemClass);

  with AStringGrid do begin;
    FixedRows := 1;
    RowCount := 1;
    FixedCols := 0;
    ColCount := vProperties.Count;

    with vProperties do
      for C := 0 to Count - 1 do
        with Items[C] do
          if IsValueDataBase then
            Cells[C, 0] := Nome;
  end;
end;

class procedure TmStringGrid.SetCollection;
var
  vProperties : TmValueList;
  C, R : Integer;
begin
  ClrCollection(AStringGrid, ACollection);

  with AStringGrid do begin
    RowCount := ACollection.Count + 1;
    FixedRows := 1;

    with ACollection do
      for R := 0 to Count - 1 do
        with GetProperties(Items[R]) do
          for C := 0 to Count - 1 do
            with Items[C] do
              Cells[C, R + 1] := ValueStr;
  end;
end;

end.