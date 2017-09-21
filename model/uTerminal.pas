unit uTerminal;

interface

uses
  Classes, SysUtils,
  mMapping;

type
  TTerminal = class(TmMapping)
  private
    fId_Terminal: Integer;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fCd_Terminal: Integer;
    fDs_Terminal: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Id_Terminal : Integer read fId_Terminal write fId_Terminal;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Terminal : Integer read fCd_Terminal write fCd_Terminal;
    property Ds_Terminal : String read fDs_Terminal write fDs_Terminal;
  end;

  TTerminals = class(TList)
  public
    function Add: TTerminal; overload;
  end;

implementation

{ TTerminal }

constructor TTerminal.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TTerminal.Destroy;
begin

  inherited;
end;

//--

function TTerminal.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'TERMINAL';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Id_Terminal', 'ID_TERMINAL', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Cd_Terminal', 'CD_TERMINAL', tfReq);
    Add('Ds_Terminal', 'DS_TERMINAL', tfReq);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin
  end;
end;

//--

{ TTerminals }

function TTerminals.Add: TTerminal;
begin
  Result := TTerminal.Create(nil);
  Self.Add(Result);
end;

end.