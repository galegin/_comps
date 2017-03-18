unit mObjeto;

interface

uses
  Classes, SysUtils, StrUtils, TypInfo, Math,
  mLogger, mProperty;

type
  TmObjeto = class(TComponent)
  public
    class procedure ResetValues(AObject: TObject);
    class function GetValues(AObject: TObject): TmPropertyList;
    class procedure SetValues(AObject: TObject; AValues: TmPropertyList);
    class procedure ToObjeto(AObjectFrom: TObject; AObjectTo: TObject);
    class function GetValuesObjeto(AObject : TObject; AInherited : TClass) : TmPropertyList;
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
            tkString, tkLString, tkWString:
              SetStrProp(AObject, PropInfo, '');
            tkInteger:
              SetOrdProp(AObject, PropInfo, 0);
            tkFloat:
              SetFloatProp(AObject, PropInfo, 0);
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
begin
  Result := TmPropertyList.Create;
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
        with Result.Add do begin
          Nome := PropInfo^.Name;
          TipoBase := PropInfo^.PropType^.Name;

          if LowerCase(Nome) = 'u_version' then
            Key := False;

          TipoField := TpField(IfThen(Key, Ord(tpfKey), Ord(tpfNul)));

          case PropInfo^.PropType^.Kind of
            tkEnumeration: begin
              if GetTypeData(PropInfo^.PropType^)^.BaseType^ = TypeInfo(Boolean) then begin
                Tipo := tppBoolean;
                ValueBoolean := GetOrdProp(AObject, PropInfo) = 1;
              end;
            end;
            tkString, tkLString, tkWString: begin
              Tipo := tppString;
              ValueString := GetStrProp(AObject, PropInfo);
            end;
            tkInteger: begin
              Tipo := tppInteger;
              ValueInteger := GetOrdProp(AObject, PropInfo);
            end;
            tkFloat: begin
              if TipoBase = 'TDateTime' then begin
                Tipo := tppDateTime;
                ValueDateTime := GetFloatProp(AObject, PropInfo);
              end else if TipoBase = 'Real' then begin
                Tipo := tppFloat;
                ValueFloat := GetFloatProp(AObject, PropInfo);
              end;
            end;
          else
            Tipo := tppObject;
            ValueObject := GetObjectProp(AObject, PropInfo);
          end;
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
  for I := 0 to AValues.Count - 1 do begin
    with AValues.Items[I] do begin

      //-- read-only
      PropInfo := GetPropInfo(AObject, Nome);
      if PropInfo^.SetProc = nil then
        Continue;

      case Tipo of
        tppBoolean:
          if ValueBoolean then
            SetOrdProp(AObject, Nome, 1)
          else
            SetOrdProp(AObject, Nome, 0);
        tppDateTime:
          SetFloatProp(AObject, Nome, ValueDateTime);
        tppEnum:
          SetOrdProp(AObject, Nome, ValueEnum);
        tppInteger:
          SetOrdProp(AObject, Nome, ValueInteger);
        tppFloat:
          SetFloatProp(AObject, Nome, ValueFloat);
        tppString:
          SetStrProp(AObject, Nome, ValueString);
        //tppList:
          //SetVariantProp(AObject, Nome, ValueList);
        tppVariant:
          SetVariantProp(AObject, Nome, ValueVariant);
      else
        SetStrProp(AObject, Nome, ValueString);
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
  vValues : TmPropertyList;
  I : Integer;
begin
  Result := TmPropertyList.Create;

  if not Assigned(AObject) then
    Exit;

  vValues := TmObjeto.GetValues(AObject);

  with vValues do
    for I := 0 to Count - 1 do
      with Items[I] do
        if IsValueObject then
          if Assigned(ValueObject) then
            if ValueObject.ClassType.InheritsFrom(AInherited) then
              Result.Add(Items[I]);
end;

class function TmObjeto.GetValuesObjetoName;
var
  vValues : TmPropertyList;
  I : Integer;
begin
  Result := nil;

  vValues := TmObjeto.GetValuesObjeto(AObject, AInherited);

  with vValues do
    for I := 0 to Count - 1 do
      with Items[I] do
        if Nome = ANome then
          if ValueObject is AInherited then
            Result := ValueObject;
end;

end.