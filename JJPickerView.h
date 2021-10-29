//
//  JJPickerView.h
//  ESKUTE
//
//  Created by HJJ on 2021/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJPickerView : UIView

@property (nonatomic, strong) NSArray *dataArray;

- (void)show;
- (void)confirmBtnClickComplete:(void(^)(NSDictionary *selectdItem))completedBlock;

@end
NS_ASSUME_NONNULL_END
