unit uDicVersao;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Versao = class;
  TDic_VersaoClass = class of TDic_Versao;

  TDic_VersaoList = class;
  TDic_VersaoListClass = class of TDic_VersaoList;

  TDic_Versao = class(TmCollectionItem)
  private
    fCd_Projeto: String;
    fCd_Operador: Integer;
    fDt_Cadastro: TDateTime;
    fDs_Versao: String;
    fU_Version: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Projeto : String read fCd_Projeto write fCd_Projeto;
    property Cd_Operador : Integer read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Versao : String read fDs_Versao write fDs_Versao;
    property U_Version : String read fU_Version write fU_Version;
  end;

  TDic_VersaoList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Versao;
    procedure SetItem(Index: Integer; Value: TDic_Versao);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Versao;
    property Items[Index: Integer]: TDic_Versao read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Versao }

constructor TDic_Versao.Create;
begin

end;

destructor TDic_Versao.Destroy;
begin

  inherited;
end;

{ TDic_VersaoList }

constructor TDic_VersaoList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Versao);
end;

function TDic_VersaoList.Add: TDic_Versao;
begin
  Result := TDic_Versao(inherited Add);
  Result.create;
end;

function TDic_VersaoList.GetItem(Index: Integer): TDic_Versao;
begin
  Result := TDic_Versao(inherited GetItem(Index));
end;

procedure TDic_VersaoList.SetItem(Index: Integer; Value: TDic_Versao);
begin
  inherited SetItem(Index, Value);
end;

end.