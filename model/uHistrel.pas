unit uHistrel;

interface

uses
  Classes, SysUtils,
  mMapping;

type
  THistrel = class(TmMapping)
  private
    fId_Histrel: Integer;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fTp_Documento: Integer;
    fCd_Histrel: Integer;
    fDs_Histrel: String;
    fNr_Parcelas: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Id_Histrel : Integer read fId_Histrel write fId_Histrel;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Tp_Documento : Integer read fTp_Documento write fTp_Documento;
    property Cd_Histrel : Integer read fCd_Histrel write fCd_Histrel;
    property Ds_Histrel : String read fDs_Histrel write fDs_Histrel;
    property Nr_Parcelas : Integer read fNr_Parcelas write fNr_Parcelas;
  end;

  THistrels = class(TList)
  public
    function Add: THistrel; overload;
  end;

implementation

{ THistrel }

constructor THistrel.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor THistrel.Destroy;
begin

  inherited;
end;

//--

function THistrel.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'HISTREL';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Id_Histrel', 'ID_HISTREL', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Tp_Documento', 'TP_DOCUMENTO', tfReq);
    Add('Cd_Histrel', 'CD_HISTREL', tfReq);
    Add('Ds_Histrel', 'DS_HISTREL', tfReq);
    Add('Nr_Parcelas', 'NR_PARCELAS', tfReq);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin
  end;
end;

//--

{ THistrels }

function THistrels.Add: THistrel;
begin
  Result := THistrel.Create(nil);
  Self.Add(Result);
end;

end.