unit uDicUsulic;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Usulic = class;
  TDic_UsulicClass = class of TDic_Usulic;

  TDic_UsulicList = class;
  TDic_UsulicListClass = class of TDic_UsulicList;

  TDic_Usulic = class(TmCollectionItem)
  private
    fCd_Usuario: String;
    fDt_Login: String;
    fHr_Login: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fTp_Privilegio: String;
    fDt_Logof: String;
    fHr_Logof: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Usuario : String read fCd_Usuario write fCd_Usuario;
    property Dt_Login : String read fDt_Login write fDt_Login;
    property Hr_Login : String read fHr_Login write fHr_Login;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Tp_Privilegio : String read fTp_Privilegio write fTp_Privilegio;
    property Dt_Logof : String read fDt_Logof write fDt_Logof;
    property Hr_Logof : String read fHr_Logof write fHr_Logof;
  end;

  TDic_UsulicList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Usulic;
    procedure SetItem(Index: Integer; Value: TDic_Usulic);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Usulic;
    property Items[Index: Integer]: TDic_Usulic read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Usulic }

constructor TDic_Usulic.Create;
begin

end;

destructor TDic_Usulic.Destroy;
begin

  inherited;
end;

{ TDic_UsulicList }

constructor TDic_UsulicList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Usulic);
end;

function TDic_UsulicList.Add: TDic_Usulic;
begin
  Result := TDic_Usulic(inherited Add);
  Result.create;
end;

function TDic_UsulicList.GetItem(Index: Integer): TDic_Usulic;
begin
  Result := TDic_Usulic(inherited GetItem(Index));
end;

procedure TDic_UsulicList.SetItem(Index: Integer; Value: TDic_Usulic);
begin
  inherited SetItem(Index, Value);
end;

end.