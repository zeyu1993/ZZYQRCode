//
//  UIImage+ZZYQRImageExtension.m
//  Created by ZZY on 15/5/15.
//

#import "UIImage+ZZYQRImageExtension.h"
#import <CoreImage/CoreImage.h>
@implementation UIImage (ZZYQRImageExtension)

// 生成原始的二维码图片
+ (UIImage *)createQRCodeWithSize:(CGFloat)size dataString:(NSString *)dataString{
    // 1.创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.还原滤镜初始化属性
    [filter setDefaults];
    
    // 3.将需要生成二维码的数据转换成二进制
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4.给二维码滤镜设置数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 5.获取滤镜生成的图片
    CIImage *ciImage =  [filter outputImage];
    UIImage *newImage = [self createNonInterpolatedUIImageFormCIImage:ciImage withSize:size];
    return newImage;
}

// 生成自定义的二维码图片
+ (UIImage *)createQRCodeWithSize:(CGFloat)size dataString:(NSString *)dataString QRCodeImageType:(QRCodeImageType) type iconImage:(UIImage *)iconImage iconImageSize:(CGFloat)iconImageSize{
    // 背景为普通二维码
    UIImage *bgImage = [self createQRCodeWithSize:size dataString:dataString];
    // 如果为圆形,对图片进行切割
    if (type == circularImage) {
        iconImage = [self createCircularImage:iconImage];
    }
    UIImage *newImage = [self createNewImageWithBg:bgImage iconImage:iconImage iconImageSize:iconImageSize];
    return newImage;
}

// 为二维码添加自定义背景
+ (UIImage *)addQRCodeBgImage:(UIImage *)bgImage bgImageSize:(CGFloat) bgImageSize QRImage:(UIImage *)QRImage{
    bgImage = [self imageCompressForSize:bgImage targetSize:CGSizeMake(bgImageSize, bgImageSize)];
    return [self createNewImageWithBg:bgImage iconImage:QRImage iconImageSize:QRImage.size.height];
}
// 绘制图片
+ (UIImage *)createNewImageWithBg:(UIImage *)bgImage iconImage:(UIImage *)iconImage iconImageSize:(CGFloat)iconImageSize{
    // 1.开启图片上下文
    UIGraphicsBeginImageContext(bgImage.size);
    
    // 2.绘制背景
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 3.绘制图标
    CGFloat imageW = iconImageSize;
    CGFloat imageH = iconImageSize;
    CGFloat imageX = (bgImage.size.width - imageW) * 0.5;
    CGFloat imageY = (bgImage.size.height - imageH) * 0.5;
    [iconImage drawInRect:CGRectMake(imageX, imageY, imageW, imageH)];
    
    // 4.取出绘制好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    // 6.返回生成好得图片
    return newImage;
}

// 剪裁圆形图片
+ (instancetype)createCircularImage:(UIImage *)iconImage{
    // 1. 创建一个bitmap类型图形上下文（空白的UiImage）
    // NO 将来创建的透明的UiImage
    // YES 不透明
    UIGraphicsBeginImageContextWithOptions(iconImage.size, NO, 0);
    
    // 2. 指定可用范围
    // 2.1 获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.2 画圆
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, iconImage.size.width, iconImage.size.height));
    // 2.3 裁剪，指定将来可以画图的可用范围
    CGContextClip(ctx);
    
    // 3. 绘制图片
    [iconImage drawInRect:CGRectMake(0, 0, iconImage.size.width, iconImage.size.height)];
    
    // 4. 取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.1 关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}


/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽高
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

//按比例缩放,size 是你要把图显示到 多大区域
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
@end
