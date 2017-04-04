unit mTipoMensagem;

interface

type
  TStatusMensagem = (
    tsErro,
    tsNormal,
    txExecutado);

  TTipoMensagem = (
    tmErroInformeOCodigo,
    tmErroInformeONome,
    tmErroInformeOEndereco,
    tmErroInformeAData);

  RTipoMensagem = record
    Tipo : TTipoMensagem;
    Status : TStatusMensagem;
    Codigo : String;
    Mensagem : String;
    Dica : String;
  end;

  function GetTipoMensagem(const pCodigo : string) : RTipoMensagem;
  function StrToTipoMensagem(const pCodigo : string) : TTipoMensagem;
  function TipoMensageToStr(const pTipo : TTipoMensagem) : string;

implementation

const
  LTipoMensagem : Array [TTipoMensagem] of RTipoMensagem = (
    (Tipo: tmErroInformeAData; Status: tsErro; Codigo: 'tmErroInformeAData'; Mensagem: 'Informe a data'; Dica: ''),
    (Tipo: tmErroInformeOCodigo; Status: tsErro; Codigo: 'tmErroInformeOCodigo'; Mensagem: 'Informe o codigo'; Dica: ''),
    (Tipo: tmErroInformeONome; Status: tsErro; Codigo: 'tmErroInformeONome'; Mensagem: 'Informe o nome'; Dica: ''),
    (Tipo: tmErroInformeOEndereco; Status: tsErro; Codigo: 'tmErroInformeOEnderco'; Mensagem: 'Informe o endereco'; Dica: '')
  );

{ TmTipoMensagem }

function GetTipoMensagem(const pCodigo : string) : RTipoMensagem;
var
  I : Integer;
begin
  Result.Tipo := TTipoMensagem(Ord(-1));
  Result.Status := tsErro;
  Result.Codigo := pCodigo;
  Result.Mensagem := 'Mensagem nao catalogada';

  for I := Ord(Low(TTipoMensagem)) to Ord(High(TTipoMensagem)) do
    if LTipoMensagem[TTipoMensagem(I)].Codigo = pCodigo then
      Result := LTipoMensagem[TTipoMensagem(I)];
end;

function StrToTipoMensagem(const pCodigo : string) : TTipoMensagem;
begin
  Result := GetTipoMensagem(pCodigo).Tipo;
end;

function TipoMensageToStr(const pTipo : TTipoMensagem) : string;
begin
  Result := LTipoMensagem[pTipo].Codigo;
end;

end.