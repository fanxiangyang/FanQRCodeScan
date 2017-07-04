//
//  FanQRCell.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/30.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanQRCell.h"
#import "FanCommonHead.h"


@implementation FanQRCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configWith:(FanQRCodeModel *)model{
    _titleLabel.text=model.title;
    _messageLabel.text=model.message;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:model.uploadTime];

    _timeLabel.text=strDate;
    
    if (model.qrType==FanQRCodeTypeWChat) {
        _leftImageView.image=[UIImage imageNamed:@"scan_wChat.png"];
    }else if (model.qrType==FanQRCodeTypeQQ) {
        _leftImageView.image=[UIImage imageNamed:@"scan_qq.png"];
    }else if (model.qrType==FanQRCodeTypeAlipay) {
        _leftImageView.image=[UIImage imageNamed:@"scan_alipay.png"];
    }else if (model.qrType==FanQRCodeTypeBarCode) {
        _leftImageView.image=[UIImage imageNamed:@"scan_bar.png"];
    }else {
        if([model.message hasPrefix:@"https://github.com"]){
            _leftImageView.image=[UIImage imageNamed:@"scan_github.png"];
        }else{
            _leftImageView.image=[UIImage imageNamed:@"scan_default.png"];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
