unit uDicConteudo;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Conteudo = class;
  TDic_ConteudoClass = class of TDic_Conteudo;

  TDic_ConteudoList = class;
  TDic_ConteudoListClass = class of TDic_ConteudoList;

  TDic_Conteudo = class(TmCollectionItem)
  private
    fCd_Empresa: Real;
    fCd_Usuario: Real;
    fTp_Conteudo: Real;
    fNr_Linha: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Linha: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Empresa : Real read fCd_Empresa write fCd_Empresa;
    property Cd_Usuario : Real read fCd_Usuario write fCd_Usuario;
    property Tp_Conteudo : Real read fTp_Conteudo write fTp_Conteudo;
    property Nr_Linha : Real read fNr_Linha write fNr_Linha;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Linha : String read fDs_Linha write fDs_Linha;
  end;

  TDic_ConteudoList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Conteudo;
    procedure SetItem(Index: Integer; Value: TDic_Conteudo);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Conteudo;
    property Items[Index: Integer]: TDic_Conteudo read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Conteudo }

constructor TDic_Conteudo.Create;
begin

end;

destructor TDic_Conteudo.Destroy;
begin

  inherited;
end;

{ TDic_ConteudoList }

constructor TDic_ConteudoList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Conteudo);
end;

function TDic_ConteudoList.Add: TDic_Conteudo;
begin
  Result := TDic_Conteudo(inherited Add);
  Result.create;
end;

function TDic_ConteudoList.GetItem(Index: Integer): TDic_Conteudo;
begin
  Result := TDic_Conteudo(inherited GetItem(Index));
end;

procedure TDic_ConteudoList.SetItem(Index: Integer; Value: TDic_Conteudo);
begin
  inherited SetItem(Index, Value);
end;

end.