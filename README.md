# ZZYQRCode_BarCode

custom QRCode<br>
个性化自定义二维码一句话完成（为二维码中添加个性图片，背景）<br>

normal QRCode<br>
原始二维码 <br>
![](https://github.com/zhang28602/ZZYQRCode_BarCode/raw/master/Screenshots/imag1.png)

<br>
<br>
<br>
<br>
UIImage *image = [UIImage createQRCodeWithSize:200 dataString:@"hello"];
<br>
<br>
<br>
<br>

custom style<br>
自定义二维码样式 <br>
![](https://github.com/zhang28602/ZZYQRCode_BarCode/raw/master/Screenshots/image2.png)

<br>
<br>
<br>
<br>
UIImage *icon = [UIImage imageNamed:@"bigMax"];<br>
// 生成二维码，二维码中带有自定义图片<br>
UIImage *image = [UIImage createQRCodeWithSize:200 dataString:@"hello" QRCodeImageType:circularImage iconImage:icon iconImageSize:40];<br>
<br>
<br>
<br>
<br>

custom QRCodeBackGround<br>
自定义二维码背景<br>
![](https://github.com/zhang28602/ZZYQRCode_BarCode/raw/master/Screenshots/image3.png)

<br>
<br>
<br>
<br>
UIImage *icon = [UIImage imageNamed:@"bigMax"];<br>
// 生成二维码，二维码中带有自定义图片<br>
UIImage *image = [UIImage createQRCodeWithSize:200 dataString:@"hello" QRCodeImageType:circularImage iconImage:icon iconImageSize:40];<br>
// 自定义背景图片<br>
 UIImage *bgImage = [UIImage imageNamed:@"flower"];<br>
UIImage *newImage = [UIImage addQRCodeBgImage:bgImage bgImageSize:200 QRImage:qrImage];<br>

//---------------------------------------------------华丽的分割线----------------------------------------------//<br>

快速创建二维码，条形码扫描页面<br>
quickly create scan view <br>
![](https://github.com/zhang28602/ZZYQRCode_BarCode/raw/master/Screenshots/scan.png)
<br>
<br>
<br>
<br>
// 获取二维码扫描session
AVCaptureSession *session = [AVCaptureSession readQRCodeWithMetadataObjectsDelegate:self];<br>
// 创建预览图层<br>
AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];<br>
previewLayer.frame = self.view.bounds;<br>
// 插入到最底层<br>
[self.view.layer insertSublayer:previewLayer atIndex:0];<br>

<br>
<br>
<br>
// 获取条形码扫描session<br>
AVCaptureSession *session = [AVCaptureSession readBarCodeWithMetadataObjectsDelegate:self];<br>


更多详细用法请看Demo！！

