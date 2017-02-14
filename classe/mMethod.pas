unit mMethod;

interface

uses
  Classes, SysUtils, TypInfo;

type
  TmMethod = class
  public
    class function Get(AObject : TObject; ANome : String) : TObject;
    class procedure Put(AObject : TObject; ANome : String; AValue : TObject);
  end;

implementation

{ TmMethod }

class function TmMethod.Get(AObject: TObject; ANome: String): TObject;
var
  vPropInfo : PPropInfo;
  //vMethod : TMethod;
begin
  vPropInfo := GetPropInfo(AObject, ANome);
  if Assigned(vPropInfo) then
    Result := GetObjectProp(AObject, ANome)
  else
    Result := nil;

  //vMethod := GetMethodProp(AObject, ANome);
end;

class procedure TmMethod.Put(AObject: TObject; ANome: String; AValue: TObject);
//var
  (* vPropInfo : PPropInfo; *)
begin
  (* vPropInfo := GetPropInfo(AObject, ANome);
  if Assigned(vPropInfo) then
    SetObjectProp(AObject, ANome, AValue); *)
end;

end.
