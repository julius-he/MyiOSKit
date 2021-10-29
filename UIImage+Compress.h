//
//  UIImage+Compress.h
//  ESKUTE
//
//  Created by HJJ on 2021/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Compress)

/// 图片压缩处理
/// @param image 需要进行处理的图片
+ (UIImage *)handleImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
