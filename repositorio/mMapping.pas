unit mMapping;

interface

uses
  Classes, SysUtils, StrUtils;

type
  PmTabela = ^TmTabela;
  TmTabela = record
    Nome : String;
  end;

  PmCampo = ^TmCampo;
  TmCampo = record
    Atributo : String;
    Campo : String;
  end;

  PmChave = ^TmChave;
  TmChave = record
    Atributo : String;
    Campo : String;
  end;

  TmCampos = class(TList)
  public
    function Add() : PmCampo; overload;
    procedure Add(AAtributo, ACampo : String); overload;
  end;

  TmChaves = class(TmCampos);

  PmMapping = ^RMapping;
  RMapping = record
    Tabela : TmTabela;
    Chaves : TmChaves;
    Campos : TmCampos;
  end;

  TmMapping = class;
  TmMappingClass = class of TmMapping;

  IMapping = interface
    function GetMapping() : PmMapping;
  end;

  TmMapping = class(TComponent, IMapping)
    function GetMapping() : PmMapping; virtual; abstract;
  end;

implementation

uses
  mString;

{ TmCampos }

function TmCampos.Add: PmCampo;
begin
  Result := New(PmCampo);
  Self.Add(Result);
end;

procedure TmCampos.Add(AAtributo, ACampo: String);
begin
  with Self.Add^ do begin
    Atributo := AAtributo;
    Campo := IfThen(ACampo <> '', ACampo, AAtributo);
  end;
end;

end.
