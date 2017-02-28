unit mRegister;

interface

uses
  Classes, SysUtils, Registry, Windows;

type
  TmRegister = class
  published
    class function Read(pReg, pKey : String) : String;
    class procedure Write(pReg, pKey, pVal : String);
  end;

implementation

// ReadRegistry
class function TmRegister.Read(pReg, pKey : String) : String;
var
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER; //HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(pReg, False) then begin
      Result := Reg.ReadString(pKey);
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

// WriteRegistry
class procedure TmRegister.Write(pReg, pKey, pVal : String);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER; //HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(pReg, True) then begin
      Reg.WriteString(pKey, pVal);
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

end.