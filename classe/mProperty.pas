unit mProperty;

interface

uses
  Classes, SysUtils, StrUtils,
  mParametroDatabase, mTipoCampo, mString;

type
  TmProperty = class;
  TmPropertyClass = class of TmProperty;

  TmPropertyList = class;
  TmPropertyListClass = class of TmPropertyList;

  TpProperty =
    (tppBoolean, tppDateTime, tppEnum, tppFloat, tppInteger, tppObject,
     tppList, tppString, tppVariant);

  TpField =
    (tpfKey, tpfReq, tpfNul);

  TmProperty = class
  private
    fNome : String;
    fTipoBase : String;
    fTipoCampo : TTipoCampo;

    fTipo : TpProperty;
    fTipoField : TpField;

    fValueBoolean : Boolean;
    fValueDateTime : TDateTime;
    fValueEnum : Integer;
    fValueFloat : Real;
    fValueInteger : Integer;
    fValueString : String;
    fValueList : TList;
    fValueVariant : Variant;
    fValueObject : TObject;

    function GetIsValueDatabase: Boolean;
    function GetIsValueFiltro: Boolean;
    function GetIsValueList: Boolean;
    function GetIsValueObject: Boolean;
    function GetIsValueStr: Boolean;
    function GetIsValueStore: Boolean;
    function GetIsValueVariant: Boolean;

    function GetValueDatabase: String;
    procedure SetValueDatabase(const Value: String);
    function GetValueIntegracao: String;
    function GetValueStr: String;

    function GetTipoDatabase: String;
    procedure SetNome(const Value: String);
  public
    property Nome : String read fNome write SetNome;
    property TipoBase : String read fTipoBase write fTipoBase;

    property Tipo : TpProperty read fTipo write fTipo;
    property TipoField : TpField read fTipoField write fTipoField;

    property ValueBoolean : Boolean read fValueBoolean write fValueBoolean;
    property ValueDateTime : TDateTime read fValueDateTime write fValueDateTime;
    property ValueEnum : Integer read fValueEnum write fValueEnum;
    property ValueFloat : Real read fValueFloat write fValueFloat;
    property ValueInteger : Integer read fValueInteger write fValueInteger;
    property ValueString : String read fValueString write fValueString;
    property ValueList : TList read fValueList write fValueList;
    property ValueVariant : Variant read fValueVariant write fValueVariant;
    property ValueObject : TObject read fValueObject write fValueObject;

    property IsValueDatabase : Boolean read GetIsValueDatabase;
    property IsValueFiltro : Boolean read GetIsValueFiltro;
    property IsValueList : Boolean read GetIsValueList;
    property IsValueObject : Boolean read GetIsValueObject;
    property IsValueStr : Boolean read GetIsValueStr;
    property IsValueStore : Boolean read GetIsValueStore;
    property IsValueVariant : Boolean read GetIsValueVariant;

    property TipoDatabase : String read GetTipoDatabase;

    property ValueDatabase : String read GetValueDatabase write SetValueDatabase;
    property ValueIntegracao : String read GetValueIntegracao;
    property ValueStr : String read GetValueStr;
  end;

  TmPropertyList = class(TList)
  private
    function GetItem(Index: Integer): TmProperty;
    procedure SetItem(Index: Integer; const Value: TmProperty);
  public
    function Add : TmProperty; overload;
    function IndexOf(ANome : String) : TmProperty;
    property Items[Index: Integer] : TmProperty read GetItem write SetItem;
  end;

  TmPropertyValue = class
  public
    class function IndexOf(AProperties : TList; ANome : String) : TmProperty;
  end;

implementation

{ TmProperty }

function TmProperty.GetIsValueDatabase: Boolean;
begin
  Result := (Tipo in [tppBoolean, tppDateTime, tppEnum, tppInteger, tppFloat,
    tppString, tppVariant]);
end;

function TmProperty.GetIsValueFiltro: Boolean;
begin
  case Tipo of
    tppBoolean:
      Result := ValueBoolean;
    tppDateTime:
      Result := ValueDateTime > 0;
    tppInteger:
      Result := ValueInteger > 0;
    tppEnum:
      Result := ValueInteger > 0;
    tppFloat:
      Result := ValueFloat > 0;
    tppString:
      Result := ValueString <> '';
    tppVariant:
      Result := ValueVariant <> varNull;
  else
    Result := False;
  end;
end;

function TmProperty.GetIsValueList: Boolean;
begin
  Result := Tipo in [tppList];
end;

function TmProperty.GetIsValueObject: Boolean;
begin
  Result := Tipo in [tppObject];
end;

function TmProperty.GetIsValueStr: Boolean;
begin
  Result := GetIsValueDatabase;
end;

function TmProperty.GetIsValueStore: Boolean;
var
  vMinValue : Integer;
begin
  vMinValue := -1;
  if (fTipoField in [tpfKey, tpfReq])
  or (fTipoCampo in [tcPercentual, tcTipagem, tcValor]) then
    vMinValue := 0;

  case Tipo of
    tppBoolean:
      Result := ValueBoolean;
    tppDateTime:
      Result := (ValueDateTime > 0) or (ValueDateTime = vMinValue);
    tppInteger:
      Result := (ValueInteger > 0) or (ValueInteger = vMinValue);
    tppEnum:
      Result := (ValueInteger > 0) or (ValueInteger = vMinValue);
    tppFloat:
      Result := (ValueFloat > 0) or (ValueFloat = vMinValue);
    tppString:
      Result := ValueString <> '';
    tppVariant:
      Result := ValueVariant <> varNull;
  else
    Result := False;
  end;
end;

function TmProperty.GetIsValueVariant: Boolean;
begin
  Result := Tipo in [tppVariant];
end;

//--

function TmProperty.GetTipoDatabase: String;
begin
  case Tipo of
    tppBoolean:
      Result := 'CHAR(1)';
    tppDateTime:
      Result := 'TIMESTAMP';
    tppEnum:
      Result := 'INTEGER';
    tppInteger:
      Result := 'INTEGER';
    tppFloat:
      Result := 'NUMERIC({tamanho},{decimal})';
    tppString:
      Result := 'VARCHAR({tamanho})';
    tppVariant:
      Result := 'VARCHAR({tamanho})';
  else
    Result := 'VARCHAR({tamanho})';
  end;
end;

function TmProperty.GetValueDatabase: String;
var
  vFormatoDataHora : String;
begin
  vFormatoDataHora := mParametroDatabase.Instance.FormatoDataHora;

  case Tipo of
    tppBoolean:
      Result := '''' + IfThen(ValueBoolean, 'T', 'F') + '''';
    tppDateTime:
      Result := '''' + FormatDateTime(vFormatoDataHora, ValueDateTime) + '''';
    tppEnum:
      Result := IntToStr(ValueInteger);
    tppInteger:
      Result := IntToStr(ValueInteger);
    tppFloat:
      Result := AnsiReplaceStr(FloatToStr(ValueFloat), ',', '.');
    tppString:
      Result := '''' + AnsiReplaceStr(ValueString, '''', '''''') + '''';
    tppVariant:
      Result := '''' + ValueVariant + '''';
  else
    Result := 'null';
  end;
end;

function TmProperty.GetValueIntegracao: String;
begin
  case Tipo of
    tppBoolean:
      Result := IfThen(ValueBoolean, 'T', 'F');
    tppDateTime:
      Result := FormatDateTime('yyyymmdd_hhnnss', ValueDateTime);
    tppInteger:
      Result := FormatFloat('000000', ValueInteger);
    tppEnum:
      Result := FormatFloat('00', ValueEnum);
    tppFloat:
      Result := FormatFloat('0000000000', ValueFloat * 100);
    tppString:
      Result := Trim(ValueString);
    tppVariant:
      Result := ValueVariant;
  end;
end;

function TmProperty.GetValueStr: String;
var
  vFormatoDataHora : String;
begin
  vFormatoDataHora := 'dd/mm/yyyy hh:nn:ss';

  case Tipo of
    tppBoolean:
      Result := IfThen(ValueBoolean, 'T', 'F');
    tppDateTime:
      Result := FormatDateTime(vFormatoDataHora, ValueDateTime);
    tppEnum:
      Result := IntToStr(ValueInteger);
    tppInteger:
      Result := IntToStr(ValueInteger);
    tppFloat:
      Result := FloatToStr(ValueFloat);
    tppString:
      Result := ValueString;
    tppVariant:
      Result := ValueVariant;
  end;
end;

procedure TmProperty.SetValueDatabase(const Value: String);
begin
  case Tipo of
    tppBoolean:
      ValueBoolean := (Value = 'T');
    tppDateTime:
      ValueDateTime := StrToDateTimeDef(Value, 0);
    tppInteger:
      ValueInteger := StrToIntDef(Value, 0);
    tppEnum:
      ValueInteger := StrToIntDef(Value, 0);
    tppFloat:
      ValueFloat := StrToFloatDef(Value, 0);
    tppString:
      ValueString := Value;
    tppVariant:
      ValueVariant := Value;
  end;
end;

procedure TmProperty.SetNome(const Value: String);
begin
  fNome := Value;
  fTipoCampo := StrToTipoCampo(Copy(Value, 1, 3));
end;

{ TmPropertyList }

function TmPropertyList.GetItem(Index: Integer): TmProperty;
begin
  Result := TmProperty(Self[Index]);
end;

procedure TmPropertyList.SetItem(Index: Integer; const Value: TmProperty);
begin
  Self[Index] := Value;
end;

function TmPropertyList.Add: TmProperty;
begin
  Result := TmProperty.Create;
  Self.Add(Result);
end;

function TmPropertyList.IndexOf(ANome: String): TmProperty;
begin
  Result := TmPropertyValue.IndexOf(Self, ANome);
end;

{ TmPropertyValue }

class function TmPropertyValue.IndexOf(AProperties : TList; ANome : String) : TmProperty;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to AProperties.Count - 1 do begin
    with TmProperty(AProperties[I]) do begin
      if LowerCase(Nome) = LowerCase(ANome) then begin
        Result := TmProperty(AProperties[I]);
        Exit;
      end;
    end;
  end;
end;

end.
