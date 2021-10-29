//
//  JJImagePicker.h
//  ESKUTE
//
//  Created by HJJ on 2021/6/8.
//

#import <Foundation/Foundation.h>

typedef void(^PickeImageCompletedBlock)(UIImage *image);

@interface JJImagePicker : NSObject

+ (instancetype)sharedPicker;

/// 拍照
/// @param completed 完成回调，返回单张照片
- (void)pickImageFromCamaraCompleted:(PickeImageCompletedBlock)completed;

/// 从相册中选照片（单选）
/// @param completed 完成回调，返回单张照片
- (void)pickImageFromAlbumCompleted:(PickeImageCompletedBlock)completed;

@end
