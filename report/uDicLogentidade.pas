unit uDicLogentidade;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Logentidade = class;
  TDic_LogentidadeClass = class of TDic_Logentidade;

  TDic_LogentidadeList = class;
  TDic_LogentidadeListClass = class of TDic_LogentidadeList;

  TDic_Logentidade = class(TmCollectionItem)
  private
    fCd_Usuario: Real;
    fDt_Logent: TDateTime;
    fNr_Seqlog: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fHr_Logent: String;
    fTp_Logent: String;
    fCd_Entidade: String;
    fCd_Chave: String;
    fCd_Campo: String;
    fDs_Valueant: String;
    fDs_Value: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Usuario : Real read fCd_Usuario write fCd_Usuario;
    property Dt_Logent : TDateTime read fDt_Logent write fDt_Logent;
    property Nr_Seqlog : Real read fNr_Seqlog write fNr_Seqlog;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Hr_Logent : String read fHr_Logent write fHr_Logent;
    property Tp_Logent : String read fTp_Logent write fTp_Logent;
    property Cd_Entidade : String read fCd_Entidade write fCd_Entidade;
    property Cd_Chave : String read fCd_Chave write fCd_Chave;
    property Cd_Campo : String read fCd_Campo write fCd_Campo;
    property Ds_Valueant : String read fDs_Valueant write fDs_Valueant;
    property Ds_Value : String read fDs_Value write fDs_Value;
  end;

  TDic_LogentidadeList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Logentidade;
    procedure SetItem(Index: Integer; Value: TDic_Logentidade);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Logentidade;
    property Items[Index: Integer]: TDic_Logentidade read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Logentidade }

constructor TDic_Logentidade.Create;
begin

end;

destructor TDic_Logentidade.Destroy;
begin

  inherited;
end;

{ TDic_LogentidadeList }

constructor TDic_LogentidadeList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Logentidade);
end;

function TDic_LogentidadeList.Add: TDic_Logentidade;
begin
  Result := TDic_Logentidade(inherited Add);
  Result.create;
end;

function TDic_LogentidadeList.GetItem(Index: Integer): TDic_Logentidade;
begin
  Result := TDic_Logentidade(inherited GetItem(Index));
end;

procedure TDic_LogentidadeList.SetItem(Index: Integer; Value: TDic_Logentidade);
begin
  inherited SetItem(Index, Value);
end;

end.