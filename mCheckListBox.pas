unit mCheckListBox;

interface

uses
  SysUtils, Classes, Controls,
  StdCtrls, CheckLst,
  mStringList;

type
  TpChk = (tpcTrue, tpcFalse, tpcInverte);

  TmCheckListBox = class(TCheckListBox)
  private
    FCampo: String;
    function GetValue: String;
    procedure SetValue(const Value: String);
    function GetLista: String;
    procedure SetLista(const Value: String);
    function GetCheck: Boolean;
    procedure SetCheck(const Value: Boolean);
    function GetListaCheck: String;
    procedure SetListaCheck(const Value: String);
    function GetValues(Index: Integer): String;
    procedure SetValues(Index: Integer; const Value: String);
  protected
  public
    constructor create(Aowner : TComponent); override;

    procedure Limpar;
    procedure Adicionar(pCod : String); overload;
    procedure Adicionar(pCod, pDes : String); overload;
    procedure AdicionarLst(pLst : String; pPad : String = '');
    procedure Retirar(pCod : String);

    procedure Checar(pInd : Integer; pChk : TpChk = tpcInverte);
    procedure ChecarVal(pVal : String; pChk : TpChk = tpcInverte);
    procedure ChecarTodos(pChk : TpChk = tpcInverte);

    property Values[Index: Integer]: String read GetValues write SetValues; default;
  published
    property _Campo : String read FCampo write FCampo;
    property _Value : String read GetValue write SetValue;
    property _Check : Boolean read GetCheck write SetCheck;
    property _Lista : String read GetLista write SetLista;
    property _ListaCheck : String read GetListaCheck write SetListaCheck;
    // property _Values : TmVariant
  end;

procedure Register;

implementation

uses
  mItem;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmCheckListBox]);
end;

{ TmCheckListBox }

constructor TmCheckListBox.create(Aowner: TComponent);
begin
  inherited create(Aowner);
end;

//--

function TmCheckListBox.GetValue: String;
begin
  Result := TmStringList(Items).getValueOf(ItemIndex);
end;

procedure TmCheckListBox.SetValue(const Value: String);
begin
  ItemIndex := TmStringList(Items).prcIndexOf(Value);
end;

//--

function TmCheckListBox.GetLista: String;
begin
  Result := TmStringList(Items).GetLista();
end;

procedure TmCheckListBox.SetLista(const Value: String);
begin
  AdicionarLst(Value);
end;

//--

function TmCheckListBox.GetCheck: Boolean;
begin
  if ItemIndex > -1 then
    Result := Checked[ItemIndex]
  else
    Result := False
end;

procedure TmCheckListBox.SetCheck(const Value: Boolean);
begin
  if ItemIndex > -1 then
    Checked[ItemIndex] := Value;
end;

//--

procedure TmCheckListBox.Limpar;
begin
  TmStringList(Items).Limpar();
end;

procedure TmCheckListBox.Adicionar(pCod, pDes: String);
begin
  TmStringList(Items).Adicionar(pCod, pDes);
end;

procedure TmCheckListBox.Adicionar(pCod: String);
begin
  TmStringList(Items).Adicionar(pCod);
end;

procedure TmCheckListBox.AdicionarLst(pLst, pPad: String);
begin
  TmStringList(Items).AdicionarLst(pLst, pPad);
end;

procedure TmCheckListBox.Retirar(pCod: String);
begin
  TmStringList(Items).Retirar(pCod);
end;

//--

procedure TmCheckListBox.Checar(pInd : Integer; pChk : TpChk);
begin
  if (pInd = -1) then Exit;

  if (pChk = tpcTrue) then
    Checked[pInd] := True
  else if (pChk = tpcFalse) then
    Checked[pInd] := False
  else if (pChk = tpcInverte) then
    Checked[pInd] := not Checked[pInd];
end;

procedure TmCheckListBox.ChecarVal(pVal : String; pChk : TpChk);
var
  I : Integer;
begin
  I := TmStringList(Items).prcIndexOf(pVal);
  if (I > -1) then Checar(I, pChk);
end;

procedure TmCheckListBox.ChecarTodos(pChk : TpChk = tpcInverte);
var
  I : Integer;
begin
  for I:=0 to Items.Count-1 do begin
    Checar(I, pChk);
  end;
end;

//--

function TmCheckListBox.GetListaCheck: String;
var
  vCod, vDes : String;
  I, T : Integer;
  vChk : Boolean;
begin
  Result := '';

  T := Items.Count - 1;

  for I:=0 to T do begin
    vCod := TmStringList(Items).getValueOf(I);
    vDes := Items[I];
    vChk := Checked[I];
    if (vChk) then begin
      if (vCod <> vDes) then begin
        putitem(Result, vCod, vDes);
      end else begin
        putitem(Result, vCod);
      end;
    end;  
  end;
end;

procedure TmCheckListBox.SetListaCheck(const Value: String);
var
  vLstVal, vVal : String;
begin
  ChecarTodos(tpcFalse);

  vLstVal := Value;
  while vLstVal <> '' do begin
    vVal := getitem(vLstVal);
    if vVal = '' then Break;
    delitem(vLstVal);
    ChecarVal(vVal, tpcTrue);
  end;
end;

//--

function TmCheckListBox.GetValues(Index: Integer): String;
begin
  Result := TmStringList(Items).PegarVr(Index);
end;

procedure TmCheckListBox.SetValues(Index: Integer; const Value: String);
begin

end;

end.