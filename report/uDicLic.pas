unit uDicLic;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Lic = class;
  TDic_LicClass = class of TDic_Lic;

  TDic_LicList = class;
  TDic_LicListClass = class of TDic_LicList;

  TDic_Lic = class(TmCollectionItem)
  private
    fTp_Privilegio: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fQt_Lic: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Tp_Privilegio : String read fTp_Privilegio write fTp_Privilegio;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Qt_Lic : String read fQt_Lic write fQt_Lic;
  end;

  TDic_LicList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Lic;
    procedure SetItem(Index: Integer; Value: TDic_Lic);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Lic;
    property Items[Index: Integer]: TDic_Lic read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Lic }

constructor TDic_Lic.Create;
begin

end;

destructor TDic_Lic.Destroy;
begin

  inherited;
end;

{ TDic_LicList }

constructor TDic_LicList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Lic);
end;

function TDic_LicList.Add: TDic_Lic;
begin
  Result := TDic_Lic(inherited Add);
  Result.create;
end;

function TDic_LicList.GetItem(Index: Integer): TDic_Lic;
begin
  Result := TDic_Lic(inherited GetItem(Index));
end;

procedure TDic_LicList.SetItem(Index: Integer; Value: TDic_Lic);
begin
  inherited SetItem(Index, Value);
end;

end.