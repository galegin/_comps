unit mTempoString;

(* mTempoString *)

interface

uses
  Classes, SysUtils, StrUtils,
  mTipoTempo, mString;

type
  RTempoString = record
    Ano : Integer;
    Mes : Integer;
    Dia : Integer;
    Hor : Integer;
    Min : Integer;
    Seg : Integer;
    Mil : Integer;
  end;

  TmTempoString = class(TComponent)
  private
    fTempoR: RTempoString;
    fTipo: TTipoTempo;

    function GetTempoS: String;
    procedure SetTempoS(const Value: String);

    function GetAno: Integer;
    function GetMes: Integer;
    function GetDia: Integer;
    function GetHor: Integer;
    function GetMin: Integer;
    function GetSeg: Integer;
    function GetMil: Integer;
  public
    property Tipo : TTipoTempo read fTipo write fTipo;

    property TempoR : RTempoString read fTempoR write fTempoR;
    property TempoS : String read GetTempoS write SetTempoS;

    property Ano : Integer read GetAno;
    property Mes : Integer read GetMes;
    property Dia : Integer read GetDia;
    property Hor : Integer read GetHor;
    property Min : Integer read GetMin;
    property Seg : Integer read GetSeg;
    property Mil : Integer read GetMil;

    function Contar(ATempo : String) : String;
    function Somar(ATempo : String) : String;
    function Media(ATempo : String) : String;
    function Maior(ATempo : String) : String;
    function Menor(ATempo : String) : String;
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
  begin
    Result.Ano := 0;
    Result.Mes := 0;
    Result.Dia := 0;
    Result.Hor := 0;
    Result.Min := 0;
    Result.Seg := 0;
    Result.Mil := 0;

    vStringArray := TmString.Split(ATempo, ':');

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
  begin
    case ATipo of
      ttAno : begin
        Result := Format('%d:%d', [ATempo.Ano, ATempo.Mes]);
      end;
      ttMes : begin
        Result := Format('%d:%d', [ATempo.Mes, ATempo.Dia]);
      end;
      ttDia : begin
        Result := Format('%d:%d', [ATempo.Dia, ATempo.Hor]);
      end;
      ttHor : begin
        Result := Format('%d:%d', [ATempo.Hor, ATempo.Min]);
      end;
      ttMin : begin
        Result := Format('%d:%d', [ATempo.Min, ATempo.Seg]);
      end;
      ttSeg : begin
        Result := Format('%d:%d', [ATempo.Seg, ATempo.Mil]);
      end;
    end;
  end;

  //--

  function RealToTempoString(const ATipo : TTipoTempo; const ATempo : Real) : RTempoString;
  var
    vMultiplo, vTempo : Real;
  begin
    vTempo := ATempo;
    
    Result.Ano := 0;
    Result.Mes := 0;
    Result.Dia := 0;
    Result.Hor := 0;
    Result.Min := 0;
    Result.Seg := 0;
    Result.Mil := 0;

    vMultiplo := GetTipoTempo(TipoTempoToStr(ATipo)).Multiplo;

    case ATipo of
      ttAno : begin
        Result.Ano := trunc(vTempo / vMultiplo);
        Result.Mes := trunc(vTempo - (vTempo * vMultiplo));
      end;
      ttMes : begin
        Result.Mes := trunc(vTempo / vMultiplo);
        Result.Dia := trunc(vTempo - (vTempo * vMultiplo));
      end;
      ttDia : begin
        Result.Dia := trunc(vTempo / vMultiplo);
        Result.Hor := trunc(vTempo - (vTempo * vMultiplo));
      end;
      ttHor : begin
        Result.Hor := trunc(vTempo / vMultiplo);
        Result.Min := trunc(vTempo - (vTempo * vMultiplo));
      end;
      ttMin : begin
        Result.Min := trunc(vTempo / vMultiplo);
        Result.Seg := trunc(vTempo - (vTempo * vMultiplo));
      end;
      ttSeg : begin
        Result.Seg := trunc(vTempo / vMultiplo);
        Result.Mil := trunc(vTempo - (vTempo * vMultiplo));
      end;
    end;
  end;

  function TempoStringToReal(const ATipo : TTipoTempo; const ATempo : RTempoString) : Real;
  var
    vMultiplo : Real;
  begin
    Result := 0;

    vMultiplo := GetTipoTempo(TipoTempoToStr(ATipo)).Multiplo;

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
  end;

  //--

  procedure SomarTempoString(const ATipo : TTipoTempo; var ATempo : RTempoString; const ATempoSoma : RTempoString);
  begin
    case ATipo of
      ttAno : begin
        ATempo.Ano := ATempo.Ano + ATempoSoma.Ano;
        ATempo.Mes := ATempo.Mes + ATempoSoma.Mes;
        if ATempo.Mes > 12 then begin
          ATempo.Ano := ATempo.Ano + 1;
          ATempo.Mes := ATempo.Mes - 12;
        end;
      end;
      ttMes : begin
        ATempo.Mes := ATempo.Mes + ATempoSoma.Mes;
        ATempo.Dia := ATempo.Dia + ATempoSoma.Dia;
        if ATempo.Dia > 30 then begin
          ATempo.Mes := ATempo.Ano + 1;
          ATempo.Dia := ATempo.Dia - 30;
        end;
      end;
      ttDia : begin
        ATempo.Dia := ATempo.Dia + ATempoSoma.Dia;
        ATempo.Hor := ATempo.Hor + ATempoSoma.Hor;
        if ATempo.Hor > 23 then begin
          ATempo.Dia := ATempo.Dia + 1;
          ATempo.Hor := ATempo.Hor - 23;
        end;
      end;
      ttHor : begin
        ATempo.Hor := ATempo.Hor + ATempoSoma.Hor;
        ATempo.Min := ATempo.Min + ATempoSoma.Min;
        if ATempo.Min > 59 then begin
          ATempo.Hor := ATempo.Hor + 1;
          ATempo.Min := ATempo.Min - 59;
        end;
      end;
      ttMin : begin
        ATempo.Min := ATempo.Min + ATempoSoma.Min;
        ATempo.Seg := ATempo.Seg + ATempoSoma.Seg;
        if ATempo.Seg > 59 then begin
          ATempo.Min := ATempo.Min + 1;
          ATempo.Seg := ATempo.Seg - 59;
        end;
      end;
      ttSeg : begin
        ATempo.Seg := ATempo.Seg + ATempoSoma.Seg;
        ATempo.Mil := ATempo.Mil + ATempoSoma.Mil;
        if ATempo.Mil > 1000 then begin
          ATempo.Seg := ATempo.Seg + 1;
          ATempo.Mil := ATempo.Mil - 1000;
        end;
      end;
    end;
  end;

  //--

  function TmTempoString.GetAno: Integer;
  begin
    Result := fTempoR.Ano;
  end;

  function TmTempoString.GetMes: Integer;
  begin
    Result := fTempoR.Mes;
  end;

  function TmTempoString.GetDia: Integer;
  begin
    Result := fTempoR.Dia;
  end;

  function TmTempoString.GetHor: Integer;
  begin
    Result := fTempoR.Hor;
  end;

  function TmTempoString.GetMin: Integer;
  begin
    Result := fTempoR.Min;
  end;

  function TmTempoString.GetSeg: Integer;
  begin
    Result := fTempoR.Seg;
  end;

  function TmTempoString.GetMil: Integer;
  begin
    Result := fTempoR.Mil;
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
