unit mBase64;

(* classe *)

interface

uses
  Classes, SysUtils, StrUtils, EncdDecd;

type
  TmBase64 = class
  public
    class function Decode(AString : String) : String;
    class function Encode(AString : String) : String;
  end;

implementation

{ TmBase64 }

class function TmBase64.Decode(AString: String): String;
begin
  Result := AString;
  Result := AnsiReplaceStr(Result, '#sLineBreak#', sLineBreak);
  Result := DecodeString(Result);
end;

class function TmBase64.Encode(AString: String): String;
begin
  Result := AString;
  Result := EncodeString(Result);
  Result := AnsiReplaceStr(Result, sLineBreak, '#sLineBreak#');
end;

end.