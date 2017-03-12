unit mTipoJson;

(*
    lista =
        [{objeto1},{objeto2},...,{objetoN}]
    objeto =
        {"atributo1":"conteudo1","atributo2":{objeto2},"atributo3":[lista3],...,"atributoN":"conteudoN"}
*)

interface

uses
  Classes, SysUtils;

type
  TpTipoJson = (
    tjLista,
    tjObjeto,
    tjAtributo,
    tjConteudo,
    tjSeparador);

  TrTipoJson = record
    Tipo : TpTipoJson;
    Codigo : String;
    Posicao : Integer;
  end;

  function GetTipoJsonIni(const s : string) : TrTipoJson;
  function GetTipoJsonFin(const s : string) : TrTipoJson;
  function GetValueTipoJson(const ATipo : TrTipoJson; const AString : String) : String;
  procedure RemoveStrTipoJson(const ATipo : TrTipoJson; var AString : String);

implementation

uses
  mString;

  function BuscarTipoJson(const pStr : String;
    const pLstStr : Array of String; const pLstTip : Array Of TpTipoJson) : TrTipoJson;
  var
    vPos, vTot, vInd : Integer;
  begin
    Result.Tipo := TpTipoJson(Ord(-1));
    Result.Posicao := -1;
    Result.Codigo := '';

    vPos := 1;
    vTot := Length(pStr);
    vInd := TmString.StringInSet(pStr[vPos], pLstStr);
    while (vInd = -1) and (vPos <= vTot) do begin
      Inc(vPos);
      vInd := TmString.StringInSet(pStr[vPos], pLstStr);
    end;

    if vInd <> -1 then begin
      Result.Tipo := pLstTip[vInd];
      Result.Posicao := vPos;
      Result.Codigo := pLstStr[vInd];
    end;
  end;

//--

function GetTipoJsonIni(const s : string) : TrTipoJson;
begin
  Result := BuscarTipoJson(s, ['[', '{', '"', ':'],
    [tjLista, tjObjeto, tjAtributo, tjConteudo]);
end;

function GetTipoJsonFin(const s : string) : TrTipoJson;
begin
  Result := BuscarTipoJson(s, [']', '}', ':', ','],
    [tjLista, tjObjeto, tjAtributo, tjSeparador]);
end;

//--

function GetValueTipoJson(const ATipo : TrTipoJson; const AString : String) : String;
begin
  Result := Copy(AString, 1, ATipo.Posicao - 1);
end;

//--

procedure RemoveStrTipoJson(const ATipo : TrTipoJson; var AString : String);
begin
  Delete(AString, 1, ATipo.Posicao);
end;

//--

end.
