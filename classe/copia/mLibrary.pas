unit mLibrary;

(* mLibrary *)

interface

uses
  Classes, SysUtils, StrUtils;

type
  TmLibrary = class
  private
    fNome : String;
    fHandle : THandle;
  public
    constructor Create(ANome : String; AHandle : THandle);
  published
    property Nome : String read fNome write fNome;
    property Handle : THandle read fHandle write fHandle;
  end;

  TmLibraryList = class(TList)
  private
    function GetItem(Index: Integer): TmLibrary;
    procedure SetItem(Index: Integer; const Value: TmLibrary);
  public
    function Add(ANome : String; AHandle : THandle) : TmLibrary; overload;
    function Buscar(ANome : String) : TmLibrary;
    procedure Remove(ANome : String); overload;
    property Items[Index : Integer] : TmLibrary read GetItem write SetItem;
  end;

  function Instance : TmLibraryList;
  procedure Destroy;

implementation

var
  _instance : TmLibraryList;

  function Instance : TmLibraryList;
  begin
    if not Assigned(_instance) then
      _instance := TmLibraryList.Create;
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

(* mLibrary *)

constructor TmLibrary.Create(ANome : String; AHandle : THandle);
begin
  fNome := ANome;
  fHandle := AHandle;
end;

{ TmLibraryList }

function TmLibraryList.Add(ANome : String; AHandle : THandle): TmLibrary;
begin
  Result := TmLibrary.Create(ANome, AHandle);
  Self.Add(Result);
end;

function TmLibraryList.GetItem(Index: Integer): TmLibrary;
begin
  Result := TmLibrary(Self[Index]);
end;

procedure TmLibraryList.SetItem(Index: Integer; const Value: TmLibrary);
begin
  Self[Index] := Value;
end;

function TmLibraryList.Buscar(ANome: String): TmLibrary;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if TmLibrary(Self[I]).Nome = ANome then begin
      Result := TmLibrary(Self[I]);
      Exit;
    end;
end;

procedure TmLibraryList.Remove(ANome: String);
var
  I : Integer;
begin
  for I := Count - 1 downto 0 do
    if TmLibrary(Self[I]).Nome = ANome then begin
      Self.Remove(Self[I]);
      Exit;
    end;
end;

initialization
  //Instance();

finalization
  Destroy();

end.