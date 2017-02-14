unit mContexto;

(* contexto *)

interface

uses
  Classes, SysUtils, StrUtils,
  mCollectionMap, mCollectionSet, mConexao;

type
  TmContexto = class(TComponent)
  private
    fConexao : TmConexao;
    fEntidades : TmCollectionMapClassArray;
  protected
  public
    constructor Create(AOwner : TComponent); override;

    procedure ClearEntidade();
    procedure AddEntidade(AEntidade : TmCollectionMapClass);

    function DbSet(
      AClasse : TCollectionItemClass) : TmCollectionSet;

    procedure AddOrUpdateItem(
      ACollectionItem : TCollectionItem);

    procedure AddOrUpdate(
      ACollection : TCollection);

    procedure RemoveItem(
      ACollectionItem : TCollectionItem);

    procedure Remove(
      ACollection : TCollection);

    procedure SaveChanges();

  published
    property Conexao : TmConexao read fConexao write fConexao;
    property Entidades : TmCollectionMapClassArray read fEntidades;
  end;

implementation

uses
  mCollection, mCollectionItem, mModulo;

constructor TmContexto.Create(AOwner : TComponent);
begin
  inherited;
  fConexao := mModulo.Instance.Conexao;
end;

//--

procedure TmContexto.ClearEntidade;
begin
  SetLength(fEntidades, 0);
end;

procedure TmContexto.AddEntidade;
begin
  SetLength(fEntidades, Length(fEntidades) + 1);
  fEntidades[High(fEntidades)] := AEntidade;
end;

//--

function TmContexto.DbSet;
begin
  Result := TmCollectionSet.Create(Self, AClasse);
end;

//--

procedure TmContexto.AddOrUpdateItem;
begin
  if ACollectionItem is TmCollectionItem then
    with ACollectionItem as TmCollectionItem do
      Salvar();
end;

procedure TmContexto.AddOrUpdate;
var
  I : Integer;
begin
  with ACollection do
    for I := 0 to Count - 1 do
      AddOrUpdateItem(Items[I]);
end;

//--

procedure TmContexto.RemoveItem;
begin
  if ACollectionItem is TmCollectionItem then
    with ACollectionItem as TmCollectionItem do begin
      Excluir();
      Limpar();
    end;
end;

procedure TmContexto.Remove;
var
  I : Integer;
begin
  with ACollection do
    for I := 0 to Count - 1 do
      RemoveItem(Items[I]);
end;

//--

procedure TmContexto.SaveChanges;
begin

end;

//--

end.