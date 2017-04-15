object mDialog: TmDialog
  Left = 230
  Top = 123
  Width = 600
  Height = 300
  Caption = 'mDialog'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object LabelTitulo: TLabel
    Left = 0
    Top = 0
    Width = 584
    Height = 40
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'LabelTitulo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    Layout = tlCenter
  end
  object LabelMensagem: TLabel
    Left = 0
    Top = 40
    Width = 584
    Height = 152
    Align = alClient
    Alignment = taCenter
    AutoSize = False
    Caption = 'LabelMensagem'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    WordWrap = True
  end
  object BevelSpace: TBevel
    Left = 0
    Top = 252
    Width = 584
    Height = 10
    Align = alBottom
    Shape = bsSpacer
  end
  object PanelOpcao: TPanel
    Left = 0
    Top = 192
    Width = 584
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
end
