unit mJson;

interface

uses
  Classes, SysUtils, StrUtils;

type
  TmJson = class
  public
    class function ObjectToJson(AObject: TObject): String;
    class function JsonToObject(AClass: TClass; AJson: String): TObject;
    class function CollectionToJson(ACollection: TCollection): String;
    class function JsonToCollection(AItemClass: TCollectionItemClass; AJson: String): TCollection;
  end;

implementation

uses
  mString, mClasse, mValue, mObjeto;

{ TmJson }

class function TmJson.ObjectToJson(AObject: TObject): String;
var
  vValues : TmValueList;
  I : Integer;
begin
  Result := '';

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do
      with Items[I] do
        if Items[I] Is TmValueBase then
          Result := Result + IfThen(Result <> '', ',', '') +
            '"' + Nome + '":"' + ValueStr + '"' ;

  if Result <> '' then
    Result := '{' + Result + '}' ;
end;

class function TmJson.JsonToObject(AClass: TClass; AJson: String): TObject;
var
  vStringList : TStringList;
  vValues : TmValueList;
  vValue : TmValue;
  vNome, vValor : String;
  I : Integer;
begin
  vStringList := TStringList.Create;

  if TmString.StartsWiths(AJson, '{') then
    Delete(AJson, 1, 1);
  if TmString.EndWiths(AJson, '}') then
    Delete(AJson, Length(AJson), 1);

  vStringList.Text := AnsiReplaceStr(AJson, '","', '"' + sLineBreak + '"');

  Result := TmClasse.createObjeto(AClass, nil);

  vValues := TmObjeto.GetValues(Result);

  for I := 0 to vStringList.Count - 1 do begin
    vNome := AnsiReplaceStr(TmString.LeftStr(vStringList[I], '":"'), '"', '');
    vValor := AnsiReplaceStr(TmString.RightStr(vStringList[I], '":"'), '"', '');
    vValue := vValues.IndexOf(vNome);
    if Assigned(vValue) then
      vValue.ValueBase := vValor;
  end;

  TmObjeto.SetValues(Result, vValues);
end;

class function TmJson.CollectionToJson(ACollection: TCollection): String;
var
  I : Integer;
begin
  Result := '';

  with ACollection do
    for I := 0 to Count - 1 do
      Result := Result + IfThen(Result <> '', ',', '') + ObjectToJson(Items[I]);

  if Result <> '' then
    Result := '[' + Result + ']' ;
end;

class function TmJson.JsonToCollection(AItemClass: TCollectionItemClass; AJson: String): TCollection;
var
  vStringList : TStringList;
  vObjeto : TObject;
  vCollectionItem : TCollectionItem;
  vValues : TmValueList;
  I : Integer;
begin
  vStringList := TStringList.Create;

  if TmString.StartsWiths(AJson, '[') then
    Delete(AJson, 1, 1);
  if TmString.EndWiths(AJson, ']') then
    Delete(AJson, Length(AJson), 1);

  vStringList.Text := AnsiReplaceStr(AJson, '"},{"', '"}' + sLineBreak + '{"');

  Result := TCollection.Create(AItemClass);

  for I := 0 to vStringList.Count - 1 do begin
    vCollectionItem := Result.Add as TCollectionItem;
    vObjeto := JsonToObject(AItemClass, vStringList[I]);
    vValues := TmObjeto.GetValues(vObjeto);
    TmObjeto.SetValues(vCollectionItem, vValues);
  end;
end;

{ TmTeste }

type
  TmTeste = class;
  TmTesteClass = class of TmTeste;

  TmTeste = class(TPersistent)
  private
    fCodigo : Integer;
    fNome : String;
  published
    property Codigo : Integer read fCodigo write fCodigo;
    property Nome : String read fNome write fNome;
  end;

procedure testar();
var
  vTeste1, vTeste2 : TmTeste;
  vJson1, vJson2 : String;
begin
  vTeste1 := TmTeste.Create;
  vTeste1.Codigo := 1;
  vTeste1.Nome := 'Jose';

  vJson1 := TmJson.ObjectToJson(vTeste1);
  vJson1 := vJson1;

  vTeste2 := TmJson.JsonToObject(TmTeste, vJson1) as TmTeste;

  vJson2 := TmJson.ObjectToJson(vTeste2);
  vJson2 := vJson2;
end;

initialization
  //testar();

end.
