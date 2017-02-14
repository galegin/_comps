unit uDicFonte;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem,
  uDicRel;

type
  TDic_Fonte = class;
  TDic_FonteClass = class of TDic_Fonte;

  TDic_FonteList = class;
  TDic_FonteListClass = class of TDic_FonteList;

  TDic_Fonte = class(TmCollectionItem)
  private
    fCd_Empresa: Real;
    fCd_Relatorio: String;
    fCd_Estilo: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Fonte: String;
    fTp_Alinhamento: String;
    fNr_Tamanho: Real;
    fDs_Corfonte: String;
    fDs_Corfundo: String;
    fNr_Espacamento: Real;
    fNr_Espacamentol: Real;
    fIn_Negrito: String;
    fIn_Italico: String;
    fIn_Sublinhado: String;
    fIn_Tracejado: String;
    fTp_Estiloborda: String;
    fNr_Espessura: Real;
    fDs_Corborda: String;
    fIn_Superior: String;
    fIn_Inferior: String;
    fIn_Direita: String;
    fIn_Esquerda: String;
	
    fObj_Relatorio : TDic_Rel;	
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Empresa : Real read fCd_Empresa write fCd_Empresa;
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Cd_Estilo : String read fCd_Estilo write fCd_Estilo;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Fonte : String read fDs_Fonte write fDs_Fonte;
    property Tp_Alinhamento : String read fTp_Alinhamento write fTp_Alinhamento;
    property Nr_Tamanho : Real read fNr_Tamanho write fNr_Tamanho;
    property Ds_Corfonte : String read fDs_Corfonte write fDs_Corfonte;
    property Ds_Corfundo : String read fDs_Corfundo write fDs_Corfundo;
    property Nr_Espacamento : Real read fNr_Espacamento write fNr_Espacamento;
    property Nr_Espacamentol : Real read fNr_Espacamentol write fNr_Espacamentol;
    property In_Negrito : String read fIn_Negrito write fIn_Negrito;
    property In_Italico : String read fIn_Italico write fIn_Italico;
    property In_Sublinhado : String read fIn_Sublinhado write fIn_Sublinhado;
    property In_Tracejado : String read fIn_Tracejado write fIn_Tracejado;
    property Tp_Estiloborda : String read fTp_Estiloborda write fTp_Estiloborda;
    property Nr_Espessura : Real read fNr_Espessura write fNr_Espessura;
    property Ds_Corborda : String read fDs_Corborda write fDs_Corborda;
    property In_Superior : String read fIn_Superior write fIn_Superior;
    property In_Inferior : String read fIn_Inferior write fIn_Inferior;
    property In_Direita : String read fIn_Direita write fIn_Direita;
    property In_Esquerda : String read fIn_Esquerda write fIn_Esquerda;
	
    property Obj_Relatorio : TDic_Rel read fObj_Relatorio write fObj_Relatorio;
  end;

  TDic_FonteList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Fonte;
    procedure SetItem(Index: Integer; Value: TDic_Fonte);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Fonte;
    property Items[Index: Integer]: TDic_Fonte read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Fonte }

constructor TDic_Fonte.Create;
begin
  fObj_Relatorio : TDic_Rel.Create(Self);
end;

destructor TDic_Fonte.Destroy;
begin
  inherited;
end;

{ TDic_FonteList }

constructor TDic_FonteList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Fonte);
end;

function TDic_FonteList.Add: TDic_Fonte;
begin
  Result := TDic_Fonte(inherited Add);
  Result.create;
end;

function TDic_FonteList.GetItem(Index: Integer): TDic_Fonte;
begin
  Result := TDic_Fonte(inherited GetItem(Index));
end;

procedure TDic_FonteList.SetItem(Index: Integer; Value: TDic_Fonte);
begin
  inherited SetItem(Index, Value);
end;

end.