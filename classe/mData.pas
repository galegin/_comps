unit mData;

interface

uses
  Classes, SysUtils, StrUtils, DateUtils;

type
  TmData = class
  public
    class procedure IncData(var pData : TDateTime; pTipo : String; pQtde : Integer = 1);

    class function data(pData : TDateTime; pTipo : String) : Real; overload;
    class function data(pDia, pMes, pAno : Real) : TDateTime; overload;
    class function data(pDia, pMes, pAno, pHor, pMin, pSeg : Real) : TDateTime; overload;
    class function data(pData : TDateTime; pHor, pMin, pSeg : Real) : TDateTime; overload;

    class function qtdDia(pData : TDateTime) : Real;

    class function priMes(pData : TDateTime) : TDateTime;
    class function ultMes(pData : TDateTime) : TDateTime;
    class function priAno(pData : TDateTime) : TDateTime;
    class function ultAno(pData : TDateTime) : TDateTime;

    class function IsValidDate(const S: string): boolean;
    class function IsValidDateStr(const S: string): boolean;
    class function IsValidDateDem(const S: string): boolean;

    class function formata(const S, F: string): string;
  end;

  (*

  var
    text : string;
  begin
    // Just 1 data item
    ShowMessage(Format('%s', ['Hello']));

    // A mix of literal text and a data item
    ShowMessage(Format('String = %s', ['Hello']));
    ShowMessage('');

    // Examples of each of the data types
    ShowMessage(Format('Decimal          = %d', [-123]));
    ShowMessage(Format('Exponent         = %e', [12345.678]));
    ShowMessage(Format('Fixed            = %f', [12345.678]));
    ShowMessage(Format('General          = %g', [12345.678]));
    ShowMessage(Format('Number           = %n', [12345.678]));
    ShowMessage(Format('Money            = %m', [12345.678]));
    ShowMessage(Format('Pointer          = %p', [addr(text)]));
    ShowMessage(Format('String           = %s', ['Hello']));
    ShowMessage(Format('Unsigned decimal = %u', [123]));
    ShowMessage(Format('Hexadecimal      = %x', [140]));
  end;

  begin
    // The width value dictates the output size
    // with blank padding to the left
    // Note the <> characters are added to show formatting
    ShowMessage(Format('Padded decimal    = <%7d>', [1234]));

    // With the '-' operator, the data is left justified
    ShowMessage(Format('Justified decimal = <%-7d>', [1234]));

    // The precision value forces 0 padding to the desired size
    ShowMessage(Format('0 padded decimal  = <%.6d>', [1234]));

    // A combination of width and precision
    // Note that width value precedes the precision value
    ShowMessage(Format('Width + precision = <%8.6d>', [1234]));

    // The index value allows the next value in the data array
    // to be changed
    ShowMessage(Format('Reposition after 3 strings = %s %s %s %1:s %s',
                       ['Zero', 'One', 'Two', 'Three']));

    // One or more of the values may be provided by the
    // data array itself. Note that testing has shown that an *
    // for the width parameter can yield EConvertError.
    ShowMessage(Format('In line           = <%10.4d>', [1234]));
    ShowMessage(Format('Part data driven  = <%*.4d>', [10, 1234]));
    ShowMessage(Format('Data driven       = <%*.*d>', [10, 4, 1234]));
  end;

  *)

implementation

uses Math;

{ TmData }

class procedure TmData.IncData(var pData : TDateTime; pTipo : String; pQtde : Integer = 1);
begin
  pTipo := UpperCase(pTipo);

  // exemplo
  //  vData := Now;
  //  TmData.IncData(vData, 'M');
  //  TmData.IncData(vData, 'M', -1);

  if (pTipo = 'Y') then begin
    pData := IncYear(pData, pQtde);
  end else if (pTipo = 'M') then begin
    pData := IncMonth(pData, pQtde);
  end else if (pTipo = 'W') then begin
    pData := IncWeek(pData, pQtde);
  end else if (pTipo = 'D') then begin
    pData := IncDay(pData, pQtde);
  end else if (pTipo = 'H') then begin
    pData := IncHour(pData, pQtde);
  end else if (pTipo = 'N') then begin
    pData := IncMinute(pData, pQtde);
  end else if (pTipo = 'S') then begin
    pData := IncSecond(pData, pQtde);
  end else if (pTipo = 'MS') then begin
    pData := IncMilliSecond(pData, pQtde);
  end;
end;

class function TmData.data(pData : TDateTime; pTipo : String) : Real;
var
  vAno, vMes, vDia, vHor, vMin, vSeg, vMil : Word;
begin
  pTipo := UpperCase(pTipo);

  DecodeDateTime(pData, vAno, vMes, vDia, vHor, vMin, vSeg, vMil);

  if (pTipo = 'Y') then begin
    Result := vAno;
  end else if (pTipo = 'M') then begin
    Result := vMes;
  end else if (pTipo = 'D') then begin
    Result := vDia;
  end else if (pTipo = 'H') then begin
    Result := vHor;
  end else if (pTipo = 'N') then begin
    Result := vMin;
  end else if (pTipo = 'S') then begin
    Result := vSeg;
  end else if (pTipo = 'MS') then begin
    Result := vMil;
  end else begin
    Result := 0;
  end;
end;

class function TmData.data(pDia, pMes, pAno : Real) : TDateTime;
var
  vAno, vMes, vDia : Word;
begin
  vAno := trunc(pAno);
  vMes := trunc(pMes);
  vDia := trunc(pDia);

  Result := EncodeDate(vAno, vMes, vDia);
end;

class function TmData.data(pDia, pMes, pAno, pHor, pMin, pSeg : Real) : TDateTime;
var
  vAno, vMes, vDia, vHor, vMin, vSeg, vMil : Word;
begin
  vAno := trunc(pAno);
  vMes := trunc(pMes);
  vDia := trunc(pDia);
  vHor := trunc(pHor);
  vMin := trunc(pMin);
  vSeg := trunc(pSeg);
  vMil := 0;

  Result := EncodeDateTime(vAno, vMes, vDia, vHor, vMin, vSeg, vMil);
end;

class function TmData.data(pData : TDateTime; pHor, pMin, pSeg : Real) : TDateTime;
var
  vAno, vMes, vDia, vHor, vMin, vSeg, vMil : Word;
begin
  DecodeDateTime(pData, vAno, vMes, vDia, vHor, vMin, vSeg, vMil);

  vHor := trunc(pHor);
  vMin := trunc(pMin);
  vSeg := trunc(pSeg);

  Result := EncodeDateTime(vAno, vMes, vDia, vHor, vMin, vSeg, vMil);
end;

class function TmData.qtdDia(pData : TDateTime) : Real;
var
  vData : TDateTime;
begin
  pData := priMes(pData);
  vData := pData;
  IncData(vData, 'M');
  Result := vData - trunc(pData);
end;

class function TmData.priMes(pData : TDateTime) : TDateTime;
begin
  Result := data(1, data(pData, 'M'), data(pData, 'Y'));
end;

class function TmData.ultMes(pData : TDateTime) : TDateTime;
begin
  Result := data(qtdDia(pData), data(pData, 'M'), data(pData, 'Y'));
end;

class function TmData.priAno(pData : TDateTime) : TDateTime;
begin
  Result := data(1, 1, data(pData, 'Y'));
end;

class function TmData.ultAno(pData : TDateTime) : TDateTime;
begin
  Result := data(1, 12, data(pData, 'Y'));
end;

class function TmData.IsValidDate(const S: string): boolean;
const
  DAYS_OF_MONTH: array[1..12] of integer =
    (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var
  y, m, d: Integer;
begin
  result := false;
  if length(S) <> 10 then Exit;
  if (S[5] <> '/') or (S[8] <> '/') then Exit;
  if not TryStrToInt(Copy(S, 1, 4), y) then Exit;
  if not TryStrToInt(Copy(S, 6, 2), m) then Exit;
  if not InRange(m, 1, 12) then Exit;
  if not TryStrToInt(Copy(S, 9, 2), d) then Exit;
  if not InRange(d, 1, DAYS_OF_MONTH[m]) then Exit;
  if (not IsLeapYear(y)) and (m = 2) and (d = 29) then Exit;
  result := true;
end;

class function TmData.IsValidDateStr(const S: string): boolean;
var
  settings: TFormatSettings;
  MyDate: TDateTime;
begin
  settings.ShortDateFormat := 'yyyy/mm/dd';
  settings.DateSeparator := '/';
  Result := TryStrToDateTime(S, MyDate, settings);
end;

class function TmData.IsValidDateDem(const S: string): boolean;
var
  TestDate : TDateTime;
begin
  Result := False;

  if (LastDelimiter('/', S) >= 4)
  and (Length(S) - LastDelimiter('/', S) >= 4) then
    Result := TryStrToDate(S, TestDate);
end;

class function TmData.formata(const S, F: string): string;
var
   I : Integer;
begin
  Result := '';

  for I:=1 to Length(F) do begin
    if (F[I] in [':', '/', ' ']) then begin
      Result := Result + F[I];
    end else begin
      Result := Result + S[I];
    end;
  end;
end;

end.