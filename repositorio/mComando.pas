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

  procedure AddString(var AString : String; AStr : String; ASep : String; AIni : String = '');
  function GetValueStr(AObject: TObject; ANome : String) : String;

implementation

  procedure AddString(var AString : String; AStr : String; ASep : String; AIni : String = '');
  begin
    AString := AString + IfThen(AString <> '', ASep, AIni) + AStr;
  end;

  function GetMappingObj(AObject: TObject) : PmMapping;
  begin
    Result := TmMapping(AObject).GetMapping();
  end;

  function GetMappingClass(AClass: TClass) : PmMapping;
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
  vMapping : PmMapping;
  vFieldsAtr, vFields : String;
  I : Integer;
begin
  vMapping := GetMappingClass(AClass);

  vFieldsAtr := '';
  vFields := '';

  with vMapping.Campos do
    for I := 0 to Count - 1 do
      with PmCampo(Items[I])^ do begin
        AddString(vFieldsAtr, Atributo + ' as "' + Atributo + '"', ', ');
        AddString(vFields, Campo + ' as ' + Atributo, ', ');
      end;

  Result :=
    'select ' + vFieldsAtr + ' from (' +
      'select ' + vFields + ' from '+ vMapping.Tabela.Nome +
    ')' + IfThen(AWhere <> '', ' where ' + AWhere);

  FreeMapping(vMapping);
end;

class function TmComando.GetSelect(AObject: TObject): String;
var
  vMapping : PmMapping;
  vWhere : String;
  I : Integer;
begin
  vMapping := GetMappingObj(AObject);

  vWhere := '';
  with vMapping.Campos do
    for I := 0 to Count - 1 do
      with PmCampo(Items[I])^ do
        if TipoCampo in [tfKey] then
          AddString(vWhere, Atributo + ' = ' + GetValueStr(AObject, Atributo), ' and ');

  Result := GetSelect(AObject.ClassType, vWhere);

  FreeMapping(vMapping);
end;

class function TmComando.GetInsert(AObject: TObject): String;
var
  vMapping : PmMapping;
  vFields, vValues : String;
  I : Integer;
begin
  vMapping := GetMappingObj(AObject);

  vFields := '';
  vValues := '';
  with vMapping.Campos do
    for I := 0 to Count - 1 do
      with PmCampo(Items[I])^ do begin
        AddString(vFields, Campo, ', ');
        AddString(vValues, GetValueStr(AObject, Atributo), ', ');
      end;

  Result :=
    'insert into ' + vMapping.Tabela.Nome +
    ' (' + vFields +
    ') values (' + vValues +
    ')';

  FreeMapping(vMapping);
end;

class function TmComando.GetUpdate(AObject: TObject): String;
var
  vMapping : PmMapping;
  vSets, vWhere : String;
  I : Integer;
begin
  vMapping := GetMappingObj(AObject);

  vWhere := '';
  vSets := '';
  with vMapping.Campos do
    for I := 0 to Count - 1 do
      with PmCampo(Items[I])^ do
        if TipoCampo in [tfKey] then
          AddString(vWhere, Campo + ' = ' + GetValueStr(AObject, Atributo), ' and ')
        else
          AddString(vSets, Campo + ' = ' + GetValueStr(AObject, Atributo), ', ');

  Result :=
    'update ' + vMapping.Tabela.Nome +
    ' set ' + vSets +
    ' where ' + vWhere;

  FreeMapping(vMapping);
end;

class function TmComando.GetDelete(AObject: TObject): String;
var
  vMapping : PmMapping;
  vWhere : String;
  I : Integer;
begin
  vMapping := GetMappingObj(AObject);

  vWhere := '';
  with vMapping.Campos do
    for I := 0 to Count - 1 do
      with PmCampo(Items[I])^ do
        if TipoCampo in [tfKey] then
          AddString(vWhere, Campo + ' = ' + GetValueStr(AObject, Atributo), ' and ');

  Result :=
    'delete from ' + vMapping.Tabela.Nome +
    ' where ' + vWhere;

  FreeMapping(vMapping);
end;

end.
