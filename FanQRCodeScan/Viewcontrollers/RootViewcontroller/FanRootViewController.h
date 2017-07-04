//
//  RootViewController.h
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/7.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+RootClass.h"

@interface FanRootViewController : UIViewController
-(void)addBackgroundImage:(NSString *)imageName;
-(void)addBackButton;
-(UIBarButtonItem *)creatUIBarButtonItemImageName:(NSString *)imageName selector:(SEL)selector;
@end
