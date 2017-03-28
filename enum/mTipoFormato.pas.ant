unit mTipoFormato;

interface

type
  TTipoFormato = (
    tfCep,
    tfCnpj,
    tfCpf,
    tfData,
    tfDataHora,
    tfHora,
    tfNumero,
    tfPlaca,
    tfQuantidade,
    tfTelefone,
    tfTexto,
    tfValor
  );

  RTipoFormato = record
    Tipo : TTipoFormato;
    Formato : String;
  end;

implementation

const
  LTipoFormato : Array [TTipoFormato] of RTipoFormato = (
    (Tipo: tfCep       ; Formato: '99.999-999'         ),
    (Tipo: tfCnpj      ; Formato: '99.999.999/9999-99' ),
    (Tipo: tfCpf       ; Formato: '999.999.999-99'     ),
    (Tipo: tfData      ; Formato: 'dd/mm/yyyy'         ),
    (Tipo: tfDataHora  ; Formato: 'dd/mm/yyyy hh:nn:ss'),
    (Tipo: tfHora      ; Formato: 'hh:nn:ss'           ),
    (Tipo: tfNumero    ; Formato: '###.##9.999'        ),
    (Tipo: tfPlaca     ; Formato: 'ZZZ-9999'           ),
    (Tipo: tfQuantidade; Formato: '###.##9,999'        ),
    (Tipo: tfTelefone  ; Formato: '(##)#-9999-9999'    ),
    (Tipo: tfTexto     ; Formato: ''                   ),
    (Tipo: tfValor     ; Formato: '###.###.##9,99'     )
  );

end.