//
//  FanQRCodeModel.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/30.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanQRCodeModel.h"

@implementation FanQRCodeModel


-(void)configWithSet:(FMResultSet *)set{
    _qrId=[set intForColumn:@"qrId"];
    _title=[set stringForColumn:@"title"];
    _insertType=[set intForColumn:@"insertType"];
    _qrType=[set intForColumn:@"qrType"];
    _message=[set stringForColumn:@"message"];
    _uploadTime=[set dateForColumn:@"uploadTime"];
    
}


@end
