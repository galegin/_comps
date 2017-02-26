unit mVersao;

interface

uses
  Classes, SysUtils, StrUtils,
  mCollectionItem;

type
  TmVersao = class(TmCollectionItem)
  protected
    fCd_Versao : String;
	fU_Version : String;
	fDs_Versao : String;
  public
    constructor create(Aowner : TComponent); override;
  published
    property Cd_Versao : String read fCd_Versao write fCd_Versao;
	property U_Version : String read fU_Version write fU_Version;
	property Ds_Versao : String read fDs_Versao write fDs_Versao;
  end;

  function Instance : TmVersao;

implementation

{ TmVersao }

var
  _instance : TmVersao;

  function Instance : TmVersao;
  begin
    if not Assigned(_instance) then
      _instance := TmVersao.create(nil);
    Result := _instance;
  end;

  //--

constructor TmVersao.create(Aowner: TComponent);
begin
  _Arquivo := 'versao.ini';
  _Metadata :=
    '<CdVersao cod="CD_VERSAO" des="Cd Versao" tpf="KEY" tpd="ALFA" tam="20" dec="0" />' +
    '<DsVersao cod="DS_VERSAO" des="Ds Versao" tpf="NUL" tpd="ALFA" tam="60" dec="0" />' ;
  inherited;
end;

end.