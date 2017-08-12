unit mComando;

interface

uses
  Classes, SysUtils, StrUtils,
  mValue, mSelect, mObjeto;

type
  TmComando = class(TmSelect)
  protected
    class function GetCampos(AObject : TObject; AListNulo : Array Of String) : String;
    class function GetValues(AObject : TObject; AListNulo : Array Of String) : String;
    class function GetSets(AObject : TObject; AWheres : TmValueList; AListNulo : Array Of String) : String;
  public
    class function GetInsert(AObject : TObject; AListNulo : Array Of String) : String;
    class function GetUpdate(AObject : TObject; AWheres : TmValueList; AListNulo : Array Of String) : String;
    class function GetDelete(AObject : TObject; AWheres : TmValueList) : String;
  end;

implementation

{ TmComando }

//--

class function TmComando.GetCampos(AObject : TObject; AListNulo : Array Of String) : String;
var
  vValues : TmValueList;
  I : Integer;
begin
  Result := '';

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do
      with Items[I] do
        if Items[I] is TmValueBase and IsInsert then
          Result := Result + IfThen(Result <> '', ', ', '') +
            UpperCase(Nome);

  for I := 0 to High(AListNulo) do
    Result := Result + IfThen(Result <> '', ', ', '') +
      UpperCase(AListNulo[I]);
end;

class function TmComando.GetValues(AObject : TObject; AListNulo : Array Of String) : String;
var
  vValues : TmValueList;
  I : Integer;
begin
  Result := '';

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do
      with Items[I] do
        if Items[I] is TmValueBase and IsInsert then
          Result := Result + IfThen(Result <> '', ', ', '') + ValueBase;

  for I := 0 to High(AListNulo) do
    Result := Result + IfThen(Result <> '', ', ', '') + 'null';
end;

class function TmComando.GetSets(AObject : TObject; AWheres : TmValueList; AListNulo : Array Of String) : String;
var
  vValues : TmValueList;
  vWhere : TmValue;
  I : Integer;
begin
  Result := '';

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do begin
      with Items[I] do
        if Items[I] is TmValueBase and IsUpdate then begin
          vWhere := AWheres.IndexOf(Nome);
          if vWhere = nil then
            Result := Result + IfThen(Result <> '', ', ', '') +
              UpperCase(Nome) + ' = ' + ValueBase;
        end;
    end;

  for I := 0 to High(AListNulo) do
    Result := Result + IfThen(Result <> '', ', ', '') +
      UpperCase(AListNulo[I]) + ' = null';
end;

//--

class function TmComando.GetInsert(AObject: TObject; AListNulo : Array Of String): String;
begin
  Result := 'insert into {entidade} ({campos}) values ({values})';
  Result := AnsiReplaceStr(Result, '{entidade}', GetEntidade(AObject));
  Result := AnsiReplaceStr(Result, '{campos}', GetCampos(AObject, AListNulo));
  Result := AnsiReplaceStr(Result, '{values}', GetValues(AObject, AListNulo));
end;

class function TmComando.GetUpdate(AObject: TObject; AWheres: TmValueList; AListNulo : Array Of String): String;
begin
  Result := 'update {entidade} set {sets} /*WHERE*/';
  Result := AnsiReplaceStr(Result, '{entidade}', GetEntidade(AObject));
  Result := AnsiReplaceStr(Result, '{sets}', GetSets(AObject, AWheres, AListNulo));
  Result := AnsiReplaceStr(Result, '/*WHERE*/', GetWheres(AObject, AWheres));
end;

class function TmComando.GetDelete(AObject: TObject; AWheres: TmValueList): String;
begin
  Result := 'delete from {entidade} /*WHERE*/';
  Result := AnsiReplaceStr(Result, '{entidade}', GetEntidade(AObject));
  Result := AnsiReplaceStr(Result, '/*WHERE*/', GetWheres(AObject, AWheres));
end;

end.