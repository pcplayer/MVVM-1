unit UDmViewModel;
{--------------------------------------------------------------------------
   测试结果：

   为了让数据对象 TnUser 平台独立，也就是不要包含 VCL 或者 FMX 的代码，
   其中的 Photo 采用 TStream 直接存储数据。

   如果把这个 Photo 属性直接 LiveBinding 到界面上的 Image，则运行时会说类型转换错误。
   那么，这里如何插入我自己写的类型转换代码？
   在 LiveBinding 的框架里面，暂时找不到地方插入代码。也搜索不到相关文档。
   --- 搞定。2020-2-13 凌晨 3 点。类型转换只需要在连接的事件 OnAssigningValue 里面写，去更改其 TValue 就可以了。

   因此，我测试了以下方法：

   1. 给 TnUser 增加一个 Helper 类，为这个类增加一个 Photo2 属性，这个属性是 TBitmap；（本模块是 ViewModel，可以平台相关）
   2. 绑定 Image 到 Photo2。但是，运行时，不会触发到 Helper 类的方法。
   2.1. 增加一个测试按钮，测试 FUser.Photo2，可以触发 Helper 类的方法，可以获得 Photo2 的属性并显示出来，说明 Helper 类没写错。
        也就说明 LiveBinding 在执行绑定的时候不认识 Helper 类。
   3. 本模块自己重新引入相关属性，然后绑定到本模块而不是 FUser，运行时出异常；原因是 AdapterBindSource1.OnCreateAdapter 先于本模块的创建。
   3.1. 就算把 AdapterBindSource1.AutoActive 设置为 True，它的事件方法依然先于本模块的 Create 被触发调用。
        因此，不能采用设置 AutoActive 为 False 然后在运行期设置为 True 来解决这个问题。

   4. 继承 TnUser，在继承的类里面实现 Photo4 属性，这个属性是 TBitmap 或者 TJpeg，绑定此对象，都能显示。
   4.1. 为了跨平台而继承，不是好的解决方法。

   ------------

   最终解决，还是到界面上的 BindingList 里面去找到具体连接图片的那个对象，在它的 OnAssigningValue 事件方法里面去修改 TValue
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
