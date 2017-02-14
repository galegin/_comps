unit uDicCampo;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem,
  uDicCampovl;

type
  TDic_Campo = class;
  TDic_CampoClass = class of TDic_Campo;

  TDic_CampoList = class;
  TDic_CampoListClass = class of TDic_CampoList;

  TDic_Campo = class(TmCollectionItem)
  private
    fCd_Campo: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Campo: String;
    fTp_Campo: String;
    fCd_Entidade: String;
    fCd_Value: String;
    fDs_Value: String;
    fTp_Filtro: String;
	
	fList_Campovl : TDic_CampovlList;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Campo : String read fCd_Campo write fCd_Campo;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Campo : String read fDs_Campo write fDs_Campo;
    property Tp_Campo : String read fTp_Campo write fTp_Campo;
    property Cd_Entidade : String read fCd_Entidade write fCd_Entidade;
    property Cd_Value : String read fCd_Value write fCd_Value;
    property Ds_Value : String read fDs_Value write fDs_Value;
    property Tp_Filtro : String read fTp_Filtro write fTp_Filtro;
	
	property List_Campovl : TDic_CampovlList read fList_Campovl write fList_Campovl;
  end;

  TDic_CampoList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Campo;
    procedure SetItem(Index: Integer; Value: TDic_Campo);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Campo;
    property Items[Index: Integer]: TDic_Campo read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Campo }

constructor TDic_Campo.Create;
begin
  fList_Campovl := TDic_CampovlList.Create(Self);
end;

destructor TDic_Campo.Destroy;
begin
  inherited;
end;

{ TDic_CampoList }

constructor TDic_CampoList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Campo);
end;

function TDic_CampoList.Add: TDic_Campo;
begin
  Result := TDic_Campo(inherited Add);
  Result.create;
end;

function TDic_CampoList.GetItem(Index: Integer): TDic_Campo;
begin
  Result := TDic_Campo(inherited GetItem(Index));
end;

procedure TDic_CampoList.SetItem(Index: Integer; Value: TDic_Campo);
begin
  inherited SetItem(Index, Value);
end;

end.