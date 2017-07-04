//
//  FanQRCodeModel.h
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/30.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FanQRCodeModel : NSObject


@property(nonatomic,assign)NSInteger qrId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)NSInteger insertType;
@property(nonatomic,assign)NSInteger qrType;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,strong)NSDate *uploadTime;



-(void)configWithSet:(FMResultSet *)set;

@end
