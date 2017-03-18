unit mComando;

interface

uses
  Classes, SysUtils, StrUtils,
  mProperty, mSelect, mObjeto;

type
  TmComando = class(TmSelect)
  protected
    class function GetCampos(AObject : TObject) : String;
    class function GetValues(AObject : TObject) : String;
    class function GetSets(AObject : TObject; AWheres : TmPropertyList) : String;
  public
    class function GetInsert(AObject : TObject) : String;
    class function GetUpdate(AObject : TObject; AWheres : TmPropertyList) : String;
    class function GetDelete(AObject : TObject; AWheres : TmPropertyList) : String;
  end;

implementation

{ TmComando }

//--

class function TmComando.GetCampos(AObject : TObject) : String;
var
  vProperties : TmPropertyList;
  I : Integer;
begin
  Result := '';

  vProperties := TmObjeto.GetValues(AObject);

  with vProperties do
    for I := 0 to Count - 1 do
      with Items[I] do
        if IsValueDatabase and IsValueStore then
          Result := Result + IfThen(Result <> '', ', ', '') + UpperCase(Nome);
end;

class function TmComando.GetValues(AObject : TObject) : String;
var
  vProperties : TmPropertyList;
  I : Integer;
begin
  Result := '';

  vProperties := TmObjeto.GetValues(AObject);

  with vProperties do
    for I := 0 to Count - 1 do
      with Items[I] do
        if IsValueDatabase and IsValueStore then
          Result := Result + IfThen(Result <> '', ', ', '') + ValueDatabase;
end;

class function TmComando.GetSets(AObject : TObject; AWheres : TmPropertyList) : String;
var
  vProperties : TmPropertyList;
  vWhere : TmProperty;
  I : Integer;
begin
  Result := '';

  vProperties := TmObjeto.GetValues(AObject);

  with vProperties do
    for I := 0 to Count - 1 do begin
      with Items[I] do
        if IsValueDatabase and IsValueStore then begin
          vWhere := AWheres.IndexOf(Items[I].Nome);
          if vWhere = nil then
            Result := Result + IfThen(Result <> '', ', ', '') +
              UpperCase(Nome) + ' = ' + ValueDatabase;
        end;
    end;
end;

//--

class function TmComando.GetInsert(AObject: TObject): String;
begin
  Result := 'insert into {entidade} ({campos}) values ({values})';
  Result := AnsiReplaceStr(Result, '{entidade}', GetEntidade(AObject));
  Result := AnsiReplaceStr(Result, '{campos}', GetCampos(AObject));
  Result := AnsiReplaceStr(Result, '{values}', GetValues(AObject));
end;

class function TmComando.GetUpdate(AObject: TObject; AWheres: TmPropertyList): String;
begin
  Result := 'update {entidade} set {sets} /*WHERE*/';
  Result := AnsiReplaceStr(Result, '{entidade}', GetEntidade(AObject));
  Result := AnsiReplaceStr(Result, '{sets}', GetSets(AObject, AWheres));
  Result := AnsiReplaceStr(Result, '/*WHERE*/', GetWheres(AObject, AWheres));
end;

class function TmComando.GetDelete(AObject: TObject; AWheres: TmPropertyList): String;
begin
  Result := 'delete from {entidade} /*WHERE*/';
  Result := AnsiReplaceStr(Result, '{entidade}', GetEntidade(AObject));
  Result := AnsiReplaceStr(Result, '/*WHERE*/', GetWheres(AObject, AWheres));
end;

end.