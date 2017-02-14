unit mMemo;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, StrUtils, Windows;

type
  TmMemo = class(TMemo)
  private
    FArquivo : String;
    FCaminho : String;
    FCampo : String;
    function GetValue: String;
    procedure SetValue(const Value: String);
  protected
  public
    procedure carregar(pArquivo : String = '');
    procedure descarregar();
    procedure corrigir();
  published
    property _Arquivo : String read FArquivo write FArquivo;
    property _Caminho : String read FCaminho write FCaminho;
    property _Campo : String read FCampo write FCampo;
    property _Value : String read GetValue write SetValue;
  end;

procedure Register;

implementation

uses
  mArquivo, mPath, mFuncao, mConst, mItem;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmMemo]);
end;

  function TmMemo.GetValue: String;
  var
    I : Integer;
  begin
    Result := '';
    for I:=0 to Lines.Count-1 do begin
      putitem(Result, Lines[I]);
    end;
  end;

  procedure TmMemo.SetValue(const Value: String);
  begin
    Lines.Text := Value;
  end;

{ TmMemo }

procedure TmMemo.carregar(pArquivo: String);
begin
  FArquivo := IfThen(pArquivo <> '', pArquivo, FArquivo);
  FCaminho := mPath.caminho(FArquivo, '.txt');
  Lines.Text := mArquivo.carregarCripto(FCaminho);
end;

procedure TmMemo.descarregar;
begin
  mArquivo.descarregarCripto(FCaminho, Lines.Text);
end;

procedure TmMemo.corrigir;
var
  I : Integer;
begin
  for I:=0 to Lines.Count-1 do begin
    Lines[I] := AnsiReplaceStr(Lines[I], Chr(VK_TAB), ' ');
    Lines[I] := AllTrim(Lines[I]);
    Lines[I] := RemoveAcento(Lines[I]);
  end;

  Lines[0] := Lines[0];

  //SelStart := 0;
end;

end.