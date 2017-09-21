unit uPessoaJson;

(* PessoaJson *)

interface

uses
  Classes, SysUtils, StrUtils;

type
  TPessoaJson = class(TComponent)
  private
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
  end;

  function Instance : TPessoaJson;
  procedure Destroy;

implementation

var
  _instance : TPessoaJson;

  function Instance : TPessoaJson;
  begin
    if not Assigned(_instance) then
      _instance := TPessoaJson.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

(* PessoaJson *)

constructor TPessoaJson.Create(AOwner : TComponent);
begin
  inherited;

end;

destructor TPessoaJson.Destroy;
begin

  inherited;
end;

initialization
  //Instance();

finalization
  Destroy();

end.