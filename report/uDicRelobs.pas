unit uDicRelobs;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relobs = class;
  TDic_RelobsClass = class of TDic_Relobs;

  TDic_RelobsList = class;
  TDic_RelobsListClass = class of TDic_RelobsList;

  TDic_Relobs = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
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
    property Nr_Linha : Real read fNr_Linha write fNr_Linha;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Linha : String read fDs_Linha write fDs_Linha;
  end;

  TDic_RelobsList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relobs;
    procedure SetItem(Index: Integer; Value: TDic_Relobs);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relobs;
    property Items[Index: Integer]: TDic_Relobs read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relobs }

constructor TDic_Relobs.Create;
begin

end;

destructor TDic_Relobs.Destroy;
begin

  inherited;
end;

{ TDic_RelobsList }

constructor TDic_RelobsList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relobs);
end;

function TDic_RelobsList.Add: TDic_Relobs;
begin
  Result := TDic_Relobs(inherited Add);
  Result.create;
end;

function TDic_RelobsList.GetItem(Index: Integer): TDic_Relobs;
begin
  Result := TDic_Relobs(inherited GetItem(Index));
end;

procedure TDic_RelobsList.SetItem(Index: Integer; Value: TDic_Relobs);
begin
  inherited SetItem(Index, Value);
end;

end.