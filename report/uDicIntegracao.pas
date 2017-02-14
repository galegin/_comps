unit uDicIntegracao;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem,
  uDicRel;

type
  TDic_Integracao = class;
  TDic_IntegracaoClass = class of TDic_Integracao;

  TDic_IntegracaoList = class;
  TDic_IntegracaoListClass = class of TDic_IntegracaoList;

  TDic_Integracao = class(TmCollectionItem)
  private
    fNr_Session: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fCd_Relatorio: String;
    fDs_Filtro: String;
	
	fObj_Relatorio : TDic_Rel;	
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Nr_Session : Real read fNr_Session write fNr_Session;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Ds_Filtro : String read fDs_Filtro write fDs_Filtro;
	
	property Obj_Relatorio : TDic_Rel read fObj_Relatorio write fObj_Relatorio;
  end;

  TDic_IntegracaoList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Integracao;
    procedure SetItem(Index: Integer; Value: TDic_Integracao);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Integracao;
    property Items[Index: Integer]: TDic_Integracao read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Integracao }

constructor TDic_Integracao.Create;
begin
  fObj_Relatorio : TDic_Rel.Create(Self);
end;

destructor TDic_Integracao.Destroy;
begin
  inherited;
end;

{ TDic_IntegracaoList }

constructor TDic_IntegracaoList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Integracao);
end;

function TDic_IntegracaoList.Add: TDic_Integracao;
begin
  Result := TDic_Integracao(inherited Add);
  Result.create;
end;

function TDic_IntegracaoList.GetItem(Index: Integer): TDic_Integracao;
begin
  Result := TDic_Integracao(inherited GetItem(Index));
end;

procedure TDic_IntegracaoList.SetItem(Index: Integer; Value: TDic_Integracao);
begin
  inherited SetItem(Index, Value);
end;

end.