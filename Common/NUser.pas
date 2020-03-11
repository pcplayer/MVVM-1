unit NUser;
{-----------------------------------------------------------------------------
   因为 VCL 和 FMX 对图片/JPEG 的定义不同，这里只能把图片放到一个 Stream 里面。

   然后在各自的 ViewModule 里面去转换为真正的图片。

   看 Delphi 提供的 LiveBinding 的 Demo，它的图片可以直接绑定到 ClientDataSet 的 BlobField 上面。无需转换。

   这里，为了同时支持 JPG 和 PNG 图片，又对缓存图片数据的 TMyPhoto 做了一次封装。
---------------------------------------------------------------------------------}
interface

uses System.SysUtils, System.Variants, System.Classes;

type
  TPicType = (picJpeg, picPNG);

  TMyPhoto = class
  public
    FPhoto: TMemoryStream;
    FPhotoType: TPicType;
  end;

  TnUser = class
  private
    FUserID: string;
    FUserName: string;
    FPhoto: TMyPhoto;


    function GetPhoto: TMyPhoto;
    procedure SetPhoto(const Value: TMyPhoto);
    function GetPicType: TPicType;
    procedure SetPicType(const Value: TPicType);
  public
    property UserID: string read FUserID write FUserID;
    property UserName: string read FUserName write FUserName;
    property Photo: TMyPhoto read GetPhoto write SetPhoto;
    property PhotoType: TPicType read GetPicType write SetPicType;
  end;

implementation

{ TnUser }

function TnUser.GetPhoto: TMyPhoto;
begin
  Result := FPhoto;
end;

function TnUser.GetPicType: TPicType;
begin
  Result := FPhoto.FPhotoType;
end;

procedure TnUser.SetPhoto(const Value: TMyPhoto);
begin
  if not Assigned(FPhoto) then
  begin
    FPhoto := TMyPhoto.Create;
    if not Assigned(FPhoto.FPhoto) then FPhoto.FPhoto := TMemoryStream.Create;

  end;

  Value.FPhoto.Position := 0;
  FPhoto.FPhoto.Clear;
  FPhoto.FPhoto.LoadFromStream(Value.FPhoto);
  FPhoto.FPhotoType := Value.FPhotoType;
end;

procedure TnUser.SetPicType(const Value: TPicType);
begin
//
end;

end.
