//
//  AVCaptureSessionManager.h
//  Demo
//
//  Created by 张泽宇 on 2017/5/19.
//  Copyright © 2017年 zzy. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
/**
 捕捉画面质量
 */
typedef NS_ENUM(NSUInteger, AVCaptureQuality) {
    AVCaptureQualityHigh,
    AVCaptureQualityMedium,
    AVCaptureQualityLow
};


/**
 识别类型
 */
typedef NS_ENUM(NSUInteger,AVCaptureType) {
    AVCaptureTypeQRCode,
    AVCaptureTypeBarCode,
    AVCaptureTypeBoth
};

typedef void(^SuccessBlock)(NSString *reuslt);

@interface AVCaptureSessionManager : AVCaptureSession

@property(strong, nonatomic) AVCaptureVideoPreviewLayer *preViewLayer;

/**扫描是否播放音效*/
@property(assign, nonatomic) BOOL isPlaySound;

/**音效名称*/
@property(copy, nonatomic) NSString *soundName;

/**
 初始化Manager
 
 @param quality 视频质量
 @param type 扫描类型
 @param scanRect 扫描区域 如果传CGRectNull为全屏，如果要指定区域需注意这里Rect中的值范围为0-1
 @param delegate delegate
 */
- (instancetype)initWithAVCaptureQuality:(AVCaptureQuality)quality
                           AVCaptureType:(AVCaptureType)type
                                scanRect:(CGRect)scanRect
                            successBlock:(SuccessBlock)success;

/**
 初始化Manager
 
 @param quality 视频质量
 @param type 扫描类型
 @param scanRect 扫描区域 如果传CGRectNull为全屏，如果要指定区域需注意这里Rect中的值范围为0-1
 @param delegate delegate
 */

+ (instancetype)createSessionManagerWithAVCaptureQuality:(AVCaptureQuality)quality
                                           AVCaptureType:(AVCaptureType)type
                                                scanRect:(CGRect)scanRect
                                            successBlock:(SuccessBlock)success;


/**
 检查相机的权限

 @param grant 授权
 @param denied 拒绝
 */
+ (void)checkAuthorizationStatusForCameraWithGrantBlock:(void(^)())grant
                                            DeniedBlock:(void(^)())denied;

+ (void)checkAuthorizationStatusForPhotoLibraryWithGrantBlock:(void(^)())grant
                                            DeniedBlock:(void(^)())denied;


/**
 扫描相册中的二维码信息,如果未检测到有二维码信息，返回字串为空,如果图片有多个二维码，只读取第一个
 */
- (void)scanPhotoWith:(UIImage *)image successBlock:(SuccessBlock)success;

/**
 显示创建好的preViewLayer

 @param view 要显示的View
 */
- (void)showPreviewLayerInView:(UIView *)view;

/**
 开启采集
 */
- (void)start;

/**
 结束采集
 */
- (void)stop;


/**
 是否开启闪光灯

 @param state 闪光灯状态
 */
- (void)turnTorch:(BOOL)state;

@end
