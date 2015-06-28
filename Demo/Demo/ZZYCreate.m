//
//  ZZYCreate.m
//  Demo
//
//  Copyright (c) 2015年 zzy. All rights reserved.
//

#import "ZZYCreate.h"
#import "UIImage+ZZYQRImageExtension.h"
@interface ZZYCreate()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *lastImage;

@end
@implementation ZZYCreate

- (void)viewDidLoad{
    [super viewDidLoad];
    // 二维码中的图片
    UIImage *icon = [UIImage imageNamed:@"bigMax"];
    // 生成二维码，二维码中带有自定义图片
    self.image.image = [UIImage createQRCodeWithSize:200 dataString:@"hello" QRCodeImageType:circularImage iconImage:icon iconImageSize:40];
    // 生成二维码
    UIImage *qrImage = [UIImage createQRCodeWithSize:150 dataString:@"hello"QRCodeImageType:squareImage iconImage:icon iconImageSize:40];
    // 自定义背景图片
    UIImage *bgImage = [UIImage imageNamed:@"flower"];
    self.lastImage.image = [UIImage addQRCodeBgImage:bgImage bgImageSize:200 QRImage:qrImage];
    // 测试
}
@end
