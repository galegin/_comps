unit mDestroy;

(* mDestroy *)

interface

uses
  Classes, SysUtils, StrUtils;

type
  TmDestroy = class(TComponent)
  private
    fList: TList;
    fInDestroy : Boolean;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Add(const AObject : TObject);
    procedure Remove(const AObject : TObject);
  published
  end;

  function Instance : TmDestroy;
  procedure Destroy;

implementation

var
  _instance : TmDestroy;

  function Instance : TmDestroy;
  begin
    if not Assigned(_instance) then
      _instance := TmDestroy.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

(* mDestroy *)

constructor TmDestroy.Create(AOwner : TComponent);
begin
  inherited;

  fList:= TList.Create;

  fInDestroy:= False;
end;

destructor TmDestroy.Destroy;
var
  I : Integer;
begin
  fInDestroy:= True;

  for I := fList.Count - 1 downto 0 do
    TObject(fList[I]).Destroy;

  FreeAndNil(fList);

  inherited;
end;

procedure TmDestroy.Add(const AObject: TObject);
begin
  if not fInDestroy then
    fList.Add(AObject);
end;

procedure TmDestroy.Remove(const AObject: TObject);
begin
  if not fInDestroy then
    fList.Remove(AObject);
end;

initialization
  Instance;

finalization
  Destroy;

end.