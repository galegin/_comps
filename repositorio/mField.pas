unit mField;

interface

uses
  Classes, SysUtils, ComCtrls, DB;

type
  TmField = class
  private
    fNome : String;
    fDescricao : String;
    fTipo : TFieldType;
    fTamanho : Integer;
    fCasasDecimais : Integer;
    fRequerido : Boolean;
    fVisible : Boolean;
  public
    constructor Create; overload;
    constructor Create(
      ANome : String; ADescricao : String;
      ATipo : TFieldType;
      ATamanho : Integer; ACasasDecimais : Integer = 0;
      ARequerido : Boolean = False; AVisible : Boolean = True); overload;
  published
    property Nome : String read fNome write fNome;
    property Descricao : String read fDescricao write fDescricao;
    property Tipo : TFieldType read fTipo write fTipo;
    property Tamanho : Integer read fTamanho write fTamanho;
    property CasasDecimais : Integer read fCasasDecimais write fCasasDecimais;
    property Requerido : Boolean read fRequerido write fRequerido;
    property Visible : Boolean read fVisible write fVisible;
  end;

  TmFieldList = class(TList)
  private
    function GetItem(Index: Integer): TmField;
    procedure SetItem(Index: Integer; const Value: TmField);
  public
    function Add : TmField; overload;
    property Items[Index : Integer] : TmField read GetItem write SetItem;
  end;

implementation

uses mListView;

{ TmField }

constructor TmField.Create;
begin
end;

constructor TmField.Create(
  ANome : String; ADescricao: String;
  ATipo : TFieldType;
  ATamanho: Integer; ACasasDecimais: Integer;
  ARequerido: Boolean; AVisible: Boolean);
begin
  fNome := ANome;
  fDescricao := ADescricao;
  fTipo := ATipo;
  fTamanho := ATamanho;
  fCasasDecimais := ACasasDecimais;
  fRequerido := ARequerido;
  fVisible := AVisible;
end;

{ TmFieldList }

function TmFieldList.Add: TmField;
begin
  Result := TmField.Create();
  Self.Add(Result);
end;

function TmFieldList.GetItem(Index: Integer): TmField;
begin
  Result := TmField(Self[Index]);
end;

procedure TmFieldList.SetItem(Index: Integer; const Value: TmField);
begin
  Self[Index] := Value;
end;

end.
