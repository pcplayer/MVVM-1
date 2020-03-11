unit Unit1;
{-----------------------------------------------------------------------------
  ��ν MVVM ģʽ����ָ Model - View - ViewModel ģʽ��

  ���ģʽ��ָ��1. Model �ǳ�������ݼ�����ҵ���߼�ģ�飻2. View ��ָ����Ľ��沿�֣�3. ViewModel ��ָ�������ʾ�߼���

  ����ʾ�߼��ͽ���ֿ�������������������������κ����߼���صĴ��룬����������ʾ��
  �����ݺ�ҵ���߼��������ͽ���֮�����һ�� ViewModel��ʹ�ó����ģ��֮�����ϸ��١����������滻���棬Ҳ�����������Ĵ�Ķ���

  ����һ�ֳ�����
  1. ���ݿ⣬�����ݿ���д����ҵ���߼����룻
  2. ���棬������ HTML5, ������ VCL�������� FMX��

  ������� MVVM ģʽ����ֻ��Ҫ�޸Ľ��沿�֡������沿�ֵĴ����������ʾ����������أ�����ʾ�߼���ҵ���߼��޹أ���������Ŀ������Ի���ߡ�

  �� Delphi ���棬Ҫ�뾡����д������룬���� Delphi �ṩ�� LiveBindings ���ݰ󶨿�ܡ�

  �� Demo ��ʾ������ TnUser ����Ϊ  ViewModel �� DmViewModel �Լ���Ϊ����� Form1 ֮��Ĺ�ϵ��
  ���У�TnUser ��Ҫƽ̨����������ά�����ݡ�VCL/FMX ƽ̨��صĴ��룬�� View ��ʵ�֡�

  -------------
  ������ FMX �ĳ����������� VCL �ĳ������� UDmViewModel �� NLUser ��Ԫ��
  �����ǽ��� Form1 ������һ������Ҫ����д��

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
