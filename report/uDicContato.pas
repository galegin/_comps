unit uDicContato;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Contato = class;
  TDic_ContatoClass = class of TDic_Contato;

  TDic_ContatoList = class;
  TDic_ContatoListClass = class of TDic_ContatoList;

  TDic_Contato = class(TmCollectionItem)
  private
    fCd_Empresa: Real;
    fCd_Usuario: Real;
    fTp_Contato: Real;
    fNr_Contato: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fNm_Contato: String;
    fDs_Contato: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Empresa : Real read fCd_Empresa write fCd_Empresa;
    property Cd_Usuario : Real read fCd_Usuario write fCd_Usuario;
    property Tp_Contato : Real read fTp_Contato write fTp_Contato;
    property Nr_Contato : Real read fNr_Contato write fNr_Contato;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Nm_Contato : String read fNm_Contato write fNm_Contato;
    property Ds_Contato : String read fDs_Contato write fDs_Contato;
  end;

  TDic_ContatoList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Contato;
    procedure SetItem(Index: Integer; Value: TDic_Contato);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Contato;
    property Items[Index: Integer]: TDic_Contato read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Contato }

constructor TDic_Contato.Create;
begin

end;

destructor TDic_Contato.Destroy;
begin

  inherited;
end;

{ TDic_ContatoList }

constructor TDic_ContatoList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Contato);
end;

function TDic_ContatoList.Add: TDic_Contato;
begin
  Result := TDic_Contato(inherited Add);
  Result.create;
end;

function TDic_ContatoList.GetItem(Index: Integer): TDic_Contato;
begin
  Result := TDic_Contato(inherited GetItem(Index));
end;

procedure TDic_ContatoList.SetItem(Index: Integer; Value: TDic_Contato);
begin
  inherited SetItem(Index, Value);
end;

end.