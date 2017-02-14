unit mListBox;

interface

uses
  SysUtils, Classes, Controls, StdCtrls,
  Variants, StrUtils,
  mStringList;

type
  TmListBox = class(TListBox)
  private
    FCampo: String;
    function GetValue: String;
    procedure SetValue(const Value: String);
    function GetValueDs: String;
    function GetLista: String;
    procedure SetLista(const Value: String);
  protected
  public
    constructor create(Aowner : TComponent); override;

    procedure Limpar;
    procedure Adicionar(pCod : String); overload;
    procedure Adicionar(pCod, pDes : String); overload;
    procedure AdicionarLst(pLst : String; pPad : String = '');
    procedure Retirar(pCod : String);

    procedure AdicionarVr(pCod : String; pVar : Variant);
    function PegarCd(pInd : Integer = -2) : String; overload;
    function PegarCd(pCod : String) : String; overload;
    function PegarVr(pInd : Integer = -2) : Variant; overload;
    function PegarVr(pCod : String) : Variant; overload;
    procedure RetirarVr(pCod : String);
  published
    property _Campo : String read FCampo write FCampo;
    property _Value : String read GetValue write SetValue;
    property _Lista : String read GetLista write SetLista;
    property _ValueDs : String read GetValueDs; // write SetValueDs;
    //property _Values : TmVariant	
  end;

procedure Register;

implementation

uses
  mFuncao, mItem;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmListBox]);
end;

{ TmListBox }

constructor TmListBox.create(Aowner: TComponent);
begin
  inherited create(Aowner);
end;

//--

function TmListBox.GetValue: String;
begin
  Result := TmStringList(Items).getValueOf(ItemIndex);
end;

procedure TmListBox.SetValue(const Value: String);
begin
  ItemIndex := TmStringList(Items).prcIndexOf(Value);
end;

//--

function TmListBox.GetValueDs: String;
begin
  Result := TmStringList(Items).GetValueDs(ItemIndex);
end;

//--

function TmListBox.GetLista: String;
begin
  Result := TmStringList(Items).GetLista();
end;

procedure TmListBox.SetLista(const Value: String);
begin
  AdicionarLst(Value);
end;

//--

procedure TmListBox.Limpar;
begin
  TmStringList(Items).Limpar();
end;

procedure TmListBox.Adicionar(pCod, pDes: String);
begin
  TmStringList(Items).Adicionar(pCod, pDes);
end;

procedure TmListBox.Adicionar(pCod: String);
begin
  TmStringList(Items).Adicionar(pCod);
end;

procedure TmListBox.AdicionarLst(pLst, pPad: String);
begin
  TmStringList(Items).AdicionarLst(pLst, pPad);
end;

procedure TmListBox.Retirar(pCod: String);
begin
  TmStringList(Items).Retirar(pCod);
end;

//--

procedure TmListBox.AdicionarVr(pCod: String; pVar: Variant);
begin
  TmStringList(Items).AdicionarVr(pCod, pVar);
end;

function TmListBox.PegarCd(pInd: Integer): String;
begin
  if (pInd = -2) then pInd := ItemIndex;
  TmStringList(Items).PegarCd(pInd);
end;

function TmListBox.PegarCd(pCod: String): String;
begin
  TmStringList(Items).PegarCd(pCod);
end;

function TmListBox.PegarVr(pInd: Integer): Variant;
begin
  if (pInd = -2) then pInd := ItemIndex;
  TmStringList(Items).PegarVr(pInd);
end;

function TmListBox.PegarVr(pCod: String): Variant;
begin
  TmStringList(Items).PegarVr(pCod);
end;

procedure TmListBox.RetirarVr(pCod: String);
begin
  TmStringList(Items).RetirarVr(pCod);
end;

//--

end.