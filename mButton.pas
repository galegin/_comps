unit mButton;

interface

uses
  Classes, Controls, Graphics, StdCtrls, SysUtils;

type
  TmButton = class(TButton)
  private
    FParams : String;
  protected
  public
    constructor create(AOwner : TComponent); overload; override; 
    constructor create(AOwner : TComponent; AParent : TWinControl; pParams : String); overload;
  published
    property _Params : String read FParams write FParams;
  end;

procedure Register;

implementation

uses
  mItem, mXml;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmButton]);
end;

{ TmButton }

constructor TmButton.create(AOwner: TComponent);
begin
  inherited; //
end;

constructor TmButton.create(AOwner: TComponent; AParent: TWinControl; pParams: String);
begin
  inherited create(AOwner);
  Parent := AParent;
  Name := 'Button' + itemA('cod', pParams);
  Caption := itemA('des', pParams);
  TabStop := False;
  if (itemA('tpf', pParams) = 'key') then begin
    Font.Style := Font.Style + [fsBold];
  end;
  if Pos(itemA('tpf', pParams), 'key|req') > 0 then begin
    Caption := Caption + ' (*)';
  end;
  //if (itemA('ent', pParams) <> '') then begin
  //  Caption := Caption + ' [...]';
  //end;
end;

end.