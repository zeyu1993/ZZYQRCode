# ZZYQRCode

使用系统API（AVFoundation）进行封装，包含UI界面以及对二维码，条形码进行扫描，生成等操作

### Swift Version: **[ZZYQRCodeSwift](https://github.com/zhang28602/ZZYQRCodeSwift)**

## 如何安装

```
platform :ios, '8.0'
use_frameworks!
pod 'ZZYQRCode', '~> 1.1.0'
```

## 如何使用
1. 创建sessionManager,同时需要设置扫描类型、扫描区域等

```objc
- (instancetype)initWithAVCaptureQuality:(AVCaptureQuality)quality
                           AVCaptureType:(AVCaptureType)type
                                scanRect:(CGRect)scanRect
                            successBlock:(SuccessBlock)success;
```

2. 显示View

```objc
- (void)showPreviewLayerInView:(UIView *)view;
```
## 附加功能
1. 扫描音效

```objc
@property(assign, nonatomic) BOOL isPlaySound;

@property(copy, nonatomic) NSString *soundName;
```

2. 开启闪光灯

```objc
- (void)turnTorch:(BOOL)state;
```

3. 扫描相册中的二维码

```objc
- (void)scanPhotoWith:(UIImage *)image successBlock:(SuccessBlock)success;
```

4. 权限监测

```objc
+ (void)checkAuthorizationStatusForCameraWithGrantBlock:(void(^)())grant
                                            DeniedBlock:(void(^)())denied;
```

5. 创建普通二维码

```objc
UIImage *image = [UIImage createQRCodeWithSize:200 dataString:@"hello"];
```

6. 自定义二维码

```objc
UIImage *icon = [UIImage imageNamed:@"bigMax"];
UIImage *image = [UIImage createQRCodeWithSize:200
                                    dataString:@"hello"
                               QRCodeImageType:circularImage
                                     iconImage:icon
                                 iconImageSize:40];
```

## 注意事项
由于iOS10权限设置变换，需要在项目中的info.plist文件中添加如下文件

```
<key>NSCameraUsageDescription</key>
<string></string>
<key>NSPhotoLibraryUsageDescription</key>
<string></string>
```

# 页面效果
![](https://github.com/zhang28602/ZZYQRCode_BarCode/raw/master/Screenshots/show.gif)
