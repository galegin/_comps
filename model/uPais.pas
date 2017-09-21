unit uPais;

interface

uses
  Classes, SysUtils,
  mMapping;

type
  TPais = class(TmMapping)
  private
    fId_Pais: Integer;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fCd_Pais: Integer;
    fDs_Pais: String;
    fDs_Sigla: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Id_Pais : Integer read fId_Pais write fId_Pais;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Pais : Integer read fCd_Pais write fCd_Pais;
    property Ds_Pais : String read fDs_Pais write fDs_Pais;
    property Ds_Sigla : String read fDs_Sigla write fDs_Sigla;
  end;

  TPaiss = class(TList)
  public
    function Add: TPais; overload;
  end;

implementation

{ TPais }

constructor TPais.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TPais.Destroy;
begin

  inherited;
end;

//--

function TPais.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'PAIS';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Id_Pais', 'ID_PAIS', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Cd_Pais', 'CD_PAIS', tfReq);
    Add('Ds_Pais', 'DS_PAIS', tfReq);
    Add('Ds_Sigla', 'DS_SIGLA', tfReq);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin
  end;
end;

//--

{ TPaiss }

function TPaiss.Add: TPais;
begin
  Result := TPais.Create(nil);
  Self.Add(Result);
end;

end.