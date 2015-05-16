//
//  AVCaptureSession+ZZYQRCodeExtension.h
//
//  Created by ZZY on 15/5/15.
//


#import <AVFoundation/AVFoundation.h>

/**
 *  读取二维码分类
 */

@interface AVCaptureSession (ZZYQRCodeAndBarCodeExtension)


/**
 *  读取二维码
 *
 *  @param delegate 输出代理
 *
 *  @return session
 */
+ (instancetype)readQRCodeWithMetadataObjectsDelegate:(id<AVCaptureMetadataOutputObjectsDelegate>)delegate;


/**
 *  读取条形码
 *
 *  @param delegate 输出代理
 *
 *  @return session
 */
+ (instancetype)readBarCodeWithMetadataObjectsDelegate:(id<AVCaptureMetadataOutputObjectsDelegate>)delegate;
@end
