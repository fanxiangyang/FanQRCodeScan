//
//  UIViewController+RootClass.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/7.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "UIViewController+RootClass.h"

@implementation UIViewController (RootClass)
-(void)fan_addTapGestureTarget:(id)target action:(SEL)action toView:(UIView *)tapView{
    UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapView.userInteractionEnabled=YES;
    [tapView addGestureRecognizer:imageTapGesture];
}
//根据不同的提示信息，创建警告框
-(void)fan_showAlertWithMessage:(NSString *)message delegate:(id)fan_delegate{
    [self fan_showAlertWithTitle:@"温馨提示" message:message delegate:fan_delegate tag:0];
}
//根据不同的提示信息，创建警告框
-(void)fan_showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)fan_delegate tag:(NSInteger)tag{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title?title:@"温馨提示" message:message delegate:fan_delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=tag;
    [alert show];
}
- (void)fan_addTitleViewWithTitle:(NSString *)title textColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=color;
    self.navigationItem.titleView = label;
}
-(UIBarButtonItem *)fan_creatUIBarButtonItemImageName:(NSString *)imageName frame:(CGRect)frame selector:(SEL)selector{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    if (imageName) {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}

@end
