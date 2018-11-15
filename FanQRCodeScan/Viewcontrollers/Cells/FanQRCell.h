//
//  FanQRCell.h
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/30.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FanQRCodeModel.h"

@interface FanQRCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;



-(void)configWith:(FanQRCodeModel *)model;




@end
