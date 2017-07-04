//
//  FanCreateQRViewController.h
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/28.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanRootViewController.h"
#import "FanCommonHead.h"

@interface FanCreateQRViewController : FanRootViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UILabel *tipLable;

- (IBAction)updateClick:(id)sender;

- (IBAction)colorClick:(id)sender;

- (IBAction)createClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *scanIamgeView;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@property (weak, nonatomic) IBOutlet UIButton *colorButton;

@property(assign,nonatomic)FanQRCodeType qrCodeType;


@end
