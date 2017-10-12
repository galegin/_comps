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

  TmDataSet = class(TDataSet)
  public
    function GetValues(): TmValueList;
    procedure SetValues(AValues : TmValueList);

    procedure ClearNotify();
    function GetNotify() : TmDataSet_Notify;
    procedure SetNotify(ANotify: TmDataSet_Notify);

    function PegarB(ACampo: String) : Boolean;
    procedure SetarB(ACampo: String; AValue : Boolean);

    function PegarD(ACampo: String) : TDateTime;
    procedure SetarD(ACampo: String; AValue : TDateTime);

    function PegarF(ACampo: String) : Real;
    procedure SetarF(ACampo: String; AValue : Real);

    function PegarI(ACampo: String) : Integer;
    procedure SetarI(ACampo: String; AValue : Integer);

    function PegarS(ACampo: String) : String;
    procedure SetarS(ACampo: String; AValue : String);

    procedure FromObject(AObject : TObject);
    procedure ToObject(AObject : TObject);

    function Calcular(ACampo : String; ATipoRetorno : TTipoRetorno) : Real;

    function Avg(ACampo : String) : Real;
    function Max(ACampo : String) : Real;
    function Min(ACampo : String) : Real;
    function Sum(ACampo : String) : Real;
  end;

implementation

{ TmDataSet }

function TmDataSet.GetValues(): TmValueList;
var
  I : Integer;
  Key : Boolean;
  Nome : String;
  TipoField : TTipoField;
begin
  Result := TmValueList.Create;

  Key := True;

  for I := 0 to FieldCount - 1 do begin
    with Fields[I] do begin
      Nome := FieldName;

      if LowerCase(FieldName) = 'u_version' then
        Key := False;

      TipoField := TTipoField(IfThen(Key, Ord(tfKey), IfThen(Required, Ord(tfReq), Ord(tfNul))));

      case DataType of
        ftBoolean : begin
          Result.AddB(Nome, AsBoolean, TipoField);
        end;
        ftDate, ftDateTime, ftTime, ftTimeStamp : begin
          Result.AddD(Nome, AsDateTime, TipoField);
        end;
        ftFloat, ftBCD, ftFMTBcd: begin
          Result.AddF(Nome, AsFloat, TipoField);
        end;
        ftInteger, ftSmallint, ftWord: begin
          Result.AddI(Nome, AsInteger, TipoField);
        end;
        ftString, ftWideString, ftMemo, ftFmtMemo, ftOraClob: begin
          if TmString.StartsWiths(LowerCase(FieldName), 'in_') then
            Result.AddB(Nome, (AsString = 'T'), TipoField)
          else
            Result.AddS(Nome, AsString, TipoField);
        end;
      end;

    end;
  end;
end;

procedure TmDataSet.SetValues(AValues: TmValueList);
var
  vValue : TmValue;
  vEdit : Boolean;
  I : Integer;
begin
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
          end;
        end;
      end;

    end;
  end;

  if not vEdit then
    Post;
end;

//--

procedure TmDataSet.ClearNotify();
begin
  AfterPost := nil;
  BeforePost := nil;
end;

function TmDataSet.GetNotify() : TmDataSet_Notify;
begin
  Result.AfterPost := Self.AfterPost;
  Result.BeforePost := Self.BeforePost;
end;

procedure TmDataSet.SetNotify(ANotify: TmDataSet_Notify);
begin
  AfterPost := ANotify.AfterPost;
  BeforePost := ANotify.BeforePost;
end;

//--

function TmDataSet.PegarB(ACampo: String): Boolean;
begin
  if FindField(ACampo) <> nil then
    Result := FieldByName(ACampo).AsBoolean
  else
    Result := False;
end;

procedure TmDataSet.SetarB(ACampo : String; AValue: Boolean);
var
  vEdit : Boolean;
begin
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

function TmDataSet.PegarD(ACampo: String): TDateTime;
begin
  if FindField(ACampo) <> nil then
    Result := FieldByName(ACampo).AsDateTime
  else
    Result := 0;
end;

procedure TmDataSet.SetarD(ACampo : String; AValue: TDateTime);
var
  vEdit : Boolean;
begin
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

function TmDataSet.PegarF(ACampo: String): Real;
begin
  if FindField(ACampo) <> nil then
    Result := FieldByName(ACampo).AsFloat
  else
    Result := 0;
end;

procedure TmDataSet.SetarF(ACampo : String; AValue: Real);
var
  vEdit : Boolean;
begin
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

function TmDataSet.PegarI(ACampo: String): Integer;
begin
  if FindField(ACampo) <> nil then
    Result := FieldByName(ACampo).AsInteger
  else
    Result := 0;
end;

procedure TmDataSet.SetarI(ACampo : String; AValue: Integer);
var
  vEdit : Boolean;
begin
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

function TmDataSet.PegarS(ACampo: String): String;
begin
  if FindField(ACampo) <> nil then
    Result := FieldByName(ACampo).AsString
  else
    Result := '';
end;

procedure TmDataSet.SetarS(ACampo : String; AValue: String);
var
  vEdit : Boolean;
begin
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

procedure TmDataSet.FromObject(AObject: TObject);
begin
  SetValues(TmObjeto(AObject).GetValues());
end;

procedure TmDataSet.ToObject(AObject: TObject);
begin
  TmObjeto(AObject).SetValues(GetValues());
end;

//--

function TmDataSet.Calcular(ACampo : String; ATipoRetorno : TTipoRetorno) : Real;
var
  vRecNo : Integer;
begin
  Result := 0;

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

function TmDataSet.Avg(ACampo : String) : Real;
begin
  Result := Calcular(ACampo, tprAvg);
end;

function TmDataSet.Max(ACampo : String) : Real;
begin
  Result := Calcular(ACampo, tprMax);
end;

function TmDataSet.Min(ACampo : String) : Real;
begin
  Result := Calcular(ACampo, tprMin);
end;

function TmDataSet.Sum(ACampo : String) : Real;
begin
  Result := Calcular(ACampo, tprSum);
end;

//--

end.