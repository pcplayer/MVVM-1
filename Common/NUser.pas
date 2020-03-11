unit NUser;
{-----------------------------------------------------------------------------
   ��Ϊ VCL �� FMX ��ͼƬ/JPEG �Ķ��岻ͬ������ֻ�ܰ�ͼƬ�ŵ�һ�� Stream ���档

   Ȼ���ڸ��Ե� ViewModule ����ȥת��Ϊ������ͼƬ��

   �� Delphi �ṩ�� LiveBinding �� Demo������ͼƬ����ֱ�Ӱ󶨵� ClientDataSet �� BlobField ���档����ת����

   ���Ϊ��ͬʱ֧�� JPG �� PNG ͼƬ���ֶԻ���ͼƬ���ݵ� TMyPhoto ����һ�η�װ��
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
