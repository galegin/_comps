unit uDicUsuper;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Usuper = class;
  TDic_UsuperClass = class of TDic_Usuper;

  TDic_UsuperList = class;
  TDic_UsuperListClass = class of TDic_UsuperList;

  TDic_Usuper = class(TmCollectionItem)
  private
    fCd_Usuario: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fTp_Privilegio: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Usuario : String read fCd_Usuario write fCd_Usuario;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Tp_Privilegio : String read fTp_Privilegio write fTp_Privilegio;
  end;

  TDic_UsuperList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Usuper;
    procedure SetItem(Index: Integer; Value: TDic_Usuper);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Usuper;
    property Items[Index: Integer]: TDic_Usuper read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Usuper }

constructor TDic_Usuper.Create;
begin

end;

destructor TDic_Usuper.Destroy;
begin

  inherited;
end;

{ TDic_UsuperList }

constructor TDic_UsuperList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Usuper);
end;

function TDic_UsuperList.Add: TDic_Usuper;
begin
  Result := TDic_Usuper(inherited Add);
  Result.create;
end;

function TDic_UsuperList.GetItem(Index: Integer): TDic_Usuper;
begin
  Result := TDic_Usuper(inherited GetItem(Index));
end;

procedure TDic_UsuperList.SetItem(Index: Integer; Value: TDic_Usuper);
begin
  inherited SetItem(Index, Value);
end;

end.