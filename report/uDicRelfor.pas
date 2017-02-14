unit uDicRelfor;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relfor = class;
  TDic_RelforClass = class of TDic_Relfor;

  TDic_RelforList = class;
  TDic_RelforListClass = class of TDic_RelforList;

  TDic_Relfor = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fCd_Campo: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Funct: String;
    fDs_Formula: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property Cd_Campo : String read fCd_Campo write fCd_Campo;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Funct : String read fDs_Funct write fDs_Funct;
    property Ds_Formula : String read fDs_Formula write fDs_Formula;
  end;

  TDic_RelforList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relfor;
    procedure SetItem(Index: Integer; Value: TDic_Relfor);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relfor;
    property Items[Index: Integer]: TDic_Relfor read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relfor }

constructor TDic_Relfor.Create;
begin

end;

destructor TDic_Relfor.Destroy;
begin

  inherited;
end;

{ TDic_RelforList }

constructor TDic_RelforList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relfor);
end;

function TDic_RelforList.Add: TDic_Relfor;
begin
  Result := TDic_Relfor(inherited Add);
  Result.create;
end;

function TDic_RelforList.GetItem(Index: Integer): TDic_Relfor;
begin
  Result := TDic_Relfor(inherited GetItem(Index));
end;

procedure TDic_RelforList.SetItem(Index: Integer; Value: TDic_Relfor);
begin
  inherited SetItem(Index, Value);
end;

end.