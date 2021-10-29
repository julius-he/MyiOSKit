//
//  UIImage+Compress.m
//  ESKUTE
//
//  Created by HJJ on 2021/6/10.
//

#import "UIImage+Compress.h"

static const CGFloat CompressionRatio = 0.5;

@implementation UIImage (Compress)

+ (UIImage *)handleImage:(UIImage *)image {
    UIImage *originalImage = image;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    
    CGFloat imageSize = imageData.length / (1024 * 1024.0);
    NSLog(@"原始大小 %f MB", imageSize);
    UIImage *imageTemp = image;
    if (imageSize < 1.0) {
        //不作处理
        originalImage = image;
    } else if (imageTemp.size.width > 1024 || imageTemp.size.height > 1920) {
        CGFloat targetWidth;
        if (imageTemp.size.width > 1024) {
            targetWidth = 1080;
        } else {
            targetWidth = imageTemp.size.width * (1920.0/imageTemp.size.height);
        }
        //压缩
        NSData *tempData = UIImageJPEGRepresentation(imageTemp, CompressionRatio);
        UIImage *imageFlag = [UIImage imageWithData:tempData];
        originalImage =  [self compressImage:imageFlag toTargetWidth:targetWidth];
        CGFloat imageSizeFlag = tempData.length /  (1024 * 1024.0);
        NSLog(@"%f MB", imageSizeFlag);
    } else if ((imageTemp.size.width / imageTemp.size.height) > 5.0 ||
               (imageTemp.size.height / imageTemp.size.width) > 5.0) {
        //压缩
        NSData *tempData = UIImageJPEGRepresentation(imageTemp, CompressionRatio);
        UIImage *imageFlag = [UIImage imageWithData:tempData];
        originalImage =  [self compressImage:imageFlag toTargetWidth:imageFlag.size.width / 2.0];
        CGFloat imageSizeFlag = tempData.length /  (1024 * 1024.0);
        NSLog(@"%f MB", imageSizeFlag);
    } else {
        //压
        NSData *tempData = UIImageJPEGRepresentation(imageTemp, CompressionRatio);
        originalImage = [UIImage imageWithData:tempData];
    }
    
    return originalImage;
}

+ (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth {
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
