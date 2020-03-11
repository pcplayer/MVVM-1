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

  --------------

  �ܽ�һ�£������ DmViewModel ����һ�� DataModule������ŵ� AdapterBindSource1 ������ TDataSource�����Ǹ� TnUser ���� TDataSet��
  �����ͺʹ�ͳ�� Delphi �����ݿ⿪���ļܹ�ģʽ��Ӧ�����ˡ�

  ��ˣ���� LiveBindings �����Ϻʹ�ͳ�� �����ݸ�֪�ؼ��� + TDataSource + TDataSet ��ģʽ���ƣ�ֻ�����������������Դ������Ŀؼ���

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

uses NUser;   //VCL ���£����� png �������󣬿���ֱ����  TImage ���� PNG �ļ������������ JPEG ���ơ�


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
