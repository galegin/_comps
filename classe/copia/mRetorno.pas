unit mRetorno;
 
interface
 
uses
  SysUtils, mRetornoIntf;
 
type
  TRetorno = class(TInterfacedObject, IRetorno)
  private
    FMensagem: PChar;
    function Mensagem: PChar;
  public
    constructor Create(AMensagem: String; AObject: TObject); overload;
    destructor Destroy; override;
  end;

implementation

{ TString }

constructor TRetorno.Create(AMensagem: String; AObject: TObject);
var
  Size: Integer;
begin
  inherited Create;
  Size := Length(AMensagem) + 1;
  FMensagem := StrAlloc(Size);
  Move(Pointer(AMensagem)^, FMensagem^, Size);
end;

destructor TRetorno.Destroy;
begin
  StrDispose(FMensagem);
  inherited;
end;

function TRetorno.Mensagem: PChar;
begin
  Result := FMensagem;
end;

(*

//-------------------------- libray
library StrDLL;

uses
  SysUtils, Classes,
  StrIntImp, StrInt;

{$R *.RES}

function GetAutoexec: IString; stdcall;
var
  S: TStringList;
begin
  S := TStringList.Create;
  try
    S.LoadFromFile('c:\autoexec.bat');
    Result := TString.Create(S.Text);
  finally
    S.Free;
  end;
end;

exports
  GetAutoexec;

begin
end.

//-------------------------- chamada
interface
  function GetAutoexec: PChar; stdcall;

implementation
  function GetAutoexec: PChar; stdcall; external 'StrDLL.dll';

procedure ShowAutoexec;
var
  I: IString;
begin
  I := GetAutoexec;
  ShowMessage(I.Str);
end;

procedure ShowAutoexec;
begin
  ShowMessage(GetAutoexec.Str);
end;

*)

end.
