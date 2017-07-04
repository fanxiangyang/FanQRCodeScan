//
//  FanQRPreePopViewController.h
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/30.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanRootViewController.h"
#import "FanQRCodeModel.h"


@protocol FanQRPreePopViewControllerDelegate <NSObject>

@optional
-(void)qrPreePopView:(NSInteger)actionIndex;

@end



@interface FanQRPreePopViewController : FanRootViewController

@property(nonatomic,strong)FanQRCodeModel *qrCodeModel;


@property(nonatomic,weak)id<FanQRPreePopViewControllerDelegate>delegate;



@end
