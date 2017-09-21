unit uTransacao;

interface

uses
  Classes, SysUtils,
  mMapping, mList,
  uEmpresa, uPessoa, uOperacao,
  uTransfiscal, uTransitem, uTranspagto;

type
  TTransacao = class(TmMapping)
  private
    fId_Transacao: String;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fId_Empresa: Integer;
    fId_Pessoa: String;
    fId_Operacao: String;
    fDt_Transacao: TDateTime;
    fNr_Transacao: Integer;
    fTp_Situacao: Integer;
    fDt_Cancelamento: TDateTime;
    fEmpresa: TEmpresa;
    fPessoa: TPessoa;
    fOperacao: TOperacao;
    fFiscal: TTransfiscal;
    fItens: TTransitems;
    fPagtos: TTranspagtos;
    function GetVl_Baseicms: Real;
    function GetVl_Baseicmsst: Real;
    function GetVl_Icms: Real;
    function GetVl_Icmsst: Real;
    function GetVl_Cofins: Real;
    function GetVl_Desconto: Real;
    function GetVl_Frete: Real;
    function GetVl_Ii: Real;
    function GetVl_Ipi: Real;
    function GetVl_Item: Real;
    function GetVl_Outro: Real;
    function GetVl_Pis: Real;
    function GetVl_Seguro: Real;
    function GetVl_Total: Real;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Id_Transacao : String read fId_Transacao write fId_Transacao;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Id_Empresa : Integer read fId_Empresa write fId_Empresa;
    property Id_Pessoa : String read fId_Pessoa write fId_Pessoa;
    property Id_Operacao : String read fId_Operacao write fId_Operacao;
    property Dt_Transacao : TDateTime read fDt_Transacao write fDt_Transacao;
    property Nr_Transacao : Integer read fNr_Transacao write fNr_Transacao;
    property Tp_Situacao : Integer read fTp_Situacao write fTp_Situacao;
    property Dt_Cancelamento : TDateTime read fDt_Cancelamento write fDt_Cancelamento;
    property Empresa: TEmpresa read fEmpresa write fEmpresa;
    property Pessoa: TPessoa read fPessoa write fPessoa;
    property Operacao: TOperacao read fOperacao write fOperacao;
    property Fiscal : TTransfiscal read fFiscal write fFiscal;
    property Itens : TTransitems read fItens write fItens;
    property Pagtos : TTranspagtos read fPagtos write fPagtos;
    property Vl_Baseicms : Real read GetVl_Baseicms;
    property Vl_Icms : Real read GetVl_Icms;
    property Vl_Baseicmsst : Real read GetVl_Baseicmsst;
    property Vl_Icmsst : Real read GetVl_Icmsst;
    property Vl_Item : Real read GetVl_Item;
    property Vl_Frete : Real read GetVl_Frete;
    property Vl_Seguro : Real read GetVl_Seguro;
    property Vl_Desconto : Real read GetVl_Desconto;
    property Vl_Ii : Real read GetVl_Ii;
    property Vl_Ipi : Real read GetVl_Ipi;
    property Vl_Pis : Real read GetVl_Pis;
    property Vl_Cofins : Real read GetVl_Cofins;
    property Vl_Outro : Real read GetVl_Outro;
    property Vl_Total : Real read GetVl_Total;
  end;

  TTransacaos = class(TList)
  public
    function Add: TTransacao; overload;
  end;

implementation

{ TTransacao }

constructor TTransacao.Create(AOwner: TComponent);
begin
  inherited;

  fEmpresa:= TEmpresa.Create(nil);
  fPessoa:= TPessoa.Create(nil);
  fOperacao:= TOperacao.Create(nil);
  fFiscal:= TTransfiscal.Create(nil);
  fItens:= TTransitems.Create();
  fPagtos:= TTranspagtos.Create();
end;

destructor TTransacao.Destroy;
begin
  FreeAndNil(fEmpresa);
  FreeAndNil(fPessoa);
  FreeAndNil(fOperacao);
  FreeAndNil(fFiscal);
  FreeAndNil(fItens);
  FreeAndNil(fPagtos);

  inherited;
end;

//--

function TTransacao.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'TRANSACAO';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Id_Transacao', 'ID_TRANSACAO', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Id_Empresa', 'ID_EMPRESA', tfReq);
    Add('Id_Pessoa', 'ID_PESSOA', tfReq);
    Add('Id_Operacao', 'ID_OPERACAO', tfReq);
    Add('Dt_Transacao', 'DT_TRANSACAO', tfReq);
    Add('Nr_Transacao', 'NR_TRANSACAO', tfReq);
    Add('Tp_Situacao', 'TP_SITUACAO', tfReq);
    Add('Dt_Cancelamento', 'DT_CANCELAMENTO', tfNul);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin

    with Add('Empresa', TEmpresa)^.Campos do begin
      Add('Id_Empresa');
    end;

    with Add('Pessoa', TPessoa)^.Campos do begin
      Add('Id_Pessoa');
    end;

    with Add('Operacao', TOperacao)^.Campos do begin
      Add('Id_Operacao');
    end;

    with Add('Fiscal', TTransfiscal)^.Campos do begin
      Add('Id_Transacao');
    end;

    with Add('Itens', TTransitem, TTransitems)^.Campos do begin
      Add('Id_Transacao');
    end;

    with Add('Pagtos', TTranspagto, TTranspagtos)^.Campos do begin
      Add('Id_Transacao');
    end;

  end;
end;

//--

function TTransacao.GetVl_Baseicms: Real;
begin
  Result := TmList(fItens).Sum('Vl_Baseicms');
end;

function TTransacao.GetVl_Icms: Real;
begin
  Result := TmList(fItens).Sum('Vl_Icms');
end;

function TTransacao.GetVl_Baseicmsst: Real;
begin
  Result := TmList(fItens).Sum('Vl_Baseicmsst');
end;

function TTransacao.GetVl_Icmsst: Real;
begin
  Result := TmList(fItens).Sum('Vl_Icmsst');
end;

function TTransacao.GetVl_Cofins: Real;
begin
  Result := TmList(fItens).Sum('Vl_Cofins');
end;

function TTransacao.GetVl_Desconto: Real;
begin
  Result := TmList(fItens).Sum('Vl_Desconto');
end;

function TTransacao.GetVl_Frete: Real;
begin
  Result := TmList(fItens).Sum('Vl_Frete');
end;

function TTransacao.GetVl_Ii: Real;
begin
  Result := TmList(fItens).Sum('Vl_Ii');
end;

function TTransacao.GetVl_Ipi: Real;
begin
  Result := TmList(fItens).Sum('Vl_Ipi');
end;

function TTransacao.GetVl_Item: Real;
begin
  Result := TmList(fItens).Sum('Vl_Item');
end;

function TTransacao.GetVl_Outro: Real;
begin
  Result := TmList(fItens).Sum('Vl_Outro');
end;

function TTransacao.GetVl_Pis: Real;
begin
  Result := TmList(fItens).Sum('Vl_Pis');
end;

function TTransacao.GetVl_Seguro: Real;
begin
  Result := TmList(fItens).Sum('Vl_Seguro');
end;

function TTransacao.GetVl_Total: Real;
begin
  Result := TmList(fItens).Sum('Vl_Total');
end;

{ TTransacaos }

function TTransacaos.Add: TTransacao;
begin
  Result := TTransacao.Create(nil);
  Self.Add(Result);
end;

end.