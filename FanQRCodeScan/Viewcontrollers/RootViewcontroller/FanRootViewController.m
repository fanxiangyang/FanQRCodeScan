//
//  RootViewController.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/7.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanRootViewController.h"

@interface FanRootViewController ()

@end

@implementation FanRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];

}
-(void)addBackgroundImage:(NSString *)imageName{
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imgView.image=[UIImage imageNamed:imageName];
    [self.view addSubview:imgView];
    [self.view sendSubviewToBack:imgView];
}
-(void)addBackButton{
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(10, 10, 40, 40)];//back_iOS.png
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_iOS.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}
-(void)backButtonClick{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"该界面VC没有导航条");
    }
}
//返回UIBarButtonItem
-(UIBarButtonItem *)creatUIBarButtonItemImageName:(NSString *)imageName selector:(SEL)selector{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btn setTitle:title forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0,0,40,40)];
    if (imageName) {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
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
