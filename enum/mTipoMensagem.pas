unit mTipoMensagem;

interface

type
  TTipoMensagem = (
    tpmErroInformeOCodigo,
    tpmErroInformeONome,
    tpmErroInformeOEndereco,
    tpmErroInformeAData);

  TmTipoMensagem = class
  public
    class function GetMensagem(
      ATipoMensagem : TTipoMensagem) : String;
  end;

implementation

{ TmTipoMensagem }

class function TmTipoMensagem.GetMensagem;
begin
  case ATipoMensagem of
    tpmErroInformeOCodigo: Result := 'Informe o codigo';
    tpmErroInformeONome: Result := 'Informe o nome';
    tpmErroInformeOEndereco: Result := 'Informe o endereco';
    tpmErroInformeAData: Result := 'Informe a data';
  else
    Result := 'Mensagem nao catalogada';
  end;
end;

end.