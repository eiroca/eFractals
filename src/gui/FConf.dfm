object fmConf: TfmConf
  Left = 0
  Top = 0
  Caption = 'Configurazione Terreno'
  ClientHeight = 199
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 33
    Height = 13
    Caption = 'Angolo'
  end
  object Label2: TLabel
    Left = 168
    Top = 8
    Width = 33
    Height = 13
    Caption = 'Dist. f.'
  end
  object Label3: TLabel
    Left = 8
    Top = 38
    Width = 21
    Height = 13
    Caption = 'Lato'
  end
  object Label4: TLabel
    Left = 168
    Top = 38
    Width = 78
    Height = 13
    Caption = 'Altezza massima'
  end
  object Label5: TLabel
    Left = 8
    Top = 68
    Width = 62
    Height = 13
    Caption = 'Altezza mare'
  end
  object Label6: TLabel
    Left = 168
    Top = 68
    Width = 61
    Height = 13
    Caption = 'Altezza vista'
  end
  object Label7: TLabel
    Left = 8
    Top = 98
    Width = 54
    Height = 13
    Caption = 'Dimensione'
  end
  object Label8: TLabel
    Left = 168
    Top = 98
    Width = 65
    Height = 13
    Caption = 'Seme random'
  end
  object Label9: TLabel
    Left = 8
    Top = 130
    Width = 66
    Height = 13
    Caption = 'Direzione sole'
  end
  object Label10: TLabel
    Left = 168
    Top = 130
    Width = 57
    Height = 13
    Caption = 'Altezza sole'
  end
  object iAngolo: TEdit
    Left = 92
    Top = 5
    Width = 61
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object iDistF: TEdit
    Left = 252
    Top = 5
    Width = 61
    Height = 21
    TabOrder = 1
    Text = '1.1'
  end
  object iLato: TEdit
    Left = 92
    Top = 35
    Width = 61
    Height = 21
    TabOrder = 2
    Text = '30000'
  end
  object iAltMax: TEdit
    Left = 252
    Top = 35
    Width = 61
    Height = 21
    TabOrder = 3
    Text = '10000'
  end
  object iAltezzaMare: TEdit
    Left = 92
    Top = 65
    Width = 61
    Height = 21
    TabOrder = 4
    Text = '5000'
  end
  object iAltVista: TEdit
    Left = 252
    Top = 68
    Width = 61
    Height = 21
    TabOrder = 5
    Text = '100.0'
  end
  object iDimensione: TEdit
    Left = 92
    Top = 95
    Width = 61
    Height = 21
    TabOrder = 6
    Text = '2.3'
  end
  object iSeed: TEdit
    Left = 252
    Top = 95
    Width = 61
    Height = 21
    TabOrder = 7
    Text = '332422656'
  end
  object iDirSole: TEdit
    Left = 92
    Top = 127
    Width = 61
    Height = 21
    TabOrder = 8
    Text = '315'
  end
  object iAltSole: TEdit
    Left = 252
    Top = 127
    Width = 61
    Height = 21
    TabOrder = 9
    Text = '45'
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 166
    Width = 75
    Height = 25
    TabOrder = 10
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 89
    Top = 166
    Width = 75
    Height = 25
    TabOrder = 11
    Kind = bkCancel
  end
  object BitBtn3: TBitBtn
    Left = 238
    Top = 166
    Width = 75
    Height = 25
    Caption = '&Random'
    TabOrder = 12
    OnClick = BitBtn3Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
      33333333333F8888883F33330000324334222222443333388F3833333388F333
      000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
      F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
      223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
      3338888300003AAAAAAA33333333333888888833333333330000333333333333
      333333333333333333FFFFFF000033333333333344444433FFFF333333888888
      00003A444333333A22222438888F333338F3333800003A2243333333A2222438
      F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
      22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
      33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
      3333333333338888883333330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
end
