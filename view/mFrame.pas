unit mFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, mFrameIntf, mOrientacaoFrame, mPanel,
  mGrade, mLabel, mButton, mCheckBox, mComboBox, mTextBox, mKeyValue,
  mTipoFormato, mValue;

type
  TmFrame = class(TFrame, IFrame)
  private
    fOrientacao : TOrientacaoFrame;
  protected
  public
    constructor Create(Aowner : TComponent); override;

    function AddPanel(
      AOrientacao : TOrientacaoFrame) : TmPanel;

    function AddGrade(
      ACollection : TCollection) : TmGrade;

    function AddLabel(
      ALargura : Integer;
      ADescricao : String) : TmLabel;

    function AddButton(
      ALargura : Integer;
      ADescricao : String) : TmButton;

    function AddCheckBox(
      ALargura : Integer;
      AEntidade : TCollectionItem;
      ACampo : String) : TmCheckBox;

    function AddComboBox(
      ALargura : Integer;
      AEntidade : TCollectionItem;
      ACampo : String;
      ALista : Array Of TmKeyValue) : TmComboBox;

    function AddTextBox(
      ALargura : Integer;
      AEntidade : TCollectionItem;
      ACampo : String;
      ATipo : TTipoValue;
      AFormato : TTipoFormato) : TmTextBox;
  published
    property Orientacao : TOrientacaoFrame read fOrientacao write fOrientacao;
  end;

implementation

{$R *.dfm}

uses
  mFormCtrl;

{ TmFrame }

constructor TmFrame.create(Aowner: TComponent);
begin
  inherited; //
  
end;

//--

function TmFrame.AddPanel;
begin
  Result := TmFormCtrl.AddPanel(Owner, Self, AOrientacao);
end;

function TmFrame.AddGrade;
begin
  Result := TmFormCtrl.AddGrade(Owner, Self, ACollection);
end;

function TmFrame.AddLabel;
begin
  Result := TmFormCtrl.AddLabel(Owner, Self, ALargura, ADescricao);
end;

function TmFrame.AddButton;
begin
  Result := TmFormCtrl.AddButton(Owner, Self, ALargura, ADescricao);
end;

function TmFrame.AddCheckBox;
begin
  Result := TmFormCtrl.AddCheckBox(Owner, Self, ALargura, AEntidade, ACampo);
end;

function TmFrame.AddComboBox;
begin
  Result := TmFormCtrl.AddComboBox(Owner, Self, ALargura, AEntidade, ACampo, ALista);
end;

function TmFrame.AddTextBox;
begin
  Result := TmFormCtrl.AddTextBox(Owner, Self, ALargura, AEntidade, ACampo, ATipo, AFormato);
end;

end.
