unit mObjeto;

interface

uses
  Classes, SysUtils;

  function get(pClasse: String; pOwner : TComponent; pInherited : TClass) : TObject; overload;
  function get(pClasse: TClass; pOwner : TComponent = nil) : TObject; overload;
  function get(pClasse: String; pOwner : TComponent = nil) : TObject; overload;

  function mtd(pClasse, pMetodo : String) : TMethod; overload;
  function mtd(pObject : TObject; pMetodo : String) : TMethod; overload;

implementation

resourcestring
  ClasseNotFound = 'Classe "%s" nao encontrada';
  ClasseUnInformed = 'Classe nao informada';
  MethodNotFound = 'Metodo "%s" nao encontrado na %s classe';
  ObjectUnInformed = 'Objeto nao informado';

function get(pClasse: String; pOwner : TComponent; pInherited : TClass) : TObject;
const
  cMETHOD = 'mObjeto.get()';
var
  vClass : TClass;
begin
  Result := nil;

  vClass := GetClass(pClasse);

  if vClass = nil then
    raise Exception.create(Format(ClasseNotFound, [pClasse]) + ' / ' + cMETHOD);

  if pInherited <> nil then
    if not vClass.InheritsFrom(pInherited) then
      Exit;

  if vClass.InheritsFrom(TComponent) then begin
    Result := TComponentClass(vClass).Create(pOwner);
  end else if vClass.InheritsFrom(TPersistent) then begin
    Result := TPersistentClass(vClass).Create();
  end else begin
    Result := vClass.NewInstance();
  end;
end;

function get(pClasse: TClass; pOwner : TComponent) : TObject;
begin
  if (pClasse.InheritsFrom(TComponent)) then begin
    Result := TComponentClass(pClasse).Create(pOwner);
  end else if (pClasse.InheritsFrom(TPersistent)) then begin
    Result := TPersistentClass(pClasse).Create();
  end else begin
    Result := pClasse.NewInstance();
  end;
end;

function get(pClasse: String; pOwner : TComponent = nil) : TObject;
begin
  if GetClass(pClasse) = nil then
    Exit;

  Result := get(GetClass(pClasse), pOwner);
end;

function mtd(pClasse, pMetodo : String) : TMethod;
const
  cMETHOD = 'mObjeto.mtd()';
var
  vClass : TClass;
begin
  if pClasse = '' then
    raise Exception.create(ClasseUnInformed + ' / ' + cMETHOD);

  //---------------------------------------------------
  //verifica classe
  vClass := GetClass(pClasse);
  if vClass = nil then
    raise Exception.create(Format(ClasseNotFound, [pClasse]) + ' / ' + cMETHOD);
  //--

  //---------------------------------------------------
  //verifica metodo
  Result.Data := Pointer(vClass);
  Result.Code := vClass.MethodAddress(pMetodo);
  if Result.Code = nil then
    raise Exception.create(Format(MethodNotFound, [pMetodo, pClasse]) + ' / ' + cMETHOD);
  //--
end;

function mtd(pObject : TObject; pMetodo : String) : TMethod;
const
  cMETHOD = 'mObjeto.mtd()';
var
  vClass : TClass;
begin
  if pObject = nil then
    raise Exception.create(ObjectUnInformed + ' / ' + cMETHOD);

  //---------------------------------------------------
  //verifica endereco do metodo desejada para executa-lo
  Result.Data := Pointer(pObject);
  Result.Code := pObject.MethodAddress(pMetodo);
  if Result.Code = nil then
    raise Exception.create(Format(MethodNotFound, [pMetodo, pObject.ClassName]) + ' / ' + cMETHOD);
  //--
end;

end.
