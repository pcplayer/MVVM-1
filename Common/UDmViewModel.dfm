object DmViewModel: TDmViewModel
  OldCreateOrder = False
  Height = 266
  Width = 374
  object AdapterBindSource1: TAdapterBindSource
    AutoActivate = True
    OnCreateAdapter = AdapterBindSource1CreateAdapter
    Adapter = DataGeneratorAdapter1
    ScopeMappings = <>
    Left = 256
    Top = 88
  end
  object DataGeneratorAdapter1: TDataGeneratorAdapter
    FieldDefs = <
      item
        Name = 'UserID'
        Generator = 'PathDataNames'
        ReadOnly = False
      end
      item
        Name = 'UserName'
        Generator = 'BitmapNames'
        ReadOnly = False
      end
      item
        Name = 'Photo'
        FieldType = ftBitmap
        Generator = 'Bitmaps'
        ReadOnly = False
      end>
    Active = True
    AutoPost = False
    Options = [loptAllowInsert, loptAllowDelete, loptAllowModify]
    Left = 96
    Top = 88
  end
end
