unit uDicProcexec;

interface

uses
  Classes, SysUtils,
  mCollection, mCollectionItem;

type
  TDic_Procexec = class;
  TDic_ProcexecClass = class of TDic_Procexec;

  TDic_ProcexecList = class;
  TDic_ProcexecListClass = class of TDic_ProcexecList;

  TDic_Procexec = class(TmCollectionItem)
  private
    fCd_Projeto: String;
    fNr_Seqproc: Real;
    fU_Version: String;
    fCd_Operador: Real;
    fDt_Cadastro: TDateTime;
    fDs_Procexec: String;
    fDs_Procparam: String;
    fDt_Execucao: TDateTime;
    fIn_Inativo: String;
    fTp_Execucao: String;
    fNr_Execucao: Real;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Cd_Projeto : String read fCd_Projeto write fCd_Projeto;
    property Nr_Seqproc : Real read fNr_Seqproc write fNr_Seqproc;
    property U_Version : String read fU_Version write fU_Version;
    property Cd_Operador : Real read fCd_Operador write fCd_Operador;
    property Dt_Cadastro : TDateTime read fDt_Cadastro write fDt_Cadastro;
    property Ds_Procexec : String read fDs_Procexec write fDs_Procexec;
    property Ds_Procparam : String read fDs_Procparam write fDs_Procparam;
    property Dt_Execucao : TDateTime read fDt_Execucao write fDt_Execucao;
    property In_Inativo : String read fIn_Inativo write fIn_Inativo;
    property Tp_Execucao : String read fTp_Execucao write fTp_Execucao;
    property Nr_Execucao : Real read fNr_Execucao write fNr_Execucao;
  end;

  TDic_ProcexecList = class(TmCollection)
  private
    function GetItem(Index: Integer): TDic_Procexec;
    procedure SetItem(Index: Integer; Value: TDic_Procexec);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDic_Procexec;
    property Items[Index: Integer]: TDic_Procexec read GetItem write SetItem; default;
  end;
  
implementation

{ TDic_Procexec }

constructor TDic_Procexec.Create;
begin

end;

destructor TDic_Procexec.Destroy;
begin

  inherited;
end;

{ TDic_ProcexecList }

constructor TDic_ProcexecList.Create(AOwner: TPersistent);
begin
  inherited Create(TDic_Procexec);
end;

function TDic_ProcexecList.Add: TDic_Procexec;
begin
  Result := TDic_Procexec(inherited Add);
  Result.create;
end;

function TDic_ProcexecList.GetItem(Index: Integer): TDic_Procexec;
begin
  Result := TDic_Procexec(inherited GetItem(Index));
end;

procedure TDic_ProcexecList.SetItem(Index: Integer; Value: TDic_Procexec);
begin
  inherited SetItem(Index, Value);
end;

end.