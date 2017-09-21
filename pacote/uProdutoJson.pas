unit uProdutoJson;

(* ProdutoJson *)

interface

uses
  Classes, SysUtils, StrUtils;

type
  TProdutoJson = class(TComponent)
  private
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
  end;

  function Instance : TProdutoJson;
  procedure Destroy;

implementation

var
  _instance : TProdutoJson;

  function Instance : TProdutoJson;
  begin
    if not Assigned(_instance) then
      _instance := TProdutoJson.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

(* ProdutoJson *)

constructor TProdutoJson.Create(AOwner : TComponent);
begin
  inherited;

end;

destructor TProdutoJson.Destroy;
begin

  inherited;
end;

initialization
  //Instance();

finalization
  Destroy();

end.