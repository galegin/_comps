unit uDicRelbari;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relbari = class;
  TDic_RelbariClass = class of TDic_Relbari;

  TDic_RelbariList = class;
  TDic_RelbariListClass = class of TDic_RelbariList;

  TDic_Relbari = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fNr_Seqbar: Real;
    fNr_Seqcampo: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fCd_Campo: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property Nr_Seqbar : Real read fNr_Seqbar write fNr_Seqbar;
    property Nr_Seqcampo : Real read fNr_Seqcampo write fNr_Seqcampo;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Campo : String read fCd_Campo write fCd_Campo;
  end;

  TDic_RelbariList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relbari;
    procedure SetItem(Index: Integer; Value: TDic_Relbari);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relbari;
    property Items[Index: Integer]: TDic_Relbari read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relbari }

constructor TDic_Relbari.Create;
begin

end;

destructor TDic_Relbari.Destroy;
begin

  inherited;
end;

{ TDic_RelbariList }

constructor TDic_RelbariList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relbari);
end;

function TDic_RelbariList.Add: TDic_Relbari;
begin
  Result := TDic_Relbari(inherited Add);
  Result.create;
end;

function TDic_RelbariList.GetItem(Index: Integer): TDic_Relbari;
begin
  Result := TDic_Relbari(inherited GetItem(Index));
end;

procedure TDic_RelbariList.SetItem(Index: Integer; Value: TDic_Relbari);
begin
  inherited SetItem(Index, Value);
end;

end.