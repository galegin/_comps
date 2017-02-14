unit mRegXml;

interface

uses
  Classes, SysUtils;

type
  TTipoRegXml = (tpvId, tpvValue);

  TmRegXml = class(TStrings)
  private
    fTagInicial : String;
    fTagFinal : String;
    fExpression: String;
    procedure SetExpression(const Value: String);
    function GetMatch(Index: TTipoRegXml): String;
  public
    function Exec(AString : String) : Boolean;
    property Expression : String read fExpression write SetExpression;
    property Match[Index : TTipoRegXml] : String read GetMatch;
  end;

implementation

uses
  mString;

{ TmRegXml }

procedure TmRegXml.SetExpression(const Value: String);
begin
  fExpression := Value;
  fTagInicial := TmString.LeftStr(Value, '(.*?)');
  fTagFinal := TmString.RightStr(Value, '(.*?)');
end;

function TmRegXml.GetMatch(Index: TTipoRegXml): String;
begin
  Result := Self[Ord(Index)];
end;

function TmRegXml.Exec(AString: String): Boolean;
var
  PI, PF : Integer;
begin
  Result := False;

  //-- limpar valores

  Clear;

  //-- verifica tag ini

  PI := Pos(fTagInicial, AString);
  if PI = 0 then
    Exit;

  if PI > 1 then
    System.Delete(AString, 1, PI - 1);

  System.Delete(AString, 1, Length(fTagInicial));

  //-- verifica tag fin

  PF := Pos(fTagFinal, AString);
  if PF = 0 then
    Exit;

  AString := Copy(AString, 1, PF - 1);

  //-- adicionar valores

  Add(fTagInicial + AString + fTagFinal);
  Add(AString);

  Result := True;
end;

end.