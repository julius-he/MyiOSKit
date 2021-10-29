//
//  JJDatePickerView.m
//  ESKUTE
//
//  Created by HJJ on 2021/6/9.
//

#import "JJDatePickerView.h"

static const NSTimeInterval JJDatePickerViewAnimateDuration = .6f;

@interface JJDatePickerView ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *maskBgView;
@property (nonatomic, strong) UIView *pickerBgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, copy) NSString *replyPeriod;
@property (copy, nonatomic) void (^selectBlock)(NSString *);

@end

@implementation JJDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    //遮罩
    self.maskBgView = [[UIView alloc] init];
    self.maskBgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    [self addSubview:self.maskBgView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.maskBgView addGestureRecognizer:tapGesture];
    //选择器背景
    self.pickerBgView = [[UIView alloc] init];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickerBgView];
    //取消按钮
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setTitle:kLocalizedStrng(@"Cancel") forState:UIControlStateNormal];
    [self.cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.cancelBtn setTitleColor:kOrangeColor forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:self.cancelBtn];
    //确定按钮
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setTitle:kLocalizedStrng(@"OK") forState:UIControlStateNormal];
    [self.confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.confirmBtn setTitleColor:kOrangeColor forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:self.confirmBtn];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = kLightGrayColor;
    [self.pickerBgView addSubview:self.lineView];
    
    //时间选择器
    self.datePicker = [[UIDatePicker alloc] init];
    if (@available(iOS 14.0, *)) {
        self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setDate:[NSDate date] animated:YES];
//    [self.datePicker setMinimumDate:[NSDate date]];
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self.pickerBgView addSubview:self.datePicker];
    self.pickerBgView.transform = CGAffineTransformMakeTranslation(0, self.height);
    
    [self.maskBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
    }];
    [self.pickerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self).offset(0);
        make.height.equalTo(@290);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.pickerBgView).offset(0);
        make.width.equalTo(@55);
        make.height.equalTo(@45);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.pickerBgView).offset(0);
        make.width.equalTo(@55);
        make.height.equalTo(@45);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelBtn.mas_bottom).offset(0);
        make.left.right.equalTo(self.pickerBgView).offset(0);
        make.height.equalTo(@1);
    }];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(0);
        make.left.bottom.right.equalTo(self.pickerBgView).offset(0);
    }];
}

- (void)setIsNotFromNowTime:(BOOL)isNotFromNowTime
{
    _isNotFromNowTime = isNotFromNowTime;
    if (_isNotFromNowTime) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-10];//设置最小时间为：当前时间前推十年
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [self.datePicker setMinimumDate:minDate];
        [self.datePicker setMaximumDate:[NSDate date]];
    } else {
        [self.datePicker setMinimumDate:[NSDate date]];
    }
}

- (void)confirmBtnClick
{
    if (self.selectBlock) {
        if (self.replyPeriod.length > 0) {//滚动选择器后就把所选时间传出去
            self.selectBlock(self.replyPeriod);
        } else {//没有滚动选择器的话就把默认时间传出去
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            formatter.dateFormat = @"yyyy-MM-dd";
            formatter.dateFormat = @"yyyy";
            self.selectBlock([formatter stringFromDate:[NSDate date]]);
        }
    }
    [self hide];
}

- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy年MM月dd日";
//    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.dateFormat = @"yyyy";
    self.replyPeriod = [formatter stringFromDate:datePicker.date];
}

- (void)selectDateBlock:(void (^)(NSString* dateStr))completedBlock{
    self.selectBlock = completedBlock;
}

#pragma mark - Animate

- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:JJDatePickerViewAnimateDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pickerBgView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.maskBgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    [UIView animateWithDuration:JJDatePickerViewAnimateDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pickerBgView.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
        self.maskBgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}

@end
