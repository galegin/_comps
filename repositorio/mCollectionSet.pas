unit mCollectionSet;

interface

uses
  Classes, SysUtils, StrUtils, DB,
  mCollectionCmd, mCollectionItem, mDataSet, mProperty, mSelect, mFilter;

type
  TmCollectionSet = class(TComponent)
  private
    fContexto : TComponent;
    fClasse : TCollectionItemClass;
  protected
  public
    constructor Create(
      AContexto : TComponent;
      AClasse : TCollectionItemClass); reintroduce; virtual;

    function FirstOrDefault(ACampo : String; AWhere : String) : TObject;

    function Group(ACampo : String; AWhere : String) : TmCollectionSet;
    function Select(ACampo : String; AWhere : String) : TmCollectionSet;
    function Where(ACampo : String; AWhere : String) : TmCollectionSet;

    function Count(ACampo : String) : Integer;
    function Avg(ACampo : String) : Real;
    function Max(ACampo : String) : Real;
    function Min(ACampo : String) : Real;
    function Sum(ACampo : String) : Real;

    function ToList() : TList;

    function GetSelect(
      ACollectonItem : TmCollectionItem;
      ACollectonCmd : TmCollectionCmdList;
      AFilters : TList) : TmCollectionCmdList;

  published
  end;

implementation

uses
  mContexto;

constructor TmCollectionSet.Create;
begin
  fContexto := AContexto;
  fClasse := AClasse;
end;

//--

function TmCollectionSet.FirstOrDefault;
begin
  Result := nil;
end;

//--

function TmCollectionSet.Group;
begin
  Result := Self;
end;

function TmCollectionSet.Select;
begin
  Result := Self;
end;

function TmCollectionSet.Where;
begin
  Result := Self;
end;

//--

function TmCollectionSet.Count;
begin
  Result := 0;
end;

function TmCollectionSet.Avg;
begin
  Result := 0;
end;

function TmCollectionSet.Max;
begin
  Result := 0;
end;

function TmCollectionSet.Min;
begin
  Result := 0;
end;

function TmCollectionSet.Sum;
begin
  Result := 0;
end;

//--

function TmCollectionSet.ToList;
begin
  Result := nil;
end;

//--

function TmCollectionSet.GetSelect;
var
  vFields, vSql : String;
  vValues : TmPropertyList;
  vDataSet : TDataSet;
  I : Integer;
begin
  Result := nil;

  vFields := '';
  with ACollectonCmd do
    for I := 0 to Count - 1 do
      with Items[I] do
        vFields := vFields +
          IfThen(vFields <> '', ', ', '') + GetComandoSelect;

  vSql := TmSelect.GetSelect(ACollectonItem, AFilters, vFields);

  if fContexto is TmContexto then begin
    vDataSet := (fContexto as TmContexto).Conexao.GetConsulta(vSql);      
    vValues := TmDataSet.GetValues(vDataSet);

    with ACollectonCmd do
      for I := 0 to Count - 1 do
        with Items[I] do
          Valor := vValues.IndexOf(Field);

    FreeAndNil(vDataSet);

    Result := ACollectonCmd;
  end;
end;

end.