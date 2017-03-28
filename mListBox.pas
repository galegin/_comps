unit mListBox;

interface

uses
  SysUtils, Classes, Controls, StdCtrls,
  Variants, StrUtils,
  mKeyValue;

type
  TmListBox = class(TListBox)
  private
    FCampo: String;
    FLista : TmKeyValueList;
    procedure ClrLista;
    procedure AddLista(const Value: TmKeyValue);
    procedure SetLista(const Value: TmKeyValueList);
    function GetValue: TmKeyValue;
    procedure SetValue(const Value: TmKeyValue);
  protected
  public
    constructor create(Aowner : TComponent); override;
  published
    property _Campo : String read FCampo write FCampo;
    property _Lista : TmKeyValueList read FLista write SetLista;
    property _Value : TmKeyValue read GetValue write SetValue;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmListBox]);
end;

{ TmListBox }

constructor TmListBox.create(Aowner: TComponent);
begin
  inherited create(Aowner);
  FLista := TmKeyValueList.Create;
end;

//--

procedure TmListBox.ClrLista;
begin
  FLista.Clear;
  Items.Clear;
end;

procedure TmListBox.AddLista(const Value: TmKeyValue);
begin
  FLista.Add(Value);
  Items.AddObject(Value.Display, Value);
end;

procedure TmListBox.SetLista(const Value: TmKeyValueList);
var
  I : Integer;
begin
  ClrLista;
  with FLista do
    for I := 0 to Count - 1 do
      AddLista(Items[I]);
end;

//--

function TmListBox.GetValue: TmKeyValue;
begin
  Result := FLista.Items[ItemIndex];
end;

procedure TmListBox.SetValue(const Value: TmKeyValue);
begin
  ItemIndex := FLista.IndexOf(Value);
end;

end.