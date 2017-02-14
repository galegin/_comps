unit uDicModbloqc;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem,
  uDicModbloqi, uDicModbloqx;

type
  TDic_Modbloqc = class;
  TDic_ModbloqcClass = class of TDic_Modbloqc;

  TDic_ModbloqcList = class;
  TDic_ModbloqcListClass = class of TDic_ModbloqcList;

  TDic_Modbloqc = class(TmCollectionItem)
  private
    fCd_Modbloq: Real;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fDs_Modbloq: String;
    fTp_Modbloq: String;
    fNr_Banco: Real;
    fNr_Ctapes: Real;
    fCd_Empresacad: Real;
    fIn_Padrao: String;
	
    fList_Modbloqi : TDic_Modbloqi;
    fList_Modbloqx : TDic_Modbloqx;	
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Modbloq : Real read fCd_Modbloq write fCd_Modbloq;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Modbloq : String read fDs_Modbloq write fDs_Modbloq;
    property Tp_Modbloq : String read fTp_Modbloq write fTp_Modbloq;
    property Nr_Banco : Real read fNr_Banco write fNr_Banco;
    property Nr_Ctapes : Real read fNr_Ctapes write fNr_Ctapes;
    property Cd_Empresacad : Real read fCd_Empresacad write fCd_Empresacad;
    property In_Padrao : String read fIn_Padrao write fIn_Padrao;
    
    property List_Modbloqi : TDic_Modbloqi read fList_Modbloqi write fList_Modbloqi;
    property List_Modbloqx : TDic_Modbloqx read fList_Modbloqx write fList_Modbloqx;
  end;

  TDic_ModbloqcList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Modbloqc;
    procedure SetItem(Index: Integer; Value: TDic_Modbloqc);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Modbloqc;
    property Items[Index: Integer]: TDic_Modbloqc read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Modbloqc }

constructor TDic_Modbloqc.Create;
begin
  List_Modbloqi := TDic_Modbloqi.Create(Self);
  List_Modbloqx := TDic_Modbloqx.Create(Self);
end;

destructor TDic_Modbloqc.Destroy;
begin
  inherited;
end;

{ TDic_ModbloqcList }

constructor TDic_ModbloqcList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Modbloqc);
end;

function TDic_ModbloqcList.Add: TDic_Modbloqc;
begin
  Result := TDic_Modbloqc(inherited Add);
  Result.create;
end;

function TDic_ModbloqcList.GetItem(Index: Integer): TDic_Modbloqc;
begin
  Result := TDic_Modbloqc(inherited GetItem(Index));
end;

procedure TDic_ModbloqcList.SetItem(Index: Integer; Value: TDic_Modbloqc);
begin
  inherited SetItem(Index, Value);
end;

end.