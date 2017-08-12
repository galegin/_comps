unit mKeyValue;

interface

uses
  Classes, SysUtils;

type
  TmKeyValue = class;
  TmKeyValueList = class;

  TmKeyValue = class
  protected
    fDisplay : String;
  public
    property Display : String read fDisplay write fDisplay;
  end;

  TmKeyValueData = class(TmKeyValue)
  protected
    fValue : TDateTime;
  public
    constructor Create(ADisplay : String; AValue : TDateTime);
  published
    property Value : TDateTime read fValue write fValue;
  end;

  TmKeyValueInteiro = class(TmKeyValue)
  protected
    fValue : Integer;
  public
    constructor Create(ADisplay : String; AValue : Integer);
  published
    property Value : Integer read fValue write fValue;
  end;

  TmKeyValueNumero = class(TmKeyValue)
  protected
    fValue : Real;
  public
    constructor Create(ADisplay : String; AValue : Real);
  published
    property Value : Real read fValue write fValue;
  end;

  TmKeyValueTexto = class(TmKeyValue)
  protected
    fValue : String;
  public
    constructor Create(ADisplay : String; AValue : String);
  published
    property Value : String read fValue write fValue;
  end;

  TmKeyValueObjeto = class(TmKeyValue)
  protected
    fValue : TObject;
  public
    constructor Create(ADisplay : String; AValue : TObject);
  published
    property Value : TObject read fValue write fValue;
  end;

  TmKeyValueList = class(TList)
  private
    function GetItem(Index: Integer): TmKeyValue;
    procedure SetItem(Index: Integer; const Value: TmKeyValue);
  public
    function Add : TmKeyValue; overload;
    property Items[Index : Integer] : TmKeyValue read GetItem write SetItem;
  end;

implementation

{ TmKeyValueData }

constructor TmKeyValueData.Create(ADisplay: String; AValue: TDateTime);
begin
  fDisplay := ADisplay;
  fValue := AValue;
end;

{ TmKeyValueInteiro }

constructor TmKeyValueInteiro.Create(ADisplay: String; AValue: Integer);
begin
  fDisplay := ADisplay;
  fValue := AValue;
end;

{ TmKeyValueNumero }

constructor TmKeyValueNumero.Create(ADisplay: String; AValue: Real);
begin
  fDisplay := ADisplay;
  fValue := AValue;
end;

{ TmKeyValueTexto }

constructor TmKeyValueTexto.Create(ADisplay, AValue: String);
begin
  fDisplay := ADisplay;
  fValue := AValue;
end;

{ TmKeyValueObjeto }

constructor TmKeyValueObjeto.Create(ADisplay: String; AValue: TObject);
begin
  fDisplay := ADisplay;
  fValue := AValue;
end;

{ TmKeyValueList }

function TmKeyValueList.Add: TmKeyValue;
begin
  Result := TmKeyValue.Create;
  Self.Add(Result);
end;

function TmKeyValueList.GetItem(Index: Integer): TmKeyValue;
begin
  Result := TmKeyValue(Self[Index]);
end;

procedure TmKeyValueList.SetItem(Index: Integer; const Value: TmKeyValue);
begin
  Self[Index] := Value;
end;

end.
