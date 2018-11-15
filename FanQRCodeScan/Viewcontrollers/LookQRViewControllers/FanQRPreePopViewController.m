//
//  FanQRPreePopViewController.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/30.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanQRPreePopViewController.h"
#import <Photos/Photos.h>
#import "FanCommonHead.h"
#import "FanQRCodeScanViewController.h"



@interface FanQRPreePopViewController ()
@property(nonatomic,strong)UIImageView *touchImageView;
@property(nonatomic,strong)UIView *ipadView;

@end

@implementation FanQRPreePopViewController

-(void)backClick{
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=[self fan_creatUIBarButtonItemImageName:@"back_iOS.png" frame:CGRectMake(0, 0, 30, 30) selector:@selector(backClick)];
    
    
    // Do any additional setup after loading the view.
    self.touchImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.touchImageView.userInteractionEnabled=YES;
    self.touchImageView.contentMode=UIViewContentModeScaleAspectFit;
    //    self.touchImageView.clipsToBounds=YES;
    [self.view addSubview:self.touchImageView];
    self.touchImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;//UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    UIImage *image;
    
    if (self.qrCodeModel.qrType==FanQRCodeTypeBarCode) {
        image=[FanQRCodeScanViewController fan_generateBarImageWithCode:self.qrCodeModel.message size:CGSizeMake(512, 256) ];
    }else{
        image=[FanQRCodeScanViewController fan_qrCodeImageWithText:self.qrCodeModel.message size:CGSizeMake(512, 512) color:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    }

    self.touchImageView.image=image;

    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moreClick)];
    
    
    self.ipadView=[[UIView alloc]initWithFrame:CGRectMake(FanScreenWidth-50, -44, 44, 44)];
//    self.ipadView.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.ipadView];
    
    self.ipadView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;

}
-(void)moreClick{
    [self tapImageView];
}
#pragma mark - 保存和分享
-(void)tapImageView{
    
    if(self.touchImageView.image==nil){
        return;
    }
    
    UIAlertController *act=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [act addAction:[UIAlertAction actionWithTitle:[NSBundle fan_qrLocalizedStringForKey:@"FanQRCodeCancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [act addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareQRCodeIsExitUrl:YES];
    }]];
    NSString *t1=@"分享二维码";
    if (self.qrCodeModel.qrType==FanQRCodeTypeBarCode) {
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
        pasteboard.string = self.qrCodeModel.message;
    }]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [act setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [act popoverPresentationController];
        popPresenter.sourceView = self.ipadView;
        popPresenter.sourceRect = self.ipadView.bounds;
    }
    [self presentViewController:act animated:YES completion:^{
        
    }];
    
}

- (void)shareQRCodeIsExitUrl:(BOOL)isExit {
    
    UIImage *imageToShare=self.touchImageView.image;
    if (!imageToShare) {
        return;
    }
    NSString *textToShare =[NSString stringWithFormat:@"小韩二维码:%@",self.qrCodeModel.message];
    
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
    
    //    activityVC.excludedActivityTypes =excludedArray;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [activityVC setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [activityVC popoverPresentationController];
        popPresenter.sourceView = self.ipadView;
        popPresenter.sourceRect = self.ipadView.bounds;
    }
   
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

-(NSArray<id<UIPreviewActionItem>>*)previewActionItems{
    UIPreviewAction *shareAction=[UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if (_delegate&&[_delegate respondsToSelector:@selector(qrPreePopView:)]) {
            [_delegate qrPreePopView:0];
        }
    }];
    UIPreviewAction *shareAction1=[UIPreviewAction actionWithTitle:@"分享图片" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if (_delegate&&[_delegate respondsToSelector:@selector(preePopView:)]) {
            [_delegate qrPreePopView:1];
        }
    }];
    
    UIPreviewAction *shareAction2=[UIPreviewAction actionWithTitle:@"保存到相册" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self savePhotoToLibrary];
    }];
    UIPreviewAction *shareAction3=[UIPreviewAction actionWithTitle:@"复制文本" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.qrCodeModel.message;
    }];
    return @[shareAction,shareAction1,shareAction2,shareAction3];
}
#pragma mark - 按钮操作
-(void)savePhotoToLibrary{
    if (self.touchImageView.image) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:self.touchImageView.image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
        }];
    }
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
