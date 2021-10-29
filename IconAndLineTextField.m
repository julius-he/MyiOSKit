//
//  IconAndLineTextField.m
//  ESKUTE
//
//  Created by HJJ on 2021/6/3.
//

#import "IconAndLineTextField.h"

@interface IconAndLineTextField ()

@property (nonatomic, copy) void (^textChangeBlock)(NSString *);

@end

@implementation IconAndLineTextField
{
    UIImageView *_iconImgView;
    UITextField *_textField;
    UIView *_bottomLineView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_iconImgView];
    
    _textField = [[UITextField alloc] init];
    _textField.tintColor = kWhiteColor;
    _textField.textColor = kWhiteColor;
    _textField.font = kMediumFont(14);
    _textField.delegate = self;
    [self addSubview:_textField];
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = kWhiteColor;
    [self addSubview:_bottomLineView];
    
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@20);
        make.width.height.equalTo(@20);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_iconImgView.mas_right).offset(10);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(@40);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textField.mas_bottom);
        make.left.right.insets(UIEdgeInsetsMake(0, 20, 0, 20));
        make.height.equalTo(@1);
    }];
}

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    _iconImgView.image = [UIImage imageNamed:_iconName];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    _textField.font = _font;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    _textField.tintColor = _tintColor;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _textField.textColor = _textColor;
}

- (void)setBottomLineViewColor:(UIColor *)bottomLineViewColor {
    _bottomLineViewColor = bottomLineViewColor;
    _bottomLineView.backgroundColor = _bottomLineViewColor;
}

- (void)setIsShowClearBtn:(BOOL)isShowClearBtn {
    _isShowClearBtn = isShowClearBtn;
    _textField.clearButtonMode = _isShowClearBtn ?  UITextFieldViewModeWhileEditing : UITextFieldViewModeNever;
}

- (void)setPlaceholderAttributedStr:(NSAttributedString *)placeholderAttributedStr {
    _placeholderAttributedStr = placeholderAttributedStr;
    _textField.attributedPlaceholder = _placeholderAttributedStr;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    _textField.secureTextEntry = _secureTextEntry;
}

- (void)textChange:(void (^)(NSString *))handler {
    self.textChangeBlock = handler;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textChangeBlock) {
        self.textChangeBlock(textField.text);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *inpuStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = inpuStr;
    if (self.textChangeBlock) {
        self.textChangeBlock(textField.text);
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.textChangeBlock) {
        self.textChangeBlock(textField.text);
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.textChangeBlock) {
        self.textChangeBlock(@"");
    }
    return YES;
}

@end
