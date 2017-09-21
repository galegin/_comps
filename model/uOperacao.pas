unit uOperacao;

interface

uses
  Classes, SysUtils,
  mMapping,
  uRegrafiscal;

type
  TOperacao = class(TmMapping)
  private
    fId_Operacao: String;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fDs_Operacao: String;
    fTp_Modelonf: Integer;
    fTp_Modalidade: Integer;
    fTp_Operacao: Integer;
    fCd_Serie: String;
    fCd_Cfop: Integer;
    fId_Regrafiscal: Integer;
    fRegrafiscal: TRegrafiscal;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Id_Operacao : String read fId_Operacao write fId_Operacao;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Operacao : String read fDs_Operacao write fDs_Operacao;
    property Tp_Modelonf : Integer read fTp_Modelonf write fTp_Modelonf;
    property Tp_Modalidade : Integer read fTp_Modalidade write fTp_Modalidade;
    property Tp_Operacao : Integer read fTp_Operacao write fTp_Operacao;
    property Cd_Serie : String read fCd_Serie write fCd_Serie;
    property Cd_Cfop : Integer read fCd_Cfop write fCd_Cfop;
    property Id_Regrafiscal : Integer read fId_Regrafiscal write fId_Regrafiscal;
    property Regrafiscal : TRegrafiscal read fRegrafiscal write fRegrafiscal;
  end;

  TOperacaos = class(TList)
  public
    function Add: TOperacao; overload;
  end;

implementation

{ TOperacao }

constructor TOperacao.Create(AOwner: TComponent);
begin
  inherited;

  fRegrafiscal:= TRegrafiscal.Create(nil);
end;

destructor TOperacao.Destroy;
begin
  FreeAndNil(fRegrafiscal);

  inherited;
end;

//--

function TOperacao.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'OPERACAO';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Id_Operacao', 'ID_OPERACAO', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Ds_Operacao', 'DS_OPERACAO', tfReq);
    Add('Tp_Modelonf', 'TP_MODELONF', tfReq);
    Add('Tp_Modalidade', 'TP_MODALIDADE', tfReq);
    Add('Tp_Operacao', 'TP_OPERACAO', tfReq);
    Add('Cd_Serie', 'CD_SERIE', tfReq);
    Add('Cd_Cfop', 'CD_CFOP', tfReq);
    Add('Id_Regrafiscal', 'ID_REGRAFISCAL', tfReq);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin

    with Add('Regrafiscal', TRegrafiscal)^.Campos do begin
      Add('Id_Operacao');
    end;

  end;
end;

//--

{ TOperacaos }

function TOperacaos.Add: TOperacao;
begin
  Result := TOperacao.Create(nil);
  Self.Add(Result);
end;

end.