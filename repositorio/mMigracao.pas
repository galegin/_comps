unit mMigracao;

(* criar / atualizar estrutura database *)

interface

uses
  Classes, SysUtils, StrUtils,
  mContexto, mCollectionCreate;

type
  TrMigracao_Script = record
    Versao : String;
    Comando : String;
  end;

  TmMigracao = class(TComponent)
  private
    fContexto : TmContexto;
    fScripts : Array Of TrMigracao_Script;
  protected
  public
    constructor Create(AOwner : TComponent); override;

    procedure ClearScript();
    procedure AddScript(AScript : TrMigracao_Script);

    procedure Initialize(AContexto : TmContexto); virtual;
    procedure CreateDatabase(); virtual;
    procedure UpdateDatabase(); virtual;

  published
  end;

implementation

{ TmMigracao }

constructor TmMigracao.Create;
begin
  inherited;
end;

//--

procedure TmMigracao.ClearScript;
begin
  SetLength(fScripts, 0);
end;

procedure TmMigracao.AddScript;
begin
  SetLength(fScripts, Length(fScripts) + 1);
  fScripts[High(fScripts)] := AScript;
end;

//--

procedure TmMigracao.Initialize;
begin
  fContexto := AContexto;
  CreateDatabase;
  UpdateDatabase;
end;

procedure TmMigracao.CreateDatabase;
var
  I : Integer;
begin
  with fContexto do
    for I := Low(Entidades) to High(Entidades) do
      mCollectionCreate.Instance.CreateOrAlter(
        fContexto, Entidades[I]);
end;

procedure TmMigracao.UpdateDatabase;
var
  I : Integer;
begin
  for I := Low(fScripts) to High(fScripts) do
    with fScripts[I] do
      fContexto.Conexao.ExecComando(Comando);
end;

end.