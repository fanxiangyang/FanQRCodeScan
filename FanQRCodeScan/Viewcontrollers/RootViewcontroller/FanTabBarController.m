//
//  FanTabBarController.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/7.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanTabBarController.h"

@interface FanTabBarController ()

@end

@implementation FanTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *itmes=self.tabBar.items;
    for (UITabBarItem *item in itmes) {
        UIImage *image1=[item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage=image1;
//        item.image=image1;
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
