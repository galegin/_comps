unit mClasse;

interface

uses
  Classes, SysUtils, TypInfo, Math, 
  mValue;

type
  TmClasse = class
  public
    class function CreateObjeto(AClass: TClass; AOwner : TComponent) : TObject;
    class function GetProperties(AClass: TClass): TmValueList;
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

class function TmClasse.GetProperties(AClass: TClass): TmValueList;
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
  Count := GetPropList(AClass.ClassInfo, tkProperties, nil, False);
  Size := Count * SizeOf(Pointer);
  GetMem(List, Size);
  Key := True;
  try
    Count := GetPropList(AClass.ClassInfo, tkProperties, List, False);
    for I:=0 to Count-1 do begin
      PropInfo := List^[I];
      if (PropInfo^.PropType^.Kind in tkProperties) then begin
        Nome := PropInfo^.Name;
        TipoBase := PropInfo^.PropType^.Name;

        if LowerCase(Nome) = 'u_version' then
          Key := False;

        TipoField := TTipoField(IfThen(Key, Ord(tfKey), Ord(tfNul)));

        case PropInfo^.PropType^.Kind of
          tkEnumeration: begin
            if GetTypeData(PropInfo^.PropType^)^.BaseType^ = TypeInfo(Boolean) then
              Result.AddB(Nome, False, TipoField);
          end;
          tkFloat: begin
            if TipoBase = 'TDateTime' then
              Result.AddD(Nome, 0, TipoField)
            else if TipoBase = 'Real' then
              Result.AddF(Nome, 0, TipoField);
          end;
          tkInteger: begin
            Result.AddI(Nome, 0, TipoField);
          end;
          tkString, tkLString, {tkUString,} tkWString: begin
            Result.AddS(Nome, '', TipoField);
          end;
        else
          Result.AddO(Nome, nil, TipoField);
        end;
      end;
    end;
  finally
    FreeMem(List);
  end;
end;

end.