unit mVersaoArquivo;

interface

uses
  Classes, SysUtils, StrUtils, Windows, Forms;

type
  TcVersaoArquivo = class
  private
    fAno : Integer;
    fMes : Integer;
    fDia : Integer;
    fRel : Integer;
    function GetStr: String;
  public
    constructor Create(AAno, AMes, ADia, ARel : Integer);
  published
    property Ano : Integer read fAno;
    property Mes : Integer read fMes;
    property Dia : Integer read fDia;
    property Rel : Integer read fRel;
    property Str : String read GetStr;
  end;

  TmVersaoArquivo = class
  public
    class function Codigo(AArquivo : String) : String;
    class function Versao(AArquivo : String) : TcVersaoArquivo;
  end;

implementation

{ TcVersaoArquivo }

constructor TcVersaoArquivo.Create(AAno, AMes, ADia, ARel: Integer);
begin
  fAno := AAno;
  fMes := AMes;
  fDia := ADia;
  fRel := ARel;
end;

function TcVersaoArquivo.GetStr: String;
begin
  Result :=
    FormatFloat('00', fAno) + '.' +
    FormatFloat('00', fMes) + '.' +
    FormatFloat('00', fDia) + '.' +
    FormatFloat('00', fRel);
end;

{ TmVersaoArquivo }

class function TmVersaoArquivo.Codigo(AArquivo: String): String;
begin
  Result := AnsiReplaceStr(ExtractFileName(AArquivo), ExtractFileExt(AArquivo), '');
end;

class function TmVersaoArquivo.Versao(AArquivo: String): TcVersaoArquivo;
type
  PFFI = ^vs_FixedFileInfo;
var
  F : PFFI;
  Handle : Dword;
  Len : Longint;
  Data : Pchar;
  Buffer : Pointer;
  Tamanho : Dword;
  Parquivo: Pchar;
begin
  Result := TcVersaoArquivo.Create(0,0,0,0);

  Parquivo := StrAlloc(Length(AArquivo) + 1);
  StrPcopy(Parquivo, AArquivo);
  Len := GetFileVersionInfoSize(Parquivo, Handle);
  if Len > 0 then begin
    Data := StrAlloc(Len + 1);
    if GetFileVersionInfo(Parquivo, Handle, Len, Data) then begin
      VerQueryValue(Data, '\', Buffer, Tamanho);
      F := PFFI(Buffer);
      Result := TcVersaoArquivo.Create(
        HiWord(F^.dwFileVersionMs),
        LoWord(F^.dwFileVersionMs),
        HiWord(F^.dwFileVersionLs),
        LoWord(F^.dwFileVersionLs));
    end;
    StrDispose(Data);
  end;

  StrDispose(Parquivo);
end;

end.