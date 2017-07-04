//
//  AppDelegate.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/4/17.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "AppDelegate.h"
#import "FanCommonHead.h"

#import "FanTabBarController.h"
#import "FanNavigationController.h"
#import "FanCreateViewController.h"
#import "FanCreateQRViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (__iOS__Version>=9.0f) {
        
        UITraitCollection *traitCollection = [[UITraitCollection alloc]init];
        
        if (traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            
            NSLog(@"已经打开了3D Touch功能");
            //[self registerForPreviewingWithDelegate:self sourceView:self.window];
        }else if(traitCollection.forceTouchCapability == UIForceTouchCapabilityUnavailable){
            
            NSLog(@"并没有打开3D Touch功能");
        }else{
            NSLog(@"不知道有没有打开3D Touch功能");
        }
        if([application respondsToSelector:@selector(setShortcutItems:)]){
            //设置3D-Touch
            UIApplicationShortcutItem *item1=[[UIApplicationShortcutItem alloc]initWithType:@"1" localizedTitle:@"二维码" localizedSubtitle:@"Create" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd] userInfo:nil];
            UIApplicationShortcutItem *item2=[[UIApplicationShortcutItem alloc]initWithType:@"2" localizedTitle:@"扫一扫" localizedSubtitle:@"scan" icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"scan_scan"] userInfo:nil];
            
            [application setShortcutItems:@[item1,item2]];
        }
    }
    return YES;
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    NSLog(@"3D_Item:%@",shortcutItem);
    if ([shortcutItem.type isEqualToString:@"1"]) {
        NSLog(@"新建二维码");
        [self jumpCreateQRVC];
    }else if([shortcutItem.type isEqualToString:@"2"]){
        NSLog(@"扫一扫");
        [self jumpScanQRVC];
    }
}
-(void)jumpCreateQRVC{
    FanTabBarController *tabBarVC=(FanTabBarController *)self.window.rootViewController;
    NSInteger i=tabBarVC.selectedIndex;
    FanNavigationController *nav=tabBarVC.viewControllers[i];
    
    FanCreateQRViewController *homePage=[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"FanCreateQRViewController"];
    homePage.hidesBottomBarWhenPushed=YES;
    
    homePage.qrCodeType=FanQRCodeTypeWWW;
    
    [nav pushViewController:homePage animated:YES];
}
-(void)jumpScanQRVC{
    FanTabBarController *tabBarVC=(FanTabBarController *)self.window.rootViewController;
    tabBarVC.selectedIndex=0;
    FanNavigationController *nav=tabBarVC.viewControllers[0];
    [nav popToRootViewControllerAnimated:NO];
    FanCreateViewController *vc=(FanCreateViewController*)nav.topViewController;
    [vc jumpScanVC];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
