unit uDicReldoc;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Reldoc = class;
  TDic_ReldocClass = class of TDic_Reldoc;

  TDic_ReldocList = class;
  TDic_ReldocListClass = class of TDic_ReldocList;

  TDic_Reldoc = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fTp_Seqdoc: String;
    fNr_Seqdoc: Real;
    fNr_Linha: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Linha: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property Tp_Seqdoc : String read fTp_Seqdoc write fTp_Seqdoc;
    property Nr_Seqdoc : Real read fNr_Seqdoc write fNr_Seqdoc;
    property Nr_Linha : Real read fNr_Linha write fNr_Linha;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Linha : String read fDs_Linha write fDs_Linha;
  end;

  TDic_ReldocList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Reldoc;
    procedure SetItem(Index: Integer; Value: TDic_Reldoc);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Reldoc;
    property Items[Index: Integer]: TDic_Reldoc read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Reldoc }

constructor TDic_Reldoc.Create;
begin

end;

destructor TDic_Reldoc.Destroy;
begin

  inherited;
end;

{ TDic_ReldocList }

constructor TDic_ReldocList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Reldoc);
end;

function TDic_ReldocList.Add: TDic_Reldoc;
begin
  Result := TDic_Reldoc(inherited Add);
  Result.create;
end;

function TDic_ReldocList.GetItem(Index: Integer): TDic_Reldoc;
begin
  Result := TDic_Reldoc(inherited GetItem(Index));
end;

procedure TDic_ReldocList.SetItem(Index: Integer; Value: TDic_Reldoc);
begin
  inherited SetItem(Index, Value);
end;

end.