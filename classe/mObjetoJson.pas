unit mObjetoJson;

interface

uses
  Classes, SysUtils, StrUtils, Math,
  mTipoJson, mProperty, mString, mObjeto;

type
  TmObjetoJson = class
  public
    class function ObjetoToJson(AObjeto : TObject) : String;
    class function JsonToObjeto(AClasse : TClass; AJson : String) : TObject;
  end;

implementation

//--

class function TmObjetoJson.ObjetoToJson(AObjeto : TObject) : String;
begin
end;

//--

  procedure AnalisaJson(pObjeto : TObject; var pJson : String;
    const pNivel : Integer);
  var
    vTipoJsonIni, vTipoJsonPrx, vTipoJsonFin : TrTipoJson;
    vAtributo, vConteudo : String;
    vValues : TmPropertyList;
    vObjeto : TObject;
    vLista : TList;
  begin
    vValues := TmPropertyList.Create;
    vObjeto := TObject.Create;
    vLista := TList.Create;

    while (pJson <> '') do begin

      // inicio
      vTipoJsonIni := GetTipoJsonIni(pJson);
      RemoveStrTipoJson(vTipoJsonIni, pJson);
      case vTipoJsonIni.Tipo of

        // [lista]
        tjLista : begin
          AnalisaJson(vLista, pJson, pNivel + 1);
          vValues.AdicionarLista('', vLista);
        end;

        // {objeto}
        tjObjeto : begin
          AnalisaJson(vObjeto, pJson, pNivel + 1);
          vValues.AdicionarObjeto('', vObjeto);
        end;

        // "Atributo":"Conteudo"
        tjAtributo : begin
          vTipoJsonIni := GetTipoJsonIni(pJson);
          vAtributo := GetValueTipoJson(vTipoJsonIni, pJson);
          RemoveStrTipoJson(vTipoJsonIni, pJson);

          // proximo
          vTipoJsonPrx := GetTipoJsonIni(pJson);
          RemoveStrTipoJson(vTipoJsonPrx, pJson);
          case vTipoJsonPrx.Tipo of

            // [lista]
            tjLista : begin
              AnalisaJson(vLista, pJson, pNivel + 1);
              vValues.AdicionarLista(vAtributo, vLista);
            end;

            // {objeto}
            tjObjeto : begin
              AnalisaJson(vObjeto, pJson, pNivel + 1);
              vValues.AdicionarObjeto(vAtributo, vObjeto);
            end;

            // :"Conteudo"
            tjConteudo : begin
              vTipoJsonFin := GetTipoJsonFin(pJson);
              vConteudo := GetValueTipoJson(vTipoJsonFin, pJson);
              RemoveStrTipoJson(vTipoJsonFin, pJson);
              vValues.AdicionarAtributo(vAtributo, vConteudo);
            end;

          end;
        end;
      end;

      TmObjeto.SetValues(pObjeto, vValues);
    end;
  end;

//--

class function TmObjetoJson.JsonToObjeto(AClasse : TClass; AJson : String) : TObject;
begin
  Result := AClasse.NewInstance;
  AnalisaJson(Result, AJson, 0);
end;

//--

(*
url:
  http://192.168.190.102/api/cep/87205104
retorno:
  {
    "Mensagem":"",
    "Conteudo":
    {
      "Logradouro":"RUA JOSE RODRIGUES BRIZNES",
      "Cep":"87205104",
      "Municipio":"CIANORTE",
      "CodigoMunicipio":4105508,
      "Bairro":"CONJUNTO PORTAL DAS AMERICAS",
      "Complemento":"- ATE 149/150",
      "CodigoEstado":41,
      "Estado":"PARANA",
      "Uf":"PR ",
      "CodigoPais":1058,
      "Pais":"BRASIL"
    }
  }
*)

type
  TRetorno = class
  private
    fMensagem: String;
    fConteudo: String;
  published
    property Mensagem : String read fMensagem write fMensagem;
    property Conteudo : String read fConteudo write fConteudo;
  end;

  TLogradouro = class
  private
    fCep : String;
    fLogradouro : String;
    fBairro : String;
    fComplemento : String;
    fCodigoMunicipio : String;
    fMunicipio : String;
    fCodigoEstado : String;
    fEstado : String;
    fUf : String;
    fCodigoPais : String;
    fPais : String;
  published
    property Cep : String read fCep write fCep;
    property Logradouro : String read fLogradouro write fLogradouro;
    property Bairro : String read fBairro write fBairro;
    property Complemento : String read fComplemento write fComplemento;
    property CodigoMunicipio : String read fCodigoMunicipio write fCodigoMunicipio;
    property Municipio : String read fMunicipio write fMunicipio;
    property CodigoEstado : String read fCodigoEstado write fCodigoEstado;
    property Estado : String read fEstado write fEstado;
    property Uf : String read fUf write fUf;
    property CodigoPais : String read fCodigoPais write fCodigoPais;
    property Pais : String read fPais write fPais;
  end;

procedure TestarJson();
var
  vJson : String;
  vObjeto : TObject;
begin
  vJson :=
    '{' +
      '"Mensagem":"",' +
      '"Conteudo":' +
      '{' +
        '"Logradouro":"RUA JOSE RODRIGUES BRIZNES",' +
        '"Cep":"87205104",' +
        '"Municipio":"CIANORTE",' +
        '"CodigoMunicipio":4105508,' +
        '"Bairro":"CONJUNTO PORTAL DAS AMERICAS",' +
        '"Complemento":"- ATE 149/150",' +
        '"CodigoEstado":41,' +
        '"Estado":"PARANA",' +
        '"Uf":"PR ",' +
        '"CodigoPais":1058,' +
        '"Pais":"BRASIL"' +
      '}' +
    '}';

  vObjeto := TmObjetoJson.JsonToObjeto(TRetorno, vJson);
end;

//--

initialization
  TestarJson();

end.