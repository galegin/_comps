unit mProperty;

interface

uses
  Classes, SysUtils, StrUtils,
  mParametroDatabase;

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
    function GetIsValueDatabase: Boolean;
    function GetIsValueFiltro: Boolean;
    function GetIsValueList: Boolean;
    function GetIsValueObject: Boolean;
    function GetIsValueStr: Boolean;
    function GetIsValueVariant: Boolean;

    function GetValueDatabase: String;
    procedure SetValueDatabase(const Value: String);
    function GetValueIntegracao: String;
    function GetValueStr: String;
    function GetTipoDatabase: String;
  public
    Nome : String;
    TipoBase : String;

    Tipo : TpProperty;
    TipoField : TpField;

    ValueBoolean : Boolean;
    ValueDateTime : TDateTime;
    ValueEnum : Integer;
    ValueFloat : Real;
    ValueInteger : Integer;
    ValueString : String;
    ValueList : TList;
    ValueVariant : Variant;
    ValueObject : TObject;

    property IsValueDatabase : Boolean read GetIsValueDatabase;
    property IsValueFiltro : Boolean read GetIsValueFiltro;
    property IsValueList : Boolean read GetIsValueList;
    property IsValueObject : Boolean read GetIsValueObject;
    property IsValueStr : Boolean read GetIsValueStr;
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
    function Adicionar : TmProperty; overload;
    procedure Adicionar(item : TmProperty); overload;
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
    tppString, tppVariant]); // and (Pos(Nome, 'IsUpdate') = 0);
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

function TmProperty.GetIsValueVariant: Boolean;
begin
  Result := Tipo in [tppVariant];
end;

function TmProperty.GetIsValueStr: Boolean;
begin
  Result := GetIsValueDatabase;
end;

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

{ TmPropertyList }

function TmPropertyList.GetItem(Index: Integer): TmProperty;
begin
  Result := TmProperty(Self[Index]);
end;

procedure TmPropertyList.SetItem(Index: Integer; const Value: TmProperty);
begin
  Self[Index] := Value;
end;

function TmPropertyList.Adicionar: TmProperty;
begin
  Result := TmProperty.Create;
  Self.Add(Result);
end;

procedure TmPropertyList.Adicionar(item : TmProperty);
begin
  Self.Add(item);
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
