unit mAppMessage;

interface

uses
  Classes, SysUtils, Windows, Forms, Controls, StdCtrls, Grids, Messages;

type
  TmAppMessage = class(TComponent)
  public
    constructor create(Aowner : TComponent); override;
    procedure AppMessage(var Msg: tagMSG; var Handled: Boolean);
  end;

  function getInstance() : TmAppMessage;
  procedure dropInstance();

implementation

uses
  mIniFiles;

var
  instance : TmAppMessage;

  function getInstance() : TmAppMessage;
  begin
    if mIniFiles.pegarB('', '', 'inEnter') then
      if instance = nil then
        instance := TmAppMessage.create(nil);

    Result := instance;
  end;

  procedure dropInstance();
  begin
    if instance <> nil then
      instance.Free;
  end;

constructor TmAppMessage.create(Aowner: TComponent);
begin
  inherited;
  Application.OnMessage := AppMessage;
end;

procedure TmAppMessage.AppMessage(var Msg: tagMSG; var Handled: Boolean);
const
  cLST_CLASSIGNORE = 'T_Dialog|TWebBrowser|TMessageForm';
var
  vClassName : String;
begin
  with Screen do begin
    if (ActiveControl = nil) then Exit;

    if not ((ActiveControl is TCustomMemo)
         or (ActiveControl is TCustomGrid)
         or (ActiveControl is TCustomComboBox)) then begin

      vClassName := ActiveForm.ClassName;
      if Pos(vClassName, cLST_CLASSIGNORE) > 0 then Exit;

      if Msg.message = WM_KEYDOWN then begin
        case Msg.wParam of
          VK_RETURN, VK_DOWN : ActiveForm.Perform(WM_NextDlgCtl,0,0);
          VK_UP : ActiveForm.Perform(WM_NextDlgCtl,1,0);
        end;
      end;
    end;
  end;
end;

initialization
  getInstance();

finalization
  dropInstance();

end.