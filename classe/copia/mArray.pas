unit mArray;

interface

type
  TMyClass = class;
  TMyClassArray = array of TMyClass;

  TMyClass = class
  private
    FIndex : Integer;
    Instances : TMyClassArray;
  public
    // Crio um novo tipo TMyClassArray que representa um array dessa nova classe.
    // Crio uma variável de nome Instances que não vai fazer parte dos objetos criados, mas sim da classe.
    // E por isso deve ser chamada atraves do identificador da classe.
    constructor Create;
    destructor Destroy;
    //Else code...
  end;

implementation

constructor TMyClass.Create;
begin
  inherited;
  SetLength(Instances, Length(Instances) + 1);
  FI := Length(Instances) - 1;
  Instances[FI] := Self;
  //Else code...
end;

destructor TMyClass.Destroy;
var
  I : Integer;
begin
  //Else code...
  Instances[FI] := nil;
  I := FI;
  while (I <= Length(Instances) - 1) do begin
    Instances[I] := Instances[I + 1];
    Instances[I].FI := I;
    Inc(I);
  end;
  SetLength(Instances, Length(Instances) - 1);
  inherited;
end;

end.