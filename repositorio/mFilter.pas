unit mFilter;

interface

uses
  Classes, SysUtils, StrUtils,
  mProperty;

type
  TmFilter = class;
  TmFilterClass = class of TmFilter;

  TmFilterList = class;
  TmFilterListClass = class of TmFilterList;

  TTipoFilter = (
    tpfIntervalo,
    tpfDiferente,
    tpfIgual,
    tpfMaior,
    tpfMaiorIgual,
    tpfMenor,
    tpfMenorIgual,
    tpfNaoNulo,
    tpfNulo,
    tpfLike,
    tpfLista);

  TmFilter = class
  private
    fNome: String;
    fFinal: TmProperty;
    fInicial: TmProperty;
    fTipo: TTipoFilter;
    function GetValueDatabase: String;
  public
    constructor Create(ANome : String; ATipo : TTipoFilter); overload;

    constructor CreateB(ANome : String; ATipo : TTipoFilter; AInicial : Boolean); overload;
    constructor CreateB(ANome : String; AInicial : Boolean); overload;

    constructor CreateD(ANome : String; ATipo : TTipoFilter; AInicial : TDateTime); overload;
    constructor CreateD(ANome : String; AInicial : TDateTime; AFinal : TDateTime); overload;
    constructor CreateD(ANome : String; AInicial : TDateTime); overload;

    constructor CreateF(ANome : String; ATipo : TTipoFilter; AInicial : Real); overload;
    constructor CreateF(ANome : String; AInicial : Real; AFinal : Real); overload;
    constructor CreateF(ANome : String; AInicial : Real); overload;

    constructor CreateI(ANome : String; ATipo : TTipoFilter; AInicial : Integer); overload;
    constructor CreateI(ANome : String; AInicial : Integer; AFinal : Integer); overload;
    constructor CreateI(ANome : String; AInicial : Integer); overload;

    constructor CreateS(ANome : String; ATipo : TTipoFilter; AInicial : String); overload;
    constructor CreateS(ANome : String; AInicial : String; AFinal : String); overload;
    constructor CreateS(ANome : String; AInicial : String); overload;

    property Nome : String read fNome write fNome;
    property Tipo : TTipoFilter read fTipo write fTipo;
    property Inicial : TmProperty read fInicial write fInicial;
    property Final : TmProperty read fFinal write fFinal;

    property ValueDatabase : String read GetValueDatabase;
  end;

  TmFilterList = class(TList)
  private
    function GetItem(Index: Integer): TmFilter;
    procedure SetItem(Index: Integer; const Value: TmFilter);
  public
    function Adicionar : TmFilter; overload;
    procedure Adicionar(item : TmFilter); overload;
    property Items[Index: Integer] : TmFilter read GetItem write SetItem;
  end;

implementation

{ TmFilter }

constructor TmFilter.Create(ANome: String; ATipo: TTipoFilter);
begin
  Nome := ANome;
  Tipo := ATipo;
  Inicial := TmProperty.Create;
  Final := TmProperty.Create;
end;

//-- boolean

constructor TmFilter.CreateB(ANome: String; ATipo: TTipoFilter; AInicial: Boolean);
begin
  Create(ANome, ATipo);
  Inicial.Tipo := tppBoolean;
  Inicial.ValueBoolean := AInicial;
end;

constructor TmFilter.CreateB(ANome: String; AInicial: Boolean);
begin
  CreateB(ANome, tpfIgual, AInicial);
end;

//-- datetime

constructor TmFilter.CreateD(ANome : String; ATipo : TTipoFilter; AInicial : TDateTime);
begin
  Create(ANome, ATipo);
  Inicial.Tipo := tppDateTime;
  Inicial.ValueDateTime := AInicial;
end;

constructor TmFilter.CreateD(ANome : String; AInicial : TDateTime; AFinal : TDateTime);
begin
  CreateD(ANome, tpfIntervalo, AInicial);
  Final.Tipo := tppDateTime;
  Final.ValueDateTime := AFinal;
end;

constructor TmFilter.CreateD(ANome: String; AInicial: TDateTime);
begin
  CreateD(ANome, tpfIgual, AInicial);
end;

//-- float

constructor TmFilter.CreateF(ANome : String; ATipo : TTipoFilter; AInicial : Real);
begin
  Create(ANome, ATipo);
  Inicial.Tipo := tppFloat;
  Inicial.ValueFloat := AInicial;
end;

constructor TmFilter.CreateF(ANome : String; AInicial : Real; AFinal : Real);
begin
  CreateF(ANome, tpfIntervalo, AInicial);
  Final.Tipo := tppFloat;
  Final.ValueFloat := AFinal;
end;

constructor TmFilter.CreateF(ANome: String; AInicial: Real);
begin
  CreateF(ANome, tpfIgual, AInicial);
end;

//-- integer

constructor TmFilter.CreateI(ANome : String; ATipo : TTipoFilter; AInicial : Integer);
begin
  Create(ANome, ATipo);
  Inicial.Tipo := tppDateTime;
  Inicial.ValueInteger := AInicial;
end;

constructor TmFilter.CreateI(ANome : String; AInicial : Integer; AFinal : Integer);
begin
  CreateI(ANome, tpfIntervalo, AInicial);
  Final.Tipo := tppInteger;
  Final.ValueInteger := AFinal;
end;

constructor TmFilter.CreateI(ANome: String; AInicial: Integer);
begin
  CreateI(ANome, tpfIgual, AInicial);
end;

//-- string

constructor TmFilter.CreateS(ANome : String; ATipo : TTipoFilter; AInicial : String);
begin
  Create(ANome, ATipo);
  Inicial.Tipo := tppString;
  Inicial.ValueString := AInicial;
end;

constructor TmFilter.CreateS(ANome : String; AInicial : String; AFinal : String);
begin
  CreateS(ANome, tpfIntervalo, AInicial);
  Final.Tipo := tppString;
  Final.ValueString := AFinal;
end;

constructor TmFilter.CreateS(ANome, AInicial: String);
begin
  CreateS(ANome, tpfIgual, AInicial);
end;

//-- database

const
  TTipoFilter_Database : Array [TTipoFilter] of string = (
    '{cod} between {ini} and {fin}',
    '{cod} != {ini}',
    '{cod} = {ini}',
    '{cod} > {ini}',
    '{cod} >= {ini}',
    '{cod} < {ini}',
    '{cod} <= {ini}',
    '{cod} is not null',
    '{cod} is null',
    '{cod} like {ini}',
    '{cod} in ({ini})');

function TmFilter.GetValueDatabase: String;
var
  vInicial, vFinal : String;
begin
  vInicial := Inicial.ValueDatabase;
  vFinal := Final.ValueDatabase;

  if Tipo in [tpfLista] then begin
    vInicial := AnsiReplaceStr(vInicial, '''', '');
  end else if Tipo in [tpfLike] then begin
    vInicial := AnsiReplaceStr(vInicial, '''', '');
    vInicial := '''%''' + AnsiReplaceStr(vInicial, ' ', '%') + '''%''';
  end;

  Result := TTipoFilter_Database[Tipo];
  Result := AnsiReplaceStr(Result, '{cod}', UpperCase(Nome));
  Result := AnsiReplaceStr(Result, '{ini}', vInicial);
  Result := AnsiReplaceStr(Result, '{fin}', vFinal);
end;

{ TmFilterList }

function TmFilterList.GetItem(Index: Integer): TmFilter;
begin
  Result := TmFilter(Self[Index]);
end;

procedure TmFilterList.SetItem(Index: Integer; const Value: TmFilter);
begin
  Self[Index] := Value;
end;

function TmFilterList.Adicionar: TmFilter;
begin
  Result := TmFilter.Create;
  Self.Add(Result);
end;

procedure TmFilterList.Adicionar(item : TmFilter);
begin
  Self.Add(item);
end;

end.