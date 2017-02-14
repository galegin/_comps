unit uDicRelsql;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relsql = class;
  TDic_RelsqlClass = class of TDic_Relsql;

  TDic_RelsqlList = class;
  TDic_RelsqlListClass = class of TDic_RelsqlList;

  TDic_Relsql = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fNr_Linha: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Sql: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property Nr_Linha : Real read fNr_Linha write fNr_Linha;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Sql : String read fDs_Sql write fDs_Sql;
  end;

  TDic_RelsqlList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relsql;
    procedure SetItem(Index: Integer; Value: TDic_Relsql);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relsql;
    property Items[Index: Integer]: TDic_Relsql read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relsql }

constructor TDic_Relsql.Create;
begin

end;

destructor TDic_Relsql.Destroy;
begin

  inherited;
end;

{ TDic_RelsqlList }

constructor TDic_RelsqlList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relsql);
end;

function TDic_RelsqlList.Add: TDic_Relsql;
begin
  Result := TDic_Relsql(inherited Add);
  Result.create;
end;

function TDic_RelsqlList.GetItem(Index: Integer): TDic_Relsql;
begin
  Result := TDic_Relsql(inherited GetItem(Index));
end;

procedure TDic_RelsqlList.SetItem(Index: Integer; Value: TDic_Relsql);
begin
  inherited SetItem(Index, Value);
end;

end.