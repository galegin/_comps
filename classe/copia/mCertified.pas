unit mCertified;

{
  alterações no arquivo ACBrNFeConfiguracoes.pas efetuado para funcionamento
  --------------------------------------------------------------------------

  interface

  type
    TCertificadosConf = class(TComponent)
    private
      FArquivoCert: AnsiString; //-- MFGALEGO - 03/09/2015
      ...
    public
      function GetCertificadoArquivo: ICertificate2; //-- MFGALEGO - 03/09/2015
      ...
    published
      property Arquivo: AnsiString read FArquivoCert write FArquivoCert; //-- MFGALEGO - 03/09/2015
      ...

  implemantation

  function TCertificadosConf.GetCertificado: ICertificate2; - alterado
  var
    ...
  begin
    if FArquivoCert <> '' then begin //-- MFGALEGO - 03/09/2015
      Result := GetCertificadoArquivo;
      Exit;
    end;
    ...
  end;

  function TCertificadosConf.GetCertificadoArquivo: ICertificate2; //-- MFGALEGO - 03/09/2015
  begin
    if (PCertCarregado <> nil) and (NumCertCarregado = FNumeroSerie) then
      Result := PCertCarregado
    else begin
      CoInitialize(nil); // PERMITE O USO DE THREAD

      try
        Result := CoCertificate.Create;
        Result.Load(FArquivoCert, FSenhaCert, CAPICOM_KEY_STORAGE_DEFAULT, CAPICOM_CURRENT_USER_STORE);

        PCertCarregado := Result;
        FNumeroSerie := Result.SerialNumber;
        FDataVenc := Result.ValidToDate;
        FSubjectName := Result.SubjectName;
      finally
        CoUninitialize;
      end;
    end;
  end;
}

interface

uses
  Classes, SysUtils,
  ACBrCAPICOM_TLB, JwaWinCrypt;

type
  TmCertified = class
  public
    class function Carregar(AArquivo, ASenha : String) : ICertificate2;
  end;	

implementation

class function TmCertified.Carregar(AArquivo, ASenha : String) : ICertificate2;
const
  cDS_METHOD = 'mCertified.Carregar()';
begin
  if AArquivo = '' then
    raise Exception.Create('Arquivo deve ser informado! / ' + cDS_METHOD);
  if ASenha = '' then
    raise Exception.Create('Senha deve ser informado! / ' + cDS_METHOD);

  Result := CoCertificate.Create;
  Result.Load(AArquivo, ASenha, CAPICOM_KEY_STORAGE_DEFAULT, CAPICOM_CURRENT_USER_KEY);
end;

end.