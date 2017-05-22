//
//  AVCaptureSessionManager.m
//  Demo
//
//  Created by 张泽宇 on 2017/5/19.
//  Copyright © 2017年 zzy. All rights reserved.
//

#import "AVCaptureSessionManager.h"
#import <Photos/Photos.h>
@interface AVCaptureSessionManager()<AVCaptureMetadataOutputObjectsDelegate>
@property(copy, nonatomic) SuccessBlock block;
@property(strong, nonatomic) AVCaptureDevice *device;
@end
@implementation AVCaptureSessionManager

- (instancetype)initWithAVCaptureQuality:(AVCaptureQuality)quality
                           AVCaptureType:(AVCaptureType)type
                                scanRect:(CGRect)scanRect
                            successBlock:(SuccessBlock)success {
    if (self = [super init]) {
        self.block = success;
        // 1.获取输入设备(摄像头)
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // 2.根据输入设备创建输入对象
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:NULL];
        
        // 3.创建输出对象
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        
        // 4.设置代理监听输出对象输出的数据
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        if (!CGRectEqualToRect(scanRect, CGRectNull)) {
            output.rectOfInterest = scanRect;
        }
        
        [self setSessionPreset:[self qualityStrWithAVCaptureQuality:quality]];
        
        // 6.添加输入和输出到会话中
        if ([self canAddInput:input]) {
            [self addInput:input];
        }
        if ([self canAddOutput:output]) {
            [self addOutput:output];
        }
        
        // 7.告诉输出对象, 需要输出什么样的数据(支持解析什么样的格式)
        NSArray *types = [self captureTypesWithAVCaptureType:type];
        [output setMetadataObjectTypes:types];
        
        // 8.添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(stop)
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(start)
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    }
    
    return self;
}

+ (instancetype)createSessionManagerWithAVCaptureQuality:(AVCaptureQuality)quality
                                           AVCaptureType:(AVCaptureType)type
                                                scanRect:(CGRect)scanRect
                                            successBlock:(SuccessBlock)success {
    AVCaptureSessionManager *manager = [[AVCaptureSessionManager alloc]initWithAVCaptureQuality:quality
                                                                                  AVCaptureType:type
                                                                                       scanRect:scanRect
                                                                                   successBlock:success];
    return manager;
}

+ (void)checkAuthorizationStatusForCameraWithGrantBlock:(void (^)())grant
                                            DeniedBlock:(void (^)())denied {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                // 第一次选择
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (grant) {
                            grant();
                        }
                    });
                
                } else {
                    
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            if (grant) {
                grant();
            }
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            if (denied) {
                denied();
            }
            
        } else if (status == AVAuthorizationStatusRestricted) {
        
        }
    } else {
        
    }
}

+ (void)checkAuthorizationStatusForPhotoLibraryWithGrantBlock:(void (^)())grant
                                                  DeniedBlock:(void (^)())denied {
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (grant) {
                        grant();
                    }
                });
            } else {
                
            }
        }];
        
    } else if (status == PHAuthorizationStatusAuthorized) {
        if (grant) {
            grant();
        }
        
    } else if (status == PHAuthorizationStatusDenied) { 
        if (denied) {
            denied();
        }
    } else if (status == PHAuthorizationStatusRestricted) {
    
    }
}

- (void)scanPhotoWith:(UIImage *)image successBlock:(SuccessBlock)success {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (int i = 0; i< features.count; i++) {
        CIQRCodeFeature *feature = [features objectAtIndex:i];
        NSString *result = feature.messageString;
        if (success) {
            success(result);
            return;
        }
    }
    // 没有识别到二维码
    if (success) {
        success(nil);
    }
}

- (void)showPreviewLayerInView:(UIView *)view {
    self.preViewLayer.frame = view.bounds;
    [view.layer insertSublayer:self.preViewLayer atIndex:0];
    [self start];
}

- (void)start {
    [self startRunning];
}

- (void)stop {
    [self stopRunning];
}

- (void)turnTorch:(BOOL)state {
    if ([_device hasTorch]) {
        [_device lockForConfiguration:nil];
        if (state) {
            [_device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [_device setTorchMode: AVCaptureTorchModeOff];
        }
        [_device unlockForConfiguration];
    }
}

- (void)playSound {
    if (self.isPlaySound) {
        NSString *result = @"ZZYQRCode.bundle/sound.caf";
        if ((self.soundName) && (![self.soundName isEqualToString:@""])) {
            result = self.soundName;
        }
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:result ofType:nil];
        NSURL *fileUrl = [NSURL fileURLWithPath:urlStr];
        
        SystemSoundID soundID = 0;
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
        
        AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, NULL, NULL);
        
        AudioServicesPlaySystemSound(soundID);
    }
}


- (AVCaptureVideoPreviewLayer *)preViewLayer {
    if (!_preViewLayer) {
        _preViewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self];
        _preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _preViewLayer;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        // 停止扫描
        [self stop];
        [self playSound];
        // 获取信息
        AVMetadataMachineReadableCodeObject *object = metadataObjects.lastObject;
        self.block(object.stringValue);
    }
}


- (NSString *)qualityStrWithAVCaptureQuality:(AVCaptureQuality)quality {
    NSString *result = @"";
    switch (quality) {
        case AVCaptureQualityHigh:
            result = AVCaptureSessionPresetHigh;
            break;
        case AVCaptureQualityMedium:
            result = AVCaptureSessionPresetMedium;
            break;
        case AVCaptureQualityLow:
            result = AVCaptureSessionPresetLow;
            break;
        default:
            break;
    }
    return result;
}

- (NSArray *)captureTypesWithAVCaptureType:(AVCaptureType)type {
    NSArray *result = [NSArray array];
    switch (type) {
        case AVCaptureTypeQRCode:
            result = @[AVMetadataObjectTypeQRCode];
            break;
        case AVCaptureTypeBarCode:
            result = @[AVMetadataObjectTypeDataMatrixCode,
                       AVMetadataObjectTypeITF14Code,
                       AVMetadataObjectTypeInterleaved2of5Code,
                       AVMetadataObjectTypeAztecCode,
                       AVMetadataObjectTypePDF417Code,
                       AVMetadataObjectTypeCode128Code,
                       AVMetadataObjectTypeCode93Code,
                       AVMetadataObjectTypeEAN8Code,
                       AVMetadataObjectTypeEAN13Code,
                       AVMetadataObjectTypeCode39Mod43Code,
                       AVMetadataObjectTypeCode39Code,
                       AVMetadataObjectTypeUPCECode];
            break;
        case AVCaptureTypeBoth:
            result = @[AVMetadataObjectTypeQRCode,
                       AVMetadataObjectTypeDataMatrixCode,
                       AVMetadataObjectTypeITF14Code,
                       AVMetadataObjectTypeInterleaved2of5Code,
                       AVMetadataObjectTypeAztecCode,
                       AVMetadataObjectTypePDF417Code,
                       AVMetadataObjectTypeCode128Code,
                       AVMetadataObjectTypeCode93Code,
                       AVMetadataObjectTypeEAN8Code,
                       AVMetadataObjectTypeEAN13Code,
                       AVMetadataObjectTypeCode39Mod43Code,
                       AVMetadataObjectTypeCode39Code,
                       AVMetadataObjectTypeUPCECode];
            break;
        default:
            break;
    }
    return result;
}

@end
