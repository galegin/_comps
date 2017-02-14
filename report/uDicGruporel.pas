unit uDicGruporel;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Gruporel = class;
  TDic_GruporelClass = class of TDic_Gruporel;

  TDic_GruporelList = class;
  TDic_GruporelListClass = class of TDic_GruporelList;

  TDic_Gruporel = class(TmCollectionItem)
  private
    fCd_Gruporel: String;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fCd_Grupopai: String;
    fDs_Gruporel: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Gruporel : String read fCd_Gruporel write fCd_Gruporel;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Grupopai : String read fCd_Grupopai write fCd_Grupopai;
    property Ds_Gruporel : String read fDs_Gruporel write fDs_Gruporel;
  end;

  TDic_GruporelList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Gruporel;
    procedure SetItem(Index: Integer; Value: TDic_Gruporel);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Gruporel;
    property Items[Index: Integer]: TDic_Gruporel read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Gruporel }

constructor TDic_Gruporel.Create;
begin

end;

destructor TDic_Gruporel.Destroy;
begin

  inherited;
end;

{ TDic_GruporelList }

constructor TDic_GruporelList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Gruporel);
end;

function TDic_GruporelList.Add: TDic_Gruporel;
begin
  Result := TDic_Gruporel(inherited Add);
  Result.create;
end;

function TDic_GruporelList.GetItem(Index: Integer): TDic_Gruporel;
begin
  Result := TDic_Gruporel(inherited GetItem(Index));
end;

procedure TDic_GruporelList.SetItem(Index: Integer; Value: TDic_Gruporel);
begin
  inherited SetItem(Index, Value);
end;

end.