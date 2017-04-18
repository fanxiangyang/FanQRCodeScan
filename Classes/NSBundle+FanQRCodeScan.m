//
//  NSBundle+FanQRCodeScan.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/4/17.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "NSBundle+FanQRCodeScan.h"

@implementation NSBundle (FanQRCodeScan)
+ (instancetype)fan_qrCodeScanBundle
{
    static NSBundle *fanqrCodeBundle = nil;
    if (fanqrCodeBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
//        fanqrCodeBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"FanQRCodeScan" ofType:@"bundle"]];
        fanqrCodeBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FanQRCodeScan" ofType:@"bundle"]];

    }
    return fanqrCodeBundle;
}

+ (UIImage *)fan_qrImageWithName:(NSString *)imgName
{
    UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self fan_qrCodeScanBundle] pathForResource:imgName ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return image;
}

+ (NSString *)fan_localizedStringForKey:(NSString *)key
{
    return [self fan_localizedStringForKey:key value:nil];
}

+ (NSString *)fan_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        // 从MJRefresh.bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[NSBundle fan_qrCodeScanBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

@end
