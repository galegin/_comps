unit mClasse;

interface

uses
  Classes, SysUtils, TypInfo, Math, 
  mProperty;

type
  TmClasse = class
  public
    class function CreateObjeto(AClass: TClass; AOwner : TComponent) : TObject;
    class function GetProperties(AClass: TClass): TmPropertyList;
  end;

  TCollectionClass = class of TCollection;

implementation

uses
  mCollection, mCollectionItem;

class function TmClasse.createObjeto(AClass: TClass; AOwner : TComponent) : TObject;
begin
  if (AClass.InheritsFrom(TComponent)) then begin
    Result := TComponentClass(AClass).Create(AOwner);

  end else if (AClass.InheritsFrom(TmCollectionItem)) then begin
    Result := TmCollectionItemClass(AClass).Create(nil);
  end else if (AClass.InheritsFrom(TmCollection)) then begin
    Result := TmCollectionClass(AClass).Create(nil);

  end else if (AClass.InheritsFrom(TCollectionItem)) then begin
    Result := TCollectionItemClass(AClass).Create(nil);
  end else if (AClass.InheritsFrom(TCollection)) then begin
    Result := TCollectionClass(AClass).Create(nil);
  end else if (AClass.InheritsFrom(TPersistent)) then begin
    Result := TPersistentClass(AClass).Create();
  end else begin
    Result := AClass.NewInstance();
  end;
end;

class function TmClasse.GetProperties(AClass: TClass): TmPropertyList;
var
  Count, Size, I : Integer;
  PropInfo : PPropInfo;
  List : PPropList;
  Key : Boolean;
begin
  Result := TmPropertyList.Create;
  Count := GetPropList(AClass.ClassInfo, tkProperties, nil, False);
  Size := Count * SizeOf(Pointer);
  GetMem(List, Size);
  Key := True;
  try
    Count := GetPropList(AClass.ClassInfo, tkProperties, List, False);
    for I:=0 to Count-1 do begin
      PropInfo := List^[I];
      if (PropInfo^.PropType^.Kind in tkProperties) then begin
        with Result.Adicionar do begin
          Nome := PropInfo^.Name;
          TipoBase := PropInfo^.PropType^.Name;

          if LowerCase(Nome) = 'u_version' then
            Key := False;

          TipoField := TpField(IfThen(Key, Ord(tpfKey), Ord(tpfNul)));

          case PropInfo^.PropType^.Kind of
            tkEnumeration: begin
              if GetTypeData(PropInfo^.PropType^)^.BaseType^ = TypeInfo(Boolean) then begin
                Tipo := tppBoolean;
              end;
            end;
            tkString, tkLString, tkWString: begin
              Tipo := tppString;
            end;
            tkInteger: begin
              Tipo := tppInteger;
            end;
            tkFloat: begin
              if TipoBase = 'TDateTime' then begin
                Tipo := tppDateTime;
              end else if TipoBase = 'Real' then begin
                Tipo := tppFloat;
              end;
            end;
          else
            Tipo := tppObject;
          end;
        end;
      end;
    end;
  finally
    FreeMem(List);
  end;
end;

end.