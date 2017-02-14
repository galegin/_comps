unit uDicRelent;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relent = class;
  TDic_RelentClass = class of TDic_Relent;

  TDic_RelentList = class;
  TDic_RelentListClass = class of TDic_RelentList;

  TDic_Relent = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fCd_Entidade: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Sigla: String;
    fNr_Linha: String;
    fNr_Coluna: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property Cd_Entidade : String read fCd_Entidade write fCd_Entidade;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Sigla : String read fDs_Sigla write fDs_Sigla;
    property Nr_Linha : String read fNr_Linha write fNr_Linha;
    property Nr_Coluna : String read fNr_Coluna write fNr_Coluna;
  end;

  TDic_RelentList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relent;
    procedure SetItem(Index: Integer; Value: TDic_Relent);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relent;
    property Items[Index: Integer]: TDic_Relent read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relent }

constructor TDic_Relent.Create;
begin

end;

destructor TDic_Relent.Destroy;
begin

  inherited;
end;

{ TDic_RelentList }

constructor TDic_RelentList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relent);
end;

function TDic_RelentList.Add: TDic_Relent;
begin
  Result := TDic_Relent(inherited Add);
  Result.create;
end;

function TDic_RelentList.GetItem(Index: Integer): TDic_Relent;
begin
  Result := TDic_Relent(inherited GetItem(Index));
end;

procedure TDic_RelentList.SetItem(Index: Integer; Value: TDic_Relent);
begin
  inherited SetItem(Index, Value);
end;

end.