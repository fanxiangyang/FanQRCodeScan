//
//  ViewController.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/4/17.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "ViewController.h"
#import "FanQRCodeScan.h"
#import <Photos/Photos.h>
#import "FanWebViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIImageView *qrcodeImageView;


@property (nonatomic, strong) NSString *qrcode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configUI];
    
}

-(void)configUI{
    
    self.dataArray=[[NSMutableArray alloc]initWithCapacity:3];
    [self.dataArray addObjectsFromArray:@[@"扫描二维码和条形码",@"生成二维码",@"生成条形码"]];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
    _qrcodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth_QR, kHeight_QR-44*3-80)];
    _qrcodeImageView.backgroundColor=[UIColor lightGrayColor];
    _qrcodeImageView.contentMode=UIViewContentModeCenter;
    _qrcodeImageView.userInteractionEnabled=YES;
    _tableView.tableFooterView=_qrcodeImageView;
    
    UIGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressgesture:)];
    [_qrcodeImageView addGestureRecognizer:longPressGesture];
    
}
-(void)longPressgesture:(UILongPressGestureRecognizer *)longGesture{
    if (longGesture.state==UIGestureRecognizerStateBegan) {
        [self fan_showActionSheetWithTitle:@"保存图片" message:nil];
    }
}
-(void)savePhotoToLibrary{
    UIImage *image=_qrcodeImageView.image;
    NSLog(@"image:%@",image);
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
#pragma mark - TableView delegate dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text=self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self jumpScanVC];
        }
            break;
        case 1:
        {
            [self fan_showAlertTextWithTitle:@"生成二维码" tag:0];
        }
            break;
        case 2:
        {
            [self fan_showAlertTextWithTitle:@"生成条形码" tag:1];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -  界面跳转

-(void)jumpScanVC{
    FanQRCodeScanViewController *qrCoreVC=[[FanQRCodeScanViewController alloc]initWithQRBlock:^(NSString *resultSrt, BOOL isSuccess) {
        if (isSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fan_showAlertWithTitle:@"扫描结果" message:resultSrt];
            });
            NSLog(@"%@",resultSrt);
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fan_showAlertWithTitle:@"扫描失败" message:resultSrt];
            });
            NSLog(@"关闭或失败:%@",resultSrt);
        }
        
    }];
    qrCoreVC.themColor=[UIColor yellowColor];
    qrCoreVC.scanColor=[UIColor greenColor];
    [self presentViewController:qrCoreVC animated:YES completion:nil];
    
}
//根据不同的提示信息，创建警告框
-(void)fan_showAlertWithTitle:(NSString *)title message:(NSString *)message{
    NSString *confirm=[NSBundle fan_localizedStringForKey:@"FanQRCodeConfirm"];
    if ([message hasPrefix:@"http"]) {
        confirm =@"打开链接";
    }
    UIAlertController *act=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [act addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([message hasPrefix:@"http"]) {
            FanWebViewController *web=[[FanWebViewController alloc]init];
            web.fanQRURL=message;
            web.hidesBottomBarWhenPushed=YES;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:web];
            
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }
        
    }]];
    [act addAction:[UIAlertAction actionWithTitle:[NSBundle fan_localizedStringForKey:@"FanQRCodeCancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    //UIAlertControllerStyleActionSheet状态需要用
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//        [act setModalPresentationStyle:UIModalPresentationPopover];
//        UIPopoverPresentationController *popPresenter = [act popoverPresentationController];
//        popPresenter.sourceView = self.tableView;
//        popPresenter.sourceRect = self.tableView.bounds;
//    }
    UIViewController *rootVC=(UIViewController*)[UIApplication sharedApplication].windows[0].rootViewController;
    [rootVC presentViewController:act animated:YES completion:^{
        
    }];
    
}
-(void)fan_showAlertTextWithTitle:(NSString *)title tag:(NSInteger)tag{
    
    UIAlertController *act=[UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [act addAction:[UIAlertAction actionWithTitle:[NSBundle fan_localizedStringForKey:@"FanQRCodeConfirm"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField=act.textFields.firstObject;
        if (textField.text.length>0) {
            UIImage *image;
            if (tag==0) {
                //二维码
                image=[FanQRCodeScanViewController fan_qrCodeImageWithText:textField.text size:CGSizeMake(300, 300)];
                //https://github.com/fanxiangyang/FanQRCodeScan
            }else if(tag==1){
                //条形码
                image=[FanQRCodeScanViewController fan_generateBarImageWithCode:textField.text size:CGSizeMake(300, 160)];
            }
            self.qrcodeImageView.image=image;
        }
    }]];
    [act addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//        [act setModalPresentationStyle:UIModalPresentationPopover];
//        UIPopoverPresentationController *popPresenter = [act popoverPresentationController];
//        popPresenter.sourceView = self.tableView;
//        popPresenter.sourceRect = self.tableView.bounds;
//    }
    UIViewController *rootVC=(UIViewController*)[UIApplication sharedApplication].windows[0].rootViewController;
    [rootVC presentViewController:act animated:YES completion:^{
        
    }];
    
}

-(void)fan_showActionSheetWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertController *act=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [act addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self savePhotoToLibrary];
    }]];
    [act addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [act setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [act popoverPresentationController];
        popPresenter.sourceView = self.qrcodeImageView;
        popPresenter.sourceRect = self.qrcodeImageView.bounds;
    }
    
    [self presentViewController:act animated:YES completion:^{
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
