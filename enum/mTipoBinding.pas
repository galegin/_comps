unit mTipoBinding;

interface

uses
  Classes, mTipoFormato;

type
  RTipoBinding = record
    Entidade : TCollectionItem;
    Campo : String;
    Formato : RTipoFormato;
  end;

implementation

end.
