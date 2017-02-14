unit uDicRelemp;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relemp = class;
  TDic_RelempClass = class of TDic_Relemp;

  TDic_RelempList = class;
  TDic_RelempListClass = class of TDic_RelempList;

  TDic_Relemp = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fCd_Empresa: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Cd_Empresa : Real read fCd_Empresa write fCd_Empresa;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
  end;

  TDic_RelempList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relemp;
    procedure SetItem(Index: Integer; Value: TDic_Relemp);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relemp;
    property Items[Index: Integer]: TDic_Relemp read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relemp }

constructor TDic_Relemp.Create;
begin

end;

destructor TDic_Relemp.Destroy;
begin

  inherited;
end;

{ TDic_RelempList }

constructor TDic_RelempList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relemp);
end;

function TDic_RelempList.Add: TDic_Relemp;
begin
  Result := TDic_Relemp(inherited Add);
  Result.create;
end;

function TDic_RelempList.GetItem(Index: Integer): TDic_Relemp;
begin
  Result := TDic_Relemp(inherited GetItem(Index));
end;

procedure TDic_RelempList.SetItem(Index: Integer; Value: TDic_Relemp);
begin
  inherited SetItem(Index, Value);
end;

end.