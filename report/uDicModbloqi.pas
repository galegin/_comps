unit uDicModbloqi;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Modbloqi = class;
  TDic_ModbloqiClass = class of TDic_Modbloqi;

  TDic_ModbloqiList = class;
  TDic_ModbloqiListClass = class of TDic_ModbloqiList;

  TDic_Modbloqi = class(TmCollectionItem)
  private
    fCd_Modbloq: Real;
    fTp_Viabol: Real;
    fNr_Seqmod: Real;
    fU_Version: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fCd_Campo: String;
    fDs_Campo: String;
    fTp_Campo: Real;
    fTp_Field: String;
    fNr_Tamanho: Real;
    fNr_Decimal: Real;
    fTp_Alin: String;
    fCd_Estilo: String;
    fNr_Linha: Real;
    fNr_Coluna: Real;
    fNr_Altura: Real;
    fNr_Largura: Real;
    fCd_Tag: String;
    fCd_Fmt: String;
    fIn_Bold: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Modbloq : Real read fCd_Modbloq write fCd_Modbloq;
    property Tp_Viabol : Real read fTp_Viabol write fTp_Viabol;
    property Nr_Seqmod : Real read fNr_Seqmod write fNr_Seqmod;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Campo : String read fCd_Campo write fCd_Campo;
    property Ds_Campo : String read fDs_Campo write fDs_Campo;
    property Tp_Campo : Real read fTp_Campo write fTp_Campo;
    property Tp_Field : String read fTp_Field write fTp_Field;
    property Nr_Tamanho : Real read fNr_Tamanho write fNr_Tamanho;
    property Nr_Decimal : Real read fNr_Decimal write fNr_Decimal;
    property Tp_Alin : String read fTp_Alin write fTp_Alin;
    property Cd_Estilo : String read fCd_Estilo write fCd_Estilo;
    property Nr_Linha : Real read fNr_Linha write fNr_Linha;
    property Nr_Coluna : Real read fNr_Coluna write fNr_Coluna;
    property Nr_Altura : Real read fNr_Altura write fNr_Altura;
    property Nr_Largura : Real read fNr_Largura write fNr_Largura;
    property Cd_Tag : String read fCd_Tag write fCd_Tag;
    property Cd_Fmt : String read fCd_Fmt write fCd_Fmt;
    property In_Bold : String read fIn_Bold write fIn_Bold;
  end;

  TDic_ModbloqiList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Modbloqi;
    procedure SetItem(Index: Integer; Value: TDic_Modbloqi);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Modbloqi;
    property Items[Index: Integer]: TDic_Modbloqi read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Modbloqi }

constructor TDic_Modbloqi.Create;
begin

end;

destructor TDic_Modbloqi.Destroy;
begin

  inherited;
end;

{ TDic_ModbloqiList }

constructor TDic_ModbloqiList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Modbloqi);
end;

function TDic_ModbloqiList.Add: TDic_Modbloqi;
begin
  Result := TDic_Modbloqi(inherited Add);
  Result.create;
end;

function TDic_ModbloqiList.GetItem(Index: Integer): TDic_Modbloqi;
begin
  Result := TDic_Modbloqi(inherited GetItem(Index));
end;

procedure TDic_ModbloqiList.SetItem(Index: Integer; Value: TDic_Modbloqi);
begin
  inherited SetItem(Index, Value);
end;

end.