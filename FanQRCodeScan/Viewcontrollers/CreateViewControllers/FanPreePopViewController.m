//
//  FanPreePopViewController.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/30.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanPreePopViewController.h"
#import <Photos/Photos.h>
#import "FanCommonHead.h"

@interface FanPreePopViewController ()<UIPreviewActionItem>
@property(nonatomic,strong)UIImageView *touchImageView;

@end

@implementation FanPreePopViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
}
-(void)backClick{
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=[self fan_creatUIBarButtonItemImageName:@"back_iOS.png" frame:CGRectMake(0, 0, 30, 30) selector:@selector(backClick)];

    
    // Do any additional setup after loading the view.
    CGFloat navHeight=self.navigationController.navigationBar.frame.size.height+20;

    self.touchImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, self.view.frame.size.height-navHeight)];
    self.touchImageView.userInteractionEnabled=YES;
    self.touchImageView.contentMode=UIViewContentModeScaleAspectFit;
//    self.touchImageView.clipsToBounds=YES;
    self.touchImageView.image=self.image;
    [self.view addSubview:self.touchImageView];
    self.touchImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;//UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
   
}
-(NSArray<id<UIPreviewActionItem>>*)previewActionItems{
    __weak typeof(self)weakSelf=self;
    UIPreviewAction *shareAction=[UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if (weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(preePopView:)]) {
            [weakSelf.delegate preePopView:0];
        }
    }];
    UIPreviewAction *shareAction1=[UIPreviewAction actionWithTitle:@"分享图片" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if (weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(preePopView:)]) {
            [weakSelf.delegate preePopView:1];
        }
    }];

    UIPreviewAction *shareAction2=[UIPreviewAction actionWithTitle:@"保存到相册" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self savePhotoToLibrary];
    }];
    UIPreviewAction *shareAction3=[UIPreviewAction actionWithTitle:@"复制文本" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.qrCode;
    }];
    return @[shareAction,shareAction1,shareAction2,shareAction3];
}
#pragma mark - 按钮操作
-(void)savePhotoToLibrary{
    if (self.image) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:self.image];
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
