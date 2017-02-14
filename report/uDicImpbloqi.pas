unit uDicImpbloqi;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Impbloqi = class;
  TDic_ImpbloqiClass = class of TDic_Impbloqi;

  TDic_ImpbloqiList = class;
  TDic_ImpbloqiListClass = class of TDic_ImpbloqiList;

  TDic_Impbloqi = class(TmCollectionItem)
  private
    fNr_Session: Real;
    fNr_Seqbloq: Real;
    fNr_Seqitem: Real;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fDs_Conteudo: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Nr_Session : Real read fNr_Session write fNr_Session;
    property Nr_Seqbloq : Real read fNr_Seqbloq write fNr_Seqbloq;
    property Nr_Seqitem : Real read fNr_Seqitem write fNr_Seqitem;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Conteudo : String read fDs_Conteudo write fDs_Conteudo;
  end;

  TDic_ImpbloqiList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Impbloqi;
    procedure SetItem(Index: Integer; Value: TDic_Impbloqi);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Impbloqi;
    property Items[Index: Integer]: TDic_Impbloqi read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Impbloqi }

constructor TDic_Impbloqi.Create;
begin

end;

destructor TDic_Impbloqi.Destroy;
begin

  inherited;
end;

{ TDic_ImpbloqiList }

constructor TDic_ImpbloqiList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Impbloqi);
end;

function TDic_ImpbloqiList.Add: TDic_Impbloqi;
begin
  Result := TDic_Impbloqi(inherited Add);
  Result.create;
end;

function TDic_ImpbloqiList.GetItem(Index: Integer): TDic_Impbloqi;
begin
  Result := TDic_Impbloqi(inherited GetItem(Index));
end;

procedure TDic_ImpbloqiList.SetItem(Index: Integer; Value: TDic_Impbloqi);
begin
  inherited SetItem(Index, Value);
end;

end.