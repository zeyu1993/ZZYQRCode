//
//  AVCaptureSession+ZZYQRCodeExtension.h
//
//  Created by ZZY on 15/5/15.
//

#import "AVCaptureSession+ZZYQRCodeAndBarCodeExtension.h"

@implementation AVCaptureSession (ZZYQRCodeAndBarCodeExtension)

// 读取二维码
+ (instancetype)readQRCodeWithMetadataObjectsDelegate:(id<AVCaptureMetadataOutputObjectsDelegate>)delegate{
    
    // 1.获取输入设备(摄像头)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2.根据输入设备创建输入对象
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    
    // 3.创建输出对象
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4.设置代理监听输出对象输出的数据
    [output setMetadataObjectsDelegate:delegate queue:dispatch_get_main_queue()];
    
    // 5.创建会话(桥梁)
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // 6.添加输入和输出到会话中
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
#warning 注意: 设置输出对象能够解析的类型必须在输出对象添加到会话之后设置, 否则会报错
    
    // 7.告诉输出对象, 需要输出什么样的数据(支持解析什么样的格式)
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 开始扫描
    [session startRunning];
    return session;
}

// 读取条形码
+ (instancetype)readBarCodeWithMetadataObjectsDelegate:(id<AVCaptureMetadataOutputObjectsDelegate>)delegate{
    // 1.获取输入设备(摄像头)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2.根据输入设备创建输入对象
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    
    // 3.创建输出对象
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4.设置代理监听输出对象输出的数据
    [output setMetadataObjectsDelegate:delegate queue:dispatch_get_main_queue()];
    
    // 5.创建会话(桥梁)
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // 6.添加输入和输出到会话中
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
#warning 注意: 设置输出对象能够解析的类型必须在输出对象添加到会话之后设置, 否则会报错
    
    // 7.告诉输出对象, 需要输出什么样的数据(支持解析什么样的格式)
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeDataMatrixCode,  AVMetadataObjectTypeITF14Code,
                                     AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeUPCECode]];
    
    // 开始扫描
    [session startRunning];
    return session;

}
@end
