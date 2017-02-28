unit mCripto;

interface

uses
  Classes, SysUtils;

type
  TmCripto = class
  public
    class function Encrypt(AString, AChave : String) : String;
    class function Decrypt(AString, AChave : String) : String;
  end;

implementation

  function rtncodificar(ParString, ParChave: String): String;
  var
    TamanhoChave, TamanhoString, PosLetra, Pos, I : Integer;
  begin
    Result := ParString;
    TamanhoString := Length(ParString);
    TamanhoChave := Length(ParChave);
    for I := 1 to TamanhoString do begin
      Pos := (I mod TamanhoChave);
      if Pos = 0 then 
	    Pos := TamanhoChave;

		PosLetra := ord(Result[I]) xor ord(parChave[Pos]);
      if PosLetra = 0 then 
	    PosLetra := ord(Result[I]);

		Result[I] := chr(PosLetra);
    end;
  end;

class function TmCripto.Encrypt(AString, AChave : String) : String;
begin
  Result := rtncodificar(AString, AChave);
end;

class function TmCripto.Decrypt(AString, AChave : String) : String;
begin
  Result := rtncodificar(AString, AChave);
end;

end.