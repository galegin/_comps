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
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    584
    262)
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
    Height = 142
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
    Top = 242
    Width = 584
    Height = 20
    Align = alBottom
    Shape = bsSpacer
  end
  object LabelDetalhar: TLabel
    Left = 4
    Top = 242
    Width = 73
    Height = 20
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Detalhar...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
    OnClick = LabelDetalharClick
  end
  object LabelSuporte: TLabel
    Left = 512
    Top = 242
    Width = 69
    Height = 20
    Cursor = crHandPoint
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    AutoSize = False
    Caption = 'Suporte...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
    OnClick = LabelSuporteClick
  end
  object LabelProjeto: TLabel
    Left = 4
    Top = 4
    Width = 89
    Height = 20
    Caption = 'LabelProjeto'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object LabelVersao: TLabel
    Left = 491
    Top = 4
    Width = 90
    Height = 20
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'LabelVersao'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object PanelOpcao: TPanel
    Left = 0
    Top = 182
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
