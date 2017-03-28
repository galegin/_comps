unit mObjetoJson;

interface

uses
  Classes, SysUtils,
  mValue, mObjeto,
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
  vValues : TmValueList;
  vValue : TmValue;
  I : Integer;
begin
  vValues := TmObjeto.GetValues(AObjeto);

  vJSONobject := TlkJSONobject.Create();

  for I := 0 to vValues.Count - 1 do begin
    vValue := TmValue(vValues[I]);

    with vValue do begin
      case Tipo of
        tvBoolean: begin
          vJSONobject.Add(Nome, TlkJSONboolean.Generate((vValue as TmValueBool).Value));
        end;
        tvDateTime: begin
          vJSONobject.Add(Nome, TlkJSONstring.Generate((vValue as TmValueStr).Value));
        end;
        tvFloat: begin
          vJSONobject.Add(Nome, TlkJSONnumber.Generate((vValue as TmValueFloat).Value));
        end;
        tvInteger: begin
          vJSONobject.Add(Nome, TlkJSONnumber.Generate((vValue as TmValueInt).Value));
        end;
        tvObject: begin
          //vJSONobject.Add(Nome, ValueToJson((vValue as TmValueObj).Value));
        end;
        tvList: begin
          //vJSONobject.Add(Nome, TlkJSONlist.Generate((vValue as TmValueLst).Value));
        end;
        tvString: begin
          vJSONobject.Add(Nome, TlkJSONstring.Generate((vValue as TmValueStr).Value));
        end;
        tvVariant: begin
          vJSONobject.Add(Nome, TlkJSONstring.Generate((vValue as TmValueVar).Value));
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
  vValues : TmValueList;
  vValue : TmValue;
  I : Integer;
begin
  Result := AClasse.NewInstance;

  vValues := TmObjeto.GetValues(Result);

  vJSONobject := TlkJSON.ParseText(AJson) as TlkJSONobject;

  for I := 0 to vValues.Count - 1 do begin
    vValue := TmValue(vValues[I]);

    with vValue do begin
      case Tipo of
        tvBoolean: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            (vValue as TmValueBool).Value := vJSONobject.getBoolean(Nome)
          else
            (vValue as TmValueBool).Value := False;
        end;
        tvDateTime: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            (vValue as TmValueDate).Value := vJSONobject.getDouble(Nome)
          else
            (vValue as TmValueDate).Value := 0;
        end;
        tvFloat: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            (vValue as TmValueFloat).Value := vJSONobject.getDouble(Nome)
          else
            (vValue as TmValueFloat).Value := 0;
        end;
        tvInteger: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            (vValue as TmValueInt).Value := vJSONobject.getInt(Nome)
          else
            (vValue as TmValueInt).Value := 0;
        end;
        tvObject: begin
          (* if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            (vValue as TmValueObj).Value := vJSONobject.getObject(Nome)
          else
            (vValue as TmValueObj).Value :=  := nil; *)
        end;
        tvList: begin
          (* if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            (vValue as TmValueLst).Value := vJSONobject.getList(Nome);
          else
            (vValue as TmValueLst).Value := nil; *)
        end;
        tvString: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            (vValue as TmValueStr).Value := vJSONobject.getString(Nome)
          else
            (vValue as TmValueStr).Value := '';
        end;
        tvVariant: begin
          if not (vJSONobject.Field[Nome] is TlkJSONnull) then
            (vValue as TmValueVar).Value := vJSONobject.getString(Nome)
          else
            (vValue as TmValueVar).Value := '';
        end;

      end;
    end;

  end;

  TmObjeto.SetValues(Result, vValues);
end;

//--

end.
