//
//  JJPickerView.m
//  ESKUTE
//
//  Created by HJJ on 2021/6/4.
//

#import "JJPickerView.h"

static const NSTimeInterval JJPickerViewAnimateDuration = .6f;

@interface JJPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *maskBgView;
@property (nonatomic, strong) UIView *pickerBgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, copy) void(^confirmBtnClickBlock)(NSDictionary *);
@property (nonatomic, strong) NSDictionary *selectdItem;

@end

@implementation JJPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)layoutContentViews {
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
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(0);
        make.left.bottom.right.equalTo(self.pickerBgView).offset(0);
    }];
}

- (void)setupSubViews {
    self.hidden = YES;
    
    self.maskBgView = [[UIView alloc] init];
    self.maskBgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    [self addSubview:self.maskBgView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.maskBgView addGestureRecognizer:tapGesture];
    
    self.pickerBgView = [[UIView alloc] init];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickerBgView];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setTitle:kLocalizedStrng(@"Cancel") forState:UIControlStateNormal];
    [self.cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.cancelBtn setTitleColor:kOrangeColor forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:self.cancelBtn];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setTitle:kLocalizedStrng(@"OK") forState:UIControlStateNormal];
    [self.confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.confirmBtn setTitleColor:kOrangeColor forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:self.confirmBtn];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = kLightGrayColor;
    [self.pickerBgView addSubview:self.lineView];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerBgView addSubview:self.pickerView];
    self.pickerBgView.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
    
    [self layoutContentViews];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dict = self.dataArray[row];
    return dict.allValues.firstObject;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *dict = self.dataArray[row];
    self.selectdItem = dict;
}

- (void)confirmBtnClick {
    if (self.dataArray.count > 0 && !self.selectdItem) {
        NSDictionary *dict = self.dataArray.firstObject;
        self.selectdItem = dict;
    }
    if (self.confirmBtnClickBlock) {
        self.confirmBtnClickBlock(self.selectdItem);
        [self hide];
    }
}

- (void)confirmBtnClickComplete:(void (^)(NSDictionary * _Nonnull))completedBlock {
    self.confirmBtnClickBlock = completedBlock;
}

#pragma mark - Animate

- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:JJPickerViewAnimateDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pickerBgView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.maskBgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    [UIView animateWithDuration:JJPickerViewAnimateDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pickerBgView.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
        self.maskBgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.pickerView reloadAllComponents];
    self.selectdItem = nil;
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}

@end
