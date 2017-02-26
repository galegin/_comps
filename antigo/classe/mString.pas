unit mString;

interface

uses
  Classes, SysUtils, StrUtils;

  function PriMaiuscula(pPalavra : String) : String;
  function HexaToString(pString : String; pTam : Integer = 3) : String;
  function StringToHexa(pString : String; pTam : Integer = 3) : String;
  function StringSort(pString : String) : String;

  function GetLeftStr(pStr, pCod : String) : String;
  function GetRightStr(pStr, pCod : String) : String;

  function startsWiths(pStr, pVal : String) : Boolean;
  function endWiths(pStr, pVal : String) : Boolean;

  function contemTodasPalavra(pLstPalavra, pString : String) : Boolean;
  function contemQualquerPalavra(pLstPalavra, pString : String) : Boolean;

implementation

{ TmString }

uses
  mFuncao, mItem;

function PriMaiuscula(pPalavra : String) : String;
var
  I : Integer;
begin
  Result := pPalavra;
  if (Result = '') then Exit;

  Result := AnsiReplaceStr(Result, '_', ' ');

  for I:=1 to Length(Result) do
    if (I=1) or (Result[I-1] in [' ', '.']) then
      Result[I] := UpCase(Result[I])
    else
      Result[I] := LwCase(Result[I]);
      
end;

function HexaToString(pString: String; pTam : Integer): String;
begin
  Result := '';
  while (pString <> '') do begin
    Result := Result + Chr(StrToInt('$' + Copy(pString,1,pTam)));
    Delete(pString,1,pTam);
  end;
end;

function StringToHexa(pString: String; pTam : Integer): String;
var
  I : Integer;
begin
  Result := '';
  for I:=1 to Length(pString) do
    Result := Result + IntToHex(Ord(pString[I]),pTam);
end;

function StringSort(pString: String): String;
var
  vLista : TStringList;
begin
  vLista := TStringList.Create;
  vLista.Text := pString;
  vLista.Sort;
  Result := vLista.Text;
  vLista.Free;
end;

function GetLeftStr(pStr, pCod : String) : String;
var
  P : Integer;
begin
  Result := '';
  P := Pos(pCod, pStr);
  if (P > 0) then begin
    Result := Copy(pStr, 1, P - 1);
  end;
end;

function GetRightStr(pStr, pCod : String) : String;
var
  P : Integer;
begin
  Result := '';
  P := Pos(pCod, pStr);
  if (P > 0) then begin
    Result := Copy(pStr, P + Length(pCod), Length(pStr));
  end;
end;

//startsWiths('miguel franco galego', 'miguel');
//startsWiths('miguel franco galego', 'jose');
function startsWiths(pStr, pVal : String) : Boolean;
begin
  pStr := LowerCase(pStr);
  pVal := LowerCase(pVal);
  Result := (Copy(pStr, 1, Length(pVal)) = pVal);
  Result := Result;
end;

//endWiths('miguel franco galego', 'galego');
//endWiths('miguel franco galego', 'silva');
function endWiths(pStr, pVal : String) : Boolean;
var
  pTam : Integer;
begin
  pStr := LowerCase(pStr);
  pVal := LowerCase(pVal);
  pTam := Length(pVal);
  Result := (Copy(pStr, Length(pStr) - pTam + 1, pTam) = pVal);
  Result := Result;
end;

function contemTodasPalavra(pLstPalavra, pString : String) : Boolean;
var
  vPalavra : String;
begin
  Result := False;

  if (pLstPalavra = '') or (pString = '') then
    Exit;

  Result := True;

  pLstPalavra := UpperCase(pLstPalavra);
  pString := UpperCase(pString);

  while pLstPalavra <> '' do begin
    vPalavra := getitem(pLstPalavra);
    if vPalavra = '' then Break;
    delitem(pLstPalavra);

    if (Pos(vPalavra, pString) = 0) then begin
      Result := False;
      Exit;
    end;
  end;
end;

function contemQualquerPalavra(pLstPalavra, pString : String) : Boolean;
var
  vPalavra : String;
begin
  Result := False;

  if (pLstPalavra = '') or (pString = '') then
    Exit;

  pLstPalavra := UpperCase(pLstPalavra);
  pString := UpperCase(pString);

  while pLstPalavra <> '' do begin
    vPalavra := getitem(pLstPalavra);
    if vPalavra = '' then Break;
    delitem(pLstPalavra);

    if (Pos(vPalavra, pString) > 0) then begin
      Result := True;
      Exit;
    end;
  end;
end;

end.
