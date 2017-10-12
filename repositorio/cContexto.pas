unit cContexto;

(* cContexto *)

interface

uses
  Classes, SysUtils, StrUtils, DB, TypInfo, Math, Contnrs,
  mDatabase, mMapping, mParametro;

  // TObjectList / TList

type
  TcContexto = class(TComponent)
  private
    FParametro: TmParametro;
    FDatabase: TmDatabase;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    function GetLista(AClass : TClass; AWhere : String = '') : TObjectList;
    procedure SetLista(AList : TObjectList); overload;
    procedure RemLista(AList : TObjectList); overload;

    function GetObjeto(AClass : TClass; AWhere : String = '') : TObject;
    procedure SetObjeto(AObjeto : TObject);
    procedure RemObjeto(AObjeto : TObject);
  published
    property Parametro : TmParametro read FParametro write FParametro;
    property Database : TmDatabase read FDatabase write FDatabase;
  end;

  function Instance() : TcContexto;
  procedure Destroy();

implementation

uses
  mClasse, mComando, mObjeto, mDataSet, mValue;

var
  _instance : TcContexto;

  function Instance() : TcContexto;
  begin
    if not Assigned(_instance) then
      _instance := TcContexto.Create(nil);
    Result := _instance;
  end;

  procedure Destroy();
  begin
    if Assigned(_instance) then
      _instance.Free;
  end;

(* cContexto *)

constructor TcContexto.Create(AOwner : TComponent);
begin
  inherited;

  FParametro := TmParametro.Create;

  FDatabase := TmDatabase.Create(Self);
  FDatabase.Conexao.Parametro := FParametro;
end;

destructor TcContexto.Destroy;
begin

  inherited;
end;

//-- lista

function TcContexto.GetLista(AClass : TClass; AWhere : String) : TObjectList;
var
  vDataSet : TDataSet;
  vObject : TObject;
  vSql : String;
begin
  Result := TObjectList.Create;

  vSql := TmComando.GetSelect(AClass, AWhere);

  vDataSet := FDatabase.Conexao.GetConsulta(vSql);
  with vDataSet do begin
    while not EOF do begin
      vObject := TmClasse.CreateObjeto(AClass, nil);
      Result.Add(vObject);
      TmDataSet(vDataSet).ToObject(vObject);
      Next;
    end;
  end;
end;

procedure TcContexto.SetLista(AList: TObjectList);
var
  I : Integer;
begin
  for I := 0 to AList.Count - 1 do
    SetObjeto(AList[I]);
end;

procedure TcContexto.RemLista(AList: TObjectList);
var
  I : Integer;
begin
  for I := 0 to AList.Count - 1 do
    RemObjeto(AList[I]);
end;

//-- objeto

function TcContexto.GetObjeto(AClass : TClass; AWhere : String) : TObject;
var
  vLista : TList;
begin
  vLista := GetLista(AClass, AWhere);
  if Assigned(vLista) and (vLista.Count > 0) then
    Result := vLista[0]
  else
    Result := nil;
end;

procedure TcContexto.SetObjeto(AObjeto : TObject);
var
  vDataSet : TDataSet;
  vCmd, vSql : String;
begin
  vSql := TmComando(AObjeto).GetSelect();
  vDataSet := FDatabase.Conexao.GetConsulta(vSql);
  if not vDataSet.IsEmpty then
    vCmd := TmComando(AObjeto).GetUpdate()
  else
    vCmd := TmComando(AObjeto).GetInsert();
  FDatabase.Conexao.ExecComando(vCmd);
end;

procedure TcContexto.RemObjeto(AObjeto : TObject);
var
  vCmd : String;
begin
  vCmd := TmComando(AObjeto).GetDelete();
  FDatabase.Conexao.ExecComando(vCmd);
end;

//--

initialization
  //Instance();

finalization
  Destroy();

end.
