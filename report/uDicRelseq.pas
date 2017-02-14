unit uDicRelseq;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem,
  uDicReldoc, uDicRelent, uDicRelevol, uDicRelfor,
  uDicRelgrd, uDicRelinfadic, uDicRelrel, uDicRelbarc,
  uDicRelcfg, uDicRelcpo, uDicReldef;

type
  TDic_Relseq = class;
  TDic_RelseqClass = class of TDic_Relseq;

  TDic_RelseqList = class;
  TDic_RelseqListClass = class of TDic_RelseqList;

  TDic_Relseq = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fTp_Seqrel: String;
    fDs_Seqrel: String;
    fNr_Faixamult: Real;
    fNr_Faixaini: Real;
    fNr_Faixaint: Real;
    fIn_Corinverso: String;
    fTp_Grafico: String;
    fIn_Legenda: String;
    fIn_Grade: String;
    fCd_Campograde: String;
    fDs_Functgrade: String;
    fQt_Colunagrade: Real;
    fNr_Escalagrade: Real;
    fNr_Seqpai: Real;
    fTp_Comparativo: String;
    fDs_Param: String;
    fIn_Listarquebra: String;
    fIn_Listarcorpo: String;
    fIn_Listartotal: String;
    fTp_Select: String;
    fIn_Quebralinha: String;
    fIn_Totalalin: String;
    fIn_Qbrpagina: String;
    fIn_Listartotalger: String;
    fIn_Zebrarel: String;
    fIn_Labeltot: String;
    fNr_Recuoesq: Real;
    fQt_Reglistar: Real;
    fIn_Visualizatodos: String;
	
    fObj_Relevol : TDic_Relevol;
    fObj_Relgrd : TDic_Relgrd;

    fList_Relent : TDic_RelentList;
    fList_Relcpo : TDic_RelcpoList;
    fList_Relrel : TDic_RelrelList;
    fList_Relsql : TDic_RelsqlList;
    fList_Reldoc : TDic_ReldocList;	
    fList_Relfor : TDic_RelforList;
    fList_Relinfadic : TDic_RelinfadicList;
    fList_Relbarc : TDic_RelbarcList;
    fList_Relcfg : TDic_RelcfgList;
    fList_Reldef : TDic_ReldefList;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Tp_Seqrel : String read fTp_Seqrel write fTp_Seqrel;
    property Ds_Seqrel : String read fDs_Seqrel write fDs_Seqrel;
    property Nr_Faixamult : Real read fNr_Faixamult write fNr_Faixamult;
    property Nr_Faixaini : Real read fNr_Faixaini write fNr_Faixaini;
    property Nr_Faixaint : Real read fNr_Faixaint write fNr_Faixaint;
    property In_Corinverso : String read fIn_Corinverso write fIn_Corinverso;
    property Tp_Grafico : String read fTp_Grafico write fTp_Grafico;
    property In_Legenda : String read fIn_Legenda write fIn_Legenda;
    property In_Grade : String read fIn_Grade write fIn_Grade;
    property Cd_Campograde : String read fCd_Campograde write fCd_Campograde;
    property Ds_Functgrade : String read fDs_Functgrade write fDs_Functgrade;
    property Qt_Colunagrade : Real read fQt_Colunagrade write fQt_Colunagrade;
    property Nr_Escalagrade : Real read fNr_Escalagrade write fNr_Escalagrade;
    property Nr_Seqpai : Real read fNr_Seqpai write fNr_Seqpai;
    property Tp_Comparativo : String read fTp_Comparativo write fTp_Comparativo;
    property Ds_Param : String read fDs_Param write fDs_Param;
    property In_Listarquebra : String read fIn_Listarquebra write fIn_Listarquebra;
    property In_Listarcorpo : String read fIn_Listarcorpo write fIn_Listarcorpo;
    property In_Listartotal : String read fIn_Listartotal write fIn_Listartotal;
    property Tp_Select : String read fTp_Select write fTp_Select;
    property In_Quebralinha : String read fIn_Quebralinha write fIn_Quebralinha;
    property In_Totalalin : String read fIn_Totalalin write fIn_Totalalin;
    property In_Qbrpagina : String read fIn_Qbrpagina write fIn_Qbrpagina;
    property In_Listartotalger : String read fIn_Listartotalger write fIn_Listartotalger;
    property In_Zebrarel : String read fIn_Zebrarel write fIn_Zebrarel;
    property In_Labeltot : String read fIn_Labeltot write fIn_Labeltot;
    property Nr_Recuoesq : Real read fNr_Recuoesq write fNr_Recuoesq;
    property Qt_Reglistar : Real read fQt_Reglistar write fQt_Reglistar;
    property In_Visualizatodos : String read fIn_Visualizatodos write fIn_Visualizatodos;

    property Obj_Relevol : TDic_Relevol read fObj_Relevol write fObj_Relevol;
    property Obj_Relgrd : TDic_Relgrd read fObj_Relgrd write fObj_Relgrd;
	
    property List_Relent : TDic_RelentList read fList_Relent write fList_Relent;
    property List_Relcpo : TDic_RelcpoList read fList_Relcpo write fList_Relcpo;
    property List_Relrel : TDic_RelrelList read fList_Relrel write fList_Relrel;
    property List_Relsql : TDic_RelsqlList read fList_Relsql write fList_Relsql;
    property List_Reldoc : TDic_ReldocList read fList_Reldoc write fList_Reldoc;	
    property List_Relfor : TDic_RelforList read fList_Relfor write fList_Relfor;
    property List_Relinfadic : TDic_RelinfadicList read fList_Relinfadic write fList_Relinfadic;
    property List_Relbarc : TDic_RelbarcList read fList_Relbarc write fList_Relbarc;
    property List_Relcfg : TDic_RelcfgList read fList_Relcfg write fList_Relcfg;
    property List_Reldef : TDic_ReldefList read fList_Reldef write fList_Reldef;	
  end;

  TDic_RelseqList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relseq;
    procedure SetItem(Index: Integer; Value: TDic_Relseq);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relseq;
    property Items[Index: Integer]: TDic_Relseq read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relseq }

constructor TDic_Relseq.Create;
begin
  fObj_Relevol := TDic_Relevol.Create(Self);
  fObj_Relgrd := TDic_Relgrd.Create(Self);

  fList_Relent := TDic_RelentList.Create(Self);
  fList_Relcpo := TDic_RelcpoList.Create(Self);
  fList_Relrel := TDic_RelrelList.Create(Self);
  fList_Relsql := TDic_RelsqlList.Create(Self);
  fList_Reldoc := TDic_ReldocList.Create(Self);	
  fList_Relfor := TDic_RelforList.Create(Self);
  fList_Relinfadic := TDic_RelinfadicList.Create(Self);
  fList_Relbarc := TDic_RelbarcList.Create(Self);
  fList_Relcfg := TDic_RelcfgList.Create(Self);
  fList_Reldef := TDic_ReldefList.Create(Self);
end;

destructor TDic_Relseq.Destroy;
begin
  inherited;
end;

{ TDic_RelseqList }

constructor TDic_RelseqList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relseq);
end;

function TDic_RelseqList.Add: TDic_Relseq;
begin
  Result := TDic_Relseq(inherited Add);
  Result.create;
end;

function TDic_RelseqList.GetItem(Index: Integer): TDic_Relseq;
begin
  Result := TDic_Relseq(inherited GetItem(Index));
end;

procedure TDic_RelseqList.SetItem(Index: Integer; Value: TDic_Relseq);
begin
  inherited SetItem(Index, Value);
end;

end.