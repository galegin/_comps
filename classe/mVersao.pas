unit mVersao;

interface

uses
  Classes, SysUtils,
  mCollectionItem;

type
  TmVersao = class(TmCollectionItem)
  protected
    fCd_Versao : String;
	fU_Version : String;
    fDs_Versao : String;
  public
    constructor create(ACollection : TCollection); override;
  published
    property Cd_Versao : String read fCd_Versao write fCd_Versao;
	property U_Version : String read fU_Version write fU_Version;
    property Ds_Versao : String read fDs_Versao write fDs_Versao;
  end;

  function Instance() : TmVersao;

implementation

{ TmVersao }

var
  _instance : TmVersao;

  function Instance() : TmVersao;
  begin
    if not Assigned(_instance) then
      _instance := TmVersao.create(nil);
    Result := _instance;
  end;

  procedure Destroy();
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

  //--

constructor TmVersao.create(ACollection : TCollection);
begin
  inherited;
  
end;

initialization
  Instance;

finalization
  Destroy;

end.