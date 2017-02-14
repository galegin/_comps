unit mSequence;

interface

uses
  Classes, SysUtils, StrUtils;

type
  TcSequence = class(TComponent)
  private
  protected
  public
    constructor Create(AOwner : TComponent); override;

    function GetSequencia(
      ANomeEntidade : String;
      ANomeAtributo : String = '';
      ADataMovimento : TDateTime = 0;
      AGrupoMovimento : Integer = 0;
      AValorConteudo : String = '') : Integer;

  published
  end;

  function Instance : TcSequence;

implementation

uses
  mModulo;

var
  _instance : TcSequence;

  function Instance : TcSequence;
  begin
    if not Assigned(_instance) then
      _instance := TcSequence.Create(nil);
    Result := _instance;
  end;

constructor TcSequence.Create(AOwner : TComponent);
begin
  inherited;
end;

function TcSequence.GetSequencia;
var
  vNome : String;
begin
  vNome := '';
  if ANomeEntidade <> '' then
    vNome := vNome + IfThen(vNome <> '', '_', '') + ANomeEntidade;
  if ANomeAtributo <> '' then
    vNome := vNome + IfThen(vNome <> '', '_', '') + ANomeAtributo;
  if ADataMovimento > 0 then
    vNome := vNome + IfThen(vNome <> '', '_', '') + FormatDateTime('ymmdd', ADataMovimento);
  if AGrupoMovimento > 0 then
    vNome := vNome + IfThen(vNome <> '', '_', '') + IntToStr(AGrupoMovimento);
  if AValorConteudo <> '' then
    vNome := vNome + IfThen(vNome <> '', '_', '') + AValorConteudo;

  Result := mModulo.Instance.Conexao.Database.GetSequence(vNome);
end;

end.