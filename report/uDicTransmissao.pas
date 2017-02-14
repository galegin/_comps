unit uDicTransmissao;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Transmissao = class;
  TDic_TransmissaoClass = class of TDic_Transmissao;

  TDic_TransmissaoList = class;
  TDic_TransmissaoListClass = class of TDic_TransmissaoList;

  TDic_Transmissao = class(TmCollectionItem)
  private
    fCd_Projeto: String;
    fCd_Empresa: Real;
    fCd_Terminal: Real;
    fCd_Entidade: String;
    fTp_Transmissao: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDt_Periodoini: TDateTime;
    fDt_Periodofin: TDateTime;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Projeto : String read fCd_Projeto write fCd_Projeto;
    property Cd_Empresa : Real read fCd_Empresa write fCd_Empresa;
    property Cd_Terminal : Real read fCd_Terminal write fCd_Terminal;
    property Cd_Entidade : String read fCd_Entidade write fCd_Entidade;
    property Tp_Transmissao : Real read fTp_Transmissao write fTp_Transmissao;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Dt_Periodoini : TDateTime read fDt_Periodoini write fDt_Periodoini;
    property Dt_Periodofin : TDateTime read fDt_Periodofin write fDt_Periodofin;
  end;

  TDic_TransmissaoList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Transmissao;
    procedure SetItem(Index: Integer; Value: TDic_Transmissao);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Transmissao;
    property Items[Index: Integer]: TDic_Transmissao read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Transmissao }

constructor TDic_Transmissao.Create;
begin

end;

destructor TDic_Transmissao.Destroy;
begin

  inherited;
end;

{ TDic_TransmissaoList }

constructor TDic_TransmissaoList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Transmissao);
end;

function TDic_TransmissaoList.Add: TDic_Transmissao;
begin
  Result := TDic_Transmissao(inherited Add);
  Result.create;
end;

function TDic_TransmissaoList.GetItem(Index: Integer): TDic_Transmissao;
begin
  Result := TDic_Transmissao(inherited GetItem(Index));
end;

procedure TDic_TransmissaoList.SetItem(Index: Integer; Value: TDic_Transmissao);
begin
  inherited SetItem(Index, Value);
end;

end.