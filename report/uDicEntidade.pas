unit uDicEntidade;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Entidade = class;
  TDic_EntidadeClass = class of TDic_Entidade;

  TDic_EntidadeList = class;
  TDic_EntidadeListClass = class of TDic_EntidadeList;

  TDic_Entidade = class(TmCollectionItem)
  private
    fCd_Entidade: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Entidade: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Entidade : String read fCd_Entidade write fCd_Entidade;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Entidade : String read fDs_Entidade write fDs_Entidade;
  end;

  TDic_EntidadeList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Entidade;
    procedure SetItem(Index: Integer; Value: TDic_Entidade);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Entidade;
    property Items[Index: Integer]: TDic_Entidade read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Entidade }

constructor TDic_Entidade.Create;
begin

end;

destructor TDic_Entidade.Destroy;
begin

  inherited;
end;

{ TDic_EntidadeList }

constructor TDic_EntidadeList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Entidade);
end;

function TDic_EntidadeList.Add: TDic_Entidade;
begin
  Result := TDic_Entidade(inherited Add);
  Result.create;
end;

function TDic_EntidadeList.GetItem(Index: Integer): TDic_Entidade;
begin
  Result := TDic_Entidade(inherited GetItem(Index));
end;

procedure TDic_EntidadeList.SetItem(Index: Integer; Value: TDic_Entidade);
begin
  inherited SetItem(Index, Value);
end;

end.