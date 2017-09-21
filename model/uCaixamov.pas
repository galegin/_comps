unit uCaixamov;

interface

uses
  Classes, SysUtils,
  mMapping;

type
  TCaixamov = class(TmMapping)
  private
    fId_Caixa: Integer;
    fNr_Seq: Integer;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fTp_Lancto: Integer;
    fVl_Lancto: Real;
    fNr_Doc: Integer;
    fDs_Aux: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Id_Caixa : Integer read fId_Caixa write fId_Caixa;
    property Nr_Seq : Integer read fNr_Seq write fNr_Seq;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Tp_Lancto : Integer read fTp_Lancto write fTp_Lancto;
    property Vl_Lancto : Real read fVl_Lancto write fVl_Lancto;
    property Nr_Doc : Integer read fNr_Doc write fNr_Doc;
    property Ds_Aux : String read fDs_Aux write fDs_Aux;
  end;

  TCaixamovs = class(TList)
  public
    function Add: TCaixamov; overload;
  end;

implementation

{ TCaixamov }

constructor TCaixamov.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TCaixamov.Destroy;
begin

  inherited;
end;

//--

function TCaixamov.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'CAIXAMOV';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Id_Caixa', 'ID_CAIXA', tfKey);
    Add('Nr_Seq', 'NR_SEQ', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Tp_Lancto', 'TP_LANCTO', tfReq);
    Add('Vl_Lancto', 'VL_LANCTO', tfReq);
    Add('Nr_Doc', 'NR_DOC', tfReq);
    Add('Ds_Aux', 'DS_AUX', tfReq);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin
  end;
end;

//--

{ TCaixamovs }

function TCaixamovs.Add: TCaixamov;
begin
  Result := TCaixamov.Create(nil);
  Self.Add(Result);
end;

end.