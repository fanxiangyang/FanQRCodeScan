//
//  FanCreateQRViewController.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/28.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanCreateQRViewController.h"
#import "FanQRCodeScan.h"
#import <Photos/Photos.h>
#import "FanPreePopViewController.h"
#import "FanDBManager.h"

@interface FanCreateQRViewController ()<UIViewControllerPreviewingDelegate,FanPreePopViewControllerDelegate>

@end

@implementation FanCreateQRViewController{
    CGSize qrSize;
    NSString *colorStr;
    UIColor *qrColor;
    NSString *qrCodeStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    
    self.navigationItem.leftBarButtonItem=[self fan_creatUIBarButtonItemImageName:@"back_iOS.png" frame:CGRectMake(0, 0, 30, 30) selector:@selector(backClick)];
    [self configUI];
}
-(void)configUI{
    qrSize=CGSizeMake(256, 256);
    colorStr=@"黑色";
    qrColor=[UIColor blackColor];
    NSString *titleStr=@"请输入一个网址";
    switch (self.qrCodeType) {
        case FanQRCodeTypeWWW:
        {
            titleStr=@"请输入一个网址";
        }
            break;
        case FanQRCodeTypeEmail:
        {
            titleStr=@"请输入一个邮件地址";
        }
            break;
        case FanQRCodeTypePhone:
        {
            titleStr=@"请输入一个电话号码";
        }
            break;
        case FanQRCodeTypeText:
        {
            titleStr=@"请输入一个文本";
        }
            break;
        case FanQRCodeTypeBarCode:
        {
            titleStr=@"请输入一个条形码号";
            qrSize=CGSizeMake(256, 128);
            self.tipLable.text=@"尺寸:256x128  颜色:黑色";
            self.colorButton.hidden=YES;
            
            NSArray* constrains = self.view.constraints;
            for (NSLayoutConstraint* constraint in constrains) {
                if (constraint.firstAttribute == NSLayoutAttributeCenterX&&constraint.firstItem == self.updateButton) {
                    //修改的约束会立即生效，加上下面这句变化的过程就显得比较自然
//                    [UIView animateWithDuration:0.27 animations:^
//                     {
//                         
//                     }];
                    
                    [self.view removeConstraint:constraint];
                    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.updateButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
                    [self.view layoutIfNeeded];
                }
            }
        }
            break;
     
            
        default:
            break;
    }
    self.titleLabel.text=titleStr;
    
    [self fan_addTapGestureTarget:self action:@selector(tapImageView) toView:self.scanIamgeView];
    //注册3D Touch
    if ([self respondsToSelector:@selector(registerForPreviewingWithDelegate:sourceView:)]) {
        [self registerForPreviewingWithDelegate:self sourceView:self.scanIamgeView];
    }

}

-(void)backClick{
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 3D-Touch  UIViewControllerPreviewingDelegate
-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    FanPreePopViewController *childVC = [[FanPreePopViewController alloc] init];
    childVC.delegate=self;
    childVC.image=self.scanIamgeView.image;
    childVC.qrCode=qrCodeStr;
    if (childVC.image==nil) {
        return nil;
    }
    CGFloat minWH=MIN(FanScreenWidth, FanScreenHeight);
    childVC.preferredContentSize = CGSizeMake(minWH,minWH);
    childVC.hidesBottomBarWhenPushed=YES;
    
    //按压资源高透区域
    CGRect rect = CGRectMake(0, 0, self.scanIamgeView.frame.size.width, self.scanIamgeView.frame.size.height);
    previewingContext.sourceRect = rect;
    return childVC;
}
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    [self showViewController:viewControllerToCommit sender:self];
}
-(void)preePopView:(NSInteger)actionIndex{
    if (actionIndex==0) {
        [self shareQRCodeIsExitUrl:YES];

    }else if (actionIndex==1){
        [self shareQRCodeIsExitUrl:NO];

    }
}
#pragma mark - 保存和分享
-(void)tapImageView{
    
    if(self.scanIamgeView.image==nil){
        return;
    }
    
    UIAlertController *act=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [act addAction:[UIAlertAction actionWithTitle:[NSBundle fan_localizedStringForKey:@"FanQRCodeCancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
  
    [act addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareQRCodeIsExitUrl:YES];
    }]];
    NSString *t1=@"分享二维码";
    if (self.qrCodeType==FanQRCodeTypeBarCode) {
        t1=@"分享条形码";
    }
    [act addAction:[UIAlertAction actionWithTitle:t1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareQRCodeIsExitUrl:NO];
    }]];
  
    [act addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self savePhotoToLibrary];
    }]];
   
    [act addAction:[UIAlertAction actionWithTitle:@"复制文本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = qrCodeStr;
    }]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [act setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [act popoverPresentationController];
        popPresenter.sourceView = self.scanIamgeView;
        popPresenter.sourceRect = self.scanIamgeView.bounds;
    }
    [self presentViewController:act animated:YES completion:^{
        
    }];

}
-(void)savePhotoToLibrary{
    UIImage *image=self.scanIamgeView.image;
    if (image) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
        }];
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}
- (void)shareQRCodeIsExitUrl:(BOOL)isExit {
    
    UIImage *imageToShare=self.scanIamgeView.image;
    if (!imageToShare) {
        return;
    }
    NSString *text=[self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *textToShare =[NSString stringWithFormat:@"小韩二维码:%@",text];

    NSURL *urlToShare = [NSURL URLWithString:@"https://github.com/fanxiangyang/FanQRCodeScan"];
    
    NSArray *activityItems =isExit?@[textToShare, imageToShare,urlToShare]:@[textToShare, imageToShare];

    UIActivityViewController *activityVC =[[UIActivityViewController alloc]initWithActivityItems:activityItems
                                                                           applicationActivities:nil];
    //不出现在活动项目
    NSMutableArray *excludedArray=[@[UIActivityTypeMessage,
                                     UIActivityTypeMail,
                                     UIActivityTypePostToFacebook,
                                     UIActivityTypePostToTwitter,
                                     UIActivityTypePostToFlickr,
                                     UIActivityTypePostToVimeo,
                                     UIActivityTypePostToTencentWeibo,
                                     UIActivityTypePostToWeibo,
                                     UIActivityTypePrint,
                                     UIActivityTypeCopyToPasteboard,
                                     UIActivityTypeAssignToContact,
                                     UIActivityTypeSaveToCameraRoll,
                                     UIActivityTypeAddToReadingList,
                                     UIActivityTypeAirDrop]mutableCopy];
    if (__iOS__Version>=9.0f) {
        [excludedArray addObject:UIActivityTypeOpenInIBooks];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [activityVC setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [activityVC popoverPresentationController];
        popPresenter.sourceView = self.scanIamgeView;
        popPresenter.sourceRect = self.scanIamgeView.bounds;
    }

//    activityVC.excludedActivityTypes =excludedArray;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

#pragma mark - 二维码生成属性修改
-(void)fan_showSizeWithTitle:(NSString *)title tag:(NSInteger)tag{
    
    UIAlertController *act=[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [act addAction:[UIAlertAction actionWithTitle:[NSBundle fan_localizedStringForKey:@"FanQRCodeCancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    NSArray *titleArray=@[@"64x64",@"128x128",@"256x256",@"512x512",@"1024x1024"];
    for (int i=0; i<titleArray.count; i++) {
        [act addAction:[UIAlertAction actionWithTitle:titleArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            int index=[act.actions indexOfObject:action];
            qrSize=CGSizeMake(64*pow(2, i), 64*pow(2, i));
            self.tipLable.text=[NSString stringWithFormat:@"尺寸:%@  颜色:%@",titleArray[i], colorStr];
//            NSLog(@"=====%f",qrSize.width);
            
        }]];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [act setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [act popoverPresentationController];
        popPresenter.sourceView = self.updateButton;
        popPresenter.sourceRect = self.updateButton.bounds;
    }
    [self presentViewController:act animated:YES completion:^{
        
    }];
    
}
-(void)fan_showBarSizeWithTitle:(NSString *)title tag:(NSInteger)tag{
    
    UIAlertController *act=[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [act addAction:[UIAlertAction actionWithTitle:[NSBundle fan_localizedStringForKey:@"FanQRCodeCancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    NSArray *titleArray=@[@"64x32",@"128x64",@"256x128",@"512x256",@"1024x512"];
    for (int i=0; i<titleArray.count; i++) {
        [act addAction:[UIAlertAction actionWithTitle:titleArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            int index=[act.actions indexOfObject:action];
            qrSize=CGSizeMake(64*pow(2, i), 32*pow(2, i));
            self.tipLable.text=[NSString stringWithFormat:@"尺寸:%@  颜色:%@",titleArray[i], colorStr];
            NSLog(@"=====%f",qrSize.width);
            
        }]];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [act setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [act popoverPresentationController];
        popPresenter.sourceView = self.updateButton;
        popPresenter.sourceRect = self.updateButton.bounds;
    }
    [self presentViewController:act animated:YES completion:^{
        
    }];
    
}

-(void)fan_showColorWithTitle:(NSString *)title tag:(NSInteger)tag{
    
    UIAlertController *act=[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [act addAction:[UIAlertAction actionWithTitle:[NSBundle fan_localizedStringForKey:@"FanQRCodeCancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    NSArray *titleArray=@[@"黑色",@"红色",@"蓝色",@"绿色",@"黄色",@"紫色",@"青色",@"棕黄色"];
    NSArray *colorArray=@[[UIColor blackColor],[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor purpleColor],[UIColor cyanColor],[UIColor orangeColor]];
    for (int i=0; i<titleArray.count; i++) {
        [act addAction:[UIAlertAction actionWithTitle:titleArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            int index=[act.actions indexOfObject:action];
            colorStr=titleArray[i];
            qrColor=colorArray[i];
            self.tipLable.text=[NSString stringWithFormat:@"尺寸:%ldx%ld  颜色:%@",(long)qrSize.width,(long)qrSize.height, colorStr];
            
        }]];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [act setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [act popoverPresentationController];
        popPresenter.sourceView = self.colorButton;
        popPresenter.sourceRect = self.colorButton.bounds;
    }
    [self presentViewController:act animated:YES completion:^{
        
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
#pragma mark - 按钮事件
- (IBAction)updateClick:(id)sender {
    if (self.qrCodeType==FanQRCodeTypeBarCode) {
        [self fan_showBarSizeWithTitle:@"选择适合你的尺寸" tag:2];
    }else{
        [self fan_showSizeWithTitle:@"选择适合你的尺寸" tag:1];
    }
}

- (IBAction)colorClick:(id)sender {
    [self fan_showColorWithTitle:@"选择二维码颜色" tag:3];
}

- (IBAction)createClick:(id)sender {
    [self.view endEditing:YES];
    UIImage *image;
    NSString *text=[self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    qrCodeStr=text;
    if(text.length>0){
        if (self.qrCodeType==FanQRCodeTypeBarCode) {
            image=[FanQRCodeScanViewController fan_generateBarImageWithCode:text size:qrSize ];
        }else{
            if(qrColor==[UIColor yellowColor]){
                image=[FanQRCodeScanViewController fan_qrCodeImageWithText:text size:qrSize color:qrColor bgColor:[UIColor blackColor]];
                
            }else{
                image=[FanQRCodeScanViewController fan_qrCodeImageWithText:text size:qrSize color:qrColor bgColor:[UIColor whiteColor]];
            }
            
        }
        self.scanIamgeView.image=image;

        if (image) {
            [self openQRCode:qrCodeStr];
        }
    }
    
}

-(void)openQRCode:(NSString *)qrCode{
    FanQRCodeType qrType = FanQRCodeTypeWWW;
    NSString *qrStr = @"网址";
    NSString *qrCodeReal=[qrCode copy];
    qrCode=[qrCode lowercaseString];
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
            if (self.qrCodeType==FanQRCodeTypeBarCode) {
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
    
    
    [[FanDBManager shareManager]fan_executeUpdateWithSql:@"insert into FanQRCodeModel(title,qrType,message,uploadTime,insertType) values (:title,:qrType,:message,:uploadTime,:insertType)" valueInDictionary:@{@"title":qrStr,@"qrType":@(qrType),@"message":qrCodeReal,@"uploadTime":[NSDate date],@"insertType":@(1)}];
    
    
}

@end
