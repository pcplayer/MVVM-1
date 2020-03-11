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

  -------------
  这里是 FMX 的程序。这个程序和 VCL 的程序共享了 UDmViewModel 和 NLUser 单元。
  仅仅是界面 Form1 里面有一点点代码要重新写。

  pcplayer 2020-2-13
-----------------------------------------------------------------------------}
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  System.Rtti, System.Bindings.Outputs, Data.Bind.Components, Fmx.Bind.Editors;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    ImageControl1: TImageControl;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkControlToField2: TLinkControlToField;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkControlToField3: TLinkControlToField;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure LinkControlToField3AssigningValue(Sender: TObject;
      AssignValueRec: TBindingAssignValueRec; var Value: TValue;
      var Handled: Boolean);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses UDmViewModel, NUser;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    DmViewModel.LoadImage(OpenDialog1.FileName);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Fm: TForm1;
begin
  Fm := TForm1.Create(Application);
  Fm.Show;
end;

procedure TForm1.LinkControlToField3AssigningValue(Sender: TObject;
  AssignValueRec: TBindingAssignValueRec; var Value: TValue;
  var Handled: Boolean);
begin
  //
  if Value.IsObject then
  begin
    if Value.AsObject is TMyPhoto then
    begin
      TMyPhoto(Value.AsObject).FPhoto.Position := 0;

      ImageControl1.Bitmap.LoadFromStream(TMyPhoto(Value.AsObject).FPhoto);
      Handled := True;
    end;
  end;
end;

end.
