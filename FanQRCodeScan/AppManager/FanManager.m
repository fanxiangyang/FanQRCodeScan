//
//  FanManager.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/28.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanManager.h"

@implementation FanManager
#pragma mark - 邮箱校验
+(BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - 条形码验证
+(BOOL)validateBarCode:(NSString *)barCode {
    NSString *Regex = @"[0-9]{1,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [predicate evaluateWithObject:barCode];
}

#pragma mark - 手机号验证
+(BOOL)validateTelphonNum:(NSString *)telNum {
    NSString *Regex = @"^((\\+86)|(86))?[1][3456789][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [predicate evaluateWithObject:telNum];
}


@end
