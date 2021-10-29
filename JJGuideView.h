//
//  GuideView.h
//  ESKUTE
//
//  Created by HJJ on 2021/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJGuideView : UIView

/// 引导页初始化
/// @param frames 绘制镂空区域的frame
/// @param tips 提示语
- (instancetype)initWithItemsFrames:(NSArray <NSValue *>*)frames itemsTips:(NSArray <NSString *>*)tips;

@end

NS_ASSUME_NONNULL_END
