unit mMapping;

interface

uses
  Classes, SysUtils, StrUtils;

type

  //-- tabela

  PmTabela = ^TmTabela;
  TmTabela = record
    Nome : String;
  end;

  //-- campo

  PmCampo = ^TmCampo;
  TmCampo = record
    Atributo : String;
    Campo : String;
  end;

  TmCampos = class(TList)
  public
    function Add() : PmCampo; overload;
    procedure Add(AAtributo, ACampo : String); overload;
    function Buscar(AAtributo: String) : PmCampo;
  end;

  //-- chave

  PmChave = ^TmCampo;

  TmChaves = class(TmCampos);

  //-- relacao

  PmRelacaoCampo = ^TmRelacaoCampo;
  TmRelacaoCampo = record
    Atributo : String;
    AtributoRel : String;
  end;

  TmRelacaoCampos = class(TList)
  public
    function Add() : PmRelacaoCampo; overload;
    procedure Add(AAtributo, AAtributoRel : String); overload;
    function Buscar(AAtributo: String) : PmRelacaoCampo;
  end;

  PmRelacao = ^TmRelacao;
  TmRelacao = record
    Tabela : PmTabela;
    Campos : TmRelacaoCampos;
  end;

  TmRelacoes = class(TList)
  public
    function Add() : PmRelacao; overload;
    procedure Add(ANome, ATabela : String); overload;
    function Buscar(ANome: String) : PmRelacao;
  end;

  //-- mapping

  PmMapping = ^RMapping;
  RMapping = record
    Tabela : PmTabela;
    Chaves : TmChaves;
    Campos : TmCampos;
    Relacoes : TmRelacoes;
  end;

  TmMapping = class;
  TmMappingClass = class of TmMapping;

  IMapping = interface
    function GetMapping() : PmMapping;
  end;

  TmMapping = class(TComponent, IMapping)
    function GetMapping() : PmMapping; virtual; abstract;
  end;

  procedure FreeMapping(var AMapping : PmMapping);

implementation

uses
  mString;

  //-- campo

  procedure FreeCampos(var ACampos : TmCampos);
  var
    I: Integer;
  begin
    for I := ACampos.Count - 1 downto 0 do begin
      Dispose(PmCampo(ACampos.Items[I]));
      ACampos.Delete(I);
    end;
  end;

  //-- relacao

  procedure FreeRelacaoCampo(var ACampos : TmRelacaoCampos);
  var
    I: Integer;
  begin
    for I := ACampos.Count - 1 downto 0 do begin
      Dispose(PmRelacaoCampo(ACampos.Items[I]));
      ACampos.Delete(I);
    end;
  end;

  procedure FreeRelacoes(var ARelacoes : TmRelacoes);
  var
    I: Integer;
  begin
    for I := ARelacoes.Count - 1 downto 0 do begin
      FreeRelacaoCampo(PmRelacao(ARelacoes).Campos);
      Dispose(PmRelacao(ARelacoes.Items[I]));
      ARelacoes.Delete(I);
    end;
  end;

  //-- mapping

  procedure FreeMapping(var AMapping : PmMapping);
  begin
    if AMapping.Tabela <> nil then
      Dispose(PmTabela(AMapping.Tabela));
    if AMapping.Campos <> nil then
      FreeCampos(AMapping.Campos);
    if AMapping.Chaves <> nil then
      FreeCampos(TmCampos(AMapping.Chaves));
    if AMapping.Relacoes <> nil then
      FreeRelacoes(AMapping.Relacoes);
    if AMapping <> nil then
      Dispose(PmMapping(AMapping));
  end;

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

function TmCampos.Buscar(AAtributo: String): PmCampo;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    with PmCampo(Items[I])^ do
      if Atributo = AAtributo then begin
        Result := PmCampo(Items[I]);
        Exit;
      end;
end;

{ TmRelacaoCampos }

function TmRelacaoCampos.Add: PmRelacaoCampo;
begin
  Result := New(PmRelacaoCampo);
  Self.Add(Result);
end;

procedure TmRelacaoCampos.Add(AAtributo, AAtributoRel: String);
begin
  with Self.Add^ do begin
    Atributo := AAtributo;
    AtributoRel := IfThen(AAtributoRel <> '', AAtributoRel, AAtributo);
  end;
end;

function TmRelacaoCampos.Buscar(AAtributo: String): PmRelacaoCampo;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    with PmRelacaoCampo(Items[I])^ do
      if Atributo = AAtributo then begin
        Result := PmRelacaoCampo(Items[I]);
        Exit;
      end;
end;

{ TmRelacoes }

function TmRelacoes.Add: PmRelacao;
begin
  Result := New(PmRelacao);
  Self.Add(Result);
end;

procedure TmRelacoes.Add(ANome, ATabela: String);
begin
  with Self.Add^ do begin
    ANome := ANome;
    ATabela := IfThen(ATabela <> '', ATabela, ANome);
  end;
end;

function TmRelacoes.Buscar(ANome: String): PmRelacao;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    with PmRelacao(Items[I])^ do
      if ANome = ANome then begin
        Result := PmRelacao(Items[I]);
        Exit;
      end;
end;

end.
