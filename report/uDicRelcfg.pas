unit uDicRelcfg;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relcfg = class;
  TDic_RelcfgClass = class of TDic_Relcfg;

  TDic_RelcfgList = class;
  TDic_RelcfgListClass = class of TDic_RelcfgList;

  TDic_Relcfg = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fNr_Seqcfg: Real;
    fNr_Seq: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fCd_Campo: String;
    fDs_Sort: String;
    fNr_Quebra: Real;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property Nr_Seqcfg : Real read fNr_Seqcfg write fNr_Seqcfg;
    property Nr_Seq : Real read fNr_Seq write fNr_Seq;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Campo : String read fCd_Campo write fCd_Campo;
    property Ds_Sort : String read fDs_Sort write fDs_Sort;
    property Nr_Quebra : Real read fNr_Quebra write fNr_Quebra;
  end;

  TDic_RelcfgList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relcfg;
    procedure SetItem(Index: Integer; Value: TDic_Relcfg);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relcfg;
    property Items[Index: Integer]: TDic_Relcfg read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relcfg }

constructor TDic_Relcfg.Create;
begin

end;

destructor TDic_Relcfg.Destroy;
begin

  inherited;
end;

{ TDic_RelcfgList }

constructor TDic_RelcfgList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relcfg);
end;

function TDic_RelcfgList.Add: TDic_Relcfg;
begin
  Result := TDic_Relcfg(inherited Add);
  Result.create;
end;

function TDic_RelcfgList.GetItem(Index: Integer): TDic_Relcfg;
begin
  Result := TDic_Relcfg(inherited GetItem(Index));
end;

procedure TDic_RelcfgList.SetItem(Index: Integer; Value: TDic_Relcfg);
begin
  inherited SetItem(Index, Value);
end;

end.