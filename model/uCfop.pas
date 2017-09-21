unit uCfop;

interface

uses
  Classes, SysUtils,
  mMapping;

type
  TCfop = class(TmMapping)
  private
    fCd_Cfop: Integer;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fDs_Cfop: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Cd_Cfop : Integer read fCd_Cfop write fCd_Cfop;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Cfop : String read fDs_Cfop write fDs_Cfop;
  end;

  TCfops = class(TList)
  public
    function Add: TCfop; overload;
  end;

implementation

{ TCfop }

constructor TCfop.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TCfop.Destroy;
begin

  inherited;
end;

//--

function TCfop.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'CFOP';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Cd_Cfop', 'CD_CFOP', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Ds_Cfop', 'DS_CFOP', tfReq);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin
  end;
end;

//--

{ TCfops }

function TCfops.Add: TCfop;
begin
  Result := TCfop.Create(nil);
  Self.Add(Result);
end;

end.