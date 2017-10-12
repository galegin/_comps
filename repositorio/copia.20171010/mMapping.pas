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

  TTipoCampo = (tfKey, tfReq, tfNul);

  PmCampo = ^TmCampo;
  TmCampo = record
    Atributo : String;
    Campo : String;
    TipoCampo : TTipoCampo;
  end;

  TmCampos = class(TList)
  public
    function Add() : PmCampo; overload;
    procedure Add(AAtributo, ACampo : String; ATipoCampo : TTipoCampo = tfNul); overload;
    function Buscar(AAtributo: String) : PmCampo;
  end;

  //-- relacao

  PmRelacaoCampo = ^TmRelacaoCampo;
  TmRelacaoCampo = record
    Atributo : String;
    AtributoRel : String;
  end;

  TmRelacaoCampos = class(TList)
  public
    function Add() : PmRelacaoCampo; overload;
    procedure Add(AAtributo : String; AAtributoRel : String = ''); overload;
    function Buscar(AAtributo : String) : PmRelacaoCampo;
  end;

  PmRelacao = ^TmRelacao;
  TmRelacao = record
    Atributo : String;
    Classe : TClass;
    ClasseLista : TClass;
    Campos : TmRelacaoCampos;
  end;

  TmRelacoes = class(TList)
  public
    function Add() : PmRelacao; overload;
    function Add(AAtributo : String; AClasse : TClass; AClasseLista : TClass = nil) : PmRelacao; overload;
    function Buscar(AAtributo : String) : PmRelacao;
  end;

  //-- mapping

  PmMapping = ^RMapping;
  RMapping = record
    Tabela : PmTabela;
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
      FreeRelacaoCampo(PmRelacao(ARelacoes.Items[I])^.Campos);
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

procedure TmCampos.Add(AAtributo, ACampo: String; ATipoCampo: TTipoCampo);
begin
  with Self.Add^ do begin
    Atributo := AAtributo;
    Campo := IfThen(ACampo <> '', ACampo, AAtributo);
    TipoCampo := ATipoCampo;
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
  Result.Campos := TmRelacaoCampos.Create;
  Self.Add(Result);
end;

function TmRelacoes.Add(AAtributo : String; AClasse, AClasseLista : TClass) : PmRelacao;
begin
  Result := Self.Add;
  with Result^ do begin
    Atributo := AAtributo;
    Classe := AClasse;
    ClasseLista := AClasseLista;
  end;
end;

function TmRelacoes.Buscar(AAtributo : String): PmRelacao;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    with PmRelacao(Items[I])^ do
      if Atributo = AAtributo then begin
        Result := PmRelacao(Items[I]);
        Exit;
      end;
end;

end.
