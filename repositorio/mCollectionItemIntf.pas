unit mCollectionItemIntf;

interface

uses
  Classes, SysUtils;

type
  ICollectionItemIntf = interface
    ['{EB71A4CE-7D72-4ACB-A4EF-B03D15A81549}']

    procedure Limpar();
    function Listar(AFiltros : TList) : TList;
    function Consultar(AFiltros : TList) : TObject;
    procedure Incluir();
    procedure Alterar();
    procedure Salvar();
    procedure Excluir();
  end;

implementation

end.