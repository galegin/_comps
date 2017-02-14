unit uDicRelmax;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relmax = class;
  TDic_RelmaxClass = class of TDic_Relmax;

  TDic_RelmaxList = class;
  TDic_RelmaxListClass = class of TDic_RelmaxList;

  TDic_Relmax = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fQt_Maxacessototal: Real;
    fQt_Maxmemoria: Real;
    fQt_Maxregistro: Real;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Qt_Maxacessototal : Real read fQt_Maxacessototal write fQt_Maxacessototal;
    property Qt_Maxmemoria : Real read fQt_Maxmemoria write fQt_Maxmemoria;
    property Qt_Maxregistro : Real read fQt_Maxregistro write fQt_Maxregistro;
  end;

  TDic_RelmaxList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relmax;
    procedure SetItem(Index: Integer; Value: TDic_Relmax);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relmax;
    property Items[Index: Integer]: TDic_Relmax read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relmax }

constructor TDic_Relmax.Create;
begin

end;

destructor TDic_Relmax.Destroy;
begin

  inherited;
end;

{ TDic_RelmaxList }

constructor TDic_RelmaxList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relmax);
end;

function TDic_RelmaxList.Add: TDic_Relmax;
begin
  Result := TDic_Relmax(inherited Add);
  Result.create;
end;

function TDic_RelmaxList.GetItem(Index: Integer): TDic_Relmax;
begin
  Result := TDic_Relmax(inherited GetItem(Index));
end;

procedure TDic_RelmaxList.SetItem(Index: Integer; Value: TDic_Relmax);
begin
  inherited SetItem(Index, Value);
end;

end.