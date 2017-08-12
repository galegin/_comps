unit mConnection;

interface

uses
  Classes, SysUtils, StrUtils,
  mTipoDatabase;

type
  TmConnection = class;
  TmConnectionClass = class of TmConnection;

  TmConnectionList = class;
  TmConnectionListClass = class of TmConnectionList;

  TmConnection = class
  private
    fConnectionString : String;
  public
    property ConnectionString : String read fConnectionString write fConnectionString;
  end;

  TmConnectionList = class(TList)
  private
    function GetItem(Index: TTipoDatabase): TmConnection;
    procedure SetItem(Index: TTipoDatabase; const Value: TmConnection);
  public
    constructor Create;
    property Items[Index: TTipoDatabase]: TmConnection read GetItem write SetItem;
  end;

implementation

{ TmConnectionList }

constructor TmConnectionList.Create;
var
  I : Integer;
begin
  for I := Ord(Low(TTipoDatabase)) to Ord(High(TTipoDatabase)) do
    Add(TmConnection.Create());
end;

function TmConnectionList.GetItem(Index: TTipoDatabase): TmConnection;
begin
  Result := Self[Ord(Index)];
end;

procedure TmConnectionList.SetItem(Index: TTipoDatabase;
  const Value: TmConnection);
begin
  Self[Ord(Index)] := Value;
end;

end.
