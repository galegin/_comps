unit mString;

interface

uses
  Classes, SysUtils, StrUtils;

type
  TmStringArray = Array Of String;

  TmString = class;
  TmStringClass = class of TmString;

  TmStringList = class;
  TmStringListClass = class of TmString;

  TmString = class
  public
    class function PrimeiraMaiscula(AString : String) : String;

    class function LeftStr(AString, ASubString : String) : String;
    class function RightStr(AString, ASubString : String) : String;

    class function StartsWiths(AString, ASubString : String) : Boolean;
    class function EndWiths(AString, ASubString : String) : Boolean;

    class function Replicate(AString : String; AQtde : Integer) : String;

    class function Split(AString : String; ASeparador : String) : TmStringArray;

    class function AllTrim(AString : String; ASubString : String = ' ') : String;

    class function RemoveAcento(ACharacter : Char) : Char; overload;
    class function RemoveAcento(AString : String) : String; overload;

    class function StringToHexa(AString : String) : String;
    class function HexaToString(AString : String) : String;
    
    class function StringInSet(AString : String; AList : Array of String) : Integer;
    class function StringNotInSet(AString : String; AList : Array of String) : Integer;
  end;

  TmStringList = class
  private
    fStringArray : TmStringArray;
    function GetItem(Index: Integer): String;
    procedure SetItem(Index: Integer; const Value: String);
  public
    procedure Clear();
    procedure Add(AString : String);
    function Count: Integer;
    property Items[Index : Integer] : String read GetItem write SetItem;
  end;

implementation

{ TmString }

  function LwCase(ch : Char) : Char;
  var
    vStr : String;
  begin
    vStr := ' ';
    vStr[1] := ch;
    vStr := LowerCase(vStr);
    Result := vStr[1];
  end;

class function TmString.PrimeiraMaiscula(AString: String): String;
var
  I : Integer;
begin
  Result := AnsiReplaceStr(AString, '_', ' ');

  for I:=1 to Length(Result) do
    if (I=1) or (Result[I-1] in [' ', '.']) then
      Result[I] := UpCase(Result[I])
    else
      Result[I] := LwCase(Result[I]);
end;

class function TmString.LeftStr(AString, ASubString : String) : String;
var
  P : Integer;
begin
  P := Pos(ASubString, AString);
  if (P > 0) then
    Result := Copy(AString, 1, P - 1)
  else
    Result := '';
end;

class function TmString.RightStr(AString, ASubString : String) : String;
var
  P : Integer;
begin
  P := Pos(ASubString, AString);
  if (P > 0) then
    Result := Copy(AString, P + Length(ASubString), Length(AString))
  else
    Result := '';
end;

//startsWiths('miguel franco galego', 'miguel');
//startsWiths('miguel franco galego', 'jose');
class function TmString.StartsWiths(AString, ASubString : String) : Boolean;
begin
  AString := LowerCase(AString);
  ASubString := LowerCase(ASubString);
  Result := (Copy(AString, 1, Length(ASubString)) = ASubString);
end;

//endWiths('miguel franco galego', 'galego');
//endWiths('miguel franco galego', 'silva');
class function TmString.EndWiths(AString, ASubString : String) : Boolean;
var
  vTam : Integer;
begin
  AString := LowerCase(AString);
  ASubString := LowerCase(ASubString);
  vTam := Length(ASubString);
  Result := (Copy(AString, Length(AString) - vTam + 1, vTam) = ASubString);
end;

class function TmString.Replicate(AString: String; AQtde: Integer): String;
begin
  Result := '';
  while AQtde > 0 do begin
    Result := Result + AString;
    Dec(AQtde);
  end;
end;

class function TmString.Split(AString, ASeparador: String): TmStringArray;
begin
  SetLength(Result, 0);

  while Pos(ASeparador, AString) > 0 do begin
    SetLength(Result, Length(Result) + 1);
    Result[High(Result)] := Copy(AString, 1, Pos(ASeparador, AString) - 1);
    Delete(AString, 1, Pos(ASeparador, AString) + Length(ASeparador) - 1);
  end;

  if AString <> '' then begin
    SetLength(Result, Length(Result) + 1);
    Result[High(Result)] := AString;
  end;
end;

class function TmString.AllTrim(AString, ASubString: String): String;
var
  vTam : Integer;
begin
  Result := AString;

  vTam := Length(ASubString);

  while Copy(Result, 1, vTam) = ASubString do
    Delete(Result, 1, vTam);

  while Copy(Result, Length(Result), vTam) = ASubString do
    Delete(Result, Length(Result), vTam);

  ASubString := ASubString + ASubString;

  while Pos(ASubString, Result) > 0 do
    Delete(Result, Pos(ASubString, Result), vTam);
end;

class function TmString.RemoveAcento(ACharacter: Char): Char;
const
  ComAcento = '����������������������������';
  SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU';
begin
  Result := ACharacter;
  if Pos(ACharacter, ComAcento) > 0 then
    Result:= SemAcento[Pos(ACharacter, ComAcento)];
end;

class function TmString.RemoveAcento(AString: String): String;
var
  I : Integer;
begin
  Result := '';
  for I := 1 to Length(AString) do
    Result := Result + RemoveAcento(AString[I]);
end;

class function TmString.HexaToString(AString: String): String;
begin

end;

class function TmString.StringToHexa(AString: String): String;
begin

end;

//--

class function TmString.StringInSet(AString : String; AList : Array of String) : Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := Low(AList) to High(AList) do begin
    if AList[I] = AString then begin
      Result := I;
      Exit;
    end;
  end;
end;

class function TmString.StringNotInSet(AString : String; AList : Array of String) : Integer;
begin
  Result := not StringInSet(AString, AList);
end;

{ TmStringList }

procedure TmStringList.Clear;
begin
  SetLength(fStringArray, 0);
end;

procedure TmStringList.Add(AString: String);
begin
  SetLength(fStringArray, Length(fStringArray) + 1);
  fStringArray[High(fStringArray)] := AString;
end;

function TmStringList.Count: Integer;
begin
  Result := Length(fStringArray);
end;

function TmStringList.GetItem(Index: Integer): String;
begin
  Result := fStringArray[Index];
end;

procedure TmStringList.SetItem(Index: Integer; const Value: String);
begin
  fStringArray[Index] := Value;
end;

end.