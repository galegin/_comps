unit uDicUsudef;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Usudef = class;
  TDic_UsudefClass = class of TDic_Usudef;

  TDic_UsudefList = class;
  TDic_UsudefListClass = class of TDic_UsudefList;

  TDic_Usudef = class(TmCollectionItem)
  private
    fCd_Usuario: Real;
    fCd_Definicao: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fVl_Definicao: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Usuario : Real read fCd_Usuario write fCd_Usuario;
    property Cd_Definicao : String read fCd_Definicao write fCd_Definicao;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Vl_Definicao : String read fVl_Definicao write fVl_Definicao;
  end;

  TDic_UsudefList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Usudef;
    procedure SetItem(Index: Integer; Value: TDic_Usudef);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Usudef;
    property Items[Index: Integer]: TDic_Usudef read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Usudef }

constructor TDic_Usudef.Create;
begin

end;

destructor TDic_Usudef.Destroy;
begin

  inherited;
end;

{ TDic_UsudefList }

constructor TDic_UsudefList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Usudef);
end;

function TDic_UsudefList.Add: TDic_Usudef;
begin
  Result := TDic_Usudef(inherited Add);
  Result.create;
end;

function TDic_UsudefList.GetItem(Index: Integer): TDic_Usudef;
begin
  Result := TDic_Usudef(inherited GetItem(Index));
end;

procedure TDic_UsudefList.SetItem(Index: Integer; Value: TDic_Usudef);
begin
  inherited SetItem(Index, Value);
end;

end.