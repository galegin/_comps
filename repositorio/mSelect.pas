unit mSelect;

interface

uses
  Classes, SysUtils, StrUtils,
  mValue, mObjeto, mFilter;

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
  vValues : TmValueList;
  I : Integer;
begin
  Result := '';

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do
      with Items[I] do
        if Items[I] is TmValueBase then
          Result := Result + IfThen(Result <> '', ', ', '') +
            UpperCase(Nome);
end;

class function TmSelect.GetWheres;
var
  vValues : TmValueList;
  vValue : TmValue;
  vObjeto : TObject;
  I : Integer;

  procedure SetarParametroP(AProperty : TmValue);
  begin
    vValue := vValues.IndexOf(AProperty.Nome);
    if Assigned(vValue) then
      if vValue is TmValueBase then
        Result := Result + IfThen(Result <> '', ' and ', 'where ') +
          UpperCase(AProperty.Nome) + ' = ' + AProperty.ValueBase;
  end;

  procedure SetarParametroF(AFilter : TmFilter);
  begin
    vValue := vValues.IndexOf(AFilter.Nome);
    if Assigned(vValue) then
      if vValue is TmValueBase then
        Result := Result + IfThen(Result <> '', ' and ', 'where ') +
          AFilter.ValueBase;
  end;  
  
begin
  Result := '';

  if not Assigned(AWheres) then
    Exit;

  vValues := TmObjeto.GetValues(AObject);

  for I := 0 to AWheres.Count - 1 do begin
    vObjeto := AWheres[I];
    if (vObjeto is TmValue) then
      SetarParametroP(vObjeto as TmValue)
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