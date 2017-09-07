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
    fDs_SiglaEstado: String;
    fCd_Pais: Integer;
    fDs_Pais: String;
    fDs_Fone: String;
    fDs_Celular: String;
    fDs_Email: String;
    fIn_Consumidorfinal: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override; 
    function GetTabela() : TmTabela; override;
    function GetKeys() : TmKeys; override;
    function GetCampos() : TmCampos; override;
  published
    property Nr_Cpfcnpj: String read fNr_Cpfcnpj write fNr_Cpfcnpj;
    property U_Version: String read fU_Version write fU_Version;
    property Cd_Operador: Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro: TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Nr_Rgie: String read fNr_Rgie write fNr_Rgie;
    property Cd_Pessoa: Integer read fCd_Pessoa write fCd_Pessoa;
    property Nm_Pessoa: String read fNm_Pessoa write fNm_Pessoa;
    property Nm_Fantasia: String read fNm_Fantasia write fNm_Fantasia;
    property Cd_Cep: Integer read fCd_Cep write fCd_Cep;
    property Nm_Logradouro: String read fNm_Logradouro write fNm_Logradouro;
    property Nr_Logradouro: String read fNr_Logradouro write fNr_Logradouro;
    property Ds_Bairro: String read fDs_Bairro write fDs_Bairro;
    property Ds_Complemento: String read fDs_Complemento write fDs_Complemento;
    property Cd_Municipio: Integer read fCd_Municipio write fCd_Municipio;
    property Ds_Municipio: String read fDs_Municipio write fDs_Municipio;
    property Cd_Estado: Integer read fCd_Estado write fCd_Estado;
    property Ds_Estado: String read fDs_Estado write fDs_Estado;
    property Ds_SiglaEstado: String read fDs_SiglaEstado write fDs_SiglaEstado;
    property Cd_Pais: Integer read fCd_Pais write fCd_Pais;
    property Ds_Pais: String read fDs_Pais write fDs_Pais;
    property Ds_Fone: String read fDs_Fone write fDs_Fone;
    property Ds_Celular: String read fDs_Celular write fDs_Celular;
    property Ds_Email: String read fDs_Email write fDs_Email;
    property In_Consumidorfinal: Boolean read fIn_Consumidorfinal write fIn_Consumidorfinal;
  end;

  TPessoas = class(TList)
  public
    function Add : TPessoa; overload;
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

function TPessoa.GetTabela: TmTabela;
begin
  Result.Nome := 'PESSOA';
end;

function TPessoa.GetKeys: TmKeys;
begin
  AddKeysResult(Result, [
    'Nr_CpfCnpj|NR_CPFCNPJ']);
end;

function TPessoa.GetCampos: TmCampos;
begin
  AddCamposResult(Result, [
    'Nr_Cpfcnpj|NR_CPFCNPJ',
    'U_Version|U_VERSION',
    'Cd_Operador|CD_OPERADOR',
    'Dt_Cadastro|DT_CADASTRO',
    'Nr_Rgie|NR_RGIE',
    'Cd_Pessoa|CD_PESSOA',
    'Nm_Pessoa|NM_PESSOA',
    'Nm_Fantasia|NM_FANTASIA',
    'Cd_Cep|CD_CEP',
    'Nm_Logradouro|NM_LOGRADOURO',
    'Nr_Logradouro|NR_LOGRADOURO',
    'Ds_Bairro|DS_BAIRRO',
    'Ds_Complemento|DS_COMPLEMENTO',
    'Cd_Municipio|CD_MUNICIPIO',
    'Ds_Municipio|DS_MUNICIPIO',
    'Cd_Estado|CD_ESTADO',
    'Ds_Estado|DS_ESTADO',
    'Ds_SiglaEstado|DS_SIGLAESTADO',
    'Cd_Pais|CD_PAIS',
    'Ds_Pais|DS_PAIS',
    'Ds_Fone|DS_FONE',
    'Ds_Celular|DS_CELULAR',
    'Ds_Email|DS_EMAIL',
    'In_Consumidorfinal|IN_CONSUMIDORFINAL']);
end;

{ TPessoas }

function TPessoas.Add: TPessoa;
begin
  Result := TPessoa.Create(nil);
  Self.Add(Result);
end;

end.