unit mControl;

interface

uses
  Classes, SysUtils, StrUtils, TypInfo, Controls, Graphics, Forms,
  mIniFiles, mVariant, mLabel, mEdit, Windows;

  function GetValue(pObj : TObject; pCod : String) : Variant;
  procedure SetValue(pObj : TObject; pCod : String; pVal : Variant);

  function GetMethod(pObj : TObject; pCod : String) : Variant;
  procedure SetMethod(pObj : TObject; pCod : String; pVal : Variant);

  function GetValues(pControl : TControl) : TmVariant;
  procedure SetValues(pControl : TControl; pValues : TmVariant);

  procedure SetMover(pControl : TControl; pMover : Variant);

  procedure SetPosCenter(pControl : TControl; pPosicao : Integer = -1);

  procedure SetPosConf(pControl : TControl);
  procedure SetPosDesk(pControl : TControl);
  procedure SetPosWork(pControl : TControl);
  procedure SetPosWorkDiv(pControl : TControl);

  function SetPosPosi(pControl : TControl) : Integer;
  function SetPosResu(pControl : TControl) : Integer;

  procedure SetPosForm(pControl : TControl);

  procedure ExecLista(pObject : TObject);
  procedure ExecComp(pObject : TObject);

  function BuscaDescr(pObject : TObject) : String;

  function GetImageFundo() : Graphics.TBitmap;
  procedure SetImageFundo(pControl : TWinControl);

  procedure GetNumSeq(pObject : TObject; pValues : TmVariant);

  function GetOuvinteAcao(Sender : TObject) : String;

  function InheritsFrom(AObject : TObject; AClass: TClass): Boolean;

implementation

uses
  mClasseExec, mPersist, mFuncao, mItem, mXml;

//--

function GetValue(pObj : TObject; pCod : String) : Variant;
begin
  if GetPropInfo(pObj, pCod) <> nil then
    Result := GetPropValue(pObj, pCod)
  else
    Result := '';
end;

procedure SetValue(pObj : TObject; pCod : String; pVal : Variant);
begin
  if GetPropInfo(pObj, pCod) <> nil then
    SetPropValue(pObj, pCod, pVal);
end;

//--

function GetMethod(pObj : TObject; pCod : String) : Variant;
begin
  if GetPropInfo(pObj, pCod) <> nil then
    Result := GetPropValue(pObj, pCod)
  else
    Result := '';
end;

procedure SetMethod(pObj : TObject; pCod : String; pVal : Variant);
begin
  if GetPropInfo(pObj, pCod) <> nil then
    SetPropValue(pObj, pCod, pVal);
end;

//--

function GetValues(pControl : TControl) : TmVariant;
var
  vCampo, vValue : String;
  I : Integer;
begin
  Result := TmVariant.Create;

  with pControl do begin
    for I:=0 to ComponentCount-1 do begin
      vCampo := GetValue(Components[I], '_Campo');
      if vCampo = '' then
        Continue;

      vValue := GetValue(Components[I], '_Value');
      Result.putitem(vCampo, vValue)
    end;
  end;
end;

procedure SetValues(pControl : TControl; pValues : TmVariant);
var
  vCampo, vValue : String;
  I : Integer;
begin
  with pControl do begin
    for I:=0 to ComponentCount-1 do begin
      vCampo := GetValue(Components[I], '_Campo');
      if vCampo = '' then
        Continue;

      vValue := pValues.itemS(vCampo);
      SetValue(Components[I], '_Value', vValue);
    end;
  end;
end;

//--

procedure SetMover(pControl : TControl; pMover : Variant);
var
  vCampo : String;
  I : Integer;
begin
  with pControl do begin
    for I:=0 to ComponentCount-1 do begin
      vCampo := GetValue(Components[I], '_Campo');
      if vCampo = '' then
        Continue;

      SetValue(Components[I], '_Mover', pMover);
    end;
  end;
end;

//--

procedure SetPosCenter(pControl : TControl; pPosicao : Integer);
var
  vControl : TControl;
begin
  vControl := TControl.Create(nil);

  if mIniFiles.pegarB('', 'FORM', 'IN_MODOJANELA') then begin
    SetPosForm(vControl);
  end else begin
    SetPosWork(vControl);
  end;

  with pControl do begin
    Top := vControl.Top + (vControl.Height div 2) - (Height div 2);
    Left := vControl.Left + (vControl.Width div 2) - (Width div 2);

    if pPosicao <> -1 then
      Top := vControl.Top + ((vControl.Height div 100) * pPosicao) - (Height div 2);
  end;

  vControl.Free;
end;

//--

procedure SetPosConf(pControl : TControl);
begin
  with pControl do begin
    Top := mIniFiles.pegarI('', 'FORM', 'TOP', 0);
    Left := mIniFiles.pegarI('', 'FORM', 'LEFT', 0);
    Height := mIniFiles.pegarI('', 'FORM', 'HEIGHT', 768);
    Width := mIniFiles.pegarI('', 'FORM', 'WIDTH', 1024);
  end;
end;

procedure SetPosDesk(pControl : TControl);
begin
  with pControl do begin
    Top := Screen.DesktopTop;
    Left := Screen.DesktopLeft;
    Height := Screen.DesktopHeight;
    Width := Screen.DesktopWidth;
  end;
end;

procedure SetPosWork(pControl : TControl);
begin
  with pControl do begin
    Top := Screen.WorkAreaLeft;
    Left := Screen.WorkAreaLeft;
    Height := Screen.WorkAreaHeight;
    Width := Screen.WorkAreaWidth;
  end;
end;

procedure SetPosWorkDiv(pControl : TControl);
begin
  with pControl do begin
    Top := Screen.WorkAreaLeft;
    Left := Screen.WorkAreaLeft;
    Height := Screen.WorkAreaHeight;
    Width := Screen.WorkAreaWidth div 2;
  end;
end;

//--

function SetPosPosi(pControl : TControl) : Integer;
var
  vDsPosicao : String;
begin
  Result := -1;

  vDsPosicao := mIniFiles.pegar('', 'FORM', 'DS_POSICAO');
  if vDsPosicao = '' then
    Exit;

  vDsPosicao := AnsiReplaceStr(vDsPosicao, ' ', '|');

  with pControl do begin
    Top := StrToIntDef(getitem(vDsPosicao, 1), Top);
    Left := StrToIntDef(getitem(vDsPosicao, 2), Left);
    Height := StrToIntDef(getitem(vDsPosicao, 3), Height);
    Width := StrToIntDef(getitem(vDsPosicao, 4), Width);
  end;

  Result := 1;
end;

function SetPosResu(pControl : TControl) : Integer;
var
  vDsResolucao : String;
begin
  Result := -1;

  vDsResolucao := mIniFiles.pegar('', 'FORM', 'DS_RESOLUCAO');
  if vDsResolucao = '' then
    Exit;

  vDsResolucao := AnsiReplaceStr(vDsResolucao, 'x', '|');

  with pControl do begin
    Width := StrToIntDef(getitem(vDsResolucao, 1), Width);
    Height := StrToIntDef(getitem(vDsResolucao, 2), Height);
  end;

  Result := 1;
end;

//--

procedure SetPosForm(pControl : TControl);
begin
  if pControl is TForm then
    with TForm(pControl) do begin
      if (FormStyle in [fsNormal])
      and (BorderStyle in [bsSizeable, bsNone]) then {} else Exit;
    end;

  if mIniFiles.pegarB('', 'FORM', 'IN_MODOJANELA') then begin
    if SetPosPosi(pControl) = -1 then
      if SetPosResu(pControl) = -1 then
        SetPosConf(pControl)

  end else if mIniFiles.pegar('', 'FORM', 'TP_MODOJANELA') = 'CHEIA' then begin
    if pControl is TForm then
      with TForm(pControl) do begin
        Position := poDesigned;
        BorderStyle := bsNone;
      end;

    SetPosWork(pControl);

  end else if mIniFiles.pegar('', 'FORM', 'TP_MODOJANELA') = 'MAX' then begin
    if pControl is TForm then
      with TForm(pControl) do begin
        Position := poDesigned;
        WindowState := wsMaximized;
      end;

  end else if mIniFiles.pegar('', 'FORM', 'TP_MODOJANELA') = 'MEIA' then begin
    SetPosWorkDiv(pControl);

  end else begin
    SetPosWork(pControl);

  end;
end;

//--

procedure ExecLista(pObject : TObject);
var
  vParams, vResult : TmVariant;
  vClasse, vCampo : String;
begin
  if pObject is TmLabel then
    with TmLabel(pObject) do
      if _Edit <> nil then
        pObject := _Edit;

  vCampo := GetValue(pObject, '_Campo');
  if vCampo = '' then begin
    with TmEdit(pObject) do
      if Assigned(OnDblClick) then
        OnDblClick(pObject);
    Exit;
  end;

  vClasse := mControl.GetValue(pObject, '_Classe');
  if GetClass(vClasse) = nil then vClasse := 'TC_' + vClasse;
  if GetClass(vClasse) = nil then vClasse := 'Tc' + vClasse;
  if GetClass(vClasse) = nil then Exit;

  vParams := TmVariant.create;
  vParams.putitem('CD_CLASSE', vClasse);
  vParams.putitem('CD_CAMPO', vCampo);
  vParams := execClasse('TmCampoVal', 'getCampo', vParams);
  if vParams <> nil then
    Exit;

  vResult := execClasse('T_Lista', 'execute', vParams);
  if vResult.itemF('status') <> mrOk then
    Exit;

  mControl.SetValue(pObject, '_Value', vResult.itemV('CD_VALUE'));

  with TmEdit(pObject) do begin
    if (Assigned(OnExit)) then begin
      OnExit(pObject);
    end else if (Assigned(OnChange)) then begin
      OnChange(pObject);
    end else begin
      keybd_event(VK_TAB, 0, 0, 0);
    end;
  end;

  TmEdit(pObject).SelectAll;
end;

procedure ExecComp(pObject : TObject);
var
  vParams, vClasse : String;
  vClass : TClass;
begin
  vClasse := mControl.GetValue(pObject, 'Hint');
  if vClasse = '' then
    Exit;

  vClasse := IfNull(itemA('cls', vClasse), vClasse);
  if vClasse = '' then
   Exit;

  vClass := GetClass(vClasse);
  if vClass = nil then
    Exit;

  if vClass.InheritsFrom(TmPersist) then begin
    vParams := '';
    putitem(vParams, 'CD_CLASSE', vClasse);
    execClasse('T_Manut', 'execute', vParams);
    Exit;
  end;

  execClasse(vClasse, 'execute', '');
end;

//--

function BuscaDescr(pObject : TObject) : String;
var
  vPersist : TmPersist;
  vParams, vResult : TmVariant;
  vClasse, vLista, vCod, vDes, vVal : String;
begin
  Result := '';

  vVal := mControl.GetValue(pObject, '_Value');
  if vVal = '' then
    Exit;

  vClasse := mControl.GetValue(pObject, '_Classe');
  if vClasse = '' then
    Exit;

  vPersist := getPersistClass(vClasse);
  if vPersist = nil then
    Exit;

  vLista := vPersist.getLista(nil);
  vCod := itemA('cod', vLista);
  vDes := itemA('des', vLista);

  vParams := TmVariant.Create();
  vParams.putitem(vCod, vVal);
  vResult := vPersist.consultar(vParams);
  if vResult.itemS(vCod) <> '' then
    Result := vResult.itemS(vDes);

  FreeAndNil(vPersist);
end;

//--

function GetImageFundo() : Graphics.TBitmap;
const
  ArqImageFundo = 'fundo.bmp';
begin
  Result := nil;

  if not FileExists(ArqImageFundo) then
    Exit;

  Result := Graphics.TBitmap.Create;
  Result.LoadFromFile(ArqImageFundo);
end;

procedure SetImageFundo(pControl : TWinControl);
var
  vBitmap : Graphics.TBitmap;
begin
  vBitmap := GetImageFundo();
  if vBitmap <> nil then
    pControl.Brush.Bitmap := vBitmap;
end;

//--

procedure GetNumSeq(pObject: TObject; pValues : TmVariant);
var
  vNumSeq : String;
  vParams, vResult : TmVariant;
  vNrSequencia : Real;
begin
  vNumSeq := GetValue(pObject, '_NumSeq');
  if vNumSeq = '' then
    Exit;

  vParams := TmVariant.Create;
  vParams.putitem('num_seq', vNumSeq);
  vParams.putitem('lst_val', pValues);
  vResult := execObjeto('TsIncremento', 'getNumSeq', vParams);
  vNrSequencia := vResult.itemF('seq');
  if vNrSequencia = 0 then
    Exit;

  SetValue(pObject, '_Numero', FloatToStr(vNrSequencia));
end;

//--

function GetOuvinteAcao(Sender : TObject) : String;
begin
  Result := GetValue(Sender, '_Acao');
  if (Result = '') then Result := GetValue(Sender, 'Hint');
  if (Result = '') then Result := GetValue(Sender, 'Name');
end;

//--

function InheritsFrom(AObject : TObject; AClass: TClass): Boolean;
var
  ClassPtr: TClass;
begin
  ClassPtr := AObject.ClassType;
  while (ClassPtr <> nil) and (ClassPtr <> AClass) do
    ClassPtr := PPointer(Integer(ClassPtr) + vmtParent)^;
  Result := ClassPtr = AClass;
end;

//--

end.
