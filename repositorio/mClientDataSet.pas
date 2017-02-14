unit mClientDataSet;

interface

uses
  Classes, SysUtils, StrUtils, DBClient, DB, MidasLib,
  mProperty;

type
  TmClientDataSet_Field = class
  private
    fNome : String;
    fDescricao : String;
    fTamanho : Integer;
    fCasasDecimais : Integer;
    fRequerido : Boolean;
  public
    constructor Create(
      ANome : String;
      ADescricao : String = '';
      ATamanho : Integer = 0;
      ACasasDecimais : Integer = 0;
      ARequerido : Boolean = False);
  published
    property Nome : String read fNome write fNome;
    property Descricao : String read fDescricao write fDescricao;
    property Tamanho : Integer read fTamanho write fTamanho;
    property CasasDecimais : Integer read fCasasDecimais write fCasasDecimais;
    property Requerido : Boolean read fRequerido write fRequerido;
  end;

  TmClientDataSet = class(TComponent)
  public
    class procedure SetFields(AClientDataSet: TClientDataSet; AValues :
      TmPropertyList);
    class procedure SetInVisible(AClientDataSet: TClientDataSet; AFields :
      Array of String);
    class procedure SetVisible(AClientDataSet: TClientDataSet; AFields :
      Array of String);
    class procedure SetFieldList(AClientDataSet: TClientDataSet; AFields :
      Array of TmClientDataSet_Field);
  end;

implementation

{ TmClientDataSet_Field }

constructor TmClientDataSet_Field.Create(
  ANome : String;
  ADescricao: String;
  ATamanho: Integer;
  ACasasDecimais: Integer;
  ARequerido: Boolean);
begin
  fNome := ANome;
  fDescricao := ADescricao;
  fTamanho := ATamanho;
  fCasasDecimais := ACasasDecimais;
  fRequerido := ARequerido;
end;

{ TmClientDataSet }

  function GetTipo(AProperty : TmProperty) : TFieldType;
  begin
    case AProperty.Tipo of
      tppBoolean : Result := ftBoolean;
      tppDateTime : Result := ftDateTime;
      tppFloat : Result := ftFloat;
      tppInteger : Result := ftInteger;
      tppString : Result := ftString;
      tppVariant : Result := ftVariant;
    else
      Result := ftString;
    end;
  end;

  function GetTamanho(AProperty : TmProperty) : Integer;
  begin
    case AProperty.Tipo of
      tppString : Result := 100;
    else
      Result := 0;
    end;
  end;

  function GetCasasDecimais(AProperty : TmProperty) : Integer;
  begin
    case AProperty.Tipo of
      tppFloat : Result := 3;
    else
      Result := 0;
    end;
  end;

  function GetRequerido(pProperty : TmProperty) : Boolean;
  begin
    Result := False;
  end;

class procedure TmClientDataSet.SetFields(AClientDataSet: TClientDataSet;
  AValues: TmPropertyList);
var
  I : Integer;
begin
  with AClientDataSet do begin
    FieldDefs.Clear();

    with AValues do
      for I := 0 to Count - 1 do
        with Items[I] do
          if IsValueDatabase then
            FieldDefs.Add(Nome, GetTipo(Items[I]), GetTamanho(Items[I]),
              GetRequerido(Items[I]));

    CreateDataSet;
  end;
end;

class procedure TmClientDataSet.SetInVisible(
  AClientDataSet: TClientDataSet; AFields: array of String);
var
  I : Integer;
begin
  with AClientDataSet do
    for I := Low(AFields) to High(AFields) do
      FieldByName(AFields[I]).Visible := False;
end;

class procedure TmClientDataSet.SetVisible(AClientDataSet: TClientDataSet;
  AFields: array of String);
var
  I : Integer;
begin
  with AClientDataSet do
    for I := 0 to FieldCount - 1 do
      FieldByName(Fields[I].FieldName).Visible := False;

  with AClientDataSet do
    for I := Low(AFields) to High(AFields) do
      FieldByName(AFields[I]).Visible := True;
end;

class procedure TmClientDataSet.SetFieldList(
  AClientDataSet: TClientDataSet; AFields: array of TmClientDataSet_Field);
var
  I : Integer;
begin
  with AClientDataSet do
    for I := Low(AFields) to High(AFields) do
      with AFields[I] do begin
        with FieldByName(Nome) do begin
          if Descricao <> '' then
            DisplayLabel := Descricao;
          if Tamanho > 0 then
            DisplayWidth := Tamanho;
          if Requerido then
            Required := Requerido;
        end;
      end;
end;

end.