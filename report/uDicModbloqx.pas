unit uDicModbloqx;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Modbloqx = class;
  TDic_ModbloqxClass = class of TDic_Modbloqx;

  TDic_ModbloqxList = class;
  TDic_ModbloqxListClass = class of TDic_ModbloqxList;

  TDic_Modbloqx = class(TmCollectionItem)
  private
    fCd_Modbloq: Real;
    fTp_Viabol: Real;
    fNr_Seqxml: Real;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fDs_Conteudo: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Modbloq : Real read fCd_Modbloq write fCd_Modbloq;
    property Tp_Viabol : Real read fTp_Viabol write fTp_Viabol;
    property Nr_Seqxml : Real read fNr_Seqxml write fNr_Seqxml;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Conteudo : String read fDs_Conteudo write fDs_Conteudo;
  end;

  TDic_ModbloqxList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Modbloqx;
    procedure SetItem(Index: Integer; Value: TDic_Modbloqx);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Modbloqx;
    property Items[Index: Integer]: TDic_Modbloqx read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Modbloqx }

constructor TDic_Modbloqx.Create;
begin

end;

destructor TDic_Modbloqx.Destroy;
begin

  inherited;
end;

{ TDic_ModbloqxList }

constructor TDic_ModbloqxList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Modbloqx);
end;

function TDic_ModbloqxList.Add: TDic_Modbloqx;
begin
  Result := TDic_Modbloqx(inherited Add);
  Result.create;
end;

function TDic_ModbloqxList.GetItem(Index: Integer): TDic_Modbloqx;
begin
  Result := TDic_Modbloqx(inherited GetItem(Index));
end;

procedure TDic_ModbloqxList.SetItem(Index: Integer; Value: TDic_Modbloqx);
begin
  inherited SetItem(Index, Value);
end;

end.