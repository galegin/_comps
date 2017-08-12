unit mDescr;

interface

uses
  Classes, SysUtils, StrUtils;

type
  TmDescr = class
  public
    class function TraduzCampo(pDescr : String) : String;
    class function TraduzCampoSem(pDescr : String) : String;
  end;

implementation

{ TmDescr }

uses
  mString, mFuncao, mItem;

class function TmDescr.TraduzCampo(pDescr : String) : String;
var
  vLstPalavra, vPalavra : String;
begin
  Result := '';

  if Pos('IN_', pDescr) > 0 then 
    pDescr := AnsiReplaceStr(pDescr, 'IN_', '');

  vLstPalavra := AnsiReplaceStr(pDescr, '_', '|');
  while vLstPalavra <> '' do begin
    vPalavra := getitem(vLstPalavra);
    if vPalavra = '' then Break;
    delitem(vLstPalavra);
    Result := Result + IfThen(Result <> '', ' ') + mString.PriMaiuscula(vPalavra);
  end;
end;

class function TmDescr.TraduzCampoSem(pDescr : String) : String;
begin
  Result := TraduzCampo(pDescr);
  Result := AnsiReplaceStr(Result, ' ', '');
end;

end.