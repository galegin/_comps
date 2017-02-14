unit mXml;

interface

uses
  Classes, SysUtils, mProperty, mObjeto;

type
  TmXml = class
  public
    class function GetXmlFromObjeto(AObjeto : TObject) : String;
  end;

implementation

{ TmXml }

class function TmXml.GetXmlFromObjeto(AObjeto: TObject): String;
var
  vValues : TList;
  vValue : TmProperty;
  I : Integer;
begin
  Result := '';

  vValues := TmObjeto.GetValues(AObjeto);

  for I := 0 to vValues.Count - 1 do begin
    vValue := TmProperty(vValues[I]);
    if vValue.IsValueStr then
      Result := Result + '<' + UpperCase(vValue.Nome) + '>' + vValue.ValueStr +
        '</' + UpperCase(vValue.Nome) + '>' ;
  end;
end;

end.