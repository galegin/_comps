unit uDicRelevol;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relevol = class;
  TDic_RelevolClass = class of TDic_Relevol;

  TDic_RelevolList = class;
  TDic_RelevolListClass = class of TDic_RelevolList;

  TDic_Relevol = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fCd_Campoevol: String;
    fTp_Campoevol: String;
    fCd_Somarevol: String;
    fDs_Functevol: String;
    fIn_Totalevol: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Campoevol : String read fCd_Campoevol write fCd_Campoevol;
    property Tp_Campoevol : String read fTp_Campoevol write fTp_Campoevol;
    property Cd_Somarevol : String read fCd_Somarevol write fCd_Somarevol;
    property Ds_Functevol : String read fDs_Functevol write fDs_Functevol;
    property In_Totalevol : String read fIn_Totalevol write fIn_Totalevol;
  end;

  TDic_RelevolList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relevol;
    procedure SetItem(Index: Integer; Value: TDic_Relevol);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relevol;
    property Items[Index: Integer]: TDic_Relevol read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relevol }

constructor TDic_Relevol.Create;
begin

end;

destructor TDic_Relevol.Destroy;
begin

  inherited;
end;

{ TDic_RelevolList }

constructor TDic_RelevolList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relevol);
end;

function TDic_RelevolList.Add: TDic_Relevol;
begin
  Result := TDic_Relevol(inherited Add);
  Result.create;
end;

function TDic_RelevolList.GetItem(Index: Integer): TDic_Relevol;
begin
  Result := TDic_Relevol(inherited GetItem(Index));
end;

procedure TDic_RelevolList.SetItem(Index: Integer; Value: TDic_Relevol);
begin
  inherited SetItem(Index, Value);
end;

end.