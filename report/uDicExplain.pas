unit uDicExplain;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Explain = class;
  TDic_ExplainClass = class of TDic_Explain;

  TDic_ExplainList = class;
  TDic_ExplainListClass = class of TDic_ExplainList;

  TDic_Explain = class(TmCollectionItem)
  private
    fCd_Entidade: String;
    fCd_Chave: String;
    fNr_Linha: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Linha: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Entidade : String read fCd_Entidade write fCd_Entidade;
    property Cd_Chave : String read fCd_Chave write fCd_Chave;
    property Nr_Linha : Real read fNr_Linha write fNr_Linha;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Linha : String read fDs_Linha write fDs_Linha;
  end;

  TDic_ExplainList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Explain;
    procedure SetItem(Index: Integer; Value: TDic_Explain);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Explain;
    property Items[Index: Integer]: TDic_Explain read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Explain }

constructor TDic_Explain.Create;
begin

end;

destructor TDic_Explain.Destroy;
begin

  inherited;
end;

{ TDic_ExplainList }

constructor TDic_ExplainList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Explain);
end;

function TDic_ExplainList.Add: TDic_Explain;
begin
  Result := TDic_Explain(inherited Add);
  Result.create;
end;

function TDic_ExplainList.GetItem(Index: Integer): TDic_Explain;
begin
  Result := TDic_Explain(inherited GetItem(Index));
end;

procedure TDic_ExplainList.SetItem(Index: Integer; Value: TDic_Explain);
begin
  inherited SetItem(Index, Value);
end;

end.