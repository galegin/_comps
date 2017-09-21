unit uNcmsubst;

interface

uses
  Classes, SysUtils,
  mMapping;

type
  TNcmsubst = class(TmMapping)
  private
    fUf_Origem: String;
    fUf_Destino: String;
    fCd_Ncm: String;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fCd_Cest: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Uf_Origem : String read fUf_Origem write fUf_Origem;
    property Uf_Destino : String read fUf_Destino write fUf_Destino;
    property Cd_Ncm : String read fCd_Ncm write fCd_Ncm;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Cest : String read fCd_Cest write fCd_Cest;
  end;

  TNcmsubsts = class(TList)
  public
    function Add: TNcmsubst; overload;
  end;

implementation

{ TNcmsubst }

constructor TNcmsubst.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TNcmsubst.Destroy;
begin

  inherited;
end;

//--

function TNcmsubst.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'NCMSUBST';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Uf_Origem', 'UF_ORIGEM', tfKey);
    Add('Uf_Destino', 'UF_DESTINO', tfKey);
    Add('Cd_Ncm', 'CD_NCM', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfNul);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfNul);
    Add('Cd_Cest', 'CD_CEST', tfNul);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin
  end;
end;

//--

{ TNcmsubsts }

function TNcmsubsts.Add: TNcmsubst;
begin
  Result := TNcmsubst.Create(nil);
  Self.Add(Result);
end;

end.