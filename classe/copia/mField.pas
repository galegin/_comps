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
    fPrecisao : Integer;
    fRequerido : Boolean;
    fVisivel : Boolean;
  public
    constructor Create; overload;
    constructor Create(ANome : String; ADescricao : String; ATipo : TFieldType;
      ATamanho : Integer; APrecisao : Integer = 0;
      ARequerido : Boolean = False; AVisivel : Boolean = True); overload;
  published
    property Nome : String read fNome write fNome;
    property Descricao : String read fDescricao write fDescricao;
    property Tipo : TFieldType read fTipo write fTipo;
    property Tamanho : Integer read fTamanho write fTamanho;
    property Precisao : Integer read fPrecisao write fPrecisao;
    property Requerido : Boolean read fRequerido write fRequerido;
    property Visivel : Boolean read fVisivel write fVisivel;
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

{ TmField }

constructor TmField.Create;
begin
end;

constructor TmField.Create(ANome : String; ADescricao: String; ATipo : TFieldType;
  ATamanho: Integer; APrecisao: Integer;
  ARequerido: Boolean; AVisivel: Boolean);
begin
  fNome := ANome;
  fDescricao := ADescricao;
  fTipo := ATipo;
  fTamanho := ATamanho;
  fPrecisao := APrecisao;
  fRequerido := ARequerido;
  fVisivel := AVisivel;
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
