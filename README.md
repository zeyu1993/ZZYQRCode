# ZZYQRCode

Using the system API (AVFoundation) for packaging, including the UI interface and QR code, barcode scanning, generating and other operations 

### Swift Version: **[ZZYQRCodeSwift](https://github.com/zhang28602/ZZYQRCodeSwift)**

### [中文介绍](https://github.com/zhang28602/ZZYQRCode/blob/master/READMEZH.md)

## HOW to install

```
platform :ios, '8.0'
use_frameworks!
pod 'ZZYQRCode', '~> 1.0.0'
```

## How to use
1. Create sessionManager

```objc
- (instancetype)initWithAVCaptureQuality:(AVCaptureQuality)quality
                           AVCaptureType:(AVCaptureType)type
                                scanRect:(CGRect)scanRect
                            successBlock:(SuccessBlock)success;
```

2. Show view

```objc
- (void)showPreviewLayerInView:(UIView *)view;
```
## Others features
1. Scan sound effects

```objc
@property(assign, nonatomic) BOOL isPlaySound;

@property(copy, nonatomic) NSString *soundName;
```

2. Torch

```objc
- (void)turnTorch:(BOOL)state;
```

3. Scan the QR code in the album

```objc
- (void)scanPhotoWith:(UIImage *)image successBlock:(SuccessBlock)success;
```

4. Check authorization status

```objc
+ (void)checkAuthorizationStatusForCameraWithGrantBlock:(void(^)())grant
                                            DeniedBlock:(void(^)())denied;
```

5. Create QR code

```objc
UIImage *image = [UIImage createQRCodeWithSize:200 dataString:@"hello"];
```

6. Create customize QR code

```objc
UIImage *icon = [UIImage imageNamed:@"bigMax"];
UIImage *image = [UIImage createQRCodeWithSize:200
                                    dataString:@"hello"
                               QRCodeImageType:circularImage
                                     iconImage:icon
                                 iconImageSize:40];
```

## Pay attention
Because of iOS10 authorization change,you need to add code in your info.plist

```
<key>NSCameraUsageDescription</key>
<string></string>
<key>NSPhotoLibraryUsageDescription</key>
<string></string>
```

# Page show
![](https://github.com/zhang28602/ZZYQRCode_BarCode/raw/master/Screenshots/show.gif)
