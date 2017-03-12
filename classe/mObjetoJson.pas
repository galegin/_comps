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

  procedure AnalisaJson(pTipoJson : TrTipoJson; var pJson : String; const pNivel : Integer);
  var
    vTipoJsonIni, vTipoJsonPrx, vTipoJsonFin : TrTipoJson;
    vAtributo, vConteudo : String;
  begin
    while (pJson <> '') do begin

      // inicio
      vTipoJsonIni := GetTipoJsonIni(pJson);
      RemoveStrTipoJson(vTipoJsonIni, pJson);
      case vTipoJsonIni.Tipo of

        // [lista]
        tjLista : begin
          pTipoJson.Lista := TList.Create;
          AnalisaJson(pTipoJson, pJson, pNivel + 1);
        end;

        // {objeto}
        tjObjeto : begin
          pTipoJson.Objeto := TObject.Create;
          AnalisaJson(pTipoJson, pJson, pNivel + 1);
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

            // :"Conteudo"
            tjConteudo : begin
              vTipoJsonFin := GetTipoJsonFin(pJson);
              vConteudo := GetValueTipoJson(vTipoJsonFin, pJson);
              RemoveStrTipoJson(vTipoJsonFin, pJson);
              
              TmObjeto.SetValue(pTipoJson.Objeto, vAtributo, vConteudo);
            end;
            
          // [lista] / {objeto}
          else  
            AnalisaJson(pTipoJson, pJson, pNivel + 1);

          end;
        end;
      end;
      
      // finaliza
      vTipoJsonFin := GetTipoJsonFin(pJson);
      RemoveStrTipoJson(vTipoJsonFin, pJson);
      case vTipoJsonFin.Tipo of      
        tjLista, tjObjeto : begin
          Exit;
        end;
      end;

    end;
  end;

//--

class function TmObjetoJson.JsonToObjeto(AClasse : TClass; AJson : String) : TObject;
var
  vTipoJson : TrTipoJson;
begin
  vTipoJson.Objeto := AClasse.NewInstance;
  AnalisaJson(vTipoJson, AJson, 0);
  Result := vTipoJson.Objeto;
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
    fConteudo: TObject;
  published
    property Mensagem : String read fMensagem write fMensagem;
    property Conteudo : TObject read fConteudo write fConteudo;
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
