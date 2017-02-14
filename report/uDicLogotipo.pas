unit uDicLogotipo;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem,
  uDicRel;

type
  TDic_Logotipo = class;
  TDic_LogotipoClass = class of TDic_Logotipo;

  TDic_LogotipoList = class;
  TDic_LogotipoListClass = class of TDic_LogotipoList;

  TDic_Logotipo = class(TmCollectionItem)
  private
    fCd_Empresa: Real;
    fCd_Relatorio: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Logotipo: Boolean;
	
	fObj_Relatorio : TDic_Rel;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Empresa : Real read fCd_Empresa write fCd_Empresa;
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Logotipo : Boolean read fDs_Logotipo write fDs_Logotipo;
	
	property Obj_Relatorio : TDic_Rel read fObj_Relatorio write fObj_Relatorio;
  end;

  TDic_LogotipoList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Logotipo;
    procedure SetItem(Index: Integer; Value: TDic_Logotipo);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Logotipo;
    property Items[Index: Integer]: TDic_Logotipo read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Logotipo }

constructor TDic_Logotipo.Create;
begin
  fObj_Relatorio : TDic_Rel.Create(Self);
end;

destructor TDic_Logotipo.Destroy;
begin
  inherited;
end;

{ TDic_LogotipoList }

constructor TDic_LogotipoList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Logotipo);
end;

function TDic_LogotipoList.Add: TDic_Logotipo;
begin
  Result := TDic_Logotipo(inherited Add);
  Result.create;
end;

function TDic_LogotipoList.GetItem(Index: Integer): TDic_Logotipo;
begin
  Result := TDic_Logotipo(inherited GetItem(Index));
end;

procedure TDic_LogotipoList.SetItem(Index: Integer; Value: TDic_Logotipo);
begin
  inherited SetItem(Index, Value);
end;

end.