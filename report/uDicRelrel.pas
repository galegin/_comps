unit uDicRelrel;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relrel = class;
  TDic_RelrelClass = class of TDic_Relrel;

  TDic_RelrelList = class;
  TDic_RelrelListClass = class of TDic_RelrelList;

  TDic_Relrel = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fNr_Seqrel: Real;
    fCd_Relacao: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fCd_Entidadepai: String;
    fCd_Campopai: String;
    fCd_Entidadefil: String;
    fCd_Campofil: String;
    fIn_Outerjoin: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Nr_Seqrel : Real read fNr_Seqrel write fNr_Seqrel;
    property Cd_Relacao : String read fCd_Relacao write fCd_Relacao;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Entidadepai : String read fCd_Entidadepai write fCd_Entidadepai;
    property Cd_Campopai : String read fCd_Campopai write fCd_Campopai;
    property Cd_Entidadefil : String read fCd_Entidadefil write fCd_Entidadefil;
    property Cd_Campofil : String read fCd_Campofil write fCd_Campofil;
    property In_Outerjoin : String read fIn_Outerjoin write fIn_Outerjoin;
  end;

  TDic_RelrelList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relrel;
    procedure SetItem(Index: Integer; Value: TDic_Relrel);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relrel;
    property Items[Index: Integer]: TDic_Relrel read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relrel }

constructor TDic_Relrel.Create;
begin

end;

destructor TDic_Relrel.Destroy;
begin

  inherited;
end;

{ TDic_RelrelList }

constructor TDic_RelrelList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relrel);
end;

function TDic_RelrelList.Add: TDic_Relrel;
begin
  Result := TDic_Relrel(inherited Add);
  Result.create;
end;

function TDic_RelrelList.GetItem(Index: Integer): TDic_Relrel;
begin
  Result := TDic_Relrel(inherited GetItem(Index));
end;

procedure TDic_RelrelList.SetItem(Index: Integer; Value: TDic_Relrel);
begin
  inherited SetItem(Index, Value);
end;

end.