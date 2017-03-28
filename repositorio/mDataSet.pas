unit mDataSet;

interface

uses
  Classes, SysUtils, StrUtils, Math, DB, DBClient,
  mObjeto, mClasse, mString, mValue;

type
  TmDataSet_Notify = record
    AfterPost : TDataSetNotifyEvent;
    BeforePost : TDataSetNotifyEvent;
  end;

  TTipoRetorno = (tprAvg, tprMax, tprMin, tprSum);

  TmDataSet = class(TComponent)
  public
    class function GetValues(ADataSet: TDataSet): TmValueList;
    class procedure SetValues(ADataSet: TDataSet; AValues : TmValueList);

    class function GetCollection(ADataSet: TDataSet; AItemClass: TCollectionItemClass): TCollection;
    class procedure SetCollection(ADataSet: TDataSet; ACollection: TCollection);

    class procedure ClearNotify(ADataSet: TDataSet);
    class function GetNotify(ADataSet: TDataSet) : TmDataSet_Notify;
    class procedure SetNotify(ADataSet: TDataSet; ANotify: TmDataSet_Notify);

    class function PegarB(ADataSet: TDataSet; ACampo: String) : Boolean;
    class procedure SetarB(ADataSet: TDataSet; ACampo: String; AValue : Boolean);

    class function PegarD(ADataSet: TDataSet; ACampo: String) : TDateTime;
    class procedure SetarD(ADataSet: TDataSet; ACampo: String; AValue : TDateTime);

    class function PegarF(ADataSet: TDataSet; ACampo: String) : Real;
    class procedure SetarF(ADataSet: TDataSet; ACampo: String; AValue : Real);

    class function PegarI(ADataSet: TDataSet; ACampo: String) : Integer;
    class procedure SetarI(ADataSet: TDataSet; ACampo: String; AValue : Integer);

    class function PegarS(ADataSet: TDataSet; ACampo: String) : String;
    class procedure SetarS(ADataSet: TDataSet; ACampo: String; AValue : String);

    class procedure FromObject(AObject : TObject; ADataSet: TDataSet);
    class procedure ToObject(ADataSet: TDataSet; AObject : TObject);

    class function Calcular(ADataSet: TDataSet; ACampo : String; ATipoRetorno : TTipoRetorno) : Real;

    class function Avg(ADataSet: TDataSet; ACampo : String) : Real;
    class function Max(ADataSet: TDataSet; ACampo : String) : Real;
    class function Min(ADataSet: TDataSet; ACampo : String) : Real;
    class function Sum(ADataSet: TDataSet; ACampo : String) : Real;
  end;

implementation

{ TmDataSet }

class function TmDataSet.GetValues(ADataSet: TDataSet): TmValueList;
var
  I : Integer;
  Key : Boolean;
  Nome : String;
  TipoField : TTipoField;
begin
  Result := TmValueList.Create;

  Key := True;

  with ADataSet do begin
    for I := 0 to FieldCount - 1 do begin
      with Fields[I] do begin
        Nome := FieldName;

        if LowerCase(FieldName) = 'u_version' then
          Key := False;

        TipoField := TTipoField(IfThen(Key, Ord(tfKey), IfThen(Required, Ord(tfReq), Ord(tfNul))));

        case DataType of
          ftBoolean : begin
            Result.Add(TmValueBool.Create(Nome, AsBoolean)).TipoField := TipoField;
          end;
          ftDate, ftDateTime, ftTime, ftTimeStamp : begin
            Result.Add(TmValueDate.Create(Nome, AsDateTime)).TipoField := TipoField;
          end;
          ftFloat, ftBCD, ftFMTBcd: begin
            Result.Add(TmValueFloat.Create(Nome, AsFloat)).TipoField := TipoField;
          end;
          ftInteger, ftSmallint, ftWord: begin
            Result.Add(TmValueInt.Create(Nome, AsInteger)).TipoField := TipoField;
          end;
          ftString, ftWideString, ftMemo, ftFmtMemo, ftOraClob: begin
            if TmString.StartsWiths(LowerCase(FieldName), 'in_') then
              Result.Add(TmValueBool.Create(Nome, (AsString = 'T'))).TipoField := TipoField
            else
              Result.Add(TmValueStr.Create(Nome, AsString)).TipoField := TipoField;
          end;
          ftVariant: begin
            Result.Add(TmValueVar.Create(Nome, AsVariant)).TipoField := TipoField;
          end;
        end;

      end;
    end;
  end;
end;

class procedure TmDataSet.SetValues(ADataSet: TDataSet; AValues: TmValueList);
var
  vValue : TmValue;
  vEdit : Boolean;
  I : Integer;
begin
  with ADataSet do begin
    vEdit := State in [dsInsert, dsEdit];
    if not vEdit then
      Edit;

    for I := 0 to FieldCount - 1 do begin
      with Fields[I] do begin
        vValue := AValues.IndexOf(FieldName);

        if vValue <> nil then begin
          with vValue do begin
            case Tipo of
              tvBoolean:
                AsBoolean := (vValue as TmValueBool).Value;
              tvDateTime:
                AsDateTime := (vValue as TmValueDate).Value;
              tvInteger:
                AsInteger := (vValue as TmValueInt).Value;
              tvFloat:
                AsFloat := (vValue as TmValueFloat).Value;
              tvString:
                AsString := (vValue as TmValueStr).Value;
              tvVariant:
                AsVariant := (vValue as TmValueVar).Value;
            end;
          end;
        end;

      end;
    end;

    if not vEdit then
      Post;
  end;
end;

//--

class function TmDataSet.GetCollection(ADataSet: TDataSet; AItemClass:
  TCollectionItemClass): TCollection;
var
  vValues : TmValueList;
  vRecNo : Integer;
begin
  Result := TCollection.Create(AItemClass);

  with ADataSet do begin
    DisableControls;

    vRecNo := RecNo;

    First;
    while not EOF do begin
      vValues := TmDataSet.GetValues(ADataSet);
      TmObjeto.SetValues(Result.Add, vValues);
      Next;
    end;

    if vRecNo > 0 then
      RecNo := vRecNo;

    EnableControls;
  end;
end;

class procedure TmDataSet.SetCollection(ADataSet: TDataSet; ACollection:
  TCollection);
var
  vNotify : TmDataSet_Notify;
  vValues : TmValueList;
  I : Integer;
begin
  with ADataSet do begin
    DisableControls;

    if ADataSet is TClientDataSet then
      (ADataSet as TClientDataSet).EmptyDataSet;

    vNotify := GetNotify(ADataSet);
    ClearNotify(ADataSet);

    Last;
    while not EOF do
      Delete;

    for I := 0 to ACollection.Count - 1 do begin
      vValues := TmObjeto.GetValues(ACollection.Items[I]);

      Append;
      TmDataSet.SetValues(ADataSet, vValues);
      Post;
    end;

    SetNotify(ADataSet, vNotify);

    EnableControls;
  end;
end;

//--

class procedure TmDataSet.ClearNotify(ADataSet: TDataSet);
begin
  with ADataSet do begin
    AfterPost := nil;
    BeforePost := nil;
  end;
end;

class function TmDataSet.GetNotify(ADataSet: TDataSet) : TmDataSet_Notify;
begin
  with Result do begin
    AfterPost := ADataSet.AfterPost;
    BeforePost := ADataSet.BeforePost;
  end;
end;

class procedure TmDataSet.SetNotify(ADataSet: TDataSet; ANotify: TmDataSet_Notify);
begin
  with ADataSet do begin
    AfterPost := ANotify.AfterPost;
    BeforePost := ANotify.BeforePost;
  end;
end;

//--

class function TmDataSet.PegarB(ADataSet: TDataSet; ACampo: String): Boolean;
begin
  with ADataSet do
    if FindField(ACampo) <> nil then
      Result := FieldByName(ACampo).AsBoolean
    else
      Result := False;
end;

class procedure TmDataSet.SetarB(ADataSet: TDataSet; ACampo : String; AValue: Boolean);
var
  vEdit : Boolean;
begin
  with ADataSet do
    if FindField(ACampo) <> nil then begin
      vEdit := State in [dsInsert, dsEdit];
      if not vEdit then
        Edit;
      FieldByName(ACampo).AsBoolean := AValue;
      if not vEdit then
        Post;
    end;
end;

//--

class function TmDataSet.PegarD(ADataSet: TDataSet; ACampo: String): TDateTime;
begin
  with ADataSet do
    if FindField(ACampo) <> nil then
      Result := FieldByName(ACampo).AsDateTime
    else
      Result := 0;
end;

class procedure TmDataSet.SetarD(ADataSet: TDataSet; ACampo : String; AValue: TDateTime);
var
  vEdit : Boolean;
begin
  with ADataSet do
    if FindField(ACampo) <> nil then begin
      vEdit := State in [dsInsert, dsEdit];
      if not vEdit then
        Edit;
      FieldByName(ACampo).AsDateTime := AValue;
      if not vEdit then
        Post;
    end;
end;

//--

class function TmDataSet.PegarF(ADataSet: TDataSet; ACampo: String): Real;
begin
  with ADataSet do
    if FindField(ACampo) <> nil then
      Result := FieldByName(ACampo).AsFloat
    else
      Result := 0;
end;

class procedure TmDataSet.SetarF(ADataSet: TDataSet; ACampo : String; AValue: Real);
var
  vEdit : Boolean;
begin
  with ADataSet do
    if FindField(ACampo) <> nil then begin
      vEdit := State in [dsInsert, dsEdit];
      if not vEdit then
        Edit;
      FieldByName(ACampo).AsFloat := AValue;
      if not vEdit then
        Post;
    end;
end;

//--

class function TmDataSet.PegarI(ADataSet: TDataSet; ACampo: String): Integer;
begin
  with ADataSet do
    if FindField(ACampo) <> nil then
      Result := FieldByName(ACampo).AsInteger
    else
      Result := 0;
end;

class procedure TmDataSet.SetarI(ADataSet: TDataSet; ACampo : String; AValue: Integer);
var
  vEdit : Boolean;
begin
  with ADataSet do
    if FindField(ACampo) <> nil then begin
      vEdit := State in [dsInsert, dsEdit];
      if not vEdit then
        Edit;
      FieldByName(ACampo).AsInteger := AValue;
      if not vEdit then
        Post;
    end;
end;

//--

class function TmDataSet.PegarS(ADataSet: TDataSet; ACampo: String): String;
begin
  with ADataSet do
    if FindField(ACampo) <> nil then
      Result := FieldByName(ACampo).AsString
    else
      Result := '';
end;

class procedure TmDataSet.SetarS(ADataSet: TDataSet; ACampo : String; AValue: String);
var
  vEdit : Boolean;
begin
  with ADataSet do
    if FindField(ACampo) <> nil then begin
      vEdit := State in [dsInsert, dsEdit];
      if not vEdit then
        Edit;
      FieldByName(ACampo).AsString := AValue;
      if not vEdit then
        Post;
    end;
end;

//--

class procedure TmDataSet.FromObject(AObject: TObject; ADataSet: TDataSet);
begin
  SetValues(ADataSet, TmObjeto.GetValues(AObject));
end;

class procedure TmDataSet.ToObject(ADataSet: TDataSet; AObject: TObject);
begin
  TmObjeto.SetValues(AObject, GetValues(ADataSet));
end;

//--

class function TmDataSet.Calcular(ADataSet: TDataSet; ACampo : String; ATipoRetorno : TTipoRetorno) : Real;
var
  vRecNo : Integer;
begin
  Result := 0;

  with ADataSet do begin
    if FindField(ACampo) = nil then
      Exit;

    vRecNo := RecNo;
    DisableControls;
    First;

    while not EOF do begin

      case ATipoRetorno of
        tprAvg, tprSum : begin
          Result := Result + FieldByName(ACampo).AsFloat;
        end;
        tprMax : begin
          if BOF or (FieldByName(ACampo).AsFloat > Result) then
            Result := FieldByName(ACampo).AsFloat;
        end;
        tprMin : begin
          if BOF or (FieldByName(ACampo).AsFloat < Result) then
            Result := FieldByName(ACampo).AsFloat;
        end;
      end;

      Next;
    end;

    case ATipoRetorno of
      tprAvg : begin
        if RecordCount > 0 then
          Result := Result / RecordCount;
      end;
    end;

    if vRecNo > 0 then
      RecNo := vRecNo;
    EnableControls;
  end;
end;

class function TmDataSet.Avg(ADataSet: TDataSet; ACampo : String) : Real;
begin
  Result := Calcular(ADataSet, ACampo, tprAvg);
end;

class function TmDataSet.Max(ADataSet: TDataSet; ACampo : String) : Real;
begin
  Result := Calcular(ADataSet, ACampo, tprMax);
end;

class function TmDataSet.Min(ADataSet: TDataSet; ACampo : String) : Real;
begin
  Result := Calcular(ADataSet, ACampo, tprMin);
end;

class function TmDataSet.Sum(ADataSet: TDataSet; ACampo : String) : Real;
begin
  Result := Calcular(ADataSet, ACampo, tprSum);
end;

//--

end.