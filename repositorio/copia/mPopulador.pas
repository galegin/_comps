unit mPopulador;

(* classe servico *)

interface

uses
  Classes, SysUtils, StrUtils,
  mContexto;

type
  TmPopulador = class(TComponent)
  private
    fContexto : TmContexto;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    procedure Initialize(AContexto : TmContexto); virtual;
  published
  end;

implementation

{ TmPopulador }

constructor TmPopulador.Create(AOwner : TComponent);
begin
  inherited;
end;

procedure TmPopulador.Initialize;
begin
  fContexto := AContexto;
end;

end.