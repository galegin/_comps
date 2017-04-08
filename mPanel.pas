unit mPanel;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, Graphics, Windows,
  StdCtrls, DB, Forms, mOrientacaoFrame;

type
  TmPanel = class(TPanel)
  private
    fOrientacao : TOrientacaoFrame;
  protected
  public
    constructor Create(Owner : TComponent); override;
  published
    property Orientacao : TOrientacaoFrame read fOrientacao write fOrientacao;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmPanel]);
end;

{ TmPanel }

constructor TmPanel.Create(Owner: TComponent);
begin
  inherited;
  Caption := ' ';
end;

end.