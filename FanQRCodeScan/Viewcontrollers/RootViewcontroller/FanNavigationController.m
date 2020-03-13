//
//  FanNavigationController.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/7.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanNavigationController.h"

@interface FanNavigationController ()

@end

@implementation FanNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationBar.translucent=NO;
//    self.navigationBar.backgroundColor=[UIColor colorNamed:@"color_navbg"];
//    self.navigationBar.backgroundColor=[UIColor redColor];

//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];

    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
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
