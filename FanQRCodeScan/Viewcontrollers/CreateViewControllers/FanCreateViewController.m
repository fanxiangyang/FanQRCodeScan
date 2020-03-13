//
//  FanCreateViewController.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/27.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanCreateViewController.h"
#import "FanQRCodeScan.h"
#import "FanWebViewController.h"
#import "FanCreateQRViewController.h"
#import "FanDBManager.h"


@interface FanCreateViewController ()

@end

@implementation FanCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *scanItem=[self fan_creatUIBarButtonItemImageName:@"scan_scan.png" frame:CGRectMake(0, 0, 29, 27) selector:@selector(scanClick)];
    self.navigationItem.rightBarButtonItem=scanItem;
    
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor=[UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trait) {
            if (trait.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor systemGroupedBackgroundColor];
            } else {
                return [UIColor systemGroupedBackgroundColor];
            }
        }];
    } else {
        // Fallback on earlier versions
        self.view.backgroundColor=[UIColor whiteColor];
    }
    
}
-(void)scanClick{
    [self jumpScanVC];
}

#pragma mark -  二维码扫描界面处理

-(void)jumpScanVC{
    FanQRCodeScanViewController *qrCoreVC=[[FanQRCodeScanViewController alloc]initWithQRBlock:^(NSString *resultSrt,NSString *type, BOOL isSuccess) {
        if (isSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self openQRCode:resultSrt type:type];
            });
            NSLog(@"%@",resultSrt);
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fan_showAlertWithTitle:@"扫描失败" message:resultSrt];
            });
            NSLog(@"关闭或失败:%@",resultSrt);
        }
        
    }];
    qrCoreVC.qrOrientation=FanQRCodeOrientationAll;
//    qrCoreVC.themColor=[UIColor yellowColor];
    if (@available(iOS 13.0, *)) {
        qrCoreVC.themColor=[UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trait) {
            if (trait.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor darkGrayColor];
            } else {
                return [UIColor yellowColor];
            }
        }];
    } else {
        // Fallback on earlier versions
        qrCoreVC.themColor=[UIColor yellowColor];
    }
    qrCoreVC.scanTipColor=[UIColor darkGrayColor];
    qrCoreVC.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:qrCoreVC animated:YES completion:nil];
    
}
-(void)openQRCode:(NSString *)qrCode type:(NSString *)type{
    FanQRCodeType qrType = FanQRCodeTypeWWW;
    NSString *qrCodeReal=[qrCode copy];
    qrCode=[qrCode lowercaseString];
    NSString *qrStr = @"网址";
    if([qrCode hasPrefix:@"http"]){
        if([qrCode hasPrefix:@"http://weixin.qq.com"]||[qrCode hasPrefix:@"https://weixin.qq.com"]){
            qrType=FanQRCodeTypeWChat;
            qrStr=@"微信";
        }else if([qrCode hasPrefix:@"http://qm.qq.com"]||[qrCode hasPrefix:@"https://qm.qq.com"]||[qrCode hasPrefix:@"http://qq.com"]||[qrCode hasPrefix:@"https://qq.com"]){
            qrType=FanQRCodeTypeQQ;
            qrStr=@"QQ";
        }else if([qrCode hasPrefix:@"https://i.qianbao.qq.com"]){
            qrType=FanQRCodeTypeQQ;
            qrStr=@"QQ支付";
        }else if([qrCode hasPrefix:@"https://qr.alipay.com"]){
            qrType=FanQRCodeTypeAlipay;
            qrStr=@"支付宝";
        }else{
            qrType = FanQRCodeTypeWWW;
            qrStr = @"网址";
        }
    }else if([FanManager validateTelphonNum:qrCode]){
        //手机号
        qrStr=@"手机号";
        qrType=FanQRCodeTypePhone;
        
    }else if ([FanManager validateEmail:qrCode]){
        //邮箱
        qrStr=@"邮箱";
        qrType=FanQRCodeTypeEmail;
        
    }else{
        if([qrCode hasPrefix:@"wxp://"]){
            qrType=FanQRCodeTypeWChat;
            qrStr=@"微信支付";
        }else{
            //AVMetadataObjectTypeEAN13Code
            if (![type isEqualToString:AVMetadataObjectTypeQRCode]) {
                qrType=FanQRCodeTypeBarCode;
                qrStr=@"条形码";
            }else{
                if ([FanManager validateBarCode:qrCode]){
                    qrType=FanQRCodeTypeText;
                    qrStr=@"数字";
                }else{
                    qrType=FanQRCodeTypeText;
                    qrStr=@"文本";
                }
            }
            
        }
    }
    

    [self fan_showAlertWithTitle:qrStr message:qrCodeReal type:qrType];
    
    [[FanDBManager shareManager]fan_executeUpdateWithSql:@"insert into FanQRCodeModel (title,qrType,message,uploadTime,insertType) values (:title,:qrType,:message,:uploadTime,:insertType)" valueInDictionary:@{@"title":qrStr,@"qrType":@(qrType),@"message":qrCodeReal,@"uploadTime":[NSDate date],@"insertType":@(0)}];
    
    
}
-(void)fan_showAlertWithTitle:(NSString *)title message:(NSString *)message type:(FanQRCodeType)qrType{
    NSString *confirm=@"复制文本";
    switch (qrType) {
        case FanQRCodeTypeWWW:
            
        case FanQRCodeTypeWChat:
        case FanQRCodeTypeQQ:
        case FanQRCodeTypeAlipay:
        {
            confirm=@"打开";
        }
            break;
        case FanQRCodeTypeEmail:
        {
            confirm=@"发送邮件";
        }
            break;
        case FanQRCodeTypePhone:
        {
            confirm=@"拨打";
        }
            break;
        default:
            
            break;
    }
    UIAlertController *act=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [act addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (qrType) {
            case FanQRCodeTypeWWW:
            case FanQRCodeTypeWChat:
            case FanQRCodeTypeQQ:
            case FanQRCodeTypeAlipay:
            {
                FanWebViewController *web=[[FanWebViewController alloc]init];
                web.fanQRURL=message;
                web.hidesBottomBarWhenPushed=YES;
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:web];
                nav.modalPresentationStyle=UIModalPresentationFullScreen;
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message]];
//                NSDictionary *option=@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES,UIApplicationOpenURLOptionsSourceApplicationKey : @YES};
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message] options:nil completionHandler:^(BOOL success) {
//                    if (!success) {
//                        NSLog(@"打开连接失败%@",message);
//                    }
//                }];
            }
                break;
            case FanQRCodeTypeEmail:
            {
                if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",message]] options:@{} completionHandler:^(BOOL success) {
                        if (!success) {
                            NSLog(@"打开连接失败%@",message);
                        }
                    }];
                }else{
                   BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",message]]] ;
                    if (!success) {
                        NSLog(@"打开邮件失败%@",message);
                    }
                }
                
            }
                break;
            case FanQRCodeTypePhone:
            {
                if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",message]] options:@{} completionHandler:^(BOOL success) {
                        if (!success) {
                            NSLog(@"拨打失败%@",message);
                        }
                    }];
                }else{
                    BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",message]]] ;
                    if (!success) {
                        NSLog(@"拨打失败%@",message);
                    }
                }
            }
                break;
            default:{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = message;
            }
                
                break;
        }

    }]];
    [act addAction:[UIAlertAction actionWithTitle:[NSBundle fan_qrLocalizedStringForKey:@"FanQRCodeCancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    UIViewController *rootVC=(UIViewController*)[UIApplication sharedApplication].windows[0].rootViewController;
    [rootVC presentViewController:act animated:YES completion:^{
        
    }];
    
}
//根据不同的提示信息，创建警告框
-(void)fan_showAlertWithTitle:(NSString *)title message:(NSString *)message{
    NSString *confirm=[NSBundle fan_qrLocalizedStringForKey:@"FanQRCodeConfirm"];
    UIAlertController *act=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [act addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [act addAction:[UIAlertAction actionWithTitle:[NSBundle fan_qrLocalizedStringForKey:@"FanQRCodeCancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
  
    UIViewController *rootVC=(UIViewController*)[UIApplication sharedApplication].windows[0].rootViewController;
    [rootVC presentViewController:act animated:YES completion:^{
        
    }];
    
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 4;
    }else if(section==1){
        return 1;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FanCreateQRViewController *homePage=[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"FanCreateQRViewController"];
    homePage.hidesBottomBarWhenPushed=YES;
    
    homePage.qrCodeType=indexPath.section*4+indexPath.row;
    
    [self.navigationController pushViewController:homePage animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
