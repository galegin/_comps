unit mCollectionCmd;

(* classe *)

interface

uses
  Classes, SysUtils, StrUtils,
  mProperty;

type
  TmCollectionCmd = class;
  TmCollectionCmdClass = class of TmCollectionCmd;

  TmCollectionCmdList = class;
  TmCollectionCmdListClass = class of TmCollectionCmdList;

  TTipoCollectionCmd = (tpcCount, tpcAvg, tpcMax, tpcMin, tpcSum);

  TmCollectionCmd = class
  private
    fCampo : String;
    fTipo : TTipoCollectionCmd;
    fValor : TmProperty;
    function GetField: String;
  public
    constructor Create(ACampo : String; ATipo : TTipoCollectionCmd);
    function GetComandoSelect() : String;
  published
    property Campo : String read fCampo write fCampo;
    property Field : String read GetField;
    property Tipo : TTipoCollectionCmd read fTipo write fTipo;
    property Valor : TmProperty read fValor write fValor;
  end;

  TmCollectionCmdList = class
  private
    fList : Array of TmCollectionCmd;
    function GetItem(Index: Integer): TmCollectionCmd;
    procedure SetItem(Index: Integer; const Value: TmCollectionCmd);
  public
    constructor Create;
    procedure Add(ACollectionCmd : TmCollectionCmd);
    function Count : Integer;
    property Items[Index : Integer] : TmCollectionCmd read GetItem write SetItem;
  end;

implementation

const
  TTipoCollectionCmd_Cod : Array [TTipoCollectionCmd] of String = (
    'c',
    'a',
    'm',
    'n',
    's');

  TTipoCollectionCmd_Sql : Array [TTipoCollectionCmd] of String = (
    'count(*) as {field}',
    'avg({campo}) as {field}',
    'max({campo}) as {field}',
    'min({campo}) as {field}',
    'sum({campo}) as {field}');

{ TcCollectionCmd }

constructor TmCollectionCmd.Create;
begin
  fValor := TmProperty.Create;
  fCampo := ACampo;
  fTipo := ATipo;
end;

function TmCollectionCmd.GetField: String;
begin
  Result := TTipoCollectionCmd_Cod[fTipo] + '_' + fCampo;
end;

function TmCollectionCmd.GetComandoSelect;
begin
  Result := TTipoCollectionCmd_Sql[fTipo];
  Result := AnsiReplaceStr(Result, '{campo}', fCampo);
  Result := AnsiReplaceStr(Result, '{field}', GetField());
end;

{ TmCollectionCmdList }

constructor TmCollectionCmdList.Create;
begin
  SetLength(fList, 0);
end;

procedure TmCollectionCmdList.Add;
begin
  SetLength(fList, Length(fList) + 1);
  fList[High(fList)] := ACollectionCmd;
end;

function TmCollectionCmdList.Count: Integer;
begin
  Result := Length(fList) - 1;
end;

function TmCollectionCmdList.GetItem;
begin
  Result := fList[Index];
end;

procedure TmCollectionCmdList.SetItem;
begin
  fList[Index] := Value;
end;

end.
