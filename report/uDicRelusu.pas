unit uDicRelusu;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relusu = class;
  TDic_RelusuClass = class of TDic_Relusu;

  TDic_RelusuList = class;
  TDic_RelusuListClass = class of TDic_RelusuList;

  TDic_Relusu = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fCd_Usuario: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Cd_Usuario : Real read fCd_Usuario write fCd_Usuario;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
  end;

  TDic_RelusuList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relusu;
    procedure SetItem(Index: Integer; Value: TDic_Relusu);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relusu;
    property Items[Index: Integer]: TDic_Relusu read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relusu }

constructor TDic_Relusu.Create;
begin

end;

destructor TDic_Relusu.Destroy;
begin

  inherited;
end;

{ TDic_RelusuList }

constructor TDic_RelusuList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relusu);
end;

function TDic_RelusuList.Add: TDic_Relusu;
begin
  Result := TDic_Relusu(inherited Add);
  Result.create;
end;

function TDic_RelusuList.GetItem(Index: Integer): TDic_Relusu;
begin
  Result := TDic_Relusu(inherited GetItem(Index));
end;

procedure TDic_RelusuList.SetItem(Index: Integer; Value: TDic_Relusu);
begin
  inherited SetItem(Index, Value);
end;

end.