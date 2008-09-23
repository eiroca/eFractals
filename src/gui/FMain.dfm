object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Frattali'
  ClientHeight = 507
  ClientWidth = 655
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object iImg: TImage
    Left = 0
    Top = 0
    Width = 655
    Height = 507
    Align = alClient
    AutoSize = True
    ExplicitLeft = 8
    ExplicitTop = 27
    ExplicitHeight = 412
  end
  object MainMenu1: TMainMenu
    Left = 52
    Top = 81
    object File1: TMenuItem
      Caption = '&File'
      object SaveBitmap1: TMenuItem
        Caption = 'Save &Bitmap'
        OnClick = SaveBitmap1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Land11: TMenuItem
      Caption = 'Land &1'
      object Regenerate1: TMenuItem
        Caption = 'Generate'
        OnClick = Regenerate1Click
      end
      object Draw2D1: TMenuItem
        Caption = 'Draw 2D'
        OnClick = Draw2D1Click
      end
      object Draw3D1: TMenuItem
        Caption = 'Draw 3D'
        OnClick = Draw3D1Click
      end
    end
    object Land21: TMenuItem
      Caption = 'Land &2'
      object Configure1: TMenuItem
        Caption = 'Configure'
        OnClick = Configure1Click
      end
      object DrawLand1: TMenuItem
        Caption = 'Draw Land'
        OnClick = DrawLand1Click
      end
    end
    object Other1: TMenuItem
      Caption = 'O&ther'
      object Forest1: TMenuItem
        Caption = '&Forest'
        OnClick = Forest1Click
      end
      object Leaf1: TMenuItem
        Caption = '&Leaf'
        OnClick = Leaf1Click
      end
      object ree1: TMenuItem
        Caption = '&Tree'
        OnClick = ree1Click
      end
      object aaa1: TMenuItem
        Caption = 'Brownian Motion &2D'
        OnClick = aaa1Click
      end
      object aa1: TMenuItem
        Caption = 'Brownian Motion &1D'
        OnClick = aa1Click
      end
    end
    object DLA2: TMenuItem
      Caption = 'DLA'
      object DLA1: TMenuItem
        Caption = 'Clear'
        OnClick = DLA1Click
      end
      object AddPoints1: TMenuItem
        Caption = 'Add  Points'
        ShortCut = 16464
        OnClick = AddPoints1Click
      end
      object Aggregate1: TMenuItem
        Caption = 'Aggregate'
        ShortCut = 16449
        OnClick = Aggregate1Click
      end
      object Shoot1: TMenuItem
        Caption = 'Shoot'
        ShortCut = 16467
        OnClick = Shoot1Click
      end
      object CloseHole1: TMenuItem
        Caption = 'Close Hole'
        ShortCut = 16456
        OnClick = CloseHole1Click
      end
    end
  end
  object dlSave: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmap|*.bmp'
    Title = 'Save bitmap'
    Left = 56
    Top = 208
  end
end
