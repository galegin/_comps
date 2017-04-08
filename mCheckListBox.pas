unit mCheckListBox;

interface

uses
  SysUtils, Classes, Controls,
  StdCtrls, CheckLst,
  mKeyValue;

type
  TpChk = (tpcTrue, tpcFalse, tpcInverte);

  TmCheckListBox = class(TCheckListBox)
  private
    FCampo: String;
    FLista : TmKeyValueList;
    procedure SetLista(const Value: TmKeyValueList);
    function GetValueList: TmKeyValueList;
    procedure SetValueList(const Value: TmKeyValueList);
  protected
  public
    constructor create(Aowner : TComponent); override;
  published
    property _Campo : String read FCampo write FCampo;
    property _Lista : TmKeyValueList read FLista write SetLista;
    property _ValueList : TmKeyValueList read GetValueList write SetValueList;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmCheckListBox]);
end;

{ TmCheckListBox }

constructor TmCheckListBox.create(Aowner: TComponent);
begin
  inherited;
  FLista := TmKeyValueList.Create;
end;

//--

procedure TmCheckListBox.SetLista(const Value: TmKeyValueList);
var
  I : Integer;
begin
  FLista := Value;

  Items.Clear;

  for I := 0 to FLista.Count - 1 do
    with FLista.Items[I] do
      Items.AddObject(FLista.Items[I].Display, FLista.Items[I]);
end;

//--

function TmCheckListBox.GetValueList: TmKeyValueList;
var
  I : Integer;
begin
  Result := TmKeyValueList.Create;

  for I := 0 to Items.Count - 1 do
    if Checked[I] then
      Result.Add(Items.Objects[I] as TmKeyValue);
end;

procedure TmCheckListBox.SetValueList(const Value: TmKeyValueList);
var
  I, J : Integer;
begin
  for I := 0 to Items.Count - 1 do
    Checked[I] := False;

  for I := 0 to Items.Count - 1 do
    for J := 0 to Value.Count - 1 do
      if Items[I] = Value.Items[I].Display then
        Checked[I] := True;
end;

end.