unit uDicReldin;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Reldin = class;
  TDic_ReldinClass = class of TDic_Reldin;

  TDic_ReldinList = class;
  TDic_ReldinListClass = class of TDic_ReldinList;

  TDic_Reldin = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fCd_Campo: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fTp_Fildin: String;
    fDs_Sugerir: String;
    fCd_Campodef: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Cd_Campo : String read fCd_Campo write fCd_Campo;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Tp_Fildin : String read fTp_Fildin write fTp_Fildin;
    property Ds_Sugerir : String read fDs_Sugerir write fDs_Sugerir;
    property Cd_Campodef : String read fCd_Campodef write fCd_Campodef;
  end;

  TDic_ReldinList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Reldin;
    procedure SetItem(Index: Integer; Value: TDic_Reldin);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Reldin;
    property Items[Index: Integer]: TDic_Reldin read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Reldin }

constructor TDic_Reldin.Create;
begin

end;

destructor TDic_Reldin.Destroy;
begin

  inherited;
end;

{ TDic_ReldinList }

constructor TDic_ReldinList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Reldin);
end;

function TDic_ReldinList.Add: TDic_Reldin;
begin
  Result := TDic_Reldin(inherited Add);
  Result.create;
end;

function TDic_ReldinList.GetItem(Index: Integer): TDic_Reldin;
begin
  Result := TDic_Reldin(inherited GetItem(Index));
end;

procedure TDic_ReldinList.SetItem(Index: Integer; Value: TDic_Reldin);
begin
  inherited SetItem(Index, Value);
end;

end.