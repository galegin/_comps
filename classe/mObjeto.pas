unit mObjeto;

interface

uses
  Classes, SysUtils, StrUtils, TypInfo, Math,
  mLogger, mValue;

type
  TmObjeto = class(TObject)
  public
    procedure ResetValues();
    function GetValues(): TmValueList;
    procedure SetValues(AValues: TmValueList);
    procedure ToObjeto(AObjectTo: TObject);
  end;

implementation

{ TmObjeto }

(*
  TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray);
*)

procedure TmObjeto.ResetValues;
const
  cDS_METHOD = 'TmObjeto.ResetValues';
var
  Count, Size, I : Integer;
  vNome, vTipoBase : String;
  vPropInfo : PPropInfo;
  vList : PPropList;
begin
  Count := GetPropList(Self.ClassInfo, tkProperties, nil, False);
  Size := Count * SizeOf(Pointer);
  GetMem(vList, Size);

  try
    Count := GetPropList(Self.ClassInfo, tkProperties, vList, False);

    for I := 0 to Count - 1 do begin
      vPropInfo := vList^[I];

      //-- read-only
      if vPropInfo^.SetProc = nil then
        Continue;

      vTipoBase := vPropInfo^.PropType^.Name;
      if vTipoBase = 'Boolean' then
        SetOrdProp(Self, vPropInfo, 0)
      else if vTipoBase = 'TDateTime' then
        SetFloatProp(Self, vPropInfo, 0)
      else if vTipoBase = 'Float' then
        SetFloatProp(Self, vPropInfo, 0)
      else if vTipoBase = 'Integer' then
        SetOrdProp(Self, vPropInfo, 0)
      else if vTipoBase = 'String' then
        SetStrProp(Self, vPropInfo, '');
    end;
  finally
    FreeMem(vList);
  end;
end;

//--

function TmObjeto.GetValues;
var
  Count, Size, I : Integer;
  vPropInfo : PPropInfo;
  vList : PPropList;
  vKey : Boolean;
  vNome, vTipoBase : String;
  vTipoField : TTipoField;
begin
  Result := TmValueList.Create;
  Count := GetPropList(Self.ClassInfo, tkProperties, nil, False);
  Size := Count * SizeOf(Pointer);
  GetMem(vList, Size);
  vKey := True;

  try
    Count := GetPropList(Self.ClassInfo, tkProperties, vList, False);

    for I := 0 to Count - 1 do begin
      vPropInfo := vList^[I];

      //-- read-only
      if vPropInfo^.SetProc = nil then
        Continue;

      vNome := vPropInfo^.Name;
      if LowerCase(vNome) = 'u_version' then
        vKey := False;

      vTipoField := TTipoField(IfThen(vKey, Ord(tfKey), Ord(tfNul)));

      vTipoBase := vPropInfo^.PropType^.Name;
      if vTipoBase = 'Boolean' then
        Result.AddB(vNome, (GetOrdProp(Self, vPropInfo) = 1), vTipoField)
      else if vTipoBase = 'TDateTime' then
        Result.AddD(vNome, GetFloatProp(Self, vPropInfo), vTipoField)
      else if vTipoBase = 'Float' then
        Result.AddF(vNome, GetFloatProp(Self, vPropInfo), vTipoField)
      else if vTipoBase = 'Integer' then
        Result.AddI(vNome, GetOrdProp(Self, vPropInfo), vTipoField)
      else if vTipoBase = 'String' then
        Result.AddS(vNome, GetStrProp(Self, vPropInfo), vTipoField);
    end;
  finally
    FreeMem(vList);
  end;
end;

procedure TmObjeto.SetValues;
var
  vPropInfo : PPropInfo;
  vNome, vTipoBase : String;
  I : Integer;
begin
  with AValues do
    for I := 0 to Count - 1 do begin
      vNome := Items[I].Nome;
      vPropInfo := GetPropInfo(Self, vNome);

      //-- read-only
      if vPropInfo^.SetProc = nil then
        Continue;

      vTipoBase := vPropInfo^.PropType^.Name;
      if vTipoBase = 'Boolean' then
        SetOrdProp(Self, vNome, IfThen(ItemsB[I].Value, 1, 0))
      else if vTipoBase = 'TDateTime' then
        SetFloatProp(Self, vNome, ItemsD[I].Value)
      else if vTipoBase = 'Float' then
        SetFloatProp(Self, vNome, ItemsF[I].Value)
      else if vTipoBase = 'Integer' then
        SetOrdProp(Self, vNome, ItemsI[I].Value)
      else if vTipoBase = 'String' then
        SetStrProp(Self, vNome, ItemsS[I].Value);
    end;
end;

//--

procedure TmObjeto.ToObjeto;
begin
  TmObjeto(AObjectTo).SetValues(GetValues());
end;

//--

end.
