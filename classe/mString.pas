unit mString;

interface

uses
  Classes, SysUtils, StrUtils, Dialogs;

type
  TmStringArray = Array Of String;

  TmString = class;
  TmStringClass = class of TmString;

  TmStringList = class;
  TmStringListClass = class of TmString;

  TmString = class
  public
    class function PrimeiraMaiscula(AString : String) : String;

    class function PosInv(ASubString, AString : String) : Integer;

    class function QtdOccurrence(AString, ASubString : String) : Integer;
    class function PosOccurrence(AString, ASubString : String; AOcurrence : Integer) : String;

    class function LeftStr(AString, ASubString : String) : String;
    class function LeftStrInv(AString, ASubString : String) : String;
    class function RightStr(AString, ASubString : String) : String;
    class function RightStrInv(AString, ASubString : String) : String;

    class function StartsWiths(AString, ASubString : String) : Boolean;
    class function EndWiths(AString, ASubString : String) : Boolean;

    class function Replicate(AString : String; AQtde : Integer) : String;

    class function Split(AString : String; ASeparador : String) : TmStringArray;

    class function AllTrim(AString : String; ASubString : String = ' ') : String;

    class function RemoveAcento(ACharacter : Char) : Char; overload;
    class function RemoveAcento(AString : String) : String; overload;

    class function StringToHexa(AString : String) : String;
    class function HexaToString(AString : String) : String;

    class function Contains(AString : String; AList : Array of String) : Integer;
    class function NotContains(AString : String; AList : Array of String) : Integer;

    class function SoAlfa(AString : String) : String;
    class function SoAlfaNumerico(AString : String) : String;
    class function SoDigitos(AString : String) : String;
    class function SoDigitosFloat(AString : String) : String;

    class function IfNull(AString, ANulo : String) : String;
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
    function GetString(ASeparador : String) : String;
  end;

  (* TmStringListL = class(TList)
  private
    function GetItem(Index: Integer): TmStringObj;
    procedure SetItem(Index: Integer; const Value: TmStringObj);
  public
    procedure Clear();
    procedure Add(AString : String);
    function Count: Integer;
    property Items[Index : Integer] : TmStringObj read GetItem write SetItem;
    function GetString(ASeparador : String) : String;
  end; *)

  TmStringListT = class(TStrings)
  private
    fList: Array Of String;
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
  public
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
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

//--

class function TmString.PosInv(ASubString, AString : String) : Integer;
begin
  Result := Length(AString);
  while (Result > 0) and (Copy(AString, Result, Length(ASubString)) <> ASubString) do
    Dec(Result);
end;

//--

class function TmString.QtdOccurrence(AString, ASubString : String) : Integer;
begin
  Result := 0;
  while Pos(ASubString, AString) > 0 do begin
    Delete(AString, 1, Pos(ASubString, AString) + Length(ASubString));
    Inc(Result);
  end;
end;

class function TmString.PosOccurrence(AString, ASubString : String; AOcurrence : Integer) : String;
var
  vPosition, vIteration : Integer;
begin
  Result := '';
  vIteration := 0;
  while (vIteration < AOcurrence) do begin
    vPosition := Pos(ASubString, AString);
    if vPosition = 0 then Break;
    Result := Result + Copy(AString, 1, vPosition + Length(ASubString));
    Delete(AString, 1, vPosition + Length(ASubString));
    Inc(vIteration);
  end;
end;

//--

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

class function TmString.LeftStrInv(AString, ASubString : String) : String;
var
  P : Integer;
begin
  P := PosInv(ASubString, AString);
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

class function TmString.RightStrInv(AString, ASubString : String) : String;
var
  P : Integer;
begin
  P := PosInv(ASubString, AString);
  if (P > 0) then
    Result := Copy(AString, P + Length(ASubString), Length(AString))
  else
    Result := '';
end;

//--

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

//--

class function TmString.Replicate(AString: String; AQtde: Integer): String;
begin
  Result := '';
  while AQtde > 0 do begin
    Result := Result + AString;
    Dec(AQtde);
  end;
end;

//--

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

//--

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

//--

class function TmString.RemoveAcento(ACharacter: Char): Char;
const
  ComAcento = 'àâêôûãõáéíóúçüÀÂÊÔÛÃÕÁÉÍÓÚÇÜ';
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

//--

class function TmString.HexaToString(AString: String): String;
begin

end;

class function TmString.StringToHexa(AString: String): String;
begin

end;

//--

class function TmString.Contains(AString : String; AList : Array of String) : Integer;
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

class function TmString.NotContains(AString : String; AList : Array of String) : Integer;
begin
  Result := not Contains(AString, AList);
end;

//--

class function TmString.SoAlfa(AString: String): String;
var
  I : Integer;
begin
  Result := '';
  for I := 1 to Length(AString) do
   if AString[I] in ['a'..'z', 'A'..'Z'] then
     Result := Result + AString[I];
end;

class function TmString.SoAlfaNumerico(AString: String): String;
var
  I : Integer;
begin
  Result := '';
  for I := 1 to Length(AString) do
   if AString[I] in ['a'..'z', 'A'..'Z', '0'..'9'] then
     Result := Result + AString[I];
end;

class function TmString.SoDigitos(AString: String): String;
var
  I : Integer;
begin
  Result := '';
  for I := 1 to Length(AString) do
   if AString[I] in ['0'..'9'] then
     Result := Result + AString[I];
end;

class function TmString.SoDigitosFloat(AString: String): String;
var
  I : Integer;
begin
  Result := '';
  for I := 1 to Length(AString) do
   if AString[I] in ['0'..'9', ','] then
     Result := Result + AString[I];
end;

class function TmString.IfNull(AString, ANulo: String): String;
begin
  Result := IfThen(AString <> '', AString, ANulo);
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

function TmStringList.GetString(ASeparador: String): String;
var
  I : Integer;
begin
  Result := '';
  for I := 0 to High(fStringArray) do
    Result := Result + IfThen(Result <> '', ASeparador) + fStringArray[I];
end;

{ TmStringListT }

procedure TmStringListT.Clear;
begin
  SetLength(fList, 0);
end;

procedure TmStringListT.Delete(Index: Integer);
var
  I : Integer;
begin
  if (Index < 0) or (Index >= Length(fList)) then
    Exit;

  for I := High(fList) downto Index do
    fList[I-1] := fList[I];

  SetLength(fList, Length(fList) - 1);
end;

function TmStringListT.Get(Index: Integer): string;
begin
  if (Index < 0) or (Index >= Length(fList)) then
    Exit;

  Result := fList[Index];
end;

function TmStringListT.GetCount: Integer;
begin
  Result := Length(fList);
end;

procedure TmStringListT.Insert(Index: Integer; const S: string);
begin
  SetLength(fList, Length(fList) + 1);
  //fList[High(fList)] := S;
  fList[Index] := S;
end;

procedure Testar;
var
  vStringList : TmStringList;
  vStringListT : TmStringListT;
  I : Integer;
begin
  vStringListT := TmStringListT.Create;
  vStringListT.Add('teste 1');
  vStringListT.Add('teste 2');
  for I := 0 to vStringListT.Count - 1 do
    ShowMessage(vStringListT[I]);

  vStringList := TmStringList.Create;
  vStringList.Add('teste 1');
  vStringList.Add('teste 2');
  for I := 0 to vStringList.Count - 1 do
    ShowMessage(vStringList.Items[I]);
end;

initialization
  //Testar();

end.