unit mGrid;

interface

uses
  SysUtils, Classes, Controls, Grids, DBGrids, StrUtils,
  Graphics, DB, Windows, Math, Forms, mFont;

type
  TInplaceEditListExtend = class(TInplaceEditList);
  TDBGridExtend = class(TDBGrid);
  TProcEvent = procedure(pDataSet : TDataSet) of object;

{$DEFINE color}

  TmGrid = class(TDBGrid)
  private
    FBloqInsert : Boolean;
    FBloqDelete : Boolean;
    FBloqOrdem : Boolean;

    {$IFDEF color}
    FColorSel : TmFont;
    FColorPar : TmFont;
    FColorImp : TmFont;
    FColorTit : TmFont;
    {$ENDIF}

    FEditing : String;
    FEditingField : String;
    FFocoIndex : Integer;
    FLstButton : String;
    FLstTipagem : String;
    FOrdenacao : String;

    FPickListAuto : Boolean;

    FSelecionar : Boolean;
  protected
    FDrawColumnCell : TDrawColumnCellEvent;

    function IsEditing(pFieldName : String) : Boolean;
  public
    constructor Create(AOwner: TComponent); override;

    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState); override;

    procedure TitleClick(Column: TColumn);
    procedure CellClick(Column: TColumn);
    procedure ColEnter(Sender: TObject);
    procedure ColExit(Sender: TObject);
    procedure KeyPress(Sender : TObject; var Key: Char);
    procedure KeyDown(Sender : TObject; var Key: Word; Shift: TShiftState);

    procedure PickListDropDown();

    procedure DesenharCheckBox(Rect : TRect; Column: TColumn);
    procedure DesenharButton(Rect: TRect; Column: TColumn);

    procedure NextGrid();

    procedure ClrPickList(Column : String);
    procedure SetPickList(Column, List : String; Padrao : String = '');

    procedure SetButton(pField, pDescr : String);
    procedure SetTipagem(pField, pList : String);

    procedure FieldGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure FieldSetText(Sender: TField; const Text: String);

    procedure SetarMetadataTmp(pMetadata : String);
    procedure SetarOrdem(pLstOrdem : String);
    procedure SetarTipagem(pLstTipagem : String);
    procedure SetarVisible(pLstVisible : String);
  published
    property _BloqInsert : Boolean read FBloqInsert write FBloqInsert;
    property _BloqDelete : Boolean read FBloqDelete write FBloqDelete;
    property _BloqOrdem : Boolean read FBloqOrdem write FBloqOrdem;

    {$IFDEF color}
    property _ColorSel : TmFont read FColorSel write FColorSel;
    property _ColorPar : TmFont read FColorPar write FColorPar;
    property _ColorImp : TmFont read FColorImp write FColorImp;
    property _ColorTit : TmFont read FColorTit write FColorTit;
    {$ENDIF}

    property _DrawColumnCell : TDrawColumnCellEvent read FDrawColumnCell write FDrawColumnCell;

    property _Editing: String read FEditing write FEditing;
    property _EditingField: String read FEditingField write FEditingField;

    property _FocoIndex : Integer read FFocoIndex write FFocoIndex;

    property _PickListAuto : Boolean read FPickListAuto write FPickListAuto;

    property _Selecionar : Boolean read FSelecionar write FSelecionar;
  end;

procedure Register;

implementation

uses
  mMetadata, mDataSet, mEstilo, mFuncao, mItem, mXml;

procedure Register;
begin
  RegisterComponents('Comps MIGUEL', [TmGrid]);
end;

{ TmGrid }

constructor TmGrid.Create(AOwner: TComponent);
begin
  inherited; // Create(AOwner);

  FixedColor := 12615680;
  TitleFont.Color := clWhite;

  Options := [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect,
              dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit];

  FBloqInsert := True;
  FBloqDelete := True;
  FBloqOrdem := True;

  {$IFDEF color}
  FColorSel := TmFont.Create($00C08080, clWhite);
  FColorPar := TmFont.Create($00DCDCBA, clBlack);
  FColorImp := TmFont.Create(clWhite, clBlack);
  FColorTit := TmFont.Create($12615680, clWhite);

  if not (csDesigning in ComponentState) then begin
    FColorSel := mEstilo.getFont('GRADE_SEL');
    FColorPar := mEstilo.getFont('GRADE_PAR');
    FColorImp := mEstilo.getFont('GRADE_IMP');
    FColorTit := mEstilo.getFont('GRADE_TIT');
  end;

  FixedColor := FColorTit._Cor;
  TitleFont.Color := FColorTit._CorFnt;
  {$ENDIF}

  FDrawColumnCell := nil;

  FFocoIndex := -1;

  OnTitleClick := TitleClick;
  OnCellClick := CellClick;
  OnColEnter := ColEnter;
  OnColExit := ColExit;
  OnEnter := ColEnter;
  OnKeyPress := KeyPress;
  OnKeyDown := KeyDown;

  BorderStyle := bsNone;
  Font.Size := 16;
  TitleFont.Size := 16;
end;

procedure TmGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  {$IFDEF color}
  if (gdSelected in State) then begin
    Canvas.Font.Color := FColorSel._CorFnt;
    Canvas.Brush.Color := FColorSel._Cor;
  end else begin
    if odd(DataSource.DataSet.RecNo) then begin
      Canvas.Font.Color := FColorPar._CorFnt;
      Canvas.Brush.Color := FColorPar._Cor;
    end else begin
      Canvas.Font.Color := FColorImp._CorFnt;
      Canvas.Brush.Color := FColorImp._Cor;
    end;
  end;

  with Column.Field do begin
    if (DataType = ftBoolean) then begin
      if (AsBoolean) then begin
        if (gdSelected in State) then begin
          Canvas.Font.Color := FColorSel._Cor;
        end else if odd(TDataSet(TDataSource(DataSource).DataSet).RecNo) then begin
          Canvas.Font.Color := FColorPar._Cor;
        end else begin
          Canvas.Font.Color := FColorImp._Cor;
        end;
      end;
    end else if (Copy(FieldName,1,3) = 'IN_') then begin
      if (IsStringTrue(AsString)) then begin
        if (gdSelected in State) then begin
          Canvas.Font.Color := FColorSel._Cor;
        end else if odd(TDataSet(TDataSource(DataSource).DataSet).RecNo) then begin
          Canvas.Font.Color := FColorPar._Cor;
        end else begin
          Canvas.Font.Color := FColorImp._Cor;
        end;
      end;
    end;
  end;

  Canvas.FillRect(Rect);
  DefaultDrawDataCell(Rect,columns[datacol].field,state);

  with Column.Field do begin
    if (DataType = ftBoolean)
    or (Copy(FieldName,1,3) = 'IN_') then begin
      DesenharCheckBox(Rect, Column);
    end else if (Copy(FieldName,1,3) = 'BT_') then begin
      DesenharButton(Rect, Column);
    end;
  end;

  if (Assigned(FDrawColumnCell)) then begin
    FDrawColumnCell(Self, Rect, DataCol, Column, State);
  end;
  {$ENDIF}
end;

function TmGrid.IsEditing(pFieldName : String) : Boolean;
begin
  Result := (FEditing = '') or (PosItem(pFieldName, FEditing) > 0);
end;

procedure TmGrid.TitleClick(Column: TColumn);
var
  vDataSet : TmDataSet;
  vInOrdenar : Boolean;

  function GetOrdem(pLstOrdem : String) : String;
  var
    vOrdem : String;
  begin
    Result := '';

    pLstOrdem := listCd(pLstOrdem);
    while pLstOrdem <> '' do begin
      vOrdem := getitem(pLstOrdem);
      if vOrdem = '' then Break;
      delitem(pLstOrdem);
      Result := Result + IfThen(Result<>'',';') + vOrdem;
    end;
  end;

begin
  if (FBloqOrdem) then
    Exit;
  if (DataSource = nil) then
    Exit;

  vDataSet := TmDataSet(DataSource.DataSet);
  if (vDataSet = nil) then
    Exit;

  vInOrdenar := True;

  with Column do begin
    if (FSelecionar) then begin
      if (Copy(FieldName,1,3) = 'IN_') then begin
        if (IsEditing(FieldName)) then begin
          vDataSet.selecionarTodos(FieldName);
          vInOrdenar := False;
        end;
      end;
    end;
  end;

  if (vInOrdenar = True) then begin
    with Column do begin
      if (Pos(' [A]', Title.Caption) > 0) then begin
        Title.Caption := AnsiReplaceStr(Title.Caption, ' [A]', ' [D]');
        putitem(FOrdenacao, FieldName, 'd');

      end else if (Pos(' [D]', Title.Caption) > 0) then begin
        Title.Caption := AnsiReplaceStr(Title.Caption, ' [D]', '');
        delitem(FieldName, FOrdenacao);

      end else begin
        Title.Caption := Title.Caption + ' [A]';
        putitem(FOrdenacao, FieldName, 'a');

      end;
    end;

    vDataSet.ordenar(FOrdenacao);

    vDataSet.First;
  end;

  //FprcTitleClick(Column);
end;

procedure TmGrid.CellClick(Column: TColumn);
var
  vDataSet : TmDataSet;
begin
  vDataSet := TmDataSet(DataSource.DataSet);
  if (vDataSet = nil) then
    Exit;

  with Column do begin
    if (Copy(Field.FieldName,1,3) = 'IN_') then
      vDataSet.selecionar(Field.FieldName);
    if (FEditingField <> '') or (FEditing <> '') then
      ColEnter(Self);
  end;

  //FprcCellClick(Column);
end;

procedure TmGrid.ColEnter(Sender: TObject);
var
  vDataSet : TmDataSet;
begin
  if SelectedField = nil then
    Exit;

  if (FFocoIndex <> -1) then begin
    if (SelectedIndex <> FFocoIndex) then begin
      SelectedIndex := FFocoIndex;
    end;
  end;

  with SelectedField do begin
    if (Copy(FieldName,1,3) <> 'IN_')
    and (IsEditing(FieldName)) then begin
      Options := Options + [dgEditing]
    end else begin
      Options := Options - [dgEditing];
    end;
  end;

  if (dgEditing in Options) then begin
    if (FEditingField <> '') then begin
      if (DataSource = nil) or (DataSource.DataSet = nil) then Exit;
      vDataSet := TmDataSet(DataSource.DataSet);
      if (itemB(FEditingField, vDataSet) = False) then begin
        Options := Options - [dgEditing];
      end;
    end;
  end;

  //if not (dgEditing in Options) then begin
  //  FprcColEnter(Sender);
  //  Exit;
  //end;

  // Abrir PICKLIST automaticamente
  if (FPickListAuto) then
    PickListDropDown();

  //FprcColEnter(Sender);
end;

procedure TmGrid.ColExit(Sender: TObject);
begin
  //FprcColExit(Sender);
end;

procedure TmGrid.KeyDown(Sender : TObject; var Key: Word; Shift: TShiftState);
var
  vDataSet : TmDataSet;
begin
  if (FEditingField <> '') or (FEditing <> '') then
    ColEnter(Self);

  if (Key = VK_SPACE) then begin
    if (SelectedField = nil) then
      Exit;
    if (Copy(SelectedField.FieldName,1,3) = 'IN_') then begin
      vDataSet := TmDataSet(DataSource.DataSet);
      vDataSet.Selecionar(SelectedField.FieldName);
      //FposSelecionar(vDataSet);
      vDataSet.Next;
    end;
  end;

  // Bloquear auto-inserção no dbgrid
  if (Key = VK_DOWN) then begin
    if (FBloqInsert) then begin
      with DataSource.DataSet do begin
        if (State = dsEdit) then
          Post;
        DisableControls;
        Next;
        if EOF then
          Key := 0
        else
          Prior;
        EnableControls;
      end;
    end;
  end;

  // Bloquear delete no dbgrid
  if (Key = VK_DELETE) then begin
    if (Shift = [ssCtrl]) then begin
      if (FBloqDelete) then begin
        Key := 0;
      end;
    end;
  end;

  //FprcKeyDown(Sender, Key, Shift);
end;

procedure TmGrid.KeyPress(Sender : TObject; var Key: Char);
var
  vAchei : Boolean;
  I : Integer;
begin
  vAchei := False;

  if (Columns.Count = 0)
  or (SelectedIndex = -1)
  or (SelectedField = nil) then
    Exit;

  for I:=0 to Columns.Count-1 do begin
    with Columns[I] do begin
      if (SelectedField.FieldName = FieldName)
      and (PickList.Count > 0) then begin
        vAchei := True;
      end;
    end;
  end;

  if (vAchei) then
    Key := #0;

  //FprcKeyPress(Sender, Key);
end;

//------------------------------------------------------------------------------
procedure TmGrid.PickListDropDown();
begin
  with Columns[SelectedIndex] do begin
    if (PickList.Count > 0) then begin
      if (Field.AsString = '') then begin
        EditorMode := True;
        TInplaceEditListExtend(TDBGridExtend(Self).InplaceEditor).DropDown;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TmGrid.DesenharCheckBox(Rect : TRect; Column: TColumn);
var
  Check: Integer;
  R: TRect;
begin
  with Column.Field do begin
    if (DataType = ftBoolean)
    or (Copy(FieldName,1,3) = 'IN_') then begin
      Canvas.FillRect(Rect);

      if (DataType = ftBoolean) then begin
        Check := IfThen(AsBoolean, DFCS_CHECKED, 0);
      end else begin
        Check := IfThen(IsStringTrue(AsString), DFCS_CHECKED, 0);
      end;

      R := Rect;
      InflateRect(R, -2, -2); {Diminue o tamanho do CheckBox}
      DrawFrameControl(Canvas.Handle, R, DFC_BUTTON, DFCS_BUTTONCHECK or Check);
    end;
  end;
end;

procedure TmGrid.DesenharButton(Rect: TRect; Column: TColumn);
var
  BUTTON: Integer;
  SCapt : string;
  R: TRect;
begin
  Canvas.FillRect(Rect);
  BUTTON := 0;
  R := Rect;
  SCapt := item(Column.FieldName, FLstButton);
  InflateRect(R, -2, -2); //Diminue o tamanho do Botão
  DrawFrameControl(Canvas.Handle, R, BUTTON, BUTTON or BUTTON);
  with Canvas do begin
    Brush.Style := bsClear;
    Font.Color := clBtnText;
    TextRect(Rect, (Rect.Left + Rect.Right - TextWidth(SCapt)) div 2, (Rect.Top + Rect.Bottom - TextHeight(SCapt)) div 2, SCapt);
  end;
end;

procedure TmGrid.NextGrid();
begin
  if (SelectedIndex < (FieldCount-1)) then begin
    keybd_event(VK_TAB, 0, 0, 0);
    exit;
  end;

  with DataSource.DataSet do begin
    if (RecNo < RecordCount) then begin
      Next;
      SelectedIndex := 0;
      exit;
    end;
  end;

  SelectedIndex := 0;
end;

//----------------------------------------------------------------------
procedure TmGrid.ClrPickList(Column : String);
var
  I : Integer;
begin
  if (Column = '') then
    Exit;

  for I:=0 to Columns.Count-1 do begin
    with Columns[I] do begin
      if (FieldName = Column) then begin
        PickList.Clear();
      end;
    end;
  end;
end;

procedure TmGrid.SetPickList(Column, List : String; Padrao : String = '');
var
  I, II, T : Integer;
begin
  if (Column = '') or (List = '') then
    Exit;

  T := itemcount(List);

  for I:=0 to Columns.Count-1 do begin
    with Columns[I] do begin
      if (FieldName = Column) then begin
        with PickList do begin
          Clear();
          if (Padrao = '=') then Add('')
          else if (Padrao <> '') then Add(Padrao);
          for II:=1 to T do begin
            Add(getitem(List,II));
          end;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------
procedure TmGrid.SetButton(pField, pDescr : String);
var
  vField : TField;
begin
  vField := TField(DataSource.DataSet.FindField(pField));
  if (vField <> nil) then
    putitemX(FLstButton, pField, pDescr);
end;

procedure TmGrid.SetTipagem(pField, pList : String);
var
  vField : TField;
begin
  vField := TField(DataSource.DataSet.FindField(pField));
  if (vField = nil) then
    Exit;

  if (Pos('|', pList) > 0) then
    SetPickList(pField, pList)
  else
    SetPickList(pField, listDs(pList));

  if (Pos('|', pList) > 0) then
    Exit;

  vField.Alignment := taLeftJustify;
  vField.OnGetText := FieldGetText;
  vField.OnSetText := FieldSetText;
  putitemX(FLstTipagem, pField, pList);
end;

procedure TmGrid.FieldGetText(Sender: TField; var Text: String; DisplayText: Boolean);
var
  vLista : String;
begin
  vLista := itemX(Sender.FieldName, FLstTipagem);
  Text := item(Sender.AsString, vLista);
end;

procedure TmGrid.FieldSetText(Sender: TField; const Text: String);
var
  vLista : String;
begin
  vLista := itemX(Sender.FieldName, FLstTipagem);
  Sender.AsString := itemDs(Text, vLista);
end;

procedure TmGrid.SetarMetadataTmp(pMetadata : String);
begin
  with DataSource do
    if Assigned(DataSet) then
      TmDataSet(DataSet).SetarMetadataTmp(pMetadata);

  //SetarOrdem(TmMetadata.getMetadataXml(pMetadata, 'cod'));
  //SetarTipagem(TmMetadata.getMetadataXml(pMetadata, 'lst'));
end;

procedure TmGrid.SetarOrdem(pLstOrdem : String);
var
  vLstCod, vCod : String;
  I, vSeq : Integer;
begin
  vLstCod := pLstOrdem;
  if (vLstCod = '') then
    Exit;

  SetarVisible(vLstCod);
  vSeq := 0;

  while vLstCod <> '' do begin
    vCod := getitem(vLstCod);
    if vCod = '' then Break;
    delitem(vLstCod);

    for I:=0 to Columns.Count-1 do begin
      with Columns[I] do begin
        if (FieldName = vCod) and (Visible) then begin
          Index := vSeq;
          Inc(vSeq);
          Break;
        end;
      end;
    end;
  end;
end;

procedure TmGrid.SetarTipagem(pLstTipagem : String);
var
  vLstTipagem, vTipagem, vValue : String;
begin
  vLstTipagem := listCd(pLstTipagem);
  while vLstTipagem <> '' do begin
    vTipagem := getitem(vLstTipagem);
    if vTipagem = '' then Break;
    delitem(vLstTipagem);
    vValue := item(vTipagem, pLstTipagem);
    SetTipagem(vTipagem, vValue);
  end;
end;

procedure TmGrid.SetarVisible(pLstVisible : String);
var
  vLstCod, vCod : String;
  I : Integer;
begin
  vLstCod := pLstVisible;
  if (vLstCod = '') then
    Exit;

  with DataSource do
    if Assigned(DataSet) then
      TmDataSet(DataSet).SetarVisible(pLstVisible);

  for I:=0 to Columns.Count-1 do
    with Columns[I] do
      Visible := (PosItem(FieldName, pLstVisible) > 0);
end;

end.