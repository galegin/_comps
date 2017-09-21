unit uNcm;

interface

uses
  Classes, SysUtils,
  mMapping;

type
  TNcm = class(TmMapping)
  private
    fCd_Ncm: String;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fDs_Ncm: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Cd_Ncm : String read fCd_Ncm write fCd_Ncm;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Ncm : String read fDs_Ncm write fDs_Ncm;
  end;

  TNcms = class(TList)
  public
    function Add: TNcm; overload;
  end;

implementation

{ TNcm }

constructor TNcm.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TNcm.Destroy;
begin

  inherited;
end;

//--

function TNcm.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'NCM';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Cd_Ncm', 'CD_NCM', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Ds_Ncm', 'DS_NCM', tfReq);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin
  end;
end;

//--

{ TNcms }

function TNcms.Add: TNcm;
begin
  Result := TNcm.Create(nil);
  Self.Add(Result);
end;

end.