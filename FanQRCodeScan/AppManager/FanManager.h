//
//  FanManager.h
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/28.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FanManager : NSObject
+(BOOL)validateEmail:(NSString *)email;
+(BOOL)validateBarCode:(NSString *)barCode;
+(BOOL)validateTelphonNum:(NSString *)telNum;
@end
