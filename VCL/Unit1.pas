unit Unit1;
{-----------------------------------------------------------------------------
  所谓 MVVM 模式，是指 Model - View - ViewModel 模式。

  这个模式是指：1. Model 是程序的数据及数据业务逻辑模块；2. View 是指程序的界面部分；3. ViewModel 是指程序的显示逻辑。

  把显示逻辑和界面分开，这样，界面基本上无需有任何与逻辑相关的代码，仅仅处理显示；
  把数据和业务逻辑单独，和界面之间隔了一个 ViewModel，使得程序各模块之间的耦合更少。这样任意替换界面，也不会带来程序的大改动。

  假设一种场景：
  1. 数据库，对数据库进行处理的业务逻辑代码；
  2. 界面，可能是 HTML5, 可能是 VCL，可能是 FMX。

  如果采用 MVVM 模式，则只需要修改界面部分。而界面部分的代码仅仅和显示呈现内容相关，和显示逻辑、业务逻辑无关，这样代码的可重用性会更高。

  在 Delphi 里面，要想尽量少写界面代码，采用 Delphi 提供的 LiveBindings 数据绑定框架。

  本 Demo 演示了数据 TnUser 和作为  ViewModel 的 DmViewModel 以及作为界面的 Form1 之间的关系。
  其中，TnUser 需要平台独立，仅仅维护数据。VCL/FMX 平台相关的代码，由 View 来实现。

  --------------

  总结一下：这里，把 DmViewModel 看成一个 DataModule，里面放的 AdapterBindSource1 看作是 TDataSource，而那个 TnUser 看作 TDataSet。
  这样就和传统的 Delphi 的数据库开发的架构模式对应起来了。

  因此，这个 LiveBindings 功能上和传统的 【数据感知控件】 + TDataSource + TDataSet 的模式类似，只是扩到了任意的数据源和任意的控件。

  pcplayer 2020-2-13


  Based on Delphi LiveBindings tech. to implement a simple MVVM framework demo APP, support VCL and FMX the same time.

  pcplayer

  2020-3-11
-----------------------------------------------------------------------------}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UDmViewModel, Vcl.ExtCtrls, Vcl.StdCtrls,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, Vcl.Imaging.pngimage, Vcl.Imaging.Jpeg;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldCaption: TLinkPropertyToField;
    LinkPropertyToFieldCaption2: TLinkPropertyToField;
    BtnImage: TButton;
    OpenDialog1: TOpenDialog;
    LinkControlToField1: TLinkControlToField;
    Button1: TButton;
    procedure BtnImageClick(Sender: TObject);
    procedure LinkControlToField1AssigningValue(Sender: TObject;
      AssignValueRec: TBindingAssignValueRec; var Value: TValue;
      var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FJpg: TJpegImage;
    FPng: TPngImage;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses NUser;   //VCL 底下，加上 png 的声明后，可以直接让  TImage 加载 PNG 文件。这个操作和 JPEG 类似。


{$R *.dfm}

procedure TForm1.BtnImageClick(Sender: TObject);
var
  AStream: TMemoryStream;
  Jpg: TJpegImage;
  Ext: string;
  PicType: TPicType;
begin
  if OpenDialog1.Execute then
  begin
    DmViewModel.LoadImage(OpenDialog1.FileName);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Fm: TForm1;
begin
  Fm := TForm1.Create(Application);

  Fm.Show;
end;

procedure TForm1.LinkControlToField1AssigningValue(Sender: TObject;
  AssignValueRec: TBindingAssignValueRec; var Value: TValue;
  var Handled: Boolean);
begin
  if Value.IsObject then
  begin
    if Value.AsObject is TMyPhoto then
    begin
      TMyPhoto(Value.AsObject).FPhoto.Position := 0;

      case TMyPhoto(Value.AsObject).FPhotoType of
        TPicType.picJpeg:
        begin
          if not Assigned(FJpg) then FJpg := TJpegImage.Create;

          FJpg.LoadFromStream(TMyPhoto(Value.AsObject).FPhoto);

          Value := TValue.From(FJpg);
        end;

        TPicType.picPNG:
        begin
          if not Assigned(FPng) then FPng := TPngImage.Create;
          FPng.LoadFromStream(TMyPhoto(Value.AsObject).FPhoto);
          Value := TValue.From(FPng);
        end;
      end;
    end;

  end;

end;

end.
