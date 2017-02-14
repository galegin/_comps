unit uDicParam;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Param = class;
  TDic_ParamClass = class of TDic_Param;

  TDic_ParamList = class;
  TDic_ParamListClass = class of TDic_ParamList;

  TDic_Param = class(TmCollectionItem)
  private
    fCd_Parametro: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Parametro: String;
    fVl_Parametro: String;
    fTp_Privilegio: Real;
    fIn_Parametro: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Parametro : String read fCd_Parametro write fCd_Parametro;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Parametro : String read fDs_Parametro write fDs_Parametro;
    property Vl_Parametro : String read fVl_Parametro write fVl_Parametro;
    property Tp_Privilegio : Real read fTp_Privilegio write fTp_Privilegio;
    property In_Parametro : String read fIn_Parametro write fIn_Parametro;
  end;

  TDic_ParamList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Param;
    procedure SetItem(Index: Integer; Value: TDic_Param);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Param;
    property Items[Index: Integer]: TDic_Param read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Param }

constructor TDic_Param.Create;
begin

end;

destructor TDic_Param.Destroy;
begin

  inherited;
end;

{ TDic_ParamList }

constructor TDic_ParamList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Param);
end;

function TDic_ParamList.Add: TDic_Param;
begin
  Result := TDic_Param(inherited Add);
  Result.create;
end;

function TDic_ParamList.GetItem(Index: Integer): TDic_Param;
begin
  Result := TDic_Param(inherited GetItem(Index));
end;

procedure TDic_ParamList.SetItem(Index: Integer; Value: TDic_Param);
begin
  inherited SetItem(Index, Value);
end;

end.