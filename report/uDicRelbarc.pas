unit uDicRelbarc;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem,
  uDicRelbariList;

type
  TDic_Relbarc = class;
  TDic_RelbarcClass = class of TDic_Relbarc;

  TDic_RelbarcList = class;
  TDic_RelbarcListClass = class of TDic_RelbarcList;

  TDic_Relbarc = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fNr_Seqbar: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Formato: String;
    fNr_Linha: Real;
    fNr_Coluna: Real;
    fNr_Altura: Real;
    fNr_Largura: Real;
	
    fList_Relbari : TDic_RelbariList;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property Nr_Seqbar : Real read fNr_Seqbar write fNr_Seqbar;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Formato : String read fDs_Formato write fDs_Formato;
    property Nr_Linha : Real read fNr_Linha write fNr_Linha;
    property Nr_Coluna : Real read fNr_Coluna write fNr_Coluna;
    property Nr_Altura : Real read fNr_Altura write fNr_Altura;
    property Nr_Largura : Real read fNr_Largura write fNr_Largura;
	
    property List_Relbari : TDic_RelbariList read fList_Relbari write fList_Relbari;
  end;

  TDic_RelbarcList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relbarc;
    procedure SetItem(Index: Integer; Value: TDic_Relbarc);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relbarc;
    property Items[Index: Integer]: TDic_Relbarc read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relbarc }

constructor TDic_Relbarc.Create;
begin
  List_Relbari := TDic_RelbariList.Crete(Self);
end;

destructor TDic_Relbarc.Destroy;
begin

  inherited;
end;

{ TDic_RelbarcList }

constructor TDic_RelbarcList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relbarc);
end;

function TDic_RelbarcList.Add: TDic_Relbarc;
begin
  Result := TDic_Relbarc(inherited Add);
  Result.create;
end;

function TDic_RelbarcList.GetItem(Index: Integer): TDic_Relbarc;
begin
  Result := TDic_Relbarc(inherited GetItem(Index));
end;

procedure TDic_RelbarcList.SetItem(Index: Integer; Value: TDic_Relbarc);
begin
  inherited SetItem(Index, Value);
end;

end.