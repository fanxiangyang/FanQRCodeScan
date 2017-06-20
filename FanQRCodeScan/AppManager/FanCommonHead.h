//
//  FanCommonHead.h
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/7.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#ifndef FanCommonHead_h
#define FanCommonHead_h

#define FanScreenWidth [UIScreen mainScreen].bounds.size.width
#define FanScreenHeight [UIScreen mainScreen].bounds.size.height


//系统版本号
#define __iOS__Version [[[UIDevice currentDevice] systemVersion] floatValue]
//显示提示信息1.5秒
//#define ShowMessage(msg) [KYUtility showHUD:msg]
//#define ShowMessageTime(msg,time) [KYUtility showHUD:msg afterDelay:time]
//#define ShowIMPMessage(msg) [KYUtility showIMPHUD:msg]
//#define ShowIMPMessageTime(msg,time) [KYUtility showIMPHUD:msg afterDelay:time]
//#define HideAllHUD  [KYUtility hideAllHUD]

//打印数据
#ifdef DEBUG
# define FanLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define FanLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

//颜色
#define FanColor(r,g,b,a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//#define KYThemeColor        [UIColor colorWithRed:22/255.0 green:130/255.0 blue:251/255.0 alpha:1]
//#define KYThemeBackColor    [UIColor colorWithRed:34/255.0 green:73/255.0 blue:106/255.0 alpha:1]
#define FanThemeColor        [UIColor colorWithRed:54/255.0 green:157/255.0 blue:226/255.0 alpha:1]
#define FanThemeBackColor    [UIColor colorWithRed:15/255.0 green:28/255.0 blue:40/255.0 alpha:1]

//本地化
#define FanLocalizedString(key) NSLocalizedString(key, @"")
#define FanLocalizedStringFromTable(key,tbl) NSLocalizedStringFromTable(key, tbl, @"")

//自定义字体
//#define FanSystemFontOfSize(fontSize) [UIFont fontWithName:@"" size:fontSize]
//#define FanBoldFontOfSize(fontSize) [UIFont fontWithName:@"" size:fontSize]

#define FanSystemFontOfSize(fontSize) [UIFont systemFontOfSize:fontSize]
#define FanBoldFontOfSize(fontSize) [UIFont systemFontOfSize:fontSize]

//定义常量宏



#endif /* FanCommonHead_h */
