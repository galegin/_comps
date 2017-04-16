object mDialog: TmDialog
  Left = 230
  Top = 123
  BorderStyle = bsNone
  Caption = 'mDialog'
  ClientHeight = 262
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 24
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
    Height = 138
    Align = alClient
    Alignment = taCenter
    AutoSize = False
    Caption = 'LabelMensagem'
    Transparent = True
    Layout = tlCenter
    WordWrap = True
  end
  object BevelSpace: TBevel
    Left = 0
    Top = 238
    Width = 584
    Height = 24
    Align = alBottom
    Shape = bsSpacer
  end
  object LabelDetalhar: TLabel
    Left = 4
    Top = 238
    Width = 84
    Height = 24
    Cursor = crHandPoint
    Caption = 'Detalhar...'
    Transparent = True
    OnDblClick = LabelDetalharDblClick
  end
  object LabelSuporte: TLabel
    Left = 500
    Top = 238
    Width = 81
    Height = 24
    Cursor = crHandPoint
    Caption = 'Suporte...'
    Transparent = True
    OnClick = LabelSuporteClick
  end
  object PanelOpcao: TPanel
    Left = 0
    Top = 178
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
