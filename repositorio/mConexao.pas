unit mConexao;

interface

uses
  Classes, SysUtils, DB,
  mDatabaseFactory, mDatabaseIntf, mDatabase, mTipoConexao,
  mException;

type
  TmConexao = class;
  TmConexaoClass = class of TmConexao;

  TmConexaoList = class;
  TmConexaoListClass = class of TmConexaoList;

  TmConexao = class(TComponent)
  private
    fTipoConexao : TTipoConexao;
    fDatabase : IDatabaseIntf;
  protected
  public
    constructor Create(Aowner : TComponent); override;

    function GetConsulta(ASql : String; AQtdeReg : Integer = -1) : TDataSet;
    procedure ExecComando(ACmd : String);
  published
    property TipoConexao : TTipoConexao read fTipoConexao write fTipoConexao;
    property Database : IDatabaseIntf read fDatabase write fDatabase;
  end;

  TmConexaoList = class(TList)
  private
    function GetItem(Index: Integer): TmConexao;
    procedure SetItem(Index: Integer; const Value: TmConexao);
  public
    function Adicionar : TmConexao; overload;
    procedure Adicionar(item : TmConexao); overload;
    property Items[Index: Integer] : TmConexao read GetItem write SetItem;
  end;

  function Instance : TmConexao;

implementation

{ TmConexao }

var
  _instance : TmConexao;

  function Instance : TmConexao;
  begin
    if not Assigned(_instance) then
      _instance := TmConexao.create(nil);
    Result := _instance;
  end;

constructor TmConexao.Create(Aowner: TComponent);
begin
  inherited;
end;

function TmConexao.GetConsulta(ASql : String; AQtdeReg : Integer = -1) : TDataSet;
const
  cDS_METHOD = 'TmConexao.GetConsulta()';
begin
  try
    Result := Database.GetConsulta(ASql, True);
  except
    on E : Exception do
      raise TmException.Create(
        'Erro na consulta / Erro: ' + E.Message + ' / ASql : ' + ASql, cDS_METHOD);
  end;
end;

procedure TmConexao.ExecComando(ACmd : String);
const
  cDS_METHOD = 'TmConexao.ExecComando()';
begin
  try
    Database.ExecComando(ACmd);
  except
    on E : Exception do
      raise TmException.Create(
        'Erro na comando / Erro: ' + E.Message + ' / ACmd : ' + ACmd, cDS_METHOD);
  end;
end;

{ TmConexaoList }

function TmConexaoList.GetItem(Index: Integer): TmConexao;
begin
  Result := TmConexao(Self[Index]);
end;

procedure TmConexaoList.SetItem(Index: Integer; const Value: TmConexao);
begin
  Self[Index] := Value;
end;

function TmConexaoList.Adicionar: TmConexao;
begin
  Result := TmConexao.Create(nil);
  Self.Add(Result);
end;

procedure TmConexaoList.Adicionar(item : TmConexao);
begin
  Self.Add(item);
end;

end.