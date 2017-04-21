unit mVisualizar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mForm, StdCtrls;

type
  TF_Visualizar = class(TmForm)
    MemoConteudo: TMemo;
    procedure FormCreate(Sender: TObject);
  private
  public
    procedure ShowDialog(AConteudo : String);
  end;

  function Instance : TF_Visualizar;
  procedure Destroy;

implementation

{$R *.dfm}

var
  _instance: TF_Visualizar;

  function Instance : TF_Visualizar;
  begin
    if not Assigned(_instance) then
      _instance := TF_Visualizar.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

{ TF_Visualizar }

procedure TF_Visualizar.FormCreate(Sender: TObject);
begin
  inherited;
  WindowState := wsMaximized;
end;

procedure TF_Visualizar.ShowDialog(AConteudo: String);
begin
  MemoConteudo.Text := AConteudo;
  ShowModal;
end;

initialization
  //Instance();

finalization
  Destroy();

end.
