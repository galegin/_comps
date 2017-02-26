unit mException;

interface

uses
  Classes, SysUtils;

type
  TmException = class(Exception)
  private
    fMetodo : String;
  public
    constructor Create(AMensagem, AMetodo : String);
  published
    property Metodo : String read fMetodo;
  end;

implementation

uses
  mLogger;

{ TmException }

constructor TmException.Create(AMensagem, AMetodo : String);
begin
  Message := AMensagem;
  fMetodo := AMetodo;
  mLogger.Instance.Erro(AMensagem, AMetodo);
end;

end.
