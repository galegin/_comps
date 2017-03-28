unit mTipoParametro;

interface

uses
  Classes, SysUtils, StrUtils;

type
  TmTipoParametro = class(TComponent)
  private
    fUf_Origem : String;   // 'PR'
    fTp_Ambiente : String; // 1 - Producao / 2 - Homologacao
    fTp_Emissao : String;  // 1 - Normal / 9 - OffLine
    fTp_ModeloDF : String;   // NFE / NFCE
    fTp_VersaoDF : String;   // 2.00 / 3.00 / 3.10

    fDs_ArquivoCert : String; // 'c:\projetos\venda\certificados\certificado.pfx'
    fDs_SenhaCert : String;   // '1234'
    fDs_SerieCert : String;   // '123456789ABCDEFGH'

    fId_CSC : String; // '1'
    fCd_CSC : String; // '0123456789'

    fTp_DANFE : String;

    fIn_MostrarPreview : String;
    fIn_MostrarStatus : String;

    fTp_ImpressaoDanfe : String;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    procedure Carregar;
    procedure Salvar;
  published
    property Uf_Origem : String read fUf_Origem write fUf_Origem;
    property Tp_Ambiente : String read fTp_Ambiente write fTp_Ambiente;
    property Tp_Emissao : String read fTp_Emissao write fTp_Emissao;
    property Tp_ModeloDF : String read fTp_ModeloDF write fTp_ModeloDF;
    property Tp_VersaoDF : String read fTp_VersaoDF write fTp_VersaoDF;

    property Ds_ArquivoCert : String read fDs_ArquivoCert write fDs_ArquivoCert;
    property Ds_SenhaCert : String read fDs_SenhaCert write fDs_SenhaCert;
    property Ds_SerieCert : String read fDs_SerieCert write fDs_SerieCert;

    property Id_CSC : String read fId_CSC write fId_CSC;
    property Cd_CSC : String read fCd_CSC write fCd_CSC;

    property Tp_DANFE : String read fTp_DANFE write fTp_DANFE;

    property In_MostrarPreview : String read fIn_MostrarPreview write fIn_MostrarPreview;
    property In_MostrarStatus : String read fIn_MostrarStatus write fIn_MostrarStatus;

    property Tp_ImpressaoDanfe : String read fTp_ImpressaoDanfe write fTp_ImpressaoDanfe;
  end;

  function Instance : TmTipoParametro;

implementation

uses
  mValue, mObjeto, mArquivo, mPath, mJson;

var
  _instance : TmTipoParametro;

  function Instance : TmTipoParametro;
  begin
    if not Assigned(_instance) then
      _instance := TmTipoParametro.Create(nil);
    Result := _instance;
  end;

{ TmTipoParametro }

constructor TmTipoParametro.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TmTipoParametro.Carregar;
var
  vArquivo, vJson : String;
  vObject : TObject;
begin
  vArquivo := TmPath.Dados() + ClassName + '.json';
  vJson := TmArquivo.Ler(vArquivo);
  vObject := TmJson.JsonToObject(ClassType, vJson);
  TmObjeto.SetValues(Self, TmObjeto.GetValues(vObject));
end;

procedure TmTipoParametro.Salvar;
var
  vArquivo, vJson : String;
begin
  vArquivo := TmPath.Dados() + ClassName + '.json';
  vJson := TmJson.ObjectToJson(Self);
  TmArquivo.Gravar(vArquivo, vJson);
end;

initialization
  Instance.Carregar;

finalization
  Instance.Salvar;

end.