unit uMunicipio;

interface

uses
  Classes, SysUtils,
  mMapping,
  uEstado;

type
  TMunicipio = class(TmMapping)
  private
    fId_Municipio: Integer;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fCd_Municipio: Integer;
    fDs_Municipio: String;
    fDs_Sigla: String;
    fId_Estado: Integer;
    fEstado: TEstado;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Id_Municipio : Integer read fId_Municipio write fId_Municipio;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Municipio : Integer read fCd_Municipio write fCd_Municipio;
    property Ds_Municipio : String read fDs_Municipio write fDs_Municipio;
    property Ds_Sigla : String read fDs_Sigla write fDs_Sigla;
    property Id_Estado : Integer read fId_Estado write fId_Estado;
    property Estado : TEstado read fEstado write fEstado;
  end;

  TMunicipios = class(TList)
  public
    function Add: TMunicipio; overload;
  end;

implementation

{ TMunicipio }

constructor TMunicipio.Create(AOwner: TComponent);
begin
  inherited;

  fEstado:= TEstado.Create(nil);
end;

destructor TMunicipio.Destroy;
begin
  FreeAndNil(fEstado);

  inherited;
end;

//--

function TMunicipio.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'MUNICIPIO';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Id_Municipio', 'ID_MUNICIPIO', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Cd_Municipio', 'CD_MUNICIPIO', tfReq);
    Add('Ds_Municipio', 'DS_MUNICIPIO', tfReq);
    Add('Ds_Sigla', 'DS_SIGLA', tfReq);
    Add('Id_Estado', 'ID_ESTADO', tfReq);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin

    with Add('Estado', TEstado)^.Campos do begin
      Add('Id_Estado');
    end;
    
  end;
end;

//--

{ TMunicipios }

function TMunicipios.Add: TMunicipio;
begin
  Result := TMunicipio.Create(nil);
  Self.Add(Result);
end;

end.