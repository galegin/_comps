unit mTipoEstilo;

interface

uses
  Classes, StdCtrls, Controls, mValue;

type
  TTipoEstilo = (
    tsLabel,
    tsLabelRequerido,
    tsButton,
    tsButtonRequerido,
    tsCheckBox,
    tsCheckBoxRequerido,
    tsComboBox,
    tsComboBoxRequerido,
    tsTextBox,
    tsTextBoxRequerido
  );

  RTipoEstilo = record
    Tipo : TTipoEstilo;
    Codigo : String;
    Classe : TClass;
    Requerido : Boolean;
    Altura : Integer;
    Largura : Integer;
  end;

  function GetTipoEstilo(const pCodigo : string) : RTipoEstilo;
  function GetTipoEstiloFromClass(const pControl : TControl) : RTipoEstilo;
  function StrToTipoEstilo(const pCodigo : string) : TTipoEstilo;
  function TipoEstiloToStr(const pTipo : TTipoEstilo) : String;

implementation

const
  LTipoEstilo : Array [TTipoEstilo] of RTipoEstilo = (
    (Tipo: tsLabel            ; Codigo: 'tsLabel'            ; Classe: TLabel   ; Requerido: False; Altura: 32; Largura: 157),
    (Tipo: tsLabelRequerido   ; Codigo: 'tsLabelRequerido'   ; Classe: TLabel   ; Requerido: True ; Altura: 32; Largura: 157),
    (Tipo: tsButton           ; Codigo: 'tsButton'           ; Classe: TButton  ; Requerido: False; Altura: 32; Largura: 157),
    (Tipo: tsButtonRequerido  ; Codigo: 'tsButtonRequerido'  ; Classe: TButton  ; Requerido: True ; Altura: 32; Largura: 157),
    (Tipo: tsCheckBox         ; Codigo: 'tsCheckBox'         ; Classe: TCheckBox; Requerido: False; Altura: 32; Largura: 157),
    (Tipo: tsCheckBoxRequerido; Codigo: 'tsCheckBoxRequerido'; Classe: TCheckBox; Requerido: True ; Altura: 32; Largura: 157),
    (Tipo: tsComboBox         ; Codigo: 'tsComboBox'         ; Classe: TComboBox; Requerido: False; Altura: 32; Largura: 157),
    (Tipo: tsComboBoxRequerido; Codigo: 'tsComboBoxRequerido'; Classe: TComboBox; Requerido: True ; Altura: 32; Largura: 157),
    (Tipo: tsTextBox          ; Codigo: 'tsTextBox'          ; Classe: TEdit    ; Requerido: False; Altura: 32; Largura: 157),
    (Tipo: tsTextBoxRequerido ; Codigo: 'tsTextBoxRequerido' ; Classe: TEdit    ; Requerido: True ; Altura: 32; Largura: 157)
  );

function GetTipoEstilo(const pCodigo : string) : RTipoEstilo;
var
  I : Integer;
begin
  Result.Tipo := TTipoEstilo(-1);
  for I := Ord(Low(TTipoEstilo)) to Ord(High(TTipoEstilo)) do
    if LTipoEstilo[TTipoEstilo(I)].Codigo = pCodigo then
      Result := LTipoEstilo[TTipoEstilo(I)];
end;

function GetTipoEstiloFromClass(const pControl : TControl) : RTipoEstilo;
var
  I : Integer;
begin
  Result.Tipo := TTipoEstilo(-1);
  for I := Ord(Low(TTipoEstilo)) to Ord(High(TTipoEstilo)) do
    if pControl.InheritsFrom(LTipoEstilo[TTipoEstilo(I)].Classe) then
      Result := LTipoEstilo[TTipoEstilo(I)];
end;

function StrToTipoEstilo(const pCodigo : string) : TTipoEstilo;
begin
  Result := GetTipoEstilo(pCodigo).Tipo;
end;

function TipoEstiloToStr(const pTipo : TTipoEstilo) : String;
begin
  Result := LTipoEstilo[pTipo].Codigo;
end;

end.
