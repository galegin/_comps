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

  function Instance() : TmAppMessage;
  procedure Destroy();

implementation

uses
  mIniFiles;

var
  _instance : TmAppMessage;

  function Instance() : TmAppMessage;
  begin
    if TmIniFiles.PegarB('', '', 'In_Enter') then
      if not Assigned(_instance) then
        _instance := TmAppMessage.create(nil);
    Result := _instance;
  end;

  procedure Destroy();
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

  //--

  function IsClasseForm(AClasse : String) : Boolean;
  const
    LClasseForm : Array [0..2] of String = (
      'T_Dialog', 'TWebBrowser', 'TMessageForm');
  var
    I : Integer;
  begin
    Result := False;
    for I := Low(LClasseForm) to High(LClasseForm) do
      if LClasseForm[I] = AClasse then begin
        Result := True;
        Exit;
      end;
  end;

  function IsClasseComp(AClasse : TClass) : Boolean;
  const
    LClasseComp : Array [0..2] of TClass = (
      TCustomMemo, TCustomGrid, TCustomComboBox);
  var
    I : Integer;
  begin
    Result := False;
    for I := Low(LClasseComp) to High(LClasseComp) do
      if LClasseComp[I] = AClasse then begin
        Result := True;
        Exit;
      end;
  end;

constructor TmAppMessage.create(Aowner: TComponent);
begin
  inherited;
  Application.OnMessage := AppMessage;
end;

procedure TmAppMessage.AppMessage(var Msg: tagMSG; var Handled: Boolean);
begin
  with Screen do
    if not IsClasseForm(ActiveForm.ClassName) then
      if Assigned(ActiveControl) and not IsClasseComp(ActiveControl.ClassType) then
        if Msg.message = WM_KEYDOWN then
          case Msg.wParam of
            VK_RETURN, VK_DOWN : ActiveForm.Perform(WM_NextDlgCtl,0,0);
            VK_UP : ActiveForm.Perform(WM_NextDlgCtl,1,0);
          end;
end;

initialization
  Instance();

finalization
  Destroy();

end.