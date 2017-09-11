unit uPessoa;

interface

uses
  Classes, SysUtils,
  mMapping;

type
  TPessoa = class(TmMapping)
  private
    fNr_Cpfcnpj: String;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fNr_Rgie: String;
    fCd_Pessoa: Integer;
    fNm_Pessoa: String;
    fNm_Fantasia: String;
    fCd_Cep: Integer;
    fNm_Logradouro: String;
    fNr_Logradouro: String;
    fDs_Bairro: String;
    fDs_Complemento: String;
    fCd_Municipio: Integer;
    fDs_Municipio: String;
    fCd_Estado: Integer;
    fDs_Estado: String;
    fDs_Siglaestado: String;
    fCd_Pais: Integer;
    fDs_Pais: String;
    fDs_Fone: String;
    fDs_Celular: String;
    fDs_Email: String;
    fIn_Consumidorfinal: String;
    procedure SetNr_Cpfcnpj(const Value : String);
    procedure SetU_Version(const Value : String);
    procedure SetCd_Operador(const Value : Integer);
    procedure SetDt_Cadastro(const Value : TDateTime);
    procedure SetNr_Rgie(const Value : String);
    procedure SetCd_Pessoa(const Value : Integer);
    procedure SetNm_Pessoa(const Value : String);
    procedure SetNm_Fantasia(const Value : String);
    procedure SetCd_Cep(const Value : Integer);
    procedure SetNm_Logradouro(const Value : String);
    procedure SetNr_Logradouro(const Value : String);
    procedure SetDs_Bairro(const Value : String);
    procedure SetDs_Complemento(const Value : String);
    procedure SetCd_Municipio(const Value : Integer);
    procedure SetDs_Municipio(const Value : String);
    procedure SetCd_Estado(const Value : Integer);
    procedure SetDs_Estado(const Value : String);
    procedure SetDs_Siglaestado(const Value : String);
    procedure SetCd_Pais(const Value : Integer);
    procedure SetDs_Pais(const Value : String);
    procedure SetDs_Fone(const Value : String);
    procedure SetDs_Celular(const Value : String);
    procedure SetDs_Email(const Value : String);
    procedure SetIn_Consumidorfinal(const Value : String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Nr_Cpfcnpj : String read fNr_Cpfcnpj write SetNr_Cpfcnpj;
    property U_Version : String read fU_Version write SetU_Version;
    property Cd_Operador : Integer read fCd_Operador write SetCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write SetDt_Cadastro;
    property Nr_Rgie : String read fNr_Rgie write SetNr_Rgie;
    property Cd_Pessoa : Integer read fCd_Pessoa write SetCd_Pessoa;
    property Nm_Pessoa : String read fNm_Pessoa write SetNm_Pessoa;
    property Nm_Fantasia : String read fNm_Fantasia write SetNm_Fantasia;
    property Cd_Cep : Integer read fCd_Cep write SetCd_Cep;
    property Nm_Logradouro : String read fNm_Logradouro write SetNm_Logradouro;
    property Nr_Logradouro : String read fNr_Logradouro write SetNr_Logradouro;
    property Ds_Bairro : String read fDs_Bairro write SetDs_Bairro;
    property Ds_Complemento : String read fDs_Complemento write SetDs_Complemento;
    property Cd_Municipio : Integer read fCd_Municipio write SetCd_Municipio;
    property Ds_Municipio : String read fDs_Municipio write SetDs_Municipio;
    property Cd_Estado : Integer read fCd_Estado write SetCd_Estado;
    property Ds_Estado : String read fDs_Estado write SetDs_Estado;
    property Ds_Siglaestado : String read fDs_Siglaestado write SetDs_Siglaestado;
    property Cd_Pais : Integer read fCd_Pais write SetCd_Pais;
    property Ds_Pais : String read fDs_Pais write SetDs_Pais;
    property Ds_Fone : String read fDs_Fone write SetDs_Fone;
    property Ds_Celular : String read fDs_Celular write SetDs_Celular;
    property Ds_Email : String read fDs_Email write SetDs_Email;
    property In_Consumidorfinal : String read fIn_Consumidorfinal write SetIn_Consumidorfinal;
  end;

  TPessoas = class(TList)
  public
    function Add: TPessoa; overload;
  end;

implementation

{ TPessoa }

constructor TPessoa.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TPessoa.Destroy;
begin

  inherited;
end;

//--

function TPessoa.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'PESSOA';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Nr_Cpfcnpj', 'NR_CPFCNPJ', tfKey);
    Add('U_Version', 'U_VERSION');
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Nr_Rgie', 'NR_RGIE');
    Add('Cd_Pessoa', 'CD_PESSOA', tfReq);
    Add('Nm_Pessoa', 'NM_PESSOA', tfReq);
    Add('Nm_Fantasia', 'NM_FANTASIA');
    Add('Cd_Cep', 'CD_CEP', tfReq);
    Add('Nm_Logradouro', 'NM_LOGRADOURO', tfReq);
    Add('Nr_Logradouro', 'NR_LOGRADOURO', tfReq);
    Add('Ds_Bairro', 'DS_BAIRRO', tfReq);
    Add('Ds_Complemento', 'DS_COMPLEMENTO');
    Add('Cd_Municipio', 'CD_MUNICIPIO', tfReq);
    Add('Ds_Municipio', 'DS_MUNICIPIO', tfReq);
    Add('Cd_Estado', 'CD_ESTADO', tfReq);
    Add('Ds_Estado', 'DS_ESTADO', tfReq);
    Add('Ds_Siglaestado', 'DS_SIGLAESTADO', tfReq);
    Add('Cd_Pais', 'CD_PAIS', tfReq);
    Add('Ds_Pais', 'DS_PAIS', tfReq);
    Add('Ds_Fone', 'DS_FONE');
    Add('Ds_Celular', 'DS_CELULAR');
    Add('Ds_Email', 'DS_EMAIL');
    Add('In_Consumidorfinal', 'IN_CONSUMIDORFINAL');
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin
  end;
end;

//--

procedure TPessoa.SetNr_Cpfcnpj(const Value : String);
begin
  fNr_Cpfcnpj := Value;
end;

procedure TPessoa.SetU_Version(const Value : String);
begin
  fU_Version := Value;
end;

procedure TPessoa.SetCd_Operador(const Value : Integer);
begin
  fCd_Operador := Value;
end;

procedure TPessoa.SetDt_Cadastro(const Value : TDateTime);
begin
  fDt_Cadastro := Value;
end;

procedure TPessoa.SetNr_Rgie(const Value : String);
begin
  fNr_Rgie := Value;
end;

procedure TPessoa.SetCd_Pessoa(const Value : Integer);
begin
  fCd_Pessoa := Value;
end;

procedure TPessoa.SetNm_Pessoa(const Value : String);
begin
  fNm_Pessoa := Value;
end;

procedure TPessoa.SetNm_Fantasia(const Value : String);
begin
  fNm_Fantasia := Value;
end;

procedure TPessoa.SetCd_Cep(const Value : Integer);
begin
  fCd_Cep := Value;
end;

procedure TPessoa.SetNm_Logradouro(const Value : String);
begin
  fNm_Logradouro := Value;
end;

procedure TPessoa.SetNr_Logradouro(const Value : String);
begin
  fNr_Logradouro := Value;
end;

procedure TPessoa.SetDs_Bairro(const Value : String);
begin
  fDs_Bairro := Value;
end;

procedure TPessoa.SetDs_Complemento(const Value : String);
begin
  fDs_Complemento := Value;
end;

procedure TPessoa.SetCd_Municipio(const Value : Integer);
begin
  fCd_Municipio := Value;
end;

procedure TPessoa.SetDs_Municipio(const Value : String);
begin
  fDs_Municipio := Value;
end;

procedure TPessoa.SetCd_Estado(const Value : Integer);
begin
  fCd_Estado := Value;
end;

procedure TPessoa.SetDs_Estado(const Value : String);
begin
  fDs_Estado := Value;
end;

procedure TPessoa.SetDs_Siglaestado(const Value : String);
begin
  fDs_Siglaestado := Value;
end;

procedure TPessoa.SetCd_Pais(const Value : Integer);
begin
  fCd_Pais := Value;
end;

procedure TPessoa.SetDs_Pais(const Value : String);
begin
  fDs_Pais := Value;
end;

procedure TPessoa.SetDs_Fone(const Value : String);
begin
  fDs_Fone := Value;
end;

procedure TPessoa.SetDs_Celular(const Value : String);
begin
  fDs_Celular := Value;
end;

procedure TPessoa.SetDs_Email(const Value : String);
begin
  fDs_Email := Value;
end;

procedure TPessoa.SetIn_Consumidorfinal(const Value : String);
begin
  fIn_Consumidorfinal := Value;
end;

{ TPessoas }

function TPessoas.Add: TPessoa;
begin
  Result := TPessoa.Create(nil);
  Self.Add(Result);
end;

end.