unit mComando;

(* mComando *)

interface

uses
  Classes, SysUtils, StrUtils, TypInfo,
  mMapping;

type
  TmComando = class
  private
  protected
  public
    class function GetSelect(AClass : TClass; AWhere : String = '') : String; overload;
    class function GetSelect(AObject : TObject) : String; overload;
    class function GetInsert(AObject : TObject) : String;
    class function GetUpdate(AObject : TObject) : String;
    class function GetDelete(AObject : TObject) : String;
  published
  end;

implementation

  procedure AddString(var AString : String; AStr : String; ASep : String; AIni : String = '');
  begin
    AString := AString + IfThen(AString <> '', ASep, AIni) + AStr;
  end;

  function GetMappingObj(AObject: TObject) : RMapping;
  var
    vMapping : IMapping;
  begin
    vMapping := TmMapping(AObject);
    Result.Tabela := vMapping.GetTabela();
    Result.Keys := vMapping.GetKeys();
    Result.Campos := vMapping.GetCampos();
  end;

  function GetMappingClass(AClass: TClass) : RMapping;
  var
    vMapping : TObject;
  begin
    vMapping := TmMappingClass(AClass).Create(nil);
    Result := GetMappingObj(vMapping);
    FreeAndNil(vMapping);
  end;

  function IsValueNull(AObject: TObject; ANome : String) : Boolean;
  var
    vPropInfo : PPropInfo;
    vTipoBase : String;
  begin
    Result := False;

    vPropInfo := GetPropInfo(AObject, ANome);
    vTipoBase := vPropInfo^.PropType^.Name;

    if vTipoBase = 'Boolean' then // mObjeto
      Result := GetOrdProp(AObject, ANome) = 0
    else if vTipoBase = 'TDateTime' then
      Result := GetFloatProp(AObject, ANome) = 0
    else if vTipoBase = 'Real' then
      Result := GetFloatProp(AObject, ANome) = 0
    else if vTipoBase = 'Integer' then
      Result := GetOrdProp(AObject, ANome) = 0
    else if vTipoBase = 'String' then
      Result := GetStrProp(AObject, ANome) = ''
  end;

  function GetValueStr(AObject: TObject; ANome : String) : String;
  var
    vPropInfo : PPropInfo;
    vTipoBase : String;
  begin
    if IsValueNull(AObject, ANome) then begin
      Result := 'null';
      Exit;
    end;

    vPropInfo := GetPropInfo(AObject, ANome);
    vTipoBase := vPropInfo^.PropType^.Name;

    if vTipoBase = 'Boolean' then // mObjeto
      Result := '''' + IfThen(GetOrdProp(AObject, ANome) = 1, 'T', 'F') + ''''
    else if vTipoBase = 'TDateTime' then
      Result := '''' + FormatDateTime('dd.mm.yyyy hh:nn:ss', GetFloatProp(AObject, ANome)) + ''''
    else if vTipoBase = 'Real' then
      Result := AnsiReplaceStr(FloatToStr(GetFloatProp(AObject, ANome)), ',', '.')
    else if vTipoBase = 'Integer' then
      Result := IntToStr(GetOrdProp(AObject, ANome))
    else if vTipoBase = 'String' then
      Result := '''' + AnsiReplaceStr(GetStrProp(AObject, ANome), '''', '''''') + '''';
  end;

{ TmComando }

class function TmComando.GetSelect(AClass: TClass; AWhere: String): String;
var
  vMapping : RMapping;
  vFieldsAtr, vFields : String;
  I : Integer;
begin
  vMapping := GetMappingClass(AClass);

  vFieldsAtr := '';
  vFields := '';
  for I := 0 to High(vMapping.Campos) do
    with vMapping.Campos[I] do begin
      AddString(vFieldsAtr, Atributo + ' as "' + Atributo + '"', ', ');
      AddString(vFields, Campo + ' as ' + Atributo, ', ');
    end;

  Result :=
    'select ' + vFieldsAtr + ' from (' +
      'select ' + vFields + ' from '+ vMapping.Tabela.Nome +
    ')' + IfThen(AWhere <> '', ' where ' + AWhere);
end;

class function TmComando.GetSelect(AObject: TObject): String;
var
  vMapping : RMapping;
  vWhere : String;
  I : Integer;
begin
  vMapping := GetMappingObj(AObject);

  vWhere := '';
  for I := 0 to High(vMapping.Keys) do
    with vMapping.Keys[I] do
      AddString(vWhere, Atributo + ' = ' + GetValueStr(AObject, Atributo), ' and ');

  Result := GetSelect(AObject.ClassType, vWhere);
end;

class function TmComando.GetInsert(AObject: TObject): String;
var
  vMapping : RMapping;
  vFields, vValues : String;
  I : Integer;
begin
  vMapping := GetMappingObj(AObject);

  vFields := '';
  vValues := '';
  for I := 0 to High(vMapping.Campos) do
    with vMapping.Campos[I] do begin
      AddString(vFields, Campo, ', ');
      AddString(vValues, GetValueStr(AObject, Atributo), ', ');
    end;

  Result :=
    'insert into ' + vMapping.Tabela.Nome +
    ' (' + vFields +
    ') values (' + vValues +
    ')';
end;

class function TmComando.GetUpdate(AObject: TObject): String;
var
  vMapping : RMapping;
  vSets, vWhere, vKeys : String;
  I : Integer;
begin
  vMapping := GetMappingObj(AObject);

  vKeys := '';
  vWhere := '';
  for I := 0 to High(vMapping.Keys) do
    with vMapping.Keys[I] do begin
      AddString(vKeys, Atributo, '|');
      AddString(vWhere, Campo + ' = ' + GetValueStr(AObject, Atributo), ' and ');
    end;

  vSets := '';
  for I := 0 to High(vMapping.Campos) do
    with vMapping.Campos[I] do
      if Pos(Atributo, vKeys) = 0 then
        AddString(vSets, GetValueStr(AObject, Atributo), ', ');

  Result :=
    'update ' + vMapping.Tabela.Nome +
    ' set ' + vSets +
    ' where ' + vWhere;
end;

class function TmComando.GetDelete(AObject: TObject): String;
var
  vMapping : RMapping;
  vWhere : String;
  I : Integer;
begin
  vMapping := GetMappingObj(AObject);

  vWhere := '';
  for I := 0 to High(vMapping.Keys) do
    with vMapping.Keys[I] do
      AddString(vWhere, Campo + ' = ' + GetValueStr(AObject, Atributo), ' and ');

  Result :=
    'delete from ' + vMapping.Tabela.Nome +
    ' where ' + vWhere;
end;

end.
