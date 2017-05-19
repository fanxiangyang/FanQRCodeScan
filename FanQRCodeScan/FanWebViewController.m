//
//  FanWebViewController.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/5/18.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanWebViewController.h"

#define FanScreenWidthRotion [UIScreen mainScreen].bounds.size.width
#define FanScreenHeightRotion [UIScreen mainScreen].bounds.size.height

#define FanScreenWidth  (FanScreenWidthRotion>FanScreenHeightRotion?FanScreenWidthRotion:FanScreenHeightRotion)
#define FanScreenHeight (FanScreenWidthRotion>FanScreenHeightRotion?FanScreenHeightRotion:FanScreenWidthRotion)


@interface FanWebViewController ()<UIWebViewDelegate>

@end

@implementation FanWebViewController
{
    UIWebView *_webView;
}
-(void)backBarClick{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //刷新按钮
    
    UIBarButtonItem *rightItem1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backBarClick)];
    self.navigationItem.leftBarButtonItem=rightItem1;
    
    
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWebView)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    self.navigationController.navigationBar.translucent=NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;//对webView有影响
    
    NSURL *url=[NSURL URLWithString:_fanQRURL];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, FanScreenWidthRotion, FanScreenHeightRotion)];
    //_webView.backgroundColor=[UIColor redColor];
    _webView.delegate=self;
    //_webView.opaque=NO;
    _webView.scalesPageToFit=YES;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    _webView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    _webView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;


}
//刷新
-(void)refreshWebView{
    [_webView reload];
}
#pragma mark - uiwebview delegate
//开始加载
-(void)webViewDidStartLoad:(UIWebView *)webView{
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}
-(void)dealloc{
    _webView.delegate=nil;
    [_webView stopLoading];
    [_webView removeFromSuperview];
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
