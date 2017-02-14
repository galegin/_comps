unit uDicRelgrd;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relgrd = class;
  TDic_RelgrdClass = class of TDic_Relgrd;

  TDic_RelgrdList = class;
  TDic_RelgrdListClass = class of TDic_RelgrdList;

  TDic_Relgrd = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fCd_Campogrd: String;
    fCd_Somargrd: String;
    fDs_Functgrd: String;
    fIn_Totalgrd: String;
    fNr_Tamangrd: String;
    fDs_Campogrd: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Campogrd : String read fCd_Campogrd write fCd_Campogrd;
    property Cd_Somargrd : String read fCd_Somargrd write fCd_Somargrd;
    property Ds_Functgrd : String read fDs_Functgrd write fDs_Functgrd;
    property In_Totalgrd : String read fIn_Totalgrd write fIn_Totalgrd;
    property Nr_Tamangrd : String read fNr_Tamangrd write fNr_Tamangrd;
    property Ds_Campogrd : String read fDs_Campogrd write fDs_Campogrd;
  end;

  TDic_RelgrdList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relgrd;
    procedure SetItem(Index: Integer; Value: TDic_Relgrd);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relgrd;
    property Items[Index: Integer]: TDic_Relgrd read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relgrd }

constructor TDic_Relgrd.Create;
begin

end;

destructor TDic_Relgrd.Destroy;
begin

  inherited;
end;

{ TDic_RelgrdList }

constructor TDic_RelgrdList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relgrd);
end;

function TDic_RelgrdList.Add: TDic_Relgrd;
begin
  Result := TDic_Relgrd(inherited Add);
  Result.create;
end;

function TDic_RelgrdList.GetItem(Index: Integer): TDic_Relgrd;
begin
  Result := TDic_Relgrd(inherited GetItem(Index));
end;

procedure TDic_RelgrdList.SetItem(Index: Integer; Value: TDic_Relgrd);
begin
  inherited SetItem(Index, Value);
end;

end.