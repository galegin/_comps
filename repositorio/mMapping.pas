unit mMapping;

interface

uses
  Classes;

type
  TmMapping = class;
  TmMappingClass = class of TmMapping;

  TmTabela = record
    Nome : String;
  end;

  TmCampo = record
    Atributo : String;
    Campo : String;
  end;

  TmKeys = Array Of TmCampo;
  TmCampos = Array Of TmCampo;

  RMapping = record
    Tabela : TmTabela;
    Keys : TmKeys;
    Campos : TmCampos;
  end;

  IMapping = interface
    function GetTabela() : TmTabela;
    function GetKeys() : TmKeys;
    function GetCampos() : TmCampos;
  end;

  TmMapping = class(TComponent, IMapping)
    function GetTabela() : TmTabela; virtual; abstract;
    function GetKeys() : TmKeys; virtual; abstract;
    function GetCampos() : TmCampos; virtual; abstract;
  end;

  procedure AddKeysResult(var AResult : TmKeys; ACampos : Array Of String);
  procedure AddCamposResult(var AResult : TmCampos; ACampos : Array Of String);

implementation

procedure AddKeysResult(var AResult : TmKeys; ACampos : Array Of String);
var
  vCampoStr, vAtributo, vCampo : String;
  P, I : Integer;
begin
  SetLength(AResult, Length(ACampos));

  for I := 0 to High(ACampos) do begin
    vCampoStr := ACampos[I];
    P := Pos('|', vCampoStr);
    if P > 0 then begin
      vAtributo := Copy(vCampoStr, 1, P - 1);
      Delete(vCampoStr, 1, P);
      vCampo := vCampoStr;
    end else begin
      vAtributo := vCampoStr;
      vCampo := vCampoStr;
    end;

    if vCampo = '' then
      vCampo := vAtributo;

    AResult[I].Atributo := vAtributo;
    AResult[I].Campo := vCampo;
  end;
end;

procedure AddCamposResult(var AResult : TmCampos; ACampos : Array Of String);
var
  vCampoStr, vAtributo, vCampo : String;
  P, I : Integer;
begin
  SetLength(AResult, Length(ACampos));

  for I := 0 to High(ACampos) do begin
    vCampoStr := ACampos[I];
    P := Pos('|', vCampoStr);
    if P > 0 then begin
      vAtributo := Copy(vCampoStr, 1, P - 1);
      Delete(vCampoStr, 1, P);
      vCampo := vCampoStr;
    end else begin
      vAtributo := vCampoStr;
      vCampo := vCampoStr;
    end;

    if vCampo = '' then
      vCampo := vAtributo;

    AResult[I].Atributo := vAtributo;
    AResult[I].Campo := vCampo;
  end;
end;

end.
