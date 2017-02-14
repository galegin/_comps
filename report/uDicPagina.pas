unit uDicPagina;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem,
  uDicRel;

type
  TDic_Pagina = class;
  TDic_PaginaClass = class of TDic_Pagina;

  TDic_PaginaList = class;
  TDic_PaginaListClass = class of TDic_PaginaList;

  TDic_Pagina = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fCd_Usuario: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fTp_Papel: String;
    fTp_Orientacao: String;
    fNr_Margemsup: Real;
    fNr_Margeminf: Real;
    fNr_Margemdir: Real;
    fNr_Margemesq: Real;
    fDs_Arquivo: String;
    fDs_Email: String;
    fIn_Emailauto: String;
    fCd_Emailcampo: String;
    fDs_Job: String;
	
	fObj_Relatorio : TDic_Rel;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Cd_Usuario : Real read fCd_Usuario write fCd_Usuario;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Tp_Papel : String read fTp_Papel write fTp_Papel;
    property Tp_Orientacao : String read fTp_Orientacao write fTp_Orientacao;
    property Nr_Margemsup : Real read fNr_Margemsup write fNr_Margemsup;
    property Nr_Margeminf : Real read fNr_Margeminf write fNr_Margeminf;
    property Nr_Margemdir : Real read fNr_Margemdir write fNr_Margemdir;
    property Nr_Margemesq : Real read fNr_Margemesq write fNr_Margemesq;
    property Ds_Arquivo : String read fDs_Arquivo write fDs_Arquivo;
    property Ds_Email : String read fDs_Email write fDs_Email;
    property In_Emailauto : String read fIn_Emailauto write fIn_Emailauto;
    property Cd_Emailcampo : String read fCd_Emailcampo write fCd_Emailcampo;
    property Ds_Job : String read fDs_Job write fDs_Job;
	
	property Obj_Relatorio : TDic_Rel read fObj_Relatorio write fObj_Relatorio;
  end;

  TDic_PaginaList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Pagina;
    procedure SetItem(Index: Integer; Value: TDic_Pagina);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Pagina;
    property Items[Index: Integer]: TDic_Pagina read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Pagina }

constructor TDic_Pagina.Create;
begin
  Obj_Relatorio := TDic_Rel.Create(Self);
end;

destructor TDic_Pagina.Destroy;
begin
  inherited;
end;

{ TDic_PaginaList }

constructor TDic_PaginaList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Pagina);
end;

function TDic_PaginaList.Add: TDic_Pagina;
begin
  Result := TDic_Pagina(inherited Add);
  Result.create;
end;

function TDic_PaginaList.GetItem(Index: Integer): TDic_Pagina;
begin
  Result := TDic_Pagina(inherited GetItem(Index));
end;

procedure TDic_PaginaList.SetItem(Index: Integer; Value: TDic_Pagina);
begin
  inherited SetItem(Index, Value);
end;

end.