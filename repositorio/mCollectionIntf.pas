unit mCollectionIntf;

interface

uses
  Classes, SysUtils;

type
  ICollectionIntf = interface
    ['{03D077D9-161D-4E74-A2A0-6C390B23F463}']

    procedure Limpar();
    function Listar(AFiltros : TList) : TList;
    function Consultar(AFiltros : TList) : TObject;
    procedure Incluir();
    procedure Alterar();
    procedure Excluir();
  end;

implementation

end.