unit mSelect;

interface

uses
  Classes, SysUtils, StrUtils,
  mProperty, mObjeto, mFilter;

type
  TmSelect = class(TComponent)
  protected
    class function GetEntidade(
      AObject : TObject) : String;

    class function GetFields(
      AObject : TObject) : String;

    class function GetWheres(
      AObject : TObject;
      AWheres : TList) : String;

  public
    class function GetSelect(
      AObject : TObject;
      AWheres : TList;
      AFields : String = '') : String;

  end;

implementation

{ TmSelect }

class function TmSelect.GetEntidade;
begin
  Result := UpperCase(AObject.ClassName);
  Delete(Result, 1, 1);
end;

//--

class function TmSelect.GetFields;
var
  vProperties : TmPropertyList;
  I : Integer;
begin
  Result := '';

  vProperties := TmObjeto.GetValues(AObject);

  with vProperties do
    for I := 0 to Count - 1 do
      with Items[I] do
        if IsValueDatabase then
          Result := Result + IfThen(Result <> '', ', ', '') +
            UpperCase(Nome);
end;

class function TmSelect.GetWheres;
var
  vProperties : TmPropertyList;
  vProperty : TmProperty;
  vObjeto : TObject;
  I : Integer;

  procedure SetarParametroP(AProperty : TmProperty);
  begin
    vProperty := vProperties.IndexOf(AProperty.Nome);
    if vProperty <> nil then
      if vProperty.IsValueDatabase then
        Result := Result + IfThen(Result <> '', ' and ', 'where ') +
          UpperCase(AProperty.Nome) + ' = ' + AProperty.ValueDatabase;
  end;

  procedure SetarParametroF(AFilter : TmFilter);
  begin
    vProperty := vProperties.IndexOf(AFilter.Nome);
    if vProperty <> nil then
      if vProperty.IsValueDatabase then
        Result := Result + IfThen(Result <> '', ' and ', 'where ') +
          AFilter.ValueDatabase;
  end;  
  
begin
  Result := '';

  if not Assigned(AWheres) then
    Exit;

  vProperties := TmObjeto.GetValues(AObject);

  for I := 0 to AWheres.Count - 1 do begin
    vObjeto := AWheres[I];
    if (vObjeto is TmProperty) then
      SetarParametroP(vObjeto as TmProperty)
    else if (vObjeto is TmFilter) then
      SetarParametroF(vObjeto as TmFilter);
  end;
end;

//--

class function TmSelect.GetSelect;
begin
  Result := 'select {fields} from {entidade} /*WHERE*/';
  Result := AnsiReplaceStr(Result, '{fields}', IfThen(AFields <> '', AFields, GetFields(AObject)));
  Result := AnsiReplaceStr(Result, '{entidade}', GetEntidade(AObject));
  Result := AnsiReplaceStr(Result, '/*WHERE*/', GetWheres(AObject, AWheres));
end;

end.