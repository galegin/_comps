unit mObjeto;

interface

uses
  Classes, SysUtils, StrUtils, TypInfo, Math,
  mLogger, mValue;

type
  TmObjeto = class(TComponent)
  public
    class procedure ResetValues(AObject: TObject);
    class function GetValues(AObject: TObject): TmValueList;
    class procedure SetValues(AObject: TObject; AValues: TmValueList);
    class procedure ToObjeto(AObjectFrom: TObject; AObjectTo: TObject);
    class function GetValuesObjeto(AObject : TObject; AInherited : TClass) : TmValueList;
    class function GetValuesObjetoName(AObject : TObject; AInherited : TClass; ANome : String) : TObject;
  end;

implementation

{ TmObjeto }

(*
  TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray);
*)

class procedure TmObjeto.ResetValues;
const
  cDS_METHOD = 'TmObjeto.ResetValues';
var
  vNome, vTipoBase : String;
  Count, Size, I : Integer;
  PropInfo : PPropInfo;
  List : PPropList;
begin
  Count := GetPropList(AObject.ClassInfo, tkProperties, nil, False);
  Size := Count * SizeOf(Pointer);
  GetMem(List, Size);

  try
    Count := GetPropList(AObject.ClassInfo, tkProperties, List, False);

    for I := 0 to Count - 1 do begin
      PropInfo := List^[I];

      try
        vNome := PropInfo^.Name;
        vTipoBase := PropInfo^.PropType^.Name;

        //-- read-only
        if PropInfo^.SetProc = nil then
          Continue;

        if (PropInfo^.PropType^.Kind in tkProperties) then begin

          case PropInfo^.PropType^.Kind of
            tkEnumeration:
              if GetTypeData(PropInfo^.PropType^)^.BaseType^ = TypeInfo(Boolean) then
                SetOrdProp(AObject, PropInfo, 0);
            tkInteger:
              SetOrdProp(AObject, PropInfo, 0);
            tkFloat:
              SetFloatProp(AObject, PropInfo, 0);
            tkString, tkLString, tkWString:
              SetStrProp(AObject, PropInfo, '');
          end;
          
        end;

      except
        on E : Exception do begin
          mLogger.Instance.Erro('Erro: ' + E.Message +
            ' / vNome: ' + vNome + ' / vTipoBase: ' + vTipoBase, cDS_METHOD);
        end;

      end;

    end;
  finally
    FreeMem(List);
  end;
end;

//--

class function TmObjeto.GetValues;
var
  Count, Size, I : Integer;
  PropInfo : PPropInfo;
  List : PPropList;
  Key : Boolean;
  Nome : String;
  TipoBase : String;
  TipoField : TTipoField;
begin
  Result := TmValueList.Create;
  Count := GetPropList(AObject.ClassInfo, tkProperties, nil, False);
  Size := Count * SizeOf(Pointer);
  GetMem(List, Size);
  Key := True;

  try

    Count := GetPropList(AObject.ClassInfo, tkProperties, List, False);
    for I := 0 to Count - 1 do begin
      PropInfo := List^[I];

      //-- read-only
      if PropInfo^.SetProc = nil then
        Continue;

      if (PropInfo^.PropType^.Kind in tkProperties) then begin
        Nome := PropInfo^.Name;
        TipoBase := PropInfo^.PropType^.Name;

        if LowerCase(Nome) = 'u_version' then
          Key := False;

        TipoField := TTipoField(IfThen(Key, Ord(tfKey), Ord(tfNul)));

        case PropInfo^.PropType^.Kind of
          tkEnumeration: begin
            if GetTypeData(PropInfo^.PropType^)^.BaseType^ = TypeInfo(Boolean) then
              Result.AddB(Nome, (GetOrdProp(AObject, PropInfo) = 1), TipoField);
          end;
          tkFloat: begin
            if TipoBase = 'TDateTime' then
              Result.AddD(Nome, GetFloatProp(AObject, PropInfo), TipoField)
            else if TipoBase = 'Real' then
              Result.AddF(Nome, GetFloatProp(AObject, PropInfo), TipoField);
          end;
          tkInteger: begin
            Result.AddI(Nome, GetOrdProp(AObject, PropInfo), TipoField);
          end;
          tkString, tkLString, {tkUString,} tkWString: begin
            Result.AddS(Nome, GetStrProp(AObject, PropInfo), TipoField);
          end;
        else
          Result.AddO(Nome, GetObjectProp(AObject, PropInfo), TipoField);
        end;

      end;
    end;
  finally
    FreeMem(List);
  end;
end;

class procedure TmObjeto.SetValues;
var
  PropInfo : PPropInfo;
  I : Integer;
begin
  with AValues do
    for I := 0 to Count - 1 do begin
      with Items[I] do begin

        //-- read-only
        PropInfo := GetPropInfo(AObject, Nome);
        if PropInfo^.SetProc = nil then
          Continue;

        case Tipo of
          tvBoolean:
            if (Items[I] as TmValueBool).Value then
              SetOrdProp(AObject, Nome, 1)
            else
              SetOrdProp(AObject, Nome, 0);
          tvDateTime:
            SetFloatProp(AObject, Nome, ItemsD[I].Value);
          tvFloat:
            SetFloatProp(AObject, Nome, ItemsF[I].Value);
          tvInteger:
            SetOrdProp(AObject, Nome, ItemsI[I].Value);
          tvString:
            SetStrProp(AObject, Nome, ItemsS[I].Value);
          tvVariant:
            SetVariantProp(AObject, Nome, ItemsV[I].Value);
        else
          SetStrProp(AObject, Nome, ItemsS[I].Value);
        end;
      end;
    end;
end;

//--

class procedure TmObjeto.ToObjeto;
begin
  SetValues(AObjectTo, GetValues(AObjectFrom));
end;

//--

class function TmObjeto.GetValuesObjeto;
var
  vValues : TmValueList;
  I : Integer;
begin
  Result := TmValueList.Create;

  if not Assigned(AObject) then
    Exit;

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do
      if Items[I] is TmValueObj then
        with Items[I] as TmValueObj do
          if Assigned(Value) then
            if Value.ClassType.InheritsFrom(AInherited) then
              Result.Add(Items[I]);
end;

class function TmObjeto.GetValuesObjetoName;
var
  vValues : TmValueList;
  I : Integer;
begin
  Result := nil;

  vValues := TmObjeto.GetValuesObjeto(AObject, AInherited);

  with vValues do
    for I := 0 to Count - 1 do
      if Items[I] is TmValueObj then
        with Items[I] as TmValueObj do
          if Nome = ANome then
            if Value is AInherited then
              Result := Value;
end;

end.