unit mObjetoJson;

interface

uses
  Classes, SysUtils,
  mProperty, mObjeto,
  ulkJSON;

type
  TmObjetoJson = class
  public
    class function ObjetoToJson(AObjeto : TObject) : String;
    class function JsonToObjeto(AClasse : TClass; AJson : String) : TObject;
  end;

implementation

{ TmObjetoJson }

class function TmObjetoJson.ObjetoToJson(AObjeto : TObject) : String;
var
  vJSONobject : TlkJSONobject;
  vValues : TmPropertyList;
  vValue : TmProperty;
  I : Integer;
begin
  vValues := TmObjeto.GetValues(AObjeto);

  vJSONobject := TlkJSONobject.Create();

  for I := 0 to vValues.Count - 1 do begin
    vValue := TmProperty(vValues[I]);

    with vValue do begin
      case Tipo of
        tppBoolean: begin
          vJSONobject.Add(Nome, TlkJSONboolean.Generate(ValueBoolean));
        end;
        tppDateTime: begin
          vJSONobject.Add(Nome, TlkJSONstring.Generate(ValueStr));
        end;
        tppFloat: begin
          vJSONobject.Add(Nome, TlkJSONnumber.Generate(ValueFloat));
        end;
        tppInteger: begin
          vJSONobject.Add(Nome, TlkJSONnumber.Generate(ValueInteger));
        end;
        tppObject: begin
          //vJSONobject.Add(Nome, ValueToJson(ValueObject));
        end;
        tppList: begin
          //vJSONobject.Add(Nome, TlkJSONlist.Generate(ValueList));
        end;
        tppString: begin
          vJSONobject.Add(Nome, TlkJSONstring.Generate(ValueString));
        end;
        tppVariant: begin
          vJSONobject.Add(Nome, TlkJSONstring.Generate(ValueStr));
        end;
      end;
    end;

  end;

  Result := TlkJSON.GenerateText(vJSONobject);
end;

//--

class function TmObjetoJson.JsonToObjeto(AClasse : TClass; AJson : String) : TObject;
var
  vJSONobject : TlkJSONobject;
  vValues : TmPropertyList;
  vValue : TmProperty;
  I : Integer;
begin
  Result := AClasse.NewInstance;

  vValues := TmObjeto.GetValues(Result);

  vJSONobject := TlkJSON.ParseText(AJson) as TlkJSONobject;

  for I := 0 to vValues.Count - 1 do begin
    vValue := TmProperty(vValues[I]);

    with vValue do begin
      case Tipo of
        tppBoolean: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            ValueBoolean := vJSONobject.getBoolean(Nome)
          else
            ValueBoolean := False;
        end;
        tppDateTime: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            ValueDatabase := vJSONobject.getString(Nome)
          else
            ValueDateTime := 0;
        end;
        tppFloat: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            ValueFloat := vJSONobject.getDouble(Nome)
          else
            ValueFloat := 0;
        end;
        tppInteger: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            ValueInteger := vJSONobject.getInt(Nome)
          else
            ValueInteger := 0;
        end;
        tppObject: begin
          (* if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            ValueObject := vJSONobject.getObject(Nome)
          else
            ValueObject := nil; *)
        end;
        tppList: begin
          (* if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            ValueList := vJSONobject.getList(Nome);
          else
            ValueList := nil; *)
        end;
        tppString: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            ValueString := vJSONobject.getString(Nome)
          else
            ValueString := '';
        end;
        tppVariant: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            ValueVariant := vJSONobject.getString(Nome)
          else
            ValueVariant := '';
        end;

      end;
    end;

  end;

  TmObjeto.SetValues(Result, vValues);
end;

//--

end.
