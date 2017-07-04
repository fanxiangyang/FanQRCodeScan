//
//  FanQRCodeScanViewController.h
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/4/17.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
 扫描的block回调

 @param resultSrt 扫描信息
 @param isSuccess 是否成功
 */
typedef void(^FanQRCodeScanResultBlock)(NSString* resultSrt,NSString *type,BOOL isSuccess);


#define iOS_VERSION_QR ([[[UIDevice currentDevice] systemVersion]floatValue])
#define kWidth_QR ([UIScreen mainScreen].bounds.size.width)
#define kHeight_QR ([UIScreen mainScreen].bounds.size.height)
#define kHeight_QRRect 250  //取景框的高度

@interface FanQRCodeScanViewController : UIViewController
/**
 *  black回调
 */
@property(nonatomic ,copy)FanQRCodeScanResultBlock qrCodeScanResultBlock;
///  主题导航和按钮字体颜色
@property(nonatomic ,strong)UIColor *themColor;
///  扫描框颜色
@property(nonatomic ,strong)UIColor *scanColor;

#pragma mark - 外部调用方法
/**
 *  扫描二维码的ViewController
 *
 *  @param qrCodeScanResultBlock 返回扫描信息+是否成功
 *
 *  @return self
 */
-(instancetype)initWithQRBlock:(FanQRCodeScanResultBlock)qrCodeScanResultBlock;
//暂停扫描
-(void)fan_stopScan;
//开始扫描
-(void)fan_startScan;
/// 生成二维码
+(UIImage *)fan_qrCodeImageWithText:(NSString *)text size:(CGSize)size;
+(UIImage *)fan_qrCodeImageWithText:(NSString *)text size:(CGSize)size color:(UIColor *)color bgColor:(UIColor *)bgColor;
/// 生成条形码
+ (UIImage *)fan_generateBarImageWithCode:(NSString *)code size:(CGSize)size;
@end
