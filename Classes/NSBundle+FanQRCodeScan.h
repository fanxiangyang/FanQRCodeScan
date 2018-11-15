//
//  NSBundle+FanQRCodeScan.h
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/4/17.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSBundle (FanQRCodeScan)
+ (instancetype)fan_qrCodeScanBundle;
+ (UIImage *)fan_qrImageWithName:(NSString *)imgName;
+ (UIImage *)fan_qrClearTinColorImageWithName:(NSString *)imgName;
+ (NSString *)fan_qrLocalizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)fan_qrLocalizedStringForKey:(NSString *)key;
@end
