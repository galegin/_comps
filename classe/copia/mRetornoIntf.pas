unit mRetornoIntf;
 
interface
 
type
  IRetorno = interface(IUnknown)
    ['{6ADF6275-82C0-4290-8C8D-DFDAA2AA17CC}']
    
    function Mensagem : PChar;
  end;
 
implementation
 
end.