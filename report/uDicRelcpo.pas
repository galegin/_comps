unit uDicRelcpo;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relcpo = class;
  TDic_RelcpoClass = class of TDic_Relcpo;

  TDic_RelcpoList = class;
  TDic_RelcpoListClass = class of TDic_RelcpoList;

  TDic_Relcpo = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fNr_Seqcampo: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fCd_Entidade: String;
    fCd_Campo: String;
    fIn_Visible: String;
    fIn_Group: String;
    fDs_Where: String;
    fDs_Sort: String;
    fDs_Funct: String;
    fTp_Inclusao: String;
    fDs_Formato: String;
    fDs_Siglaent: String;
    fCd_Apelido: String;
    fDs_Formula: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property Nr_Seqcampo : Real read fNr_Seqcampo write fNr_Seqcampo;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Entidade : String read fCd_Entidade write fCd_Entidade;
    property Cd_Campo : String read fCd_Campo write fCd_Campo;
    property In_Visible : String read fIn_Visible write fIn_Visible;
    property In_Group : String read fIn_Group write fIn_Group;
    property Ds_Where : String read fDs_Where write fDs_Where;
    property Ds_Sort : String read fDs_Sort write fDs_Sort;
    property Ds_Funct : String read fDs_Funct write fDs_Funct;
    property Tp_Inclusao : String read fTp_Inclusao write fTp_Inclusao;
    property Ds_Formato : String read fDs_Formato write fDs_Formato;
    property Ds_Siglaent : String read fDs_Siglaent write fDs_Siglaent;
    property Cd_Apelido : String read fCd_Apelido write fCd_Apelido;
    property Ds_Formula : String read fDs_Formula write fDs_Formula;
  end;

  TDic_RelcpoList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relcpo;
    procedure SetItem(Index: Integer; Value: TDic_Relcpo);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relcpo;
    property Items[Index: Integer]: TDic_Relcpo read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relcpo }

constructor TDic_Relcpo.Create;
begin

end;

destructor TDic_Relcpo.Destroy;
begin

  inherited;
end;

{ TDic_RelcpoList }

constructor TDic_RelcpoList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relcpo);
end;

function TDic_RelcpoList.Add: TDic_Relcpo;
begin
  Result := TDic_Relcpo(inherited Add);
  Result.create;
end;

function TDic_RelcpoList.GetItem(Index: Integer): TDic_Relcpo;
begin
  Result := TDic_Relcpo(inherited GetItem(Index));
end;

procedure TDic_RelcpoList.SetItem(Index: Integer; Value: TDic_Relcpo);
begin
  inherited SetItem(Index, Value);
end;

end.