unit uProduto;

interface

uses
  Classes, SysUtils,
  mMapping;

type
  TProduto = class(TmMapping)
  private
    fCd_Barraprd: String;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fCd_Produto: Integer;
    fDs_Produto: String;
    fCd_Especie: String;
    fCd_Cst: String;
    fCd_Ncm: String;
    fPr_Aliquota: Real;
    fVl_Custo: Real;
    fVl_Venda: Real;
    fVl_Promocao: Real;
    fCd_Csosn: String;
    fTp_Producao: Integer;
    procedure SetCd_Barraprd(const Value : String);
    procedure SetU_Version(const Value : String);
    procedure SetCd_Operador(const Value : Integer);
    procedure SetDt_Cadastro(const Value : TDateTime);
    procedure SetCd_Produto(const Value : Integer);
    procedure SetDs_Produto(const Value : String);
    procedure SetCd_Especie(const Value : String);
    procedure SetCd_Cst(const Value : String);
    procedure SetCd_Ncm(const Value : String);
    procedure SetPr_Aliquota(const Value : Real);
    procedure SetVl_Custo(const Value : Real);
    procedure SetVl_Venda(const Value : Real);
    procedure SetVl_Promocao(const Value : Real);
    procedure SetCd_Csosn(const Value : String);
    procedure SetTp_Producao(const Value : Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Cd_Barraprd : String read fCd_Barraprd write SetCd_Barraprd;
    property U_Version : String read fU_Version write SetU_Version;
    property Cd_Operador : Integer read fCd_Operador write SetCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write SetDt_Cadastro;
    property Cd_Produto : Integer read fCd_Produto write SetCd_Produto;
    property Ds_Produto : String read fDs_Produto write SetDs_Produto;
    property Cd_Especie : String read fCd_Especie write SetCd_Especie;
    property Cd_Cst : String read fCd_Cst write SetCd_Cst;
    property Cd_Ncm : String read fCd_Ncm write SetCd_Ncm;
    property Pr_Aliquota : Real read fPr_Aliquota write SetPr_Aliquota;
    property Vl_Custo : Real read fVl_Custo write SetVl_Custo;
    property Vl_Venda : Real read fVl_Venda write SetVl_Venda;
    property Vl_Promocao : Real read fVl_Promocao write SetVl_Promocao;
    property Cd_Csosn : String read fCd_Csosn write SetCd_Csosn;
    property Tp_Producao : Integer read fTp_Producao write SetTp_Producao;
  end;

  TProdutos = class(TList)
  public
    function Add: TProduto; overload;
  end;

implementation

{ TProduto }

constructor TProduto.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TProduto.Destroy;
begin

  inherited;
end;

//--

function TProduto.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'PRODUTO';
  end;

  Result.Chaves := TmChaves.Create;
  with Result.Chaves do begin
    Add('Cd_Barraprd', 'CD_BARRAPRD');
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Cd_Barraprd', 'CD_BARRAPRD');
    Add('U_Version', 'U_VERSION');
    Add('Cd_Operador', 'CD_OPERADOR');
    Add('Dt_Cadastro', 'DT_CADASTRO');
    Add('Cd_Produto', 'CD_PRODUTO');
    Add('Ds_Produto', 'DS_PRODUTO');
    Add('Cd_Especie', 'CD_ESPECIE');
    Add('Cd_Cst', 'CD_CST');
    Add('Cd_Ncm', 'CD_NCM');
    Add('Pr_Aliquota', 'PR_ALIQUOTA');
    Add('Vl_Custo', 'VL_CUSTO');
    Add('Vl_Venda', 'VL_VENDA');
    Add('Vl_Promocao', 'VL_PROMOCAO');
    Add('Cd_Csosn', 'CD_CSOSN');
    Add('Tp_Producao', 'TP_PRODUCAO');
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin
  end;
end;

//--

procedure TProduto.SetCd_Barraprd(const Value : String);
begin
  fCd_Barraprd := Value;
end;

procedure TProduto.SetU_Version(const Value : String);
begin
  fU_Version := Value;
end;

procedure TProduto.SetCd_Operador(const Value : Integer);
begin
  fCd_Operador := Value;
end;

procedure TProduto.SetDt_Cadastro(const Value : TDateTime);
begin
  fDt_Cadastro := Value;
end;

procedure TProduto.SetCd_Produto(const Value : Integer);
begin
  fCd_Produto := Value;
end;

procedure TProduto.SetDs_Produto(const Value : String);
begin
  fDs_Produto := Value;
end;

procedure TProduto.SetCd_Especie(const Value : String);
begin
  fCd_Especie := Value;
end;

procedure TProduto.SetCd_Cst(const Value : String);
begin
  fCd_Cst := Value;
end;

procedure TProduto.SetCd_Ncm(const Value : String);
begin
  fCd_Ncm := Value;
end;

procedure TProduto.SetPr_Aliquota(const Value : Real);
begin
  fPr_Aliquota := Value;
end;

procedure TProduto.SetVl_Custo(const Value : Real);
begin
  fVl_Custo := Value;
end;

procedure TProduto.SetVl_Venda(const Value : Real);
begin
  fVl_Venda := Value;
end;

procedure TProduto.SetVl_Promocao(const Value : Real);
begin
  fVl_Promocao := Value;
end;

procedure TProduto.SetCd_Csosn(const Value : String);
begin
  fCd_Csosn := Value;
end;

procedure TProduto.SetTp_Producao(const Value : Integer);
begin
  fTp_Producao := Value;
end;

{ TProdutos }

function TProdutos.Add: TProduto;
begin
  Result := TProduto.Create(nil);
  Self.Add(Result);
end;

end.