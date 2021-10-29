//
//  GuideView.m
//  ESKUTE
//
//  Created by HJJ on 2021/6/15.
//

#import "JJGuideView.h"

@interface JJGuideView ()

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSArray <NSValue *>*frames;
@property (nonatomic, copy) NSArray <NSString *>*tips;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIBezierPath *tempPath;

@property (nonatomic, strong) MASConstraint *labelLeftMargin;
@property (nonatomic, strong) MASConstraint *labelRightMargin;

@end

@implementation JJGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithItemsFrames:(NSArray <NSValue *>*)frames itemsTips:(NSArray <NSString *>*)tips {
    self = [[[self class] alloc] init];
    // 先初始化对象后再存数据
    _frames = frames;
    _tips = tips;
    [self updatePath];
    [self updateLabel];
    [self updateBtnTitle];
    return self;
}

- (void)setupSubViews {
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.6;
    [self addSubview:maskView];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.textColor = kWhiteColor;
    self.descLabel.font = kBoldFont(15);
    self.descLabel.numberOfLines = 0;
    [self addSubview:self.descLabel];
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.doneBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.doneBtn.titleLabel setFont:kBoldFont(24)];
    [self.doneBtn setBackgroundImage:[UIImage imageNamed:@"guide_button_bg"] forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.doneBtn];
    
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-200);
        make.width.equalTo(@169);
        make.height.equalTo(@55);
        make.centerX.equalTo(self);
    }];
}

- (CAShapeLayer *)addTransparencyViewWith:(UIBezierPath *)tempPath{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    [path appendPath:tempPath];
    path.usesEvenOddFillRule = YES;
 
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor blackColor].CGColor;  //其他颜色都可以，只要不是透明的
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    return shapeLayer;
}

- (void)updateLabelLayoutWithFrame:(CGRect)frame {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat halfScreenWidth = [UIScreen mainScreen].bounds.size.width * 0.5;
    CGFloat viewWith = frame.size.width;
    CGFloat viewX = frame.origin.x;
    CGFloat viewY = frame.origin.y;
    CGFloat margin = (viewX + viewWith) < halfScreenWidth ?
                                    viewX + viewWith + 20 :
         screenWidth - (viewX + viewWith) + viewWith + 20;
    // 第0个添加约束，否则更新约束
    if (self.index == 0) {
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(viewY);
            if ((viewX + viewWith) < halfScreenWidth) {
                _labelLeftMargin = make.left.mas_equalTo(margin);
            } else {
                _labelRightMargin = make.right.mas_equalTo(-margin);
            }
            make.width.lessThanOrEqualTo(@200);
        }];
    } else {
        // 更新前先删除约束
        if (self.labelLeftMargin) {
            [self.labelLeftMargin uninstall];
        }
        if (self.labelRightMargin) {
            [self.labelRightMargin uninstall];
        }
        [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(viewY);
            if ((viewX + viewWith) < halfScreenWidth) {
                make.left.mas_equalTo(margin);
            } else {
                make.right.mas_equalTo(-margin);
            }
        }];
    }
}
// 更新镂空图的路径
- (void)updatePath {
    // 有数据再取值，避免数组越界
    if (self.frames.count > 0) {
        NSValue *value = self.frames[self.index];
        CGRect frame = [value CGRectValue];
        self.tempPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight |UIRectCornerBottomRight|UIRectCornerBottomLeft) cornerRadii:CGSizeMake(4, 4)];
        self.layer.mask = [self addTransparencyViewWith:self.tempPath];
    }
}

- (void)updateLabel {
    // 有数据再取值，避免数组越界
    if (self.tips.count > 0) {
        self.descLabel.text = self.tips[self.index];
        [self.descLabel sizeToFit];
    }
    if (self.frames.count > 0) {
        NSValue *value = self.frames[self.index];
        CGRect frame = [value CGRectValue];
        [self updateLabelLayoutWithFrame:frame];
    }
}

- (void)updateBtnTitle {
    if (self.frames.count == 0 || self.index == (self.frames.count - 1) ) {
        [self.doneBtn setTitle:kLocalizedStrng(@"Got it") forState:UIControlStateNormal];
    } else {
        [self.doneBtn setTitle:kLocalizedStrng(@"Next") forState:UIControlStateNormal];
    }
}

- (void)doneBtnClick {
    // 如果没有传坐标进来 或者 当前是最后一个坐标时 就移除引导页
    if (self.frames.count == 0 || self.index == (self.frames.count - 1) ) {
        [self removeFromSuperview];
    } else {
        self.index ++;
        [self updatePath];
        [self updateBtnTitle];
        [self updateLabel];
    }
}

@end
