unit uTransinut;

interface

uses
  Classes, SysUtils,
  mMapping;

type
  TTransinut = class(TmMapping)
  private
    fId_Transacao: String;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fDt_Emissao: TDateTime;
    fTp_Modelonf: Integer;
    fCd_Serie: String;
    fNr_Nf: Integer;
    fDt_Recebimento: TDateTime;
    fNr_Recibo: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Id_Transacao : String read fId_Transacao write fId_Transacao;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Dt_Emissao : TDateTime read fDt_Emissao write fDt_Emissao;
    property Tp_Modelonf : Integer read fTp_Modelonf write fTp_Modelonf;
    property Cd_Serie : String read fCd_Serie write fCd_Serie;
    property Nr_Nf : Integer read fNr_Nf write fNr_Nf;
    property Dt_Recebimento : TDateTime read fDt_Recebimento write fDt_Recebimento;
    property Nr_Recibo : String read fNr_Recibo write fNr_Recibo;
  end;

  TTransinuts = class(TList)
  public
    function Add: TTransinut; overload;
  end;

implementation

{ TTransinut }

constructor TTransinut.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TTransinut.Destroy;
begin

  inherited;
end;

//--

function TTransinut.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'TRANSINUT';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Id_Transacao', 'ID_TRANSACAO', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Dt_Emissao', 'DT_EMISSAO', tfReq);
    Add('Tp_Modelonf', 'TP_MODELONF', tfReq);
    Add('Cd_Serie', 'CD_SERIE', tfReq);
    Add('Nr_Nf', 'NR_NF', tfReq);
    Add('Dt_Recebimento', 'DT_RECEBIMENTO', tfNul);
    Add('Nr_Recibo', 'NR_RECIBO', tfNul);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin
  end;
end;

//--

{ TTransinuts }

function TTransinuts.Add: TTransinut;
begin
  Result := TTransinut.Create(nil);
  Self.Add(Result);
end;

end.