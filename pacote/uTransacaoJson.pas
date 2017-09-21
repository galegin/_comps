unit uTransacaoJson;

(* TransacaoJson *)

interface

uses
  Classes, SysUtils, StrUtils, Variants,
  uTransacao, uTransitem, uTransimposto;

type
  TTransacaoJson = class(TComponent)
  private
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function ToJson(AList : TList) : String;
    function ToList(AJson : String) : TList;
  published
  end;

  function Instance : TTransacaoJson;
  procedure Destroy;

implementation

uses
  uLkJSON, Contnrs;

var
  _instance : TTransacaoJson;

  function Instance : TTransacaoJson;
  begin
    if not Assigned(_instance) then
      _instance := TTransacaoJson.Create(nil);
    Result := _instance;
  end;

  procedure Destroy;
  begin
    if Assigned(_instance) then
      FreeAndNil(_instance);
  end;

(* TransacaoJson *)

constructor TTransacaoJson.Create(AOwner : TComponent);
begin
  inherited;

end;

destructor TTransacaoJson.Destroy;
begin

  inherited;
end;

function TTransacaoJson.ToJson(AList: TList): String;
var
  vTransacaosJson, vTransitemsJson, vTransimpostosJson : TlkJSONlist;
  vTransacaoJson, vTransitemJson, vTransimpostoJson : TlkJSONobject;
  vObjTransacao : TTransacao;
  vObjTransitem : TTransitem;
  vObjTransimposto : TTransimposto;
  I, J, L : Integer;
begin
  vTransacaosJson := TlkJSONlist.Create;

  for I := 0 to AList.Count - 1 do begin
    vObjTransacao := TTransacao(AList[I]);

    vTransitemsJson := TlkJSONlist.Create();
    for J := 0 to vObjTransacao.Itens.Count - 1 do begin
      vObjTransitem := TTransitem(vObjTransacao.Itens[J]);

      vTransimpostosJson := TlkJSONlist.Create();
      for L := 0 to vObjTransitem.Impostos.Count - 1 do begin
        vObjTransimposto := TTransimposto(vObjTransitem.Impostos[L]);

        vTransimpostoJson := TlkJSONobject.Create();
        vTransimpostoJson.Add('Cd_Imposto', vObjTransimposto.Cd_Imposto);
        vTransimpostoJson.Add('Pr_Aliquota', vObjTransimposto.Pr_Aliquota);
        vTransimpostoJson.Add('Vl_Basecalculo', vObjTransimposto.Vl_Basecalculo);
        vTransimpostoJson.Add('Pr_Basecalculo', vObjTransimposto.Pr_Basecalculo);
        vTransimpostoJson.Add('Pr_Redbasecalculo', vObjTransimposto.Pr_Redbasecalculo);
        vTransimpostoJson.Add('Vl_Imposto', vObjTransimposto.Vl_Imposto);
        vTransimpostoJson.Add('Vl_Outro', vObjTransimposto.Vl_Outro);
        vTransimpostoJson.Add('Vl_Isento', vObjTransimposto.Vl_Isento);
        vTransimpostoJson.Add('Vl_Isento', vObjTransimposto.Vl_Isento);
        vTransimpostoJson.Add('Cd_Cst', vObjTransimposto.Cd_Cst);
        vTransimpostoJson.Add('Cd_Csosn', vObjTransimposto.Cd_Csosn);
        vTransimpostosJson.Add(vTransimpostoJson);
      end;

      vTransitemJson := TlkJSONobject.Create();
      vTransitemJson.Add('Nr_Item', vObjTransitem.Nr_Item);
      vTransitemJson.Add('Id_Produto', vObjTransitem.Id_Produto);
      vTransitemJson.Add('Cd_Produto', vObjTransitem.Cd_Produto);
      vTransitemJson.Add('Ds_Produto', vObjTransitem.Ds_Produto);
      vTransitemJson.Add('Cd_Cfop', vObjTransitem.Cd_Cfop);
      vTransitemJson.Add('Cd_Especie', vObjTransitem.Cd_Especie);
      vTransitemJson.Add('Cd_Ncm', vObjTransitem.Cd_Ncm);
      vTransitemJson.Add('Qt_Item', vObjTransitem.Qt_Item);
      vTransitemJson.Add('Vl_Custo', vObjTransitem.Vl_Custo);
      vTransitemJson.Add('Vl_Unitario', vObjTransitem.Vl_Unitario);
      vTransitemJson.Add('Vl_Item', vObjTransitem.Vl_Item);
      vTransitemJson.Add('Vl_Variacao', vObjTransitem.Vl_Variacao);
      vTransitemJson.Add('Vl_Variacaocapa', vObjTransitem.Vl_Variacaocapa);
      vTransitemJson.Add('Vl_Frete', vObjTransitem.Vl_Frete);
      vTransitemJson.Add('Vl_Seguro', vObjTransitem.Vl_Seguro);
      vTransitemJson.Add('Vl_Outro', vObjTransitem.Vl_Outro);
      vTransitemJson.Add('Vl_Despesa', vObjTransitem.Vl_Despesa);
      vTransitemJson.Add('Impostos', vTransimpostosJson);
      vTransitemsJson.Add(vTransitemJson);
    end;

    vTransacaoJson := TlkJSONobject.Create();
    vTransacaoJson.Add('Id_Transacao', vObjTransacao.Id_Transacao);
    vTransacaoJson.Add('Id_Empresa', vObjTransacao.Id_Empresa);
    vTransacaoJson.Add('Id_Pessoa', vObjTransacao.Id_Pessoa);
    vTransacaoJson.Add('Id_Operacao', vObjTransacao.Id_Operacao);
    vTransacaoJson.Add('Dt_Transacao', vObjTransacao.Dt_Transacao);
    vTransacaoJson.Add('Tp_Situacao', vObjTransacao.Tp_Situacao);
    vTransacaoJson.Add('Dt_Cancelamento', vObjTransacao.Dt_Cancelamento);
    vTransacaoJson.Add('Itens', vTransitemsJson);
    vTransacaosJson.Add(vTransacaoJson);
  end;

  I := 0;
  Result := GenerateReadableText(vTransacaosJson, I);
end;

function TTransacaoJson.ToList(AJson: String): TList;
var
  vTransacaosJson, vTransitemsJson, vTransimpostosJson : TlkJSONlist;
  vTransacaoJson, vTransitemJson, vTransimpostoJson : TlkJSONobject;
  vObjTransacao : TTransacao;
  vObjTransitem : TTransitem;
  vObjTransimposto : TTransimposto;
  I, J, L : Integer;
begin
  Result := TList.Create;

  vTransacaosJson := TlkJSON.ParseText(AJson) as TlkJSONlist;
  for I := 0 to vTransacaosJson.Count - 1 do begin
    vTransacaoJson := vTransacaosJson.Child[I] as TlkJSONobject;

    vObjTransacao := TTransacao.Create(nil);
    vObjTransacao.Id_Transacao := vTransacaoJson.getString('Id_Transacao');
    vObjTransacao.Id_Empresa := vTransacaoJson.getInt('Id_Empresa');
    vObjTransacao.Id_Pessoa := vTransacaoJson.getString('Id_Pessoa');
    vObjTransacao.Id_Operacao := vTransacaoJson.getString('Id_Operacao');
    vObjTransacao.Dt_Transacao := vTransacaoJson.getDouble('Dt_Transacao');
    vObjTransacao.Nr_Transacao := vTransacaoJson.getInt('Nr_Transacao');
    vObjTransacao.Tp_Situacao := vTransacaoJson.getInt('Tp_Situacao');
    vObjTransacao.Dt_Cancelamento := vTransacaoJson.getDouble('Dt_Cancelamento');

    vTransitemsJson := vTransacaoJson.Field['Itens'] as TlkJSONlist;
    for J := 0 to vTransitemsJson.Count - 1 do begin
      vTransitemJson := vTransitemsJson.Child[J] as TlkJSONobject;

      vObjTransitem := vObjTransacao.Itens.Add;
      vObjTransitem.Nr_Item := vTransitemJson.getInt('Nr_Item');
      vObjTransitem.Id_Produto := vTransitemJson.getString('Id_produto');
      vObjTransitem.Cd_Produto := vTransitemJson.getInt('Cd_Produto');
      vObjTransitem.Ds_Produto := vTransitemJson.getString('Ds_Produto');
      vObjTransitem.Cd_Cfop := vTransitemJson.getInt('Cd_Cfop');
      vObjTransitem.Cd_Especie := vTransitemJson.getString('Cd_Especie');
      vObjTransitem.Cd_Ncm := vTransitemJson.getString('Cd_Ncm');
      vObjTransitem.Qt_Item := vTransitemJson.getDouble('Qt_Item');
      vObjTransitem.Vl_Custo := vTransitemJson.getDouble('Vl_Custo');
      vObjTransitem.Vl_Unitario := vTransitemJson.getDouble('Vl_Unitario');
      vObjTransitem.Vl_Item := vTransitemJson.getDouble('Vl_Item');
      vObjTransitem.Vl_Variacao := vTransitemJson.getDouble('Vl_Variacao');
      vObjTransitem.Vl_Variacaocapa := vTransitemJson.getDouble('Vl_Variacaocapa');
      vObjTransitem.Vl_Frete := vTransitemJson.getDouble('Vl_Frete');
      vObjTransitem.Vl_Seguro := vTransitemJson.getDouble('Vl_Seguro');
      vObjTransitem.Vl_Outro := vTransitemJson.getDouble('Vl_Outro');
      vObjTransitem.Vl_Despesa := vTransitemJson.getDouble('Vl_Despesa');

      vTransimpostosJson := vTransitemJson.Field['Impostos'] as TlkJSONlist;
      for L := 0 to vTransimpostosJson.Count - 1 do begin
        vTransimpostoJson := vTransimpostosJson.Child[L] as TlkJSONobject;

        vObjTransimposto := vObjTransitem.Impostos.Add;
        vObjTransimposto.Cd_Imposto := vTransimpostoJson.getInt('Cd_Imposto');
        vObjTransimposto.Pr_Aliquota := vTransimpostoJson.getDouble('Pr_Aliquota');
        vObjTransimposto.Vl_Basecalculo := vTransimpostoJson.getDouble('Vl_Basecalculo');
        vObjTransimposto.Pr_Basecalculo := vTransimpostoJson.getDouble('Pr_Basecalculo');
        vObjTransimposto.Pr_Redbasecalculo := vTransimpostoJson.getDouble('Pr_Redbasecalculo');
        vObjTransimposto.Vl_Imposto := vTransimpostoJson.getDouble('Vl_Imposto');
        vObjTransimposto.Vl_Outro := vTransimpostoJson.getDouble('Vl_Outro');
        vObjTransimposto.Vl_Isento := vTransimpostoJson.getDouble('Vl_Isento');
        vObjTransimposto.Cd_Cst := vTransimpostoJson.getString('Cd_Cst');
        vObjTransimposto.Cd_Csosn := vTransimpostoJson.getString('Cd_Csosn');
      end;

    end;

    Result.Add(vObjTransacao);
  end;

end;

initialization
  //Instance();

finalization
  Destroy();

end.
