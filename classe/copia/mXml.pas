unit mXml;

interface

uses
  Classes, SysUtils, mValue, mObjeto;

type
  TmXml = class
  public
    class function GetXmlFromObjeto(AObjeto : TObject) : String;
    class procedure SetXmlToObjeto(AXml : String; AObjeto : TObject);

    class procedure putitem(var AXml : String; const ACod : String; AVal : Variant);

    class function itemB(const AXml : String; const ACod : String) : Boolean;
    class function itemD(const AXml : String; const ACod : String) : TDateTime;
    class function itemF(const AXml : String; const ACod : String) : Real;
    class function itemI(const AXml : String; const ACod : String) : Integer;
    class function itemS(const AXml : String; const ACod : String) : String;

    class procedure putitemA(var AXml : String; const ACod : String; AVal : Variant);

    class function itemAB(const AXml : String; const ACod : String) : Boolean;
    class function itemAD(const AXml : String; const ACod : String) : TDateTime;
    class function itemAF(const AXml : String; const ACod : String) : Real;
    class function itemAI(const AXml : String; const ACod : String) : Integer;
    class function itemAS(const AXml : String; const ACod : String) : String;
  end;

implementation

{ TmXml }

class function TmXml.GetXmlFromObjeto(AObjeto: TObject): String;
var
  vValues : TList;
  vValue : TmValue;
  I : Integer;
begin
  Result := '';

  vValues := TmObjeto.GetValues(AObjeto);

  for I := 0 to vValues.Count - 1 do begin
    vValue := TmValue(vValues[I]);
    if vValue.IsValueStr then
      Result := Result + '<' + UpperCase(vValue.Nome) + '>' + vValue.ValueStr +
        '</' + UpperCase(vValue.Nome) + '>' ;
  end;
end;

//--

class procedure TmXml.SetXmlToObjeto(AXml: String; AObjeto: TObject);
begin

end;

//--

class procedure TmXml.putitem(var AXml: String; const ACod: String; AVal: Variant);
begin

end;

//--

class function TmXml.itemB(const AXml, ACod: String): Boolean;
begin

end;

class function TmXml.itemD(const AXml, ACod: String): TDateTime;
begin

end;

class function TmXml.itemF(const AXml, ACod: String): Real;
begin

end;

class function TmXml.itemI(const AXml, ACod: String): Integer;
begin

end;

class function TmXml.itemS(const AXml, ACod: String): String;
begin

end;

//--

class procedure TmXml.putitemA(var AXml: String; const ACod: String; AVal: Variant);
begin

end;

//--

class function TmXml.itemAB(const AXml, ACod: String): Boolean;
begin

end;

class function TmXml.itemAD(const AXml, ACod: String): TDateTime;
begin

end;

class function TmXml.itemAF(const AXml, ACod: String): Real;
begin

end;

class function TmXml.itemAI(const AXml, ACod: String): Integer;
begin

end;

class function TmXml.itemAS(const AXml, ACod: String): String;
begin

end;

//--

end.
