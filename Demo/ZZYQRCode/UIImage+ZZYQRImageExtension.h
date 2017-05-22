//
//  UIImage+ZZYQRImageExtension.h
//
//  Created by ZZY on 15/5/15.
//

#import <UIKit/UIKit.h>

typedef enum {
    // 圆形图片
    circularImage,
    // 方形图片
    squareImage
}QRCodeImageType;


@interface UIImage (ZZYQRImageExtension)

/**
 *  生成原始的二维码（中间不带图片）
 *
 *  @param size 二维码的大小
 *
 *  @param data 数据
 *
 *  @return 二维码图片
 */
+ (UIImage *)createQRCodeWithSize:(CGFloat)size dataString:(NSString *)dataString;

/**
 *  生成自定义的二维码 （中间带图片,背景为二维嘛）
 *
 *  @param size      二维码的大小
 *  @param type      自定义二维码图片的种类（中间图片为方形，中间图片为圆形）
 *  @param image     中间图片
 *  @param imageSize 中间图片的大小
 *  @param data 数据
 *  @return 自定义二维码图片
 */
+ (UIImage *)createQRCodeWithSize:(CGFloat)size dataString:(NSString *)dataString QRCodeImageType:(QRCodeImageType) type iconImage:(UIImage *)iconImage iconImageSize:(CGFloat)iconImageSize;


/**
 *  为二维码添加自定义背景
 *
 *  @param bgImage     背景图片
 *  @param QRImage     二维码图片
 *  @param QRImageSize 二维码图片大小
 *  @param bgImageSize 背景图片大小
 *  @return 二维码图片（自定义背景）
 */
+ (UIImage *)addQRCodeBgImage:(UIImage *)bgImage bgImageSize:(CGFloat) bgImageSize QRImage:(UIImage *)QRImage;
@end
