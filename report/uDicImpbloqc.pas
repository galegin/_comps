unit uDicImpbloqc;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem,
  uDicImpbloqi;

type
  TDic_Impbloqc = class;
  TDic_ImpbloqcClass = class of TDic_Impbloqc;

  TDic_ImpbloqcList = class;
  TDic_ImpbloqcListClass = class of TDic_ImpbloqcList;

  TDic_Impbloqc = class(TmCollectionItem)
  private
    fNr_Session: Real;
    fNr_Seqbloq: Real;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fCd_Empresa: Real;
    fCd_Cliente: Real;
    fNr_Fat: Real;
    fNr_Parcela: Real;
	
	fList_Impbloqi : TDic_ImpbloqiList;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Nr_Session : Real read fNr_Session write fNr_Session;
    property Nr_Seqbloq : Real read fNr_Seqbloq write fNr_Seqbloq;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Empresa : Real read fCd_Empresa write fCd_Empresa;
    property Cd_Cliente : Real read fCd_Cliente write fCd_Cliente;
    property Nr_Fat : Real read fNr_Fat write fNr_Fat;
    property Nr_Parcela : Real read fNr_Parcela write fNr_Parcela;
	
	property List_Impbloqi : TDic_ImpbloqiList read fList_Impbloqi write fList_Impbloqi;
  end;

  TDic_ImpbloqcList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Impbloqc;
    procedure SetItem(Index: Integer; Value: TDic_Impbloqc);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Impbloqc;
    property Items[Index: Integer]: TDic_Impbloqc read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Impbloqc }

constructor TDic_Impbloqc.Create;
begin
  List_Impbloqi := TDic_ImpbloqiList.Create(Self);
end;

destructor TDic_Impbloqc.Destroy;
begin
  inherited;
end;

{ TDic_ImpbloqcList }

constructor TDic_ImpbloqcList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Impbloqc);
end;

function TDic_ImpbloqcList.Add: TDic_Impbloqc;
begin
  Result := TDic_Impbloqc(inherited Add);
  Result.create;
end;

function TDic_ImpbloqcList.GetItem(Index: Integer): TDic_Impbloqc;
begin
  Result := TDic_Impbloqc(inherited GetItem(Index));
end;

procedure TDic_ImpbloqcList.SetItem(Index: Integer; Value: TDic_Impbloqc);
begin
  inherited SetItem(Index, Value);
end;

end.