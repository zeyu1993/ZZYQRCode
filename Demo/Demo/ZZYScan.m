//
//  ZZYScan.m
//  Demo
//  Copyright (c) 2015年 zzy. All rights reserved.
//

#import "ZZYScan.h"
#import "AVCaptureSession+ZZYQRCodeAndBarCodeExtension.h"
@interface ZZYScan()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanTop;

@property (nonatomic, strong) CADisplayLink *link;

@property (nonatomic, strong) AVCaptureSession *session;
@end
@implementation ZZYScan

- (void)viewDidLoad{
    [super viewDidLoad];
    // 添加跟屏幕刷新频率一样的定时器
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(scan)];
    self.link = link;
    // 获取读取读取二维码的会话
    self.session = [AVCaptureSession readQRCodeWithMetadataObjectsDelegate:self];
    
//    // 获取读取条形码的会话
//    self.session = [AVCaptureSession readBarCodeWithMetadataObjectsDelegate:self];
    
    
    // 创建预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    previewLayer.frame = self.view.bounds;
    // 插入到最底层
    [self.view.layer insertSublayer:previewLayer atIndex:0];
}
// 在页面将要显示的时候添加定时器
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.session startRunning];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

// 在页面将要消失的时候移除定时器
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
// 扫描效果
- (void)scan{
    self.scanTop.constant -= 1;
    if (self.scanTop.constant <= -170) {
        self.scanTop.constant = 170;
    }
}


#pragma mark ---------------------AVCaptureMetadataOutputObjectsDelegate--------------------

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        // 停止扫描
        [self.session stopRunning];
        // 获取信息
        AVMetadataMachineReadableCodeObject *object = metadataObjects.lastObject;
        
        // 弹窗提示
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Result" message:[NSString stringWithFormat:@"%@",object.stringValue] delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
