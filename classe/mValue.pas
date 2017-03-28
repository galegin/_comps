unit mValue; // mValue

interface

uses
  Classes, SysUtils, StrUtils;

type
  TTipoField = (
    tfKey,
    tfReq,
    tfNul);

  TTipoValue = (
    tvBoolean,
    tvDateTime,
    tvFloat,
    tvInteger,
    tvString,
    tvVariant,
    tvObject,
    tvList);

  TmValue = class;
  TmValueClass = class of TmValue;

  TmValue = class
  private
    fNome : String;
    fTipoField : TTipoField;
    function GetTipo: TTipoValue;
  protected
    function GetTipoBase: String; virtual; abstract;
    function GetValueBase: String; virtual; abstract;
    procedure SetValueBase(const AValue: String); virtual; abstract;
    function GetValueInt() : String; virtual; abstract;
    function GetValueStr() : String; virtual; abstract;
    function GetIsFiltro() : Boolean; virtual; abstract;
    function GetIsStore() : Boolean; virtual; abstract;
  public
  published
    property Nome : String read fNome write fNome;
    property Tipo : TTipoValue read GetTipo;
    property TipoField : TTipoField read fTipoField write fTipoField;
    property TipoBase : String read GetTipoBase;
    property ValueBase : String read GetValueBase write SetValueBase;
    property ValueInt : String read GetValueInt;
    property ValueStr : String read GetValueStr;
    property IsFiltro : Boolean read GetIsFiltro;
    property IsStore : Boolean read GetIsStore;
  end;

  //-- database

  TmValueBase = class(TmValue);

  TmValueBool = class(TmValueBase)
  private
    fValue : Boolean;
  protected
    function GetTipoBase: String; override;
    function GetValueBase: String; override;
    procedure SetValueBase(const AValue: String); override;
    function GetValueInt() : String; override;
    function GetValueStr() : String; override;
    function GetIsFiltro() : Boolean; override;
    function GetIsStore() : Boolean; override;
  public
    constructor Create(const ANome : String; AValue : Boolean);
  published
    property Value : Boolean read fValue write fValue;
  end;

  TmValueDate = class(TmValueBase)
  private
    fValue : TDateTime;
  protected
    function GetTipoBase: String; override;
    function GetValueBase: String; override;
    procedure SetValueBase(const AValue: String); override;
    function GetValueInt() : String; override;
    function GetValueStr() : String; override;
    function GetIsFiltro() : Boolean; override;
    function GetIsStore() : Boolean; override;
  public
    constructor Create(const ANome : String; AValue : TDateTime);
  published
    property Value : TDateTime read fValue write fValue;
  end;

  TmValueFloat = class(TmValueBase)
  private
    fValue : Real;
  protected
    function GetTipoBase: String; override;
    function GetValueBase: String; override;
    procedure SetValueBase(const AValue: String); override;
    function GetValueInt() : String; override;
    function GetValueStr() : String; override;
    function GetIsFiltro() : Boolean; override;
    function GetIsStore() : Boolean; override;
  public
    constructor Create(const ANome : String; AValue : Real);
  published
    property Value : Real read fValue write fValue;
  end;

  TmValueInt = class(TmValueBase)
  private
    fValue : Integer;
  protected
    function GetTipoBase: String; override;
    function GetValueBase: String; override;
    procedure SetValueBase(const AValue: String); override;
    function GetValueInt() : String; override;
    function GetValueStr() : String; override;
    function GetIsFiltro() : Boolean; override;
    function GetIsStore() : Boolean; override;
  public
    constructor Create(const ANome : String; AValue : Integer);
  published
    property Value : Integer read fValue write fValue;
  end;

  TmValueStr = class(TmValueBase)
  private
    fValue : String;
  protected
    function GetTipoBase: String; override;
    function GetValueBase: String; override;
    procedure SetValueBase(const AValue: String); override;
    function GetValueInt() : String; override;
    function GetValueStr() : String; override;
    function GetIsFiltro() : Boolean; override;
    function GetIsStore() : Boolean; override;
  public
    constructor Create(const ANome : String; AValue : String);
  published
    property Value : String read fValue write fValue;
  end;

  TmValueVar = class(TmValueBase)
  private
    fValue : Variant;
  protected
    function GetTipoBase: String; override;
    function GetValueBase: String; override;
    procedure SetValueBase(const AValue: String); override;
    function GetValueInt() : String; override;
    function GetValueStr() : String; override;
    function GetIsFiltro() : Boolean; override;
    function GetIsStore() : Boolean; override;
  public
    constructor Create(const ANome : String; AValue : Variant);
  published
    property Value : Variant read fValue write fValue;
  end;

  //-- objeto

  TmValueClas = class(TmValue);

  TmValueObj = class(TmValueClas)
  private
    fValue : TObject;
  protected
    function GetTipoBase: String; override;
    function GetValueBase: String; override;
    procedure SetValueBase(const AValue: String); override;
    function GetValueInt() : String; override;
    function GetValueStr() : String; override;
    function GetIsFiltro() : Boolean; override;
    function GetIsStore() : Boolean; override;
  public
    constructor Create(const ANome : String; AValue : TObject);
  published
    property Value : TObject read fValue write fValue;
  end;

  TmValueLst = class(TmValueClas)
  private
    fValue : TList;
  protected
    function GetTipoBase: String; override;
    function GetValueBase: String; override;
    procedure SetValueBase(const AValue: String); override;
    function GetValueInt() : String; override;
    function GetValueStr() : String; override;
    function GetIsFiltro() : Boolean; override;
    function GetIsStore() : Boolean; override;
  public
    constructor Create(const ANome : String; AValue : TList);
  published
    property Value : TList read fValue write fValue;
  end;

  //-- lista

  TmValueList = class(TList)
  private
    function GetItem(Index: Integer): TmValue;
    procedure SetItem(Index: Integer; const AValue: TmValue);
  public
    function Add(const AValue : TmValue) : TmValue; overload;
    function IndexOf(ANome : String) : TmValue;
    property Items[Index : Integer] : TmValue read GetItem write SetItem;
  end;

implementation

uses
  mParametroDatabase;

const
  LTipoValue : Array [TTipoValue] Of TmValueClass = (
    TmValueBool,
    TmValueDate,
    TmValueFloat,
    TmValueInt,
    TmValueStr,
    TmValueVar,
    TmValueObj,
    TmValueLst);

{ TmValue }

function TmValue.GetTipo: TTipoValue;
var
  I : Integer;
begin
  Result := TTipoValue(Ord(-1));
  for I := Ord(Low(TTipoValue)) to Ord(High(TTipoValue)) do
    if ClassType = LTipoValue[TTipoValue(I)] then
      Result := TTipoValue(I);
end;

{ TmValueBool }

constructor TmValueBool.Create(const ANome: String; AValue: Boolean);
begin
  fNome := ANome;
  fValue := AValue;
end;

function TmValueBool.GetTipoBase: String;
begin
  Result := 'CHAR(1)';
end;

function TmValueBool.GetValueBase: String;
begin
  Result := '''' + IfThen(fValue, 'T', 'F') + '''';
end;

procedure TmValueBool.SetValueBase(const AValue: String);
begin
  fValue := (AValue = 'T');
end;

function TmValueBool.GetValueInt: String;
begin
  Result := IfThen(fValue, 'T', 'F');
end;

function TmValueBool.GetValueStr: String;
begin
  Result := IfThen(fValue, 'T', 'F');
end;

function TmValueBool.GetIsFiltro: Boolean;
begin
  Result := fValue;
end;

function TmValueBool.GetIsStore: Boolean;
begin
  Result := fValue;
end;

{ TmValueDate }

constructor TmValueDate.Create(const ANome: String; AValue: TDateTime);
begin
  fNome := ANome;
  fValue := AValue;
end;

function TmValueDate.GetTipoBase: String;
begin
  Result := 'TIMESTAMP';
end;

function TmValueDate.GetValueBase: String;
var
  vFormatoDataHora : String;
begin
  vFormatoDataHora := mParametroDatabase.Instance.FormatoDataHora;
  Result := '''' + FormatDateTime(vFormatoDataHora, fValue) + '''';
end;

procedure TmValueDate.SetValueBase(const AValue: String);
begin
  fValue := StrToDateTimeDef(AValue, 0);
end;

function TmValueDate.GetValueInt: String;
begin
  Result := FormatDateTime('yyyymmdd_hhnnss', fValue);
end;

function TmValueDate.GetValueStr: String;
var
  vFormatoDataHora : String;
begin
  vFormatoDataHora := 'dd/mm/yyyy hh:nn:ss';
  Result := FormatDateTime(vFormatoDataHora, fValue);
end;

function TmValueDate.GetIsFiltro: Boolean;
begin
  Result := fValue > 0;
end;

function TmValueDate.GetIsStore: Boolean;
var
  vMinValue : Integer;
begin
  vMinValue := -1;
  if (fTipoField in [tfKey, tfReq]) then
    vMinValue := 0;

  Result := (fValue > 0) or (fValue = vMinValue);
end;

{ TmValueFloat }

constructor TmValueFloat.Create(const ANome: String; AValue: Real);
begin
  fNome := ANome;
  fValue := AValue;
end;

function TmValueFloat.GetTipoBase: String;
begin
  Result := 'NUMERIC({tamanho},{decimal})';
end;

function TmValueFloat.GetValueBase: String;
begin
  Result := AnsiReplaceStr(FloatToStr(fValue), ',', '.');
end;

procedure TmValueFloat.SetValueBase(const AValue: String);
begin
  fValue := StrToFloatDef(AValue, 0);
end;

function TmValueFloat.GetValueInt: String;
begin
  Result := FormatFloat('0000000000', fValue * 100);
end;

function TmValueFloat.GetValueStr: String;
begin
  Result := FloatToStr(fValue);
end;

function TmValueFloat.GetIsFiltro: Boolean;
begin
  Result := fValue > 0;
end;

function TmValueFloat.GetIsStore: Boolean;
var
  vMinValue : Integer;
begin
  vMinValue := -1;
  if (fTipoField in [tfKey, tfReq]) then
    vMinValue := 0;

  Result := (fValue > 0) or (fValue = vMinValue);
end;

{ TmValueInt }

constructor TmValueInt.Create(const ANome: String; AValue: Integer);
begin
  fNome := ANome;
  fValue := AValue;
end;

function TmValueInt.GetTipoBase: String;
begin
  Result := 'INTEGER';
end;

function TmValueInt.GetValueBase: String;
begin
  Result := IntToStr(fValue);
end;

procedure TmValueInt.SetValueBase(const AValue: String);
begin
  fValue := StrToIntDef(AValue, 0);
end;

function TmValueInt.GetValueInt: String;
begin
  Result := FormatFloat('000000', fValue);
end;

function TmValueInt.GetValueStr: String;
begin
  Result := IntToStr(fValue);
end;

function TmValueInt.GetIsFiltro: Boolean;
begin
  Result := fValue > 0;
end;

function TmValueInt.GetIsStore: Boolean;
var
  vMinValue : Integer;
begin
  vMinValue := -1;
  if (fTipoField in [tfKey, tfReq]) then
    vMinValue := 0;

  Result := (fValue > 0) or (fValue = vMinValue);
end;

{ TmValueStr }

constructor TmValueStr.Create(const ANome: String; AValue: String);
begin
  fNome := ANome;
  fValue := AValue;
end;

function TmValueStr.GetTipoBase: String;
begin
  Result := 'VARCHAR({tamanho})';
end;

function TmValueStr.GetValueBase: String;
begin
  Result := '''' + AnsiReplaceStr(fValue, '''', '''''') + '''';
end;

procedure TmValueStr.SetValueBase(const AValue: String);
begin
  fValue := AValue;
end;

function TmValueStr.GetValueInt: String;
begin
  Result := Trim(fValue);
end;

function TmValueStr.GetValueStr: String;
begin
  Result := fValue;
end;

function TmValueStr.GetIsFiltro: Boolean;
begin
  Result := fValue <> '';
end;

function TmValueStr.GetIsStore: Boolean;
begin
  Result := fValue <> '';
end;

{ TmValueVar }

constructor TmValueVar.Create(const ANome: String; AValue: Variant);
begin
  fNome := ANome;
  fValue := AValue;
end;

function TmValueVar.GetTipoBase: String;
begin
  Result := 'VARCHAR({tamanho})';
end;

function TmValueVar.GetValueBase: String;
begin
  Result := '''' + fValue + '''';
end;

procedure TmValueVar.SetValueBase(const AValue: String);
begin
  fValue := AValue;
end;

function TmValueVar.GetValueInt: String;
begin
  Result := fValue;
end;

function TmValueVar.GetValueStr: String;
begin
  Result := fValue;
end;

function TmValueVar.GetIsFiltro: Boolean;
begin
  Result := fValue <> varNull;
end;

function TmValueVar.GetIsStore: Boolean;
begin
  Result := fValue <> varNull;
end;

{ TmValueObj }

constructor TmValueObj.Create(const ANome: String; AValue: TObject);
begin
  fNome := ANome;
  fValue := AValue;
end;

function TmValueObj.GetTipoBase: String;
begin
  Result := '';
end;

function TmValueObj.GetValueBase: String;
begin
  Result := ''; // ?????
end;

procedure TmValueObj.SetValueBase(const AValue: String);
begin
  // ?????
end;

function TmValueObj.GetValueInt: String;
begin
  Result := '';
end;

function TmValueObj.GetValueStr: String;
begin
  Result := ''; // ?????
end;

function TmValueObj.GetIsFiltro: Boolean;
begin
  Result := False;
end;

function TmValueObj.GetIsStore: Boolean;
begin
  Result := False;
end;

{ TmValueLst }

constructor TmValueLst.Create(const ANome: String; AValue: TList);
begin
  fNome := ANome;
  fValue := AValue;
end;

function TmValueLst.GetTipoBase: String;
begin
  Result := '';
end;

function TmValueLst.GetValueBase: String;
begin
  Result := ''; // ?????
end;

procedure TmValueLst.SetValueBase(const AValue: String);
begin
  // ?????
end;

function TmValueLst.GetValueInt: String;
begin
  Result := '';
end;

function TmValueLst.GetValueStr: String;
begin
  Result := ''; // ?????
end;

function TmValueLst.GetIsFiltro: Boolean;
begin
  Result := False;
end;

function TmValueLst.GetIsStore: Boolean;
begin
  Result := False;
end;

{ TmValueList }

function TmValueList.Add(const AValue: TmValue): TmValue;
begin
  Result := AValue;
  Self.Add(Result);
end;

function TmValueList.GetItem(Index: Integer): TmValue;
begin
  Result := TmValue(Self[Index]);
end;

procedure TmValueList.SetItem(Index: Integer; const AValue: TmValue);
begin
  Self[Index] := AValue;
end;

function TmValueList.IndexOf(ANome: String): TmValue;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    with TmValue(Self[I]) do
      if LowerCase(Nome) = LowerCase(ANome) then begin
        Result := TmValue(Self[I]);
        Exit;
      end;
end;

end.
