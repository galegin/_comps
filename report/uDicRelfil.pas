unit uDicRelfil;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Relfil = class;
  TDic_RelfilClass = class of TDic_Relfil;

  TDic_RelfilList = class;
  TDic_RelfilListClass = class of TDic_RelfilList;

  TDic_Relfil = class(TmCollectionItem)
  private
    fCd_Relatorio: String;
    fCd_Usuario: Real;
    fCd_Campo: String;
    fNr_Seqfiltro: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fCd_Valueini: String;
    fCd_Valuefin: String;
    fCd_Valuedes: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Relatorio : String read fCd_Relatorio write fCd_Relatorio;
    property Cd_Usuario : Real read fCd_Usuario write fCd_Usuario;
    property Cd_Campo : String read fCd_Campo write fCd_Campo;
    property Nr_Seqfiltro : Real read fNr_Seqfiltro write fNr_Seqfiltro;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Cd_Valueini : String read fCd_Valueini write fCd_Valueini;
    property Cd_Valuefin : String read fCd_Valuefin write fCd_Valuefin;
    property Cd_Valuedes : String read fCd_Valuedes write fCd_Valuedes;
  end;

  TDic_RelfilList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Relfil;
    procedure SetItem(Index: Integer; Value: TDic_Relfil);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Relfil;
    property Items[Index: Integer]: TDic_Relfil read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Relfil }

constructor TDic_Relfil.Create;
begin

end;

destructor TDic_Relfil.Destroy;
begin

  inherited;
end;

{ TDic_RelfilList }

constructor TDic_RelfilList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Relfil);
end;

function TDic_RelfilList.Add: TDic_Relfil;
begin
  Result := TDic_Relfil(inherited Add);
  Result.create;
end;

function TDic_RelfilList.GetItem(Index: Integer): TDic_Relfil;
begin
  Result := TDic_Relfil(inherited GetItem(Index));
end;

procedure TDic_RelfilList.SetItem(Index: Integer; Value: TDic_Relfil);
begin
  inherited SetItem(Index, Value);
end;

end.