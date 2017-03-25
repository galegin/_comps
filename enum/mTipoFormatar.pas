unit mTipoFormatar;

interface

uses
  Classes, SysUtils, StrUtils, TypInfo;

type
  TTipoFormatar = (
    tfCep, 
    tfCnpj,
    tfCpf,
    tfData,
    tfInscricao,
    tfNumero,
    tfPlaca,
    tfTelefone,
    tfEmail,
    tfSite,
    tfSenha);

  function StrToTipoFormatar(const s : string) : TTipoFormatar;
  function TipoFormatarToStr(const t : TTipoFormatar) : string;

implementation

{ TmFormatar }

const
  LTipoFormatar : Array [TTipoFormatar] of String  = (
    '99.999-999'         ,
    '#99.999.999/9999-99',
    '999.999.999-99'     ,
    '99/99/9999'         ,
    '999.999.999.999'    ,
    '#,###,###,##0'      ,
    'ZZZ-9999'           ,
    '(##)#-9999-9999'    ,
    'x@x.x'              ,
    'x.x'                ,
    'x'                  );

function StrToTipoFormatar(const s : string) : TTipoFormatar;
var
  I : Integer;
begin
  Result := TTipoFormatar(Ord(-1));
  for I := Ord(Low(TTipoFormatar)) to Ord(High(TTipoFormatar)) do
   if LTipoFormatar[TTipoFormatar(I)] = s then
	   Result := TTipoFormatar(I);
end;

function TipoFormatarToStr(const t : TTipoFormatar) : string;
begin
  Result := LTipoFormatar[TTipoFormatar(t)];
end;

end.