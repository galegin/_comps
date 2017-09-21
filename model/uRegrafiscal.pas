unit uRegrafiscal;

interface

uses
  Classes, SysUtils,
  mMapping,
  uRegraimposto;

type
  TRegrafiscal = class(TmMapping)
  private
    fId_Regrafiscal: Integer;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fDs_Regrafiscal: String;
    fIn_Calcimposto: String;
    fImpostos: TRegraimpostos;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Id_Regrafiscal : Integer read fId_Regrafiscal write fId_Regrafiscal;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Regrafiscal : String read fDs_Regrafiscal write fDs_Regrafiscal;
    property In_Calcimposto : String read fIn_Calcimposto write fIn_Calcimposto;
    property Impostos : TRegraimpostos read fImpostos write fImpostos;
  end;

  TRegrafiscals = class(TList)
  public
    function Add: TRegrafiscal; overload;
  end;

implementation

{ TRegrafiscal }

constructor TRegrafiscal.Create(AOwner: TComponent);
begin
  inherited;

  fImpostos:= TRegraimpostos.Create;
end;

destructor TRegrafiscal.Destroy;
begin
  FreeAndNil(fImpostos);

  inherited;
end;

//--

function TRegrafiscal.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'REGRAFISCAL';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Id_Regrafiscal', 'ID_REGRAFISCAL', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Ds_Regrafiscal', 'DS_REGRAFISCAL', tfReq);
    Add('In_Calcimposto', 'IN_CALCIMPOSTO', tfReq);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin

    with Add('Impostos', TRegraimpostos)^.Campos do begin
      Add('Id_Regrafiscal');
    end;

  end;
end;

//--

{ TRegrafiscals }

function TRegrafiscals.Add: TRegrafiscal;
begin
  Result := TRegrafiscal.Create(nil);
  Self.Add(Result);
end;

end.