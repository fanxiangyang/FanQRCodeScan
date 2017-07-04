//
//  FanPreePopViewController.h
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/30.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanRootViewController.h"


@protocol FanPreePopViewControllerDelegate <NSObject>

@optional
-(void)preePopView:(NSInteger)actionIndex;

@end


@interface FanPreePopViewController : FanRootViewController


@property(nonatomic,strong)UIImage *image;
@property(nonatomic,copy)NSString *qrCode;


@property(nonatomic,weak)id<FanPreePopViewControllerDelegate>delegate;


@end
