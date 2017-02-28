unit mValidar;

interface

uses
  Classes, SysUtils, StrUtils, Math;

  function cnpjcpf(pNum : String) : Boolean;
  function inscricao(pInscricao : String; pTipo : String = '') : Boolean;

implementation

{ TmValidar }

uses
  mFuncao;

function cnpjcpf(pNum : String) : Boolean;
type
  TpDocto = (tpCNPJ, tpCPF);
var
  I, D, K, Soma, vDigito : Integer;
  vDigiCalc, vDigiDoct : String;
  vTpDocto : TpDocto;
begin
  Result := False;

  //mantem apenas os digitos do documento, retirando a mascara
  pNum := SoDigitos(pNum);

  //Verifica se CPF ou CNPJ
  if (Length(pNum) = 11) then begin
    vTpDocto := tpCPF;
  end else if (Length(pNum) = 14) then begin
    vTpDocto := tpCNPJ;
  end else begin
    Exit;
  end;

  //Retira digito verificado do documento
  vDigiDoct := Copy(pNum, Length(pNum) - 1, 2);
  Delete(pNum, Length(pNum) - 1, 2);
  vDigiCalc := '';

  //Calcula digito verificar
  for D:=1 to 2 do begin
    K := Ifthen(D=1,2,3);
    Soma := Ifthen(D=1,0,StrToIntDef(vDigiCalc,0)*2);
    for I:=Length(pNum) downto 1 do begin
      Soma := Soma + (Ord(pNum[I]) - Ord('0')) * K;
      Inc(K);
      if (K > 9) and (vTpDocto = tpCNPJ) then K := 2;
    end;
    vDigito := 11 - Soma mod 11;
    if (vDigito >= 10) then vDigito := 0;
    vDigiCalc := vDigiCalc + Chr(vDigito + Ord('0'));
  end;

  //Compara se o digito calculado é igual ao digito do documento
  Result := (vDigiDoct = vDigiCalc);
end;

function inscricao(pInscricao, pTipo : String) : Boolean;
var
  Contador  : ShortInt;
  Casos     : ShortInt;
  Digitos   : ShortInt;

  Tabela_1  : String;
  Tabela_2  : String;
  Tabela_3  : String;

  Base_1    : String;
  Base_2    : String;
  Base_3    : String;

  Valor_1   : ShortInt;

  Soma_1    : Integer;
  Soma_2    : Integer;

  Erro_1    : ShortInt;
  Erro_2    : ShortInt;
  Erro_3    : ShortInt;

  Posicao_1 : string;
  Posicao_2 : String;

  Tabela    : String;
  Rotina    : String;
  Modulo    : ShortInt;
  Peso      : String;

  Digito    : ShortInt;

  Resultado : String;
  Retorno   : Boolean;
begin

  Try

    Tabela_1 := ' ';
    Tabela_2 := ' ';
    Tabela_3 := ' ';

    {                                                                               }                                                                                                                 {                                                                                                }
    {         Valores possiveis para os digitos (j)                                 }
    {                                                                               }
    { 0 a 9 = Somente o digito indicado.                                            }
    {     N = Numeros 0 1 2 3 4 5 6 7 8 ou 9                                        }
    {     A = Numeros 1 2 3 4 5 6 7 8 ou 9                                          }
    {     B = Numeros 0 3 5 7 ou 8                                                  }
    {     C = Numeros 4 ou 7                                                        }
    {     D = Numeros 3 ou 4                                                        }
    {     E = Numeros 0 ou 8                                                        }
    {     F = Numeros 0 1 ou 5                                                      }
    {     G = Numeros 1 7 8 ou 9                                                    }
    {     H = Numeros 0 1 2 ou 3                                                    }
    {     I = Numeros 0 1 2 3 ou 4                                                  }
    {     J = Numeros 0 ou 9                                                        }
    {     K = Numeros 1 2 3 ou 9                                                    }
    {                                                                               }
    { ----------------------------------------------------------------------------- }
    {                                                                               }
    {         Valores possiveis para as rotinas (d) e (g)                           }
    {                                                                               }
    { A a E = Somente a Letra indicada.                                             }
    {     0 = B e D                                                                 }
    {     1 = C e E                                                                 }
    {     2 = A e E                                                                 }
    {                                                                               }
    { ----------------------------------------------------------------------------- }
    {                                                                               }
    {                                  C T  F R M  P  R M  P                        }
    {                                  A A  A O O  E  O O  E                        }
    {                                  S M  T T D  S  T D  S                        }
    {                                                                               }
    {                                  a b  c d e  f  g h  i  jjjjjjjjjjjjjj        }
    {                                  0000000001111111111222222222233333333        }
    {                                  1234567890123456789012345678901234567        }

    if pTipo = 'AC'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     01NNNNNNX.14.00';
    if pTipo = 'AC'   then Tabela_2 := '2.13.0.E.11.02.E.11.01. 01NNNNNNNNNXY.13.14';
    if pTipo = 'AL'   then Tabela_1 := '1.09.0.0.11.01. .  .  .     24BNNNNNX.14.00';
    if pTipo = 'AP'   then Tabela_1 := '1.09.0.1.11.01. .  .  .     03NNNNNNX.14.00';
    if pTipo = 'AP'   then Tabela_2 := '2.09.1.1.11.01. .  .  .     03NNNNNNX.14.00';
    if pTipo = 'AP'   then Tabela_3 := '3.09.0.E.11.01. .  .  .     03NNNNNNX.14.00';
    if pTipo = 'AM'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     0CNNNNNNX.14.00';
    if pTipo = 'BA'   then Tabela_1 := '1.08.0.E.10.02.E.10.03.      NNNNNNYX.14.13';
    if pTipo = 'BA'   then Tabela_2 := '2.08.0.E.11.02.E.11.03.      NNNNNNYX.14.13';
    if pTipo = 'CE'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     0NNNNNNNX.14.13';
    if pTipo = 'DF'   then Tabela_1 := '1.13.0.E.11.02.E.11.01. 07DNNNNNNNNXY.13.14';
    if pTipo = 'ES'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     0ENNNNNNX.14.00';
    if pTipo = 'GO'   then Tabela_1 := '1.09.1.E.11.01. .  .  .     1FNNNNNNX.14.00';
    if pTipo = 'GO'   then Tabela_2 := '2.09.0.E.11.01. .  .  .     1FNNNNNNX.14.00';
    if pTipo = 'MA'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     12NNNNNNX.14.00';
    if pTipo = 'MT'   then Tabela_1 := '1.11.0.E.11.01. .  .  .   NNNNNNNNNNX.14.00';
    if pTipo = 'MS'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     28NNNNNNX.14.00';
    if pTipo = 'MG'   then Tabela_1 := '1.13.0.2.10.10.E.11.11. NNNNNNNNNNNXY.13.14';
    if pTipo = 'PA'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     15NNNNNNX.14.00';
    if pTipo = 'PB'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     16NNNNNNX.14.00';
    if pTipo = 'PR'   then Tabela_1 := '1.10.0.E.11.09.E.11.08.    NNNNNNNNXY.13.14';
    if pTipo = 'PE'   then Tabela_1 := '1.14.1.E.11.07. .  .  .18ANNNNNNNNNNX.14.00';
    if pTipo = 'PI'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     19NNNNNNX.14.00';
    if pTipo = 'RJ'   then Tabela_1 := '1.08.0.E.11.08. .  .  .      GNNNNNNX.14.00';
    if pTipo = 'RN'   then Tabela_1 := '1.09.0.0.11.01. .  .  .     20HNNNNNX.14.00';
    if pTipo = 'RS'   then Tabela_1 := '1.10.0.E.11.01. .  .  .    INNNNNNNNX.14.00';
    if pTipo = 'RO'   then Tabela_1 := '1.09.1.E.11.04. .  .  .     ANNNNNNNX.14.00';
    if pTipo = 'RO'   then Tabela_2 := '2.14.0.E.11.01. .  .  .NNNNNNNNNNNNNX.14.00';
    if pTipo = 'RR'   then Tabela_1 := '1.09.0.D.09.05. .  .  .     24NNNNNNX.14.00';
    if pTipo = 'SC'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     NNNNNNNNX.14.00';
    if pTipo = 'SP'   then Tabela_1 := '1.12.0.D.11.12.D.11.13.  NNNNNNNNXNNY.11.14';
    if pTipo = 'SP'   then Tabela_2 := '2.12.0.D.11.12. .  .  .  NNNNNNNNXNNN.11.00';
    if pTipo = 'SE'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     NNNNNNNNX.14.00';
    if pTipo = 'TO'   then Tabela_1 := '1.11.0.E.11.06. .  .  .   29JKNNNNNNX.14.00';

    if pTipo = 'CNPJ' then Tabela_1 := '1.14.0.E.11.21.E.11.22.NNNNNNNNNNNNXY.13.14';
    if pTipo = 'CPF'  then Tabela_1 := '1.11.0.E.11.31.E.11.32.   NNNNNNNNNXY.13.14';

    { Deixa somente os numeros }

    Base_1 := '';

    for Contador := 1 to 30 do
      if Pos( Copy(pInscricao, Contador, 1 ), '0123456789' ) <> 0 then
        Base_1 := Base_1 + Copy( pInscricao, Contador, 1 );

    { Repete 3x - 1 para cada caso possivel  }

    Casos  := 0;

    Erro_1 := 0;
    Erro_2 := 0;
    Erro_3 := 0;

    while Casos < 3 Do Begin

      Casos := Casos + 1;

      if Casos = 1 then Tabela := Tabela_1;
      if Casos = 2 then Erro_1 := Erro_3  ;
      if Casos = 2 then Tabela := Tabela_2;
      if Casos = 3 then Erro_2 := Erro_3  ;
      if Casos = 3 then Tabela := Tabela_3;

      Erro_3 := 0 ;

      if Copy( Tabela, 1, 1 ) <> ' ' then Begin

        { Verifica o Tamanho }

        if Length( Trim( Base_1 ) ) <> ( StrToInt( Copy( Tabela,  3,  2 ) ) ) then Erro_3 := 1;

        if Erro_3 = 0 then Begin

          { Ajusta o Tamanho }

          Base_2 := Copy( '              ' + Base_1, Length( '              ' + Base_1 ) - 13, 14 );

          { Compara com valores possivel para cada uma da 14 posições }

          Contador := 0 ;

          while ( Contador < 14 ) and ( Erro_3 = 0 ) Do Begin

            Contador := Contador + 1;

            Posicao_1 := Copy( Copy( Tabela, 24, 14 ), Contador, 1 );
            Posicao_2 := Copy( Base_2                , Contador, 1 );

            if ( Posicao_1  = ' '        ) and (      Posicao_2                 <> ' ') then Erro_3 := 1;
            if ( Posicao_1  = 'N'        ) and ( Pos( Posicao_2, '0123456789' )  =   0) then Erro_3 := 1;
            if ( Posicao_1  = 'A'        ) and ( Pos( Posicao_2, '123456789'  )  =   0) then Erro_3 := 1;
            if ( Posicao_1  = 'B'        ) and ( Pos( Posicao_2, '03578'      )  =   0) then Erro_3 := 1;
            if ( Posicao_1  = 'C'        ) and ( Pos( Posicao_2, '47'         )  =   0) then Erro_3 := 1;
            if ( Posicao_1  = 'D'        ) and ( Pos( Posicao_2, '34'         )  =   0) then Erro_3 := 1;
            if ( Posicao_1  = 'E'        ) and ( Pos( Posicao_2, '08'         )  =   0) then Erro_3 := 1;
            if ( Posicao_1  = 'F'        ) and ( Pos( Posicao_2, '015'        )  =   0) then Erro_3 := 1;
            if ( Posicao_1  = 'G'        ) and ( Pos( Posicao_2, '1789'       )  =   0) then Erro_3 := 1;
            if ( Posicao_1  = 'H'        ) and ( Pos( Posicao_2, '0123'       )  =   0) then Erro_3 := 1;
            if ( Posicao_1  = 'I'        ) and ( Pos( Posicao_2, '01234'      )  =   0) then Erro_3 := 1;
            if ( Posicao_1  = 'J'        ) and ( Pos( Posicao_2, '09'         )  =   0) then Erro_3 := 1;
            if ( Posicao_1  = 'K'        ) and ( Pos( Posicao_2, '1239'       )  =   0) then Erro_3 := 1;
            if ( Posicao_1 <>  Posicao_2 ) and ( Pos( Posicao_1, '0123456789' )  >   0) then Erro_3 := 1;

          end;

          { Calcula os Digitos }

          Rotina  := ' ';
          Digitos := 000;
          Digito  := 000;

          while ( Digitos < 2 ) and ( Erro_3 = 0 ) Do Begin

            Digitos := Digitos + 1;

            { Carrega peso }

            Peso := Copy( Tabela, 5 + ( Digitos * 8 ), 2 );

            if Peso <> '  ' then Begin
              Rotina :=           Copy( Tabela, 0 + ( Digitos * 8 ), 1 )  ;
              Modulo := StrToInt( Copy( Tabela, 2 + ( Digitos * 8 ), 2 ) );

              if Peso = '01' then Peso := '06.05.04.03.02.09.08.07.06.05.04.03.02.00';
              if Peso = '02' then Peso := '05.04.03.02.09.08.07.06.05.04.03.02.00.00';
              if Peso = '03' then Peso := '06.05.04.03.02.09.08.07.06.05.04.03.00.02';
              if Peso = '04' then Peso := '00.00.00.00.00.00.00.00.06.05.04.03.02.00';
              if Peso = '05' then Peso := '00.00.00.00.00.01.02.03.04.05.06.07.08.00';
              if Peso = '06' then Peso := '00.00.00.09.08.00.00.07.06.05.04.03.02.00';
              if Peso = '07' then Peso := '05.04.03.02.01.09.08.07.06.05.04.03.02.00';
              if Peso = '08' then Peso := '08.07.06.05.04.03.02.07.06.05.04.03.02.00';
              if Peso = '09' then Peso := '07.06.05.04.03.02.07.06.05.04.03.02.00.00';
              if Peso = '10' then Peso := '00.01.02.01.01.02.01.02.01.02.01.02.00.00';
              if Peso = '11' then Peso := '00.03.02.11.10.09.08.07.06.05.04.03.02.00';
              if Peso = '12' then Peso := '00.00.01.03.04.05.06.07.08.10.00.00.00.00';
              if Peso = '13' then Peso := '00.00.03.02.10.09.08.07.06.05.04.03.02.00';
              if Peso = '21' then Peso := '05.04.03.02.09.08.07.06.05.04.03.02.00.00';
              if Peso = '22' then Peso := '06.05.04.03.02.09.08.07.06.05.04.03.02.00';
              if Peso = '31' then Peso := '00.00.00.10.09.08.07.06.05.04.03.02.00.00';
              if Peso = '32' then Peso := '00.00.00.11.10.09.08.07.06.05.04.03.02.00';

              { Multiplica }

              Base_3 := Copy( ( '0000000000000000' + Trim( Base_2 ) ), Length( ( '0000000000000000' + Trim( Base_2 ) ) ) - 13, 14 );

              Soma_1 := 0;
              Soma_2 := 0;

              For Contador := 1 To 14 Do Begin
                Valor_1 := ( StrToInt( Copy( Base_3, Contador, 01 ) ) * StrToInt( Copy( Peso, Contador * 3 - 2, 2 ) ) );
                Soma_1  := Soma_1 + Valor_1;
                if Valor_1 > 9 then Valor_1 := Valor_1 - 9;
                Soma_2  := Soma_2 + Valor_1;
              end;

              { Ajusta valor da soma }

              if Pos( Rotina, 'A2'  ) > 0 then Soma_1 := Soma_2;
              if Pos( Rotina, 'B0'  ) > 0 then Soma_1 := Soma_1 * 10;
              if Pos( Rotina, 'C1'  ) > 0 then Soma_1 := Soma_1 + ( 5 + 4 * StrToInt( Copy( Tabela, 6, 1 ) ) );

              { Calcula o Digito }

              if Pos( Rotina, 'D0'  ) > 0 then Digito := Soma_1 Mod Modulo;
              if Pos( Rotina, 'E12' ) > 0 then Digito := Modulo - ( Soma_1 Mod Modulo);

              if Digito < 10 then Resultado := IntToStr( Digito );
              if Digito = 10 then Resultado := '0';
              if Digito = 11 then Resultado := Copy( Tabela, 6, 1 );

              { Verifica o Digito }

              if ( Copy( Base_2, StrToInt( Copy( Tabela, 36 + ( Digitos * 3 ), 2 ) ), 1 ) <> Resultado ) then Erro_3 := 1;

            end;

          end;

        end;

      end;

    end;

    { Retorna o resultado da Verificação }

    Retorno := FALSE;

    if (Trim(Tabela_1) <> '') and (ERRO_1 = 0) then Retorno := TRUE;
    if (Trim(Tabela_2) <> '') and (ERRO_2 = 0) then Retorno := TRUE;
    if (Trim(Tabela_3) <> '') and (ERRO_3 = 0) then Retorno := TRUE;

    if Trim( pInscricao ) = 'ISENTO' then Retorno := TRUE;

    Result := Retorno;

  except
    Result := False;
  end;

end;

end.
