unit mCollectionCreate;

(* classe servico *)

interface

uses
  Classes, SysUtils, StrUtils,
  mContexto, mCollectionMap, mModulo, mConexao, mDatabase, mCreateEnt, mString;

type
  TmCollectionCreate = class(TComponent)
  private
    fContexto : TmContexto;
    fClasse : TmCollectionMapClass;
    fObjeto : TmCollectionMap;
  protected
  public
    constructor Create(AOwner : TComponent); override;

    procedure CreateOrAlter(
      AContexto : TmContexto;
      AClasse : TmCollectionMapClass);

    procedure AlterEntidade();
    procedure CreateEntidade();
    procedure CreateForeignKey();

    function EntidadeExiste() : Boolean;
  published
  end;

  function Instance : TmCollectionCreate;

implementation

uses
  mLogger;

var
  _instance : TmCollectionCreate;

  function Instance : TmCollectionCreate;
  begin
    if not Assigned(_instance) then
      _instance := TmCollectionCreate.Create(nil);
    Result := _instance;
  end;

{ TmCollectionCreate }

constructor TmCollectionCreate.Create(AOwner : TComponent);
begin
  inherited;
end;

procedure TmCollectionCreate.CreateOrAlter;
begin
  fContexto := AContexto;
  fClasse := AClasse;
  fObjeto := AClasse.Create(nil);

  if EntidadeExiste() then
    AlterEntidade()
  else
    CreateEntidade();

  CreateForeignKey();
end;

function TmCollectionCreate.EntidadeExiste;
begin
  Result := fContexto.Conexao.Database.TableExiste(fObjeto.Table);
end;

procedure TmCollectionCreate.AlterEntidade;
var
  vLstAlter : TmStringList;
  I : Integer;
begin
  vLstAlter := mCreateEnt.Instance.GetAlter(fContexto, fClasse);
  for I := 0 to vLstAlter.Count - 1 do
    fContexto.Conexao.ExecComando(vLstAlter.Items[I]);
end;

procedure TmCollectionCreate.CreateEntidade;
var
  vCmd : String;
begin
  vCmd := mCreateEnt.Instance.GetCreate(fContexto, fClasse);
  fContexto.Conexao.ExecComando(vCmd);
end;

procedure TmCollectionCreate.CreateForeignKey;
var
  vLstForeignKey : TmStringList;
  I : Integer;
begin
  vLstForeignKey := mCreateEnt.Instance.GetForeignKey(fContexto, fClasse);
  for I := 0 to vLstForeignKey.Count - 1 do
    fContexto.Conexao.ExecComando(vLstForeignKey.Items[I]);
end;

end.