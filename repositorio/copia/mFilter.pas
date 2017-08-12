unit mFilter;

interface

uses
  Classes, SysUtils, StrUtils,
  mValue;

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
    fFinal: TmValue;
    fInicial: TmValue;
    fLista: TmValueList;
    fTipo: TTipoFilter;
    function GetValueBase: String;
  public
    constructor Create(ANome : String; ATipo : TTipoFilter); overload;

    constructor CreateB(ANome : String; ATipo : TTipoFilter; AInicial : Boolean); overload;
    constructor CreateB(ANome : String; AInicial : Boolean); overload;

    constructor CreateD(ANome : String; ATipo : TTipoFilter; AInicial : TDateTime); overload;
    constructor CreateD(ANome : String; AInicial : TDateTime; AFinal : TDateTime); overload;
    constructor CreateD(ANome : String; AInicial : TDateTime); overload;
    constructor CreateD(ANome : String; ALista : Array Of TDateTime); overload;

    constructor CreateF(ANome : String; ATipo : TTipoFilter; AInicial : Real); overload;
    constructor CreateF(ANome : String; AInicial : Real; AFinal : Real); overload;
    constructor CreateF(ANome : String; AInicial : Real); overload;
    constructor CreateF(ANome : String; ALista : Array Of Real); overload;

    constructor CreateI(ANome : String; ATipo : TTipoFilter; AInicial : Integer); overload;
    constructor CreateI(ANome : String; AInicial : Integer; AFinal : Integer); overload;
    constructor CreateI(ANome : String; AInicial : Integer); overload;
    constructor CreateI(ANome : String; ALista : Array Of Integer); overload;

    constructor CreateS(ANome : String; ATipo : TTipoFilter; AInicial : String); overload;
    constructor CreateS(ANome : String; AInicial : String; AFinal : String); overload;
    constructor CreateS(ANome : String; AInicial : String); overload;
    constructor CreateS(ANome : String; ALista : Array Of String); overload;

    property Nome : String read fNome write fNome;
    property Tipo : TTipoFilter read fTipo write fTipo;
    property Inicial : TmValue read fInicial write fInicial;
    property Final : TmValue read fFinal write fFinal;

    property ValueBase : String read GetValueBase;
  end;

  TmFilterList = class(TList)
  private
    function GetItem(Index: Integer): TmFilter;
    procedure SetItem(Index: Integer; const Value: TmFilter);
  public
    function Add : TmFilter; overload;
    property Items[Index: Integer] : TmFilter read GetItem write SetItem;
  end;

implementation

{ TmFilter }

constructor TmFilter.Create(ANome: String; ATipo: TTipoFilter);
begin
  fNome := ANome;
  fTipo := ATipo;
  fInicial := TmValueStr.Create(ANome, '');
  fFinal := TmValueStr.Create(ANome, '');
  fLista := TmValueList.Create;
end;

//-- boolean

constructor TmFilter.CreateB(ANome: String; ATipo: TTipoFilter; AInicial: Boolean);
begin
  Create(ANome, ATipo);
  Inicial := TmValueBool.Create(ANome, AInicial);
end;

constructor TmFilter.CreateB(ANome: String; AInicial: Boolean);
begin
  CreateB(ANome, tpfIgual, AInicial);
end;

//-- datetime

constructor TmFilter.CreateD(ANome : String; ATipo : TTipoFilter; AInicial : TDateTime);
begin
  Create(ANome, ATipo);
  Inicial := TmValueDate.Create(ANome, AInicial);
end;

constructor TmFilter.CreateD(ANome : String; AInicial : TDateTime; AFinal : TDateTime);
begin
  CreateD(ANome, tpfIntervalo, AInicial);
  Final := TmValueDate.Create(ANome, AFinal);
end;

constructor TmFilter.CreateD(ANome: String; AInicial: TDateTime);
begin
  CreateD(ANome, tpfIgual, AInicial);
end;

constructor TmFilter.CreateD(ANome : String; ALista : Array Of TDateTime);
var
  I : Integer;
begin
  Create(ANome, tpfLista);

  fLista.Clear;
  for I := 0 to High(ALista) do
    fLista.AddD(ANome, ALista[I]);
end;

//-- float

constructor TmFilter.CreateF(ANome : String; ATipo : TTipoFilter; AInicial : Real);
begin
  Create(ANome, ATipo);
  Inicial := TmValueFloat.Create(ANome, AInicial);
end;

constructor TmFilter.CreateF(ANome : String; AInicial : Real; AFinal : Real);
begin
  CreateF(ANome, tpfIntervalo, AInicial);
  Final := TmValueFloat.Create(ANome, AFinal);
end;

constructor TmFilter.CreateF(ANome: String; AInicial: Real);
begin
  CreateF(ANome, tpfIgual, AInicial);
end;

constructor TmFilter.CreateF(ANome : String; ALista : Array Of Real);
var
  I : Integer;
begin
  Create(ANome, tpfLista);

  fLista.Clear;
  for I := 0 to High(ALista) do
    fLista.AddF(ANome, ALista[I]);
end;

//-- integer

constructor TmFilter.CreateI(ANome : String; ATipo : TTipoFilter; AInicial : Integer);
begin
  Create(ANome, ATipo);
  Inicial := TmValueInt.Create(ANome, AInicial);
end;

constructor TmFilter.CreateI(ANome : String; AInicial : Integer; AFinal : Integer);
begin
  CreateI(ANome, tpfIntervalo, AInicial);
  Final := TmValueInt.Create(ANome, AFinal);
end;

constructor TmFilter.CreateI(ANome: String; AInicial: Integer);
begin
  CreateI(ANome, tpfIgual, AInicial);
end;

constructor TmFilter.CreateI(ANome : String; ALista : Array Of Integer);
var
  I : Integer;
begin
  Create(ANome, tpfLista);

  fLista.Clear;
  for I := 0 to High(ALista) do
    fLista.AddI(ANome, ALista[I]);
end;

//-- string

constructor TmFilter.CreateS(ANome : String; ATipo : TTipoFilter; AInicial : String);
begin
  Create(ANome, ATipo);
  Inicial := TmValueStr.Create(ANome, AInicial);
end;

constructor TmFilter.CreateS(ANome : String; AInicial : String; AFinal : String);
begin
  CreateS(ANome, tpfIntervalo, AInicial);
  Final := TmValueStr.Create(ANome, AFinal);
end;

constructor TmFilter.CreateS(ANome, AInicial: String);
begin
  CreateS(ANome, tpfIgual, AInicial);
end;

constructor TmFilter.CreateS(ANome : String; ALista : Array Of String);
var
  I : Integer;
begin
  Create(ANome, tpfLista);

  fLista.Clear;
  for I := 0 to High(ALista) do
    fLista.AddS(ANome, ALista[I]);
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

function TmFilter.GetValueBase: String;
var
  vInicial, vFinal : String;
  I : Integer;
begin
  vInicial := Inicial.ValueBase;
  vFinal := Final.ValueBase;

  if Tipo in [tpfLista] then begin
    vInicial := '';
    if fLista.Count > 0 then begin
      for I := 0 to fLista.Count - 1 do
        vInicial := vInicial + IfThen(vInicial <> '', ',') +
          fLista.Items[I].ValueBase;
    end else
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

function TmFilterList.Add: TmFilter;
begin
  Result := TmFilter.Create;
  Self.Add(Result);
end;

end.
