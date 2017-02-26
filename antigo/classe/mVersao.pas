unit mVersao;

interface

uses
  Classes, SysUtils, Windows, TypInfo,
  mPersistPAO;

type
  TmVersao = class(TmPersistPAO)
  protected
    FCdVersao : String;
    FDsVersao : String;
  public
    constructor create(Aowner : TComponent); override;
  published
    property CdVersao : String read FCdVersao write FCdVersao;
    property DsVersao : String read FDsVersao write FDsVersao;
  end;

  function Instance() : TmVersao;

implementation

{ TmVersao }

var
  _instance : TmVersao;

  function getInstance() : TmVersao;
  begin
    if _instance = nil then
      _instance := TmVersao.create(nil);
    Result := _instance;
  end;

  procedure dropInstance();
  begin
    if _instance <> nil then
      _instance.Free;
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