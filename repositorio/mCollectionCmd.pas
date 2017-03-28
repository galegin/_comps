unit mCollectionCmd;

(* classe *)

interface

uses
  Classes, SysUtils, StrUtils,
  mValue;

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
    fValor : TmValue;
    function GetField: String;
  public
    constructor Create; overload;
    constructor Create(ACampo : String; ATipo : TTipoCollectionCmd); overload;
    constructor Create(ACampo : String; ATipo : TTipoCollectionCmd; AValor : TmValue); overload;
    function GetComandoSelect() : String;
  published
    property Campo : String read fCampo write fCampo;
    property Tipo : TTipoCollectionCmd read fTipo write fTipo;
    property Valor : TmValue read fValor write fValor;
    property Field : String read GetField;
  end;

  TmCollectionCmdList = class(TList)
  private
    function GetItem(Index: Integer): TmCollectionCmd;
    procedure SetItem(Index: Integer; const Value: TmCollectionCmd);
  public
    function Add : TmCollectionCmd; overload;
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

end;

constructor TmCollectionCmd.Create(ACampo: String;
  ATipo: TTipoCollectionCmd);
begin
  fCampo := ACampo;
  fTipo := ATipo;
end;

constructor TmCollectionCmd.Create(ACampo: String;
  ATipo: TTipoCollectionCmd; AValor: TmValue);
begin
  fCampo := ACampo;
  fTipo := ATipo;
  fValor := AValor;
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

function TmCollectionCmdList.Add : TmCollectionCmd;
begin
  Result := TmCollectionCmd.Create;
  Self.Add(Result);
end;

function TmCollectionCmdList.GetItem;
begin
  Result := TmCollectionCmd(Self[Index]);
end;

procedure TmCollectionCmdList.SetItem;
begin
  Self[Index] := Value;
end;

end.
