unit uDicReldef;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Reldef = class;
  TDic_ReldefClass = class of TDic_Reldef;

  TDic_ReldefList = class;
  TDic_ReldefListClass = class of TDic_ReldefList;

  TDic_Reldef = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fCd_Campo: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fNr_Ordem: Real;
    fDs_Campo: String;
    fNr_Tamanho: Real;
    fNr_Decimal: Real;
    fIn_Filtro: String;
    fDs_Funct: String;
    fIn_Obrig: String;
    fDs_Sugerir: String;
    fCd_Campodef: String;
    fIn_Listar: String;
    fNr_Quebra: Real;
    fDs_Expr: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property Cd_Campo : String read fCd_Campo write fCd_Campo;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Nr_Ordem : Real read fNr_Ordem write fNr_Ordem;
    property Ds_Campo : String read fDs_Campo write fDs_Campo;
    property Nr_Tamanho : Real read fNr_Tamanho write fNr_Tamanho;
    property Nr_Decimal : Real read fNr_Decimal write fNr_Decimal;
    property In_Filtro : String read fIn_Filtro write fIn_Filtro;
    property Ds_Funct : String read fDs_Funct write fDs_Funct;
    property In_Obrig : String read fIn_Obrig write fIn_Obrig;
    property Ds_Sugerir : String read fDs_Sugerir write fDs_Sugerir;
    property Cd_Campodef : String read fCd_Campodef write fCd_Campodef;
    property In_Listar : String read fIn_Listar write fIn_Listar;
    property Nr_Quebra : Real read fNr_Quebra write fNr_Quebra;
    property Ds_Expr : String read fDs_Expr write fDs_Expr;
  end;

  TDic_ReldefList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Reldef;
    procedure SetItem(Index: Integer; Value: TDic_Reldef);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Reldef;
    property Items[Index: Integer]: TDic_Reldef read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Reldef }

constructor TDic_Reldef.Create;
begin

end;

destructor TDic_Reldef.Destroy;
begin

  inherited;
end;

{ TDic_ReldefList }

constructor TDic_ReldefList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Reldef);
end;

function TDic_ReldefList.Add: TDic_Reldef;
begin
  Result := TDic_Reldef(inherited Add);
  Result.create;
end;

function TDic_ReldefList.GetItem(Index: Integer): TDic_Reldef;
begin
  Result := TDic_Reldef(inherited GetItem(Index));
end;

procedure TDic_ReldefList.SetItem(Index: Integer; Value: TDic_Reldef);
begin
  inherited SetItem(Index, Value);
end;

end.