unit uDicCampovl;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Campovl = class;
  TDic_CampovlClass = class of TDic_Campovl;

  TDic_CampovlList = class;
  TDic_CampovlListClass = class of TDic_CampovlList;

  TDic_Campovl = class(TmCollectionItem)
  private
    fCd_Campo: String;
    fCd_Value: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Value: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Campo : String read fCd_Campo write fCd_Campo;
    property Cd_Value : String read fCd_Value write fCd_Value;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Value : String read fDs_Value write fDs_Value;
  end;

  TDic_CampovlList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Campovl;
    procedure SetItem(Index: Integer; Value: TDic_Campovl);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Campovl;
    property Items[Index: Integer]: TDic_Campovl read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Campovl }

constructor TDic_Campovl.Create;
begin

end;

destructor TDic_Campovl.Destroy;
begin

  inherited;
end;

{ TDic_CampovlList }

constructor TDic_CampovlList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Campovl);
end;

function TDic_CampovlList.Add: TDic_Campovl;
begin
  Result := TDic_Campovl(inherited Add);
  Result.create;
end;

function TDic_CampovlList.GetItem(Index: Integer): TDic_Campovl;
begin
  Result := TDic_Campovl(inherited GetItem(Index));
end;

procedure TDic_CampovlList.SetItem(Index: Integer; Value: TDic_Campovl);
begin
  inherited SetItem(Index, Value);
end;

end.