unit UDmViewModel;
{--------------------------------------------------------------------------
   ���Խ����

   Ϊ�������ݶ��� TnUser ƽ̨������Ҳ���ǲ�Ҫ���� VCL ���� FMX �Ĵ��룬
   ���е� Photo ���� TStream ֱ�Ӵ洢���ݡ�

   �������� Photo ����ֱ�� LiveBinding �������ϵ� Image��������ʱ��˵����ת������
   ��ô��������β������Լ�д������ת�����룿
   �� LiveBinding �Ŀ�����棬��ʱ�Ҳ����ط�������롣Ҳ������������ĵ���
   --- �㶨��2020-2-13 �賿 3 �㡣����ת��ֻ��Ҫ�����ӵ��¼� OnAssigningValue ����д��ȥ������ TValue �Ϳ����ˡ�

   ��ˣ��Ҳ��������·�����

   1. �� TnUser ����һ�� Helper �࣬Ϊ���������һ�� Photo2 ���ԣ���������� TBitmap������ģ���� ViewModel������ƽ̨��أ�
   2. �� Image �� Photo2�����ǣ�����ʱ�����ᴥ���� Helper ��ķ�����
   2.1. ����һ�����԰�ť������ FUser.Photo2�����Դ��� Helper ��ķ��������Ի�� Photo2 �����Բ���ʾ������˵�� Helper ��ûд��
        Ҳ��˵�� LiveBinding ��ִ�а󶨵�ʱ����ʶ Helper �ࡣ
   3. ��ģ���Լ���������������ԣ�Ȼ��󶨵���ģ������� FUser������ʱ���쳣��ԭ���� AdapterBindSource1.OnCreateAdapter ���ڱ�ģ��Ĵ�����
   3.1. ����� AdapterBindSource1.AutoActive ����Ϊ True�������¼�������Ȼ���ڱ�ģ��� Create ���������á�
        ��ˣ����ܲ������� AutoActive Ϊ False Ȼ��������������Ϊ True �����������⡣

   4. �̳� TnUser���ڼ̳е�������ʵ�� Photo4 ���ԣ���������� TBitmap ���� TJpeg���󶨴˶��󣬶�����ʾ��
   4.1. Ϊ�˿�ƽ̨���̳У����ǺõĽ��������

   ------------

   ���ս�������ǵ������ϵ� BindingList ����ȥ�ҵ���������ͼƬ���Ǹ����������� OnAssigningValue �¼���������ȥ�޸� TValue
-----------------------------------------------------------------------------}
interface

uses
  System.SysUtils, System.Classes, NUser, Data.Bind.ObjectScope,
  Data.Bind.Components, Data.Bind.GenData, Vcl.Bind.GenData,
  VCL.Graphics;

type
  TDmViewModel = class(TDataModule)
    AdapterBindSource1: TAdapterBindSource;
    DataGeneratorAdapter1: TDataGeneratorAdapter;
    procedure AdapterBindSource1CreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
  private
    { Private declarations }
    FUser: TnUser;

    function GetUserID: string;
    function GetUserName: string;
    procedure SetUserID(const Value: string);
    procedure SetUserName(const Value: string);
  public
    { Public declarations }
    procedure LoadImage(const FileName: string);

    procedure EnableBinding;

    //property MyUser: TnUser read FUser;

    property UserID: string read GetUserID write SetUserID;
    property UserName: string read GetUserName write SetUserName;
  end;



var
  DmViewModel: TDmViewModel;

implementation

uses System.IoUtils;



{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmViewModel.AdapterBindSource1CreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin

  if not Assigned(FUser) then
  begin
    FUser := TnUser.Create();

    FUser.UserID := 'pcplayer';
    FUser.UserName := 'James';
  end;


  ABindSourceAdapter := TObjectBindSourceAdapter<TnUser>.Create(AdapterBindSource1,
                                                               FUser, True);

  ABindSourceAdapter.AutoPost := False;
end;


procedure TDmViewModel.EnableBinding;
begin
  AdapterBindSource1.Active := True;
end;

function TDmViewModel.GetUserID: string;
begin
  Result := FUser.UserID;
end;

function TDmViewModel.GetUserName: string;
begin
  Result := FUser.UserName;
end;

procedure TDmViewModel.LoadImage(const FileName: string);
var
  AStream: TMemoryStream;
  Ext: string;
  PicType: TPicType;
  Photo: TMyPhoto;
begin
  if not FileExists(FileName) then raise Exception.Create('Picture file not found');

  Ext := Uppercase(TPath.GetExtension(FileName));

  if (Ext = '.JPG') or (Ext = 'JPG') then PicType := TPicType.picJpeg
  else
  if (Ext = '.PNG') then PicType := TPicType.picPNG
  else raise Exception.Create('Picture file must be JPG or PNG file format.');


  AStream := TMemoryStream.Create;
  Photo := TMyPhoto.Create;;
  try
    AStream.LoadFromFile(FileName);

    Photo.FPhoto := AStream;
    Photo.FPhotoType := PicType;

    Self.FUser.Photo := Photo;
  finally
    AStream.DisposeOf;
    Photo.DisposeOf;
  end;

  AdapterBindSource1.Refresh;
end;

procedure TDmViewModel.SetUserID(const Value: string);
begin
  FUser.UserID := Value;
end;

procedure TDmViewModel.SetUserName(const Value: string);
begin
  FUser.UserName := Value;
end;


end.
