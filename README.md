# ZZYQRCode

使用系统API（AVFoundation）进行封装，包含UI界面以及对二维码，条形码进行扫描，生成等操作

## 如何使用
1. 创建sessionManager,同时需要设置扫描类型、扫描区域等

```
- (instancetype)initWithAVCaptureQuality:(AVCaptureQuality)quality
AVCaptureType:(AVCaptureType)type
scanRect:(CGRect)scanRect
successBlock:(SuccessBlock)success;
```

2. 显示View

```
- (void)showPreviewLayerInView:(UIView *)view;
```
## 附加功能
1. 扫描音效

```
@property(assign, nonatomic) BOOL isPlaySound;

@property(copy, nonatomic) NSString *soundName;
```

2. 开启闪光灯

```
- (void)turnTorch:(BOOL)state;
```

3. 扫描相册中的二维码

```
- (void)scanPhotoWith:(UIImage *)image successBlock:(SuccessBlock)success;
```

4. 权限监测

```
+ (void)checkAuthorizationStatusForCameraWithGrantBlock:(void(^)())grant
DeniedBlock:(void(^)())denied;
```

5. 创建普通二维码

```
UIImage *image = [UIImage createQRCodeWithSize:200 dataString:@"hello"];
```
![](https://github.com/zhang28602/ZZYQRCode_BarCode/raw/master/Screenshots/imag1.png)

6. 自定义二维码

```
UIImage *icon = [UIImage imageNamed:@"bigMax"];
UIImage *image = [UIImage createQRCodeWithSize:200
dataString:@"hello"
QRCodeImageType:circularImage
iconImage:icon
iconImageSize:40];
```
![](https://github.com/zhang28602/ZZYQRCode_BarCode/raw/master/Screenshots/image3.png)
