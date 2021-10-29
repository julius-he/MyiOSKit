//
//  JJDatePickerView.h
//  ESKUTE
//
//  Created by HJJ on 2021/6/9.
//

#import <UIKit/UIKit.h>

@interface JJDatePickerView : UIView

@property (nonatomic, assign) BOOL isNotFromNowTime;

- (void)show;
- (void)hide;
- (void)selectDateBlock:(void (^)(NSString *dateStr))completedBlock;

@end
