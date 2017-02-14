unit mTipoConexao;

interface

type
  TTipoConexao = (tpcAmbiente, tpcGlobal, tpcLogin);

const
  TTipoConexaoUsername : Array [TTipoConexao] of String =
    ('', 'uv3dadglb', 'loginp');

  TTipoConexaoPassword : Array [TTipoConexao] of String =
    ('', 'uv3dadglb', 'loginp');

implementation

end.