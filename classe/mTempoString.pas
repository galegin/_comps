unit mTempoString;

(* mTempoString *)

interface

uses
  Classes, SysUtils, StrUtils,
  mTipoTempo, mString;

type
  RTempoString = record
    Sinal : Integer;
    Ano : Integer;
    Mes : Integer;
    Dia : Integer;
    Hor : Integer;
    Min : Integer;
    Seg : Integer;
    Mil : Integer;
  end;

  TmTempoString = class
  private
    fTipo: TTipoTempo;

    fTempoR: RTempoString;

    function GetTempoS: String;
    procedure SetTempoS(const Value: String);
  public  
    constructor Create(ATipo : TTipoTempo; ATempo : String);
    
    function Contar(ATempo : String) : String;
    function Somar(ATempo : String) : String;
    function Media(ATempo : String) : String;
    function Maior(ATempo : String) : String;
    function Menor(ATempo : String) : String;
  published
    property Tipo : TTipoTempo read fTipo write fTipo;

    property TempoR : RTempoString read fTempoR write fTempoR;
    property TempoS : String read GetTempoS write SetTempoS;

    property Sinal : Integer read fTempoR.Sinal;
    property Ano : Integer read fTempoR.Ano;
    property Mes : Integer read fTempoR.Mes;
    property Dia : Integer read fTempoR.Dia;
    property Hor : Integer read fTempoR.Hor;
    property Min : Integer read fTempoR.Min;
    property Seg : Integer read fTempoR.Seg;
    property Mil : Integer read fTempoR.Mil;
  end;

  function StrToTempoString(const ATipo : TTipoTempo; const ATempo : string) : RTempoString;
  function TempoStringToStr(const ATipo : TTipoTempo; const ATempo : RTempoString) : String;

  function RealToTempoString(const ATipo : TTipoTempo; const ATempo : Real) : RTempoString;
  function TempoStringToReal(const ATipo : TTipoTempo; const ATempo : RTempoString) : Real;

  procedure SomarTempoString(const ATipo : TTipoTempo; var ATempo : RTempoString; const ATempoSoma : RTempoString);

implementation

{ TmTempoString }

  function StrToTempoString(const ATipo : TTipoTempo; const ATempo : string) : RTempoString;
  var
    vStringArray : TmStringArray;
    vTempo : String;
  begin
    Result.Sinal := 1;
    Result.Ano := 0;
    Result.Mes := 0;
    Result.Dia := 0;
    Result.Hor := 0;
    Result.Min := 0;
    Result.Seg := 0;
    Result.Mil := 0;

    vTempo := ATempo;

    if TmString.StartsWiths(vTempo, '-') then begin
      Result.Sinal := -1;
      Delete(vTempo, 1, 1);
    end;

    vStringArray := TmString.Split(vTempo, ':');

    if Length(vStringArray) < 2 then
      Exit;

    case ATipo of
      ttAno : begin
        Result.Ano := StrToIntDef(vStringArray[0], 0);
        Result.Mes := StrToIntDef(vStringArray[1], 0);
      end;
      ttMes : begin
        Result.Mes := StrToIntDef(vStringArray[0], 0);
        Result.Dia := StrToIntDef(vStringArray[1], 0);
      end;
      ttDia : begin
        Result.Dia := StrToIntDef(vStringArray[0], 0);
        Result.Hor := StrToIntDef(vStringArray[1], 0);
      end;
      ttHor : begin
        Result.Hor := StrToIntDef(vStringArray[0], 0);
        Result.Min := StrToIntDef(vStringArray[1], 0);
      end;
      ttMin : begin
        Result.Min := StrToIntDef(vStringArray[0], 0);
        Result.Seg := StrToIntDef(vStringArray[1], 0);
      end;
      ttSeg : begin
        Result.Seg := StrToIntDef(vStringArray[0], 0);
        Result.Mil := StrToIntDef(vStringArray[1], 0);
      end;
    end;  
  end;

  function TempoStringToStr(const ATipo : TTipoTempo; const ATempo : RTempoString) : String;
  var
    vSinal : String;
  begin
    vSinal := IfThen(ATempo.Sinal < 0, '-', '');

    case ATipo of
      ttAno : begin
        Result := vSinal + Format('%d:%2d', [ATempo.Ano, ATempo.Mes]);
      end;
      ttMes : begin
        Result := vSinal + Format('%d:%2d', [ATempo.Mes, ATempo.Dia]);
      end;
      ttDia : begin
        Result := vSinal + Format('%d:%2d', [ATempo.Dia, ATempo.Hor]);
      end;
      ttHor : begin
        Result := vSinal + Format('%d:%2d', [ATempo.Hor, ATempo.Min]);
      end;
      ttMin : begin
        Result := vSinal + Format('%d:%2d', [ATempo.Min, ATempo.Seg]);
      end;
      ttSeg : begin
        Result := vSinal + Format('%d:%3d', [ATempo.Seg, ATempo.Mil]);
      end;
    end;
  end;

  //--

  function RealToTempoString(const ATipo : TTipoTempo; const ATempo : Real) : RTempoString;
  var
    vMultiplo, vTempo : Real;
  begin
    vTempo := Abs(ATempo);

    Result.Sinal := IfThen(ATempo < 0, -1, 1);
    Result.Ano := 0;
    Result.Mes := 0;
    Result.Dia := 0;
    Result.Hor := 0;
    Result.Min := 0;
    Result.Seg := 0;
    Result.Mil := 0;

    vMultiplo := GetTpTipoTempo(TpTipoTempoToStr(ATipo)).Multiplo;

    case ATipo of
      ttAno : begin
        Result.Ano := trunc(vTempo / vMultiplo);
        Result.Mes := trunc(vTempo - (Result.Ano * vMultiplo));
      end;
      ttMes : begin
        Result.Mes := trunc(vTempo / vMultiplo);
        Result.Dia := trunc(vTempo - (Result.Mes * vMultiplo));
      end;
      ttDia : begin
        Result.Dia := trunc(vTempo / vMultiplo);
        Result.Hor := trunc(vTempo - (Result.Dia * vMultiplo));
      end;
      ttHor : begin
        Result.Hor := trunc(vTempo / vMultiplo);
        Result.Min := trunc(vTempo - (Result.Hor * vMultiplo));
      end;
      ttMin : begin
        Result.Min := trunc(vTempo / vMultiplo);
        Result.Seg := trunc(vTempo - (Result.Min * vMultiplo));
      end;
      ttSeg : begin
        Result.Seg := trunc(vTempo / vMultiplo);
        Result.Mil := trunc(vTempo - (Result.Seg * vMultiplo));
      end;
    end;
  end;

  function TempoStringToReal(const ATipo : TTipoTempo; const ATempo : RTempoString) : Real;
  var
    vMultiplo : Real;
  begin
    Result := 0;

    vMultiplo := GetTpTipoTempo(TpTipoTempoToStr(ATipo)).Multiplo;

    case ATipo of
      ttAno : begin
        Result := (ATempo.Ano * vMultiplo) + ATempo.Mes;
      end;
      ttMes : begin
        Result := (ATempo.Mes * vMultiplo) + ATempo.Dia;
      end;
      ttDia : begin
        Result := (ATempo.Dia * vMultiplo) + ATempo.Hor;
      end;
      ttHor : begin
        Result := (ATempo.Hor * vMultiplo) + ATempo.Min;
      end;
      ttMin : begin
        Result := (ATempo.Min * vMultiplo) + ATempo.Seg;
      end;
      ttSeg : begin
        Result := (ATempo.Seg * vMultiplo) + ATempo.Mil;
      end;
    end;

    Result := Result * ATempo.Sinal;
  end;

  //--

  procedure SomarTempoString(const ATipo : TTipoTempo; var ATempo : RTempoString; const ATempoSoma : RTempoString);
  var
    vQtTempo, vQtTempoSoma, vQtTempoDif : Real;
  begin
    vQtTempo := TempoStringToReal(ATipo, ATempo);
    vQtTempoSoma := TempoStringToReal(ATipo, ATempoSoma);
    vQtTempoDif := vQtTempo + vQtTempoSoma;
    ATempo := RealToTempoString(ATipo, vQtTempoDif);
  end;

  //--

  function TmTempoString.GetTempoS: String;
  begin
    Result := TempoStringToStr(Tipo, fTempoR);
  end;

  procedure TmTempoString.SetTempoS(const Value: String);
  begin
    fTempoR := StrToTempoString(Tipo, Value);
  end;

{ TmTempoString }

constructor TmTempoString.Create(ATipo : TTipoTempo; ATempo : String);
begin
  fTipo := ATipo;
  SetTempoS(ATempo);
end;  

//--

function TmTempoString.Contar(ATempo : String) : String;
begin
end;

function TmTempoString.Somar(ATempo : String) : String;
begin
  SomarTempoString(Tipo, fTempoR, StrToTempoString(Tipo, ATempo));
end;

function TmTempoString.Media(ATempo : String) : String;
begin
end;

function TmTempoString.Maior(ATempo : String) : String;
var
  vTempo : RTempoString;
begin
  vTempo := StrToTempoString(Tipo, ATempo);
  if TempoStringToReal(Tipo, vTempo) > TempoStringToReal(Tipo, fTempoR) then
    fTempoR := vTempo;
end;

function TmTempoString.Menor(ATempo : String) : String;
var
  vTempo : RTempoString;
begin
  vTempo := StrToTempoString(Tipo, ATempo);
  if TempoStringToReal(Tipo, vTempo) < TempoStringToReal(Tipo, fTempoR) then
    fTempoR := vTempo;
end;

//--

end.
