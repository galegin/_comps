unit mClasse;

interface

uses
  Classes, SysUtils;

type
  TmClasse = class
  public
    class function CreateObjeto(AClass: TClass; AOwner : TComponent) : TObject;
  end;

implementation

class function TmClasse.CreateObjeto(AClass: TClass; AOwner : TComponent) : TObject;
begin
  if (AClass.InheritsFrom(TComponent)) then begin
    Result := TComponentClass(AClass).Create(AOwner);
  end else begin
    Result := AClass.NewInstance();
  end;
end;

end.