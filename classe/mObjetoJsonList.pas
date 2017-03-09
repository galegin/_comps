unit mObjetoJsonList;

interface

type
  TrObjetoJson = record
    Lista : TObject;
    Objeto : TObject;
    Atributo : String;
    Conteudo : String;
  end;

  TrObjetoJsonArray = Array of TrObjetoJson;

  TmObjetoJsonList = class
  private
    fArray : TrObjetoJsonArray;
    function GetItem(Index: Integer): TrObjetoJson;
    procedure SetItem(Index: Integer; const Value: TrObjetoJson);
  public
    procedure Limpar();
    function Count : Integer;
    procedure Adicionar(AObjetoList : TrObjetoJson);
    procedure AdicionarLista(ALista : TObject);
    procedure AdicionarObjeto(AObjeto : TObject);
    procedure AdicionarAtributo(AAtributo : String; AConteudo : String);
    property Items[Index : Integer] : TrObjetoJson read GetItem write SetItem;
  end;

implementation

{ TmObjetoJsonList }

procedure TmObjetoJsonList.Limpar;
begin
  SetLength(fArray, 0);
end;

function TmObjetoJsonList.Count: Integer;
begin
  Result := Length(fArray);
end;

procedure TmObjetoJsonList.Adicionar(AObjetoList : TrObjetoJson);
begin
  SetLength(fArray, Length(fArray) + 1);
  fArray[High(fArray)] := AObjetoList;
end;

procedure TmObjetoJsonList.AdicionarLista(ALista: TObject);
begin
  SetLength(fArray, Length(fArray) + 1);
  fArray[High(fArray)].Lista := ALista;
end;

procedure TmObjetoJsonList.AdicionarObjeto(AObjeto: TObject);
begin
  SetLength(fArray, Length(fArray) + 1);
  fArray[High(fArray)].Objeto := AObjeto;
end;

procedure TmObjetoJsonList.AdicionarAtributo(AAtributo, AConteudo: String);
begin
  SetLength(fArray, Length(fArray) + 1);
  fArray[High(fArray)].Atributo := AAtributo;
  fArray[High(fArray)].Conteudo := AConteudo;
end;

function TmObjetoJsonList.GetItem(Index: Integer): TrObjetoJson;
begin
  Result := fArray[Index];
end;

procedure TmObjetoJsonList.SetItem(Index: Integer; const Value: TrObjetoJson);
begin
  fArray[Index] := Value;
end;

end.
