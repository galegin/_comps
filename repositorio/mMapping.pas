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
  vAtributo, vCampo : String;
  vCampoStr : TmStringArray;
  I : Integer;
begin
  SetLength(AResult, Length(ACampos));

  for I := 0 to High(ACampos) do begin
    vCampoStr := TmString.Split(ACampos[I], '|');
    AResult[I].Atributo := vCampoStr[0];
    AResult[I].Campo := IfThen(Length(vCampoStr) > 1, vCampoStr[1], vCampoStr[0]);
  end;
end;

procedure AddCamposResult(var AResult : TmCampos; ACampos : Array Of String);
var
  vAtributo, vCampo : String;
  vCampoStr : TmStringArray;
  I : Integer;
begin
  SetLength(AResult, Length(ACampos));

  for I := 0 to High(ACampos) do begin
    vCampoStr := TmString.Split(ACampos[I], '|');
    AResult[I].Atributo := vCampoStr[0];
    AResult[I].Campo := IfThen(Length(vCampoStr) > 1, vCampoStr[1], vCampoStr[0]);
  end;
end;

end.
