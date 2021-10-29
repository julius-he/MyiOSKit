//
//  IconAndLineTextField.h
//  ESKUTE
//
//  Created by HJJ on 2021/6/3.
//

#import <UIKit/UIKit.h>


@interface IconAndLineTextField : UIView<UITextFieldDelegate>

/// 图标
@property (nonatomic, copy) NSString *iconName;
/// 提示文本
@property (nonatomic, copy) NSAttributedString *placeholderAttributedStr;
/// 字体
@property (nonatomic, strong) UIFont *font;
/// 主题色
@property (nonatomic, strong) UIColor *tintColor;
/// 文本颜色
@property (nonatomic, strong) UIColor *textColor;
/// 底部线条颜色
@property (nonatomic, strong) UIColor *bottomLineViewColor;
/// 是否显示清除按钮
@property (nonatomic, assign) BOOL isShowClearBtn;
/// 是否密文输入
@property (nonatomic, assign) BOOL secureTextEntry;

/// 文字输入回调
/// @param handler 处理回调
- (void)textChange:(void (^)(NSString *text))handler;

@end
