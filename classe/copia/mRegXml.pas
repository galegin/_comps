unit mRegXml;

interface

uses
  Classes, SysUtils;

type
  TTipoRegXml = (tpvId, tpvValue);

  TmRegXml = class(TStringList)
  private
    fTagInicial : String;
    fTagFinal : String;
    fExpression : String;
    procedure SetExpression(const Value: String);
    function GetMatch(Index: TTipoRegXml): String;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function Exec(AString : String) : Boolean; overload;
    function Exec(ATipo : TTipoRegXml; AString, AExpression  : String) : String; overload;
    property Expression : String read fExpression write SetExpression;
    property Match[Index : TTipoRegXml] : String read GetMatch;
  end;

  function Instance : TmRegXml;
  procedure Destroy;

implementation

uses
  mString, StrUtils;

var
  _instance : TmRegXml;

  function Instance : TmRegXml;
  begin
    if not Assigned(_instance) then
      _instance := TmRegXml.Create;
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

{ TmRegXml }

constructor TmRegXml.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TmRegXml.Destroy;
begin

  inherited;
end;

//--

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
  if fTagFinal = '' then
    PF := Length(AString) + 1;
  if PF = 0 then
    Exit;

  AString := Copy(AString, 1, PF - 1);

  //-- adicionar valores

  Add(fTagInicial + AString + fTagFinal);
  Add(AString);

  Result := True;
end;

function TmRegXml.Exec(ATipo : TTipoRegXml; AString, AExpression : String) : String;
begin
  Result := '';

  if AString = '' then
    Exit;

  Expression := AnsiReplaceStr(AExpression, '{val}', '(.*?)');

  if Exec(AString) then
    Result := Match[ATipo];
end;

initialization
  //Instance();

finalization
  Destroy();

end.