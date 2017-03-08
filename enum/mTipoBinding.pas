unit mTipoBinding;

interface

uses
  Classes, mTipoFormato;

type
  RTipoBinding = record
    Entidade : TCollection;
    Campo : String;
    Formato : RTipoFormato;
  end;

implementation

end.
