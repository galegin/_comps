unit mCollectionMap;

  // mapeamento
  //  - ToTable('TESTE');
  //
  //  - HasKey(x => new { x.Codigo, x.Data });
  //
  //  - Property(x => x.Codigo)
  //    .HasColumnName('Codigo')
  //    .IsRequired();
  //  - Property(x => x.Descricao)
  //    .HasColumnName('Descricao')
  //    .IsRequired();
  //    .MaxLength(10)
  //  - Property(x => x.Data)
  //    .HasColumnName('Data')
  //    .IsOptional()
  //  - Property(x => x.Valor)
  //    .HasColumnName('Valor')
  //    .IsOptional()
  //    .HasPrecision(15, 2);
  //
  //  - HasRequired()
  //    .WithMany()
  //    .HasForengKey();
  //  - HasOptional()
  //    .WithOptional()
  //    .HasForengKey();

interface

uses
  Classes, SysUtils, StrUtils,
  mString;

type
  TmCollectionMap = class;
  TmCollectionMapClass = class of TmCollectionMap;
  TmCollectionMapClassArray = array of TmCollectionMapClass;

  TmCollectionProp = class;
  TmCollectionPropClass = class of TmCollectionProp;
  TmCollectionPropArray = array of TmCollectionProp;

  TmCollectionMap = class(TComponent)
  private
    fClasse: TCollectionItemClass;
    fTable: String;
    fProperties: TmCollectionPropArray;
    function GetPrimaryKeys: TmCollectionPropArray;
    function GetRequireds: TmCollectionPropArray;
    function GetOptionais: TmCollectionPropArray;
  protected
  public
    constructor Create(
      AClasse: TCollectionItemClass); reintroduce; virtual;

    procedure ToTable(
      ATable: String);

    function Propert(
      APropertyName: String): TmCollectionProp;

    procedure HasKey(
      AKeys: Array Of String);

    function HasRequired(
      APropertyName: String): TmCollectionProp;

    function HasOptional(
      APropertyName: String): TmCollectionProp;

  public
    property Classe: TCollectionItemClass read fClasse;
    property Table : String read fTable;
    property Properties: TmCollectionPropArray read fProperties;
    property PrimaryKeys: TmCollectionPropArray read GetPrimaryKeys;
    property Requireds: TmCollectionPropArray read GetRequireds;
    property Optionais: TmCollectionPropArray read GetOptionais;
  end;

  TTipoCollectionProp = (tppPrimaryKey, tppForengKey, tppRequired, tppOptional);
  TTipoCollectionMany = (tpmRequired, tpmOptional);

  TmCollectionProp = class
  private
    fName: String;
    fColumnName: String;
    fType: TTipoCollectionProp;
    fMany: TTipoCollectionMany;
    fForengKeys: TmStringList;
    fLength: Integer;
    fPrecision: Integer;
    fInWithMany: Boolean;
    fSubType: String;
    function GetInPrimaryKey: Boolean;
    function GetInForengKey: Boolean;
    function GetInRequired: Boolean;
    function GetInOptional: Boolean;
    function GetInCreate: Boolean;
  public
    constructor Create;

    function HasName(AName: String): TmCollectionProp;
    function HasColumnName(AColumnName: String): TmCollectionProp;
    function HasForengKey(AForengKeys: Array Of String): TmCollectionProp;
    function HasPrecision(ALength, APrecision: Integer): TmCollectionProp;
    function HasRequired(): TmCollectionProp;
    function HasOptional(): TmCollectionProp;
    function HasSubType(ASubType : String): TmCollectionProp;

    function IsPrimaryKey(): TmCollectionProp;
    function IsForengKey(): TmCollectionProp;
    function IsRequired(): TmCollectionProp;
    function IsOptional(): TmCollectionProp;

    function MaxLength(ALength: Integer): TmCollectionProp;

    function WithMany(): TmCollectionProp;
    function WithOptional(): TmCollectionProp;
  published
    property PropName : String read fName;
    property ColumnName : String read fColumnName;
    property ForengKeys : TmStringList read fForengKeys;
    property Length : Integer read fLength;
    property Precision : Integer read fPrecision;
    property InPrimaryKey : Boolean read GetInPrimaryKey;
    property InForengKey : Boolean read GetInForengKey;
    property InRequired : Boolean read GetInRequired;
    property InOptional : Boolean read GetInOptional;
    property InWithMany : Boolean read fInWithMany;
    property InCreate : Boolean read GetInCreate;
  end;

implementation

{ TmCollectionMap }

constructor TmCollectionMap.Create;
begin
  fClasse:= AClasse;
  SetLength(fProperties, 0);
end;

//--

procedure TmCollectionMap.ToTable;
begin
  fTable:= ATable;
end;

//--

function TmCollectionMap.Propert;

  function GetPropert() : TmCollectionProp;
  var
    I : Integer;
  begin
    Result := nil;
    for I := Low(fProperties) to High(fProperties) do
      with fProperties[I] do
        if PropName = APropertyName then begin
          Result := fProperties[I];
          Exit;
        end;
  end;

begin
  Result := GetPropert();

  if Assigned(Result) then
    Exit;

  Result := TmCollectionProp.Create;
  Result.HasName(APropertyName);
  Result.HasColumnName(UpperCase(APropertyName));
  Result.IsOptional();

  SetLength(fProperties, Length(fProperties) + 1);
  fProperties[High(fProperties)] := Result;
end;

//--

procedure TmCollectionMap.HasKey;
var
  I : Integer;
begin
  for I := Low(AKeys) to High(AKeys) do
    Propert(AKeys[I]).IsPrimaryKey();
end;

//--

function TmCollectionMap.HasRequired;
begin
  Result := Propert(APropertyName).IsForengKey();
end;

function TmCollectionMap.HasOptional;
begin
  Result := Propert(APropertyName).IsForengKey();
end;

//--

function TmCollectionMap.GetPrimaryKeys;
var
  I : Integer;
begin
  SetLength(Result, 0);
  for I := Low(fProperties) to High(fProperties) do
    with fProperties[I] do
      if InPrimaryKey then begin
        SetLength(Result, System.Length(Result) + 1);
        Result[High(Result)] := fProperties[I];
      end;
end;

function TmCollectionMap.GetRequireds;
var
  I : Integer;
begin
  SetLength(Result, 0);
  for I := Low(fProperties) to High(fProperties) do
    with fProperties[I] do
      if InRequired then begin
        SetLength(Result, System.Length(Result) + 1);
        Result[High(Result)] := fProperties[I];
      end;
end;

function TmCollectionMap.GetOptionais;
var
  I : Integer;
begin
  SetLength(Result, 0);
  for I := Low(fProperties) to High(fProperties) do
    with fProperties[I] do
      if InOptional then begin
        SetLength(Result, System.Length(Result) + 1);
        Result[High(Result)] := fProperties[I];
      end;
end;

{ TmCollectionProp }

constructor TmCollectionProp.Create;
begin
  fForengKeys := TmStringList.Create;
end;

function TmCollectionProp.HasName;
begin
  fName:= AName;
  Result := Self;
end;

function TmCollectionProp.HasColumnName;
begin
  fColumnName:= AColumnName;
  Result := Self;
end;

function TmCollectionProp.HasForengKey;
var
  I : Integer;
begin
  fForengKeys.Clear();
  for I := Low(AForengKeys) to High(AForengKeys) do
    fForengKeys.Add(AForengKeys[I]);
  Result := Self;
end;

//--

function TmCollectionProp.HasPrecision;
begin
  fLength := ALength;
  fPrecision := APrecision;
  Result := Self;
end;

//--

function TmCollectionProp.HasRequired;
begin
  fType := tppForengKey;
  fMany := tpmRequired;
  Result := Self;
end;

function TmCollectionProp.HasOptional;
begin
  fType := tppForengKey;
  fMany := tpmOptional;
  Result := Self;
end;

function TmCollectionProp.HasSubType;
begin
  fSubType := ASubType;
  Result := Self;
end;

//--

function TmCollectionProp.IsPrimaryKey;
begin
  fType := tppPrimaryKey;
  Result := Self;
end;

function TmCollectionProp.IsForengKey;
begin
  fType := tppForengKey;
  Result := Self;
end;

function TmCollectionProp.IsRequired;
begin
  if not (fType in [tppPrimaryKey, tppRequired]) then
    fType := tppRequired;
  Result := Self;
end;

function TmCollectionProp.IsOptional;
begin
  fType := tppOptional;
  Result := Self;
end;

//--

function TmCollectionProp.MaxLength;
begin
  fLength := ALength;
  Result := Self;
end;

//--

function TmCollectionProp.WithMany;
begin
  fInWithMany := True;
  Result := Self;
end;

function TmCollectionProp.WithOptional;
begin
  fInWithMany := False;
  Result := Self;
end;

//--

function TmCollectionProp.GetInPrimaryKey: Boolean;
begin
  Result := fType in [tppPrimaryKey];
end;

function TmCollectionProp.GetInRequired: Boolean;
begin
  Result := fType in [tppPrimaryKey, tppRequired];
end;

function TmCollectionProp.GetInOptional: Boolean;
begin
  Result := fType in [tppOptional];
end;

function TmCollectionProp.GetInForengKey: Boolean;
begin
  Result := fType in [tppForengKey];
end;

function TmCollectionProp.GetInCreate: Boolean;
begin
  Result := fType in [tppPrimaryKey, tppRequired, tppOptional];
end;

//--

end.
