unit mTipoTecla;

interface

uses
  Classes;

type
  TSetOfChar = Set Of Char;

  TmTipoTecla = class
  public
    class function GetLstDigitos : TSetOfChar;
    class function GetLstLetras : TSetOfChar;
    class function GetLstSimbolos : TSetOfChar;
    class function GetLstData : TSetOfChar;
    class function GetLstInteiro : TSetOfChar;
    class function GetLstNumero : TSetOfChar;
    class function GetLstTexto : TSetOfChar;
    class function GetLstEmail : TSetOfChar;
    class function GetLstSenha : TSetOfChar;
    class function GetLstSite : TSetOfChar;
  end;

implementation

class function TmTipoTecla.GetLstDigitos : TSetOfChar;
begin
  Result := ['0'..'9'];
end;

class function TmTipoTecla.GetLstLetras : TSetOfChar;
begin
  Result := ['a'..'z', 'A'..'Z'];
end;

class function TmTipoTecla.GetLstSimbolos : TSetOfChar;
begin
  Result := ['.', ',', '!', '@', '#', '%', '$', '%', '&', '*', '(', ')',
    '[', ']', '{', '}', '_', '-', '+', '=', '/', '\', '?', '<', '>', ':', ' '];
end;

class function TmTipoTecla.GetLstData : TSetOfChar;
begin
  Result := GetLstDigitos + ['/', ':', Chr(8)];
end;

class function TmTipoTecla.GetLstInteiro : TSetOfChar;
begin
  Result := GetLstDigitos + [Chr(8)];
end;

class function TmTipoTecla.GetLstNumero : TSetOfChar;
begin
  Result := GetLstDigitos + [',', Chr(8)];
end;

class function TmTipoTecla.GetLstTexto : TSetOfChar;
begin
  Result := GetLstDigitos + GetLstLetras + GetLstSimbolos + [Chr(8)];
end;

class function TmTipoTecla.GetLstEmail : TSetOfChar;
begin
  Result := GetLstDigitos + GetLstLetras + ['@', '.', Chr(8)];
end;

class function TmTipoTecla.GetLstSenha : TSetOfChar;
begin
  Result := GetLstDigitos + GetLstLetras + ['!', '@', '#', '$', '%', '?', Chr(8)];
end;

class function TmTipoTecla.GetLstSite : TSetOfChar;
begin
  Result := GetLstDigitos + GetLstLetras + ['.', Chr(8)];
end;

end.
