unit uTransacao;

interface

uses
  Classes, SysUtils,
  mMapping, uPessoa, uTransitem;

type
  TTransacao = class(TmMapping)
  private
    fCd_Dnatrans: String;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fCd_Equip: String;
    fDt_Transacao: TDateTime;
    fNr_Transacao: Integer;
    fNr_Cpfcnpj: String;
    fCd_Operacao: String;
    fCd_Dnapagto: String;
    fDt_Canc: TDateTime;
    fPessoa: TPessoa;
    fItens: TTransitems;
    procedure SetCd_Dnatrans(const Value : String);
    procedure SetU_Version(const Value : String);
    procedure SetCd_Operador(const Value : Integer);
    procedure SetDt_Cadastro(const Value : TDateTime);
    procedure SetCd_Equip(const Value : String);
    procedure SetDt_Transacao(const Value : TDateTime);
    procedure SetNr_Transacao(const Value : Integer);
    procedure SetNr_Cpfcnpj(const Value : String);
    procedure SetCd_Operacao(const Value : String);
    procedure SetCd_Dnapagto(const Value : String);
    procedure SetDt_Canc(const Value : TDateTime);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Cd_Dnatrans : String read fCd_Dnatrans write SetCd_Dnatrans;
    property U_Version : String read fU_Version write SetU_Version;
    property Cd_Operador : Integer read fCd_Operador write SetCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write SetDt_Cadastro;
    property Cd_Equip : String read fCd_Equip write SetCd_Equip;
    property Dt_Transacao : TDateTime read fDt_Transacao write SetDt_Transacao;
    property Nr_Transacao : Integer read fNr_Transacao write SetNr_Transacao;
    property Nr_Cpfcnpj : String read fNr_Cpfcnpj write SetNr_Cpfcnpj;
    property Cd_Operacao : String read fCd_Operacao write SetCd_Operacao;
    property Cd_Dnapagto : String read fCd_Dnapagto write SetCd_Dnapagto;
    property Dt_Canc : TDateTime read fDt_Canc write SetDt_Canc;
    property Pessoa: TPessoa read fPessoa write fPessoa;
    property Itens: TTransitems read fItens write fItens;
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

  fPessoa:= TPessoa.Create(nil);
  fItens:= TTransitems.Create;
end;

destructor TTransacao.Destroy;
begin
  FreeAndNil(fPessoa);
  FreeAndNil(fItens);

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

  Result.Chaves := TmChaves.Create;
  with Result.Chaves do begin
    Add('Cd_Dnatrans', 'CD_DNATRANS');
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Cd_Dnatrans', 'CD_DNATRANS');
    Add('U_Version', 'U_VERSION');
    Add('Cd_Operador', 'CD_OPERADOR');
    Add('Dt_Cadastro', 'DT_CADASTRO');
    Add('Cd_Equip', 'CD_EQUIP');
    Add('Dt_Transacao', 'DT_TRANSACAO');
    Add('Nr_Transacao', 'NR_TRANSACAO');
    Add('Nr_Cpfcnpj', 'NR_CPFCNPJ');
    Add('Cd_Operacao', 'CD_OPERACAO');
    Add('Cd_Dnapagto', 'CD_DNAPAGTO');
    Add('Dt_Canc', 'DT_CANC');
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin

    with Add('Pessoa', TPessoa)^ do begin
      with Campos do begin
        Add('Nr_Cpfcnpj');
      end;
    end;

    with Add('Itens', TTransitem, TTransitems)^ do begin
      with Campos do begin
        Add('Cd_Dnatrans');
      end;
    end;

  end;
end;

//--

procedure TTransacao.SetCd_Dnatrans(const Value : String);
begin
  fCd_Dnatrans := Value;
end;

procedure TTransacao.SetU_Version(const Value : String);
begin
  fU_Version := Value;
end;

procedure TTransacao.SetCd_Operador(const Value : Integer);
begin
  fCd_Operador := Value;
end;

procedure TTransacao.SetDt_Cadastro(const Value : TDateTime);
begin
  fDt_Cadastro := Value;
end;

procedure TTransacao.SetCd_Equip(const Value : String);
begin
  fCd_Equip := Value;
end;

procedure TTransacao.SetDt_Transacao(const Value : TDateTime);
begin
  fDt_Transacao := Value;
end;

procedure TTransacao.SetNr_Transacao(const Value : Integer);
begin
  fNr_Transacao := Value;
end;

procedure TTransacao.SetNr_Cpfcnpj(const Value : String);
begin
  fNr_Cpfcnpj := Value;
end;

procedure TTransacao.SetCd_Operacao(const Value : String);
begin
  fCd_Operacao := Value;
end;

procedure TTransacao.SetCd_Dnapagto(const Value : String);
begin
  fCd_Dnapagto := Value;
end;

procedure TTransacao.SetDt_Canc(const Value : TDateTime);
begin
  fDt_Canc := Value;
end;

{ TTransacaos }

function TTransacaos.Add: TTransacao;
begin
  Result := TTransacao.Create(nil);
  Self.Add(Result);
end;

end.