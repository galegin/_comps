unit uCaixacont;

interface

uses
  Classes, SysUtils,
  mMapping;

type
  TCaixacont = class(TmMapping)
  private
    fId_Caixa: Integer;
    fId_Histrel: Integer;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fVl_Contado: Real;
    fVl_Sistema: Real;
    fVl_Retirada: Real;
    fVl_Suprimento: Real;
    fVl_Diferenca: Real;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMapping() : PmMapping; override;
  published
    property Id_Caixa : Integer read fId_Caixa write fId_Caixa;
    property Id_Histrel : Integer read fId_Histrel write fId_Histrel;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Vl_Contado : Real read fVl_Contado write fVl_Contado;
    property Vl_Sistema : Real read fVl_Sistema write fVl_Sistema;
    property Vl_Retirada : Real read fVl_Retirada write fVl_Retirada;
    property Vl_Suprimento : Real read fVl_Suprimento write fVl_Suprimento;
    property Vl_Diferenca : Real read fVl_Diferenca write fVl_Diferenca;
  end;

  TCaixaconts = class(TList)
  public
    function Add: TCaixacont; overload;
  end;

implementation

{ TCaixacont }

constructor TCaixacont.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TCaixacont.Destroy;
begin

  inherited;
end;

//--

function TCaixacont.GetMapping: PmMapping;
begin
  Result := New(PmMapping);

  Result.Tabela := New(PmTabela);
  with Result.Tabela^ do begin
    Nome := 'CAIXACONT';
  end;

  Result.Campos := TmCampos.Create;
  with Result.Campos do begin
    Add('Id_Caixa', 'ID_CAIXA', tfKey);
    Add('Id_Histrel', 'ID_HISTREL', tfKey);
    Add('U_Version', 'U_VERSION', tfNul);
    Add('Cd_Operador', 'CD_OPERADOR', tfReq);
    Add('Dt_Cadastro', 'DT_CADASTRO', tfReq);
    Add('Vl_Contado', 'VL_CONTADO', tfReq);
    Add('Vl_Sistema', 'VL_SISTEMA', tfReq);
    Add('Vl_Retirada', 'VL_RETIRADA', tfReq);
    Add('Vl_Suprimento', 'VL_SUPRIMENTO', tfReq);
    Add('Vl_Diferenca', 'VL_DIFERENCA', tfReq);
  end;

  Result.Relacoes := TmRelacoes.Create;
  with Result.Relacoes do begin
  end;
end;

//--

{ TCaixaconts }

function TCaixaconts.Add: TCaixacont;
begin
  Result := TCaixacont.Create(nil);
  Self.Add(Result);
end;

end.