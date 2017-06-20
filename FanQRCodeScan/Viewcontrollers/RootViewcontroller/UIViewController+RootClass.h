//
//  UIViewController+RootClass.h
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/7.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RootClass)
/** 添加单击手势 */
-(void)fan_addTapGestureTarget:(id)target action:(SEL)action toView:(UIView *)tapView;

/** 根据不同的提示信息，创建警告框 */
-(void)fan_showAlertWithMessage:(NSString *)message delegate:(id)fan_delegate;
-(void)fan_showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)fan_delegate tag:(NSInteger)tag;
/**titleView*/
- (void)fan_addTitleViewWithTitle:(NSString *)title textColor:(UIColor *)color;
-(UIBarButtonItem *)fan_creatUIBarButtonItemImageName:(NSString *)imageName frame:(CGRect)frame selector:(SEL)selector;

@end
