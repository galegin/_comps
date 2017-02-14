unit uDicRelinfadic;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relinfadic = class;
  TDic_RelinfadicClass = class of TDic_Relinfadic;

  TDic_RelinfadicList = class;
  TDic_RelinfadicListClass = class of TDic_RelinfadicList;

  TDic_Relinfadic = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fNr_Seqinf: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Param: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property Nr_Seqinf : Real read fNr_Seqinf write fNr_Seqinf;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Param : String read fDs_Param write fDs_Param;
  end;

  TDic_RelinfadicList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relinfadic;
    procedure SetItem(Index: Integer; Value: TDic_Relinfadic);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relinfadic;
    property Items[Index: Integer]: TDic_Relinfadic read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relinfadic }

constructor TDic_Relinfadic.Create;
begin

end;

destructor TDic_Relinfadic.Destroy;
begin

  inherited;
end;

{ TDic_RelinfadicList }

constructor TDic_RelinfadicList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relinfadic);
end;

function TDic_RelinfadicList.Add: TDic_Relinfadic;
begin
  Result := TDic_Relinfadic(inherited Add);
  Result.create;
end;

function TDic_RelinfadicList.GetItem(Index: Integer): TDic_Relinfadic;
begin
  Result := TDic_Relinfadic(inherited GetItem(Index));
end;

procedure TDic_RelinfadicList.SetItem(Index: Integer; Value: TDic_Relinfadic);
begin
  inherited SetItem(Index, Value);
end;

end.