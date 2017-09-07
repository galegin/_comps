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
    fDt_Cadastro: String;
    fCd_Produto: Integer;
    fDs_Produto: String;
    fCd_Especie: String;
    fCd_Cst: String;
    fCd_Ncm: String;
    fPr_Aliquota: String;
    fVl_Custo: String;
    fVl_Venda: String;
    fVl_Promocao: String;
    fCd_Csosn: String;
    fTp_Producao: Integer;
    procedure SetCd_Barraprd(const Value : String);
    procedure SetU_Version(const Value : String);
    procedure SetCd_Operador(const Value : Integer);
    procedure SetDt_Cadastro(const Value : String);
    procedure SetCd_Produto(const Value : Integer);
    procedure SetDs_Produto(const Value : String);
    procedure SetCd_Especie(const Value : String);
    procedure SetCd_Cst(const Value : String);
    procedure SetCd_Ncm(const Value : String);
    procedure SetPr_Aliquota(const Value : String);
    procedure SetVl_Custo(const Value : String);
    procedure SetVl_Venda(const Value : String);
    procedure SetVl_Promocao(const Value : String);
    procedure SetCd_Csosn(const Value : String);
    procedure SetTp_Producao(const Value : Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetTabela() : TmTabela; override;
    function GetKeys() : TmKeys; override;
    function GetCampos() : TmCampos; override;
  published
    property Cd_Barraprd : String read fCd_Barraprd write SetCd_Barraprd;
    property U_Version : String read fU_Version write SetU_Version;
    property Cd_Operador : Integer read fCd_Operador write SetCd_Operador;
    property Dt_Cadastro : String read fDt_Cadastro write SetDt_Cadastro;
    property Cd_Produto : Integer read fCd_Produto write SetCd_Produto;
    property Ds_Produto : String read fDs_Produto write SetDs_Produto;
    property Cd_Especie : String read fCd_Especie write SetCd_Especie;
    property Cd_Cst : String read fCd_Cst write SetCd_Cst;
    property Cd_Ncm : String read fCd_Ncm write SetCd_Ncm;
    property Pr_Aliquota : String read fPr_Aliquota write SetPr_Aliquota;
    property Vl_Custo : String read fVl_Custo write SetVl_Custo;
    property Vl_Venda : String read fVl_Venda write SetVl_Venda;
    property Vl_Promocao : String read fVl_Promocao write SetVl_Promocao;
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

function TProduto.GetTabela: TmTabela;
begin
  Result.Nome := 'PRODUTO';
end;

function TProduto.GetKeys: TmKeys;
begin
  AddKeysResult(Result, [
    'Cd_Barraprd|CD_BARRAPRD']);
end;

function TProduto.GetCampos: TmCampos;
begin
  AddCamposResult(Result, [
    'Cd_Barraprd|CD_BARRAPRD',
    'U_Version|U_VERSION',
    'Cd_Operador|CD_OPERADOR',
    'Dt_Cadastro|DT_CADASTRO',
    'Cd_Produto|CD_PRODUTO',
    'Ds_Produto|DS_PRODUTO',
    'Cd_Especie|CD_ESPECIE',
    'Cd_Cst|CD_CST',
    'Cd_Ncm|CD_NCM',
    'Pr_Aliquota|PR_ALIQUOTA',
    'Vl_Custo|VL_CUSTO',
    'Vl_Venda|VL_VENDA',
    'Vl_Promocao|VL_PROMOCAO',
    'Cd_Csosn|CD_CSOSN',
    'Tp_Producao|TP_PRODUCAO']);
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

procedure TProduto.SetDt_Cadastro(const Value : String);
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

procedure TProduto.SetPr_Aliquota(const Value : String);
begin
  fPr_Aliquota := Value;
end;

procedure TProduto.SetVl_Custo(const Value : String);
begin
  fVl_Custo := Value;
end;

procedure TProduto.SetVl_Venda(const Value : String);
begin
  fVl_Venda := Value;
end;

procedure TProduto.SetVl_Promocao(const Value : String);
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