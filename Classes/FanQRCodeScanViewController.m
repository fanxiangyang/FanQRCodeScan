//
//  FanQRCodeScanViewController.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/4/17.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanQRCodeScanViewController.h"
#import "NSBundle+FanQRCodeScan.h"

@interface FanQRCodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/**
 *  预览层Layer
 */
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
/**
 *  会话session
 */
@property (nonatomic, strong) AVCaptureSession *captureSession;

//动画线条
@property (nonatomic, strong) UIImageView *lineImageView;

@end

@implementation FanQRCodeScanViewController
#pragma mark - 初始化
-(instancetype)initWithQRBlock:(FanQRCodeScanResultBlock)qrCodeScanResultBlock{
    if (self=[super init]) {
        self.qrCodeScanResultBlock = qrCodeScanResultBlock;
    }
    return self;
}
-(void)dealloc{
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self openCapture];
    
    [self configUI];

}

#pragma mark - 界面UI（兼容带导航的）

//取消了横屏，原本横屏适配了，但是有时又不起作用，故强制不能横屏
//-(BOOL)shouldAutorotate{
//    return NO;
//}
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController.navigationBar performSelector:@selector(setHidden:) withObject:nil]) {
        self.navigationController.navigationBar.hidden=YES;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([self.navigationController.navigationBar performSelector:@selector(setHidden:) withObject:nil]) {
        self.navigationController.navigationBar.hidden=NO;
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.captureVideoPreviewLayer) {
        self.captureVideoPreviewLayer.frame=self.view.bounds;
    }

}
-(void)configUI{
    self.view.backgroundColor=[UIColor whiteColor];
    self.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    //导航条
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth_QR, 64)];
    navView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:navView];
    
    navView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    
    UIButton*backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[NSBundle fan_qrImageWithName:@"fan_qrcode_back@2x"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(10,20, 44, 44)];
    backButton.tintColor=self.themColor;
    [backButton addTarget:self action:@selector(pressCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50,20 , kWidth_QR-100, 44)];
    titleLabel.textColor=self.themColor;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    titleLabel.text=[NSBundle fan_localizedStringForKey:@"FanQRCodeScan"];
    [navView addSubview:titleLabel];
    
    //相册和闪过灯
    UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight_QR-100, kWidth_QR, 100)];
    bottomView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:bottomView];
    bottomView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;

    NSArray*unSelectImageNames=@[@"fan_qrcode_photo@2x",@"fan_qrcode_flash@2x"];
    NSArray *titleArray=@[[NSBundle fan_localizedStringForKey:@"FanQRCodePhotoLibrary"],[NSBundle fan_localizedStringForKey:@"FanQRCodeFlash"]];
    CGFloat btn_width = 57;
    CGFloat btn_heigt = 78;
    CGFloat space_width = (kWidth_QR-2*btn_width)/3;
    for (int i=0; i<unSelectImageNames.count; i++) {
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[NSBundle fan_qrImageWithName:unSelectImageNames[i]] forState:UIControlStateNormal];
        button.frame=CGRectMake(space_width+(btn_width+space_width)*i, 11, btn_width, btn_heigt);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:self.themColor forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 21, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(btn_width, -(btn_width), 0, 0);
        button.tintColor=self.themColor;
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [bottomView addSubview:button];
        if (i==0) {
            [button addTarget:self action:@selector(pressPhotoLibraryButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i==1) {
            [button addTarget:self action:@selector(flashLightClick:) forControlEvents:UIControlEventTouchUpInside];
        }
       
        button.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;

    }
    
    //中间显示部分
    UIImageView*bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kHeight_QRRect, kHeight_QRRect)];
    bgImageView.center=self.view.center;
    bgImageView.contentMode=UIViewContentModeTop;
    bgImageView.clipsToBounds=YES;
    
    bgImageView.image=[NSBundle fan_qrImageWithName:@"fan_qrcode_scan_bg@2x"];
    bgImageView.userInteractionEnabled=YES;
    [self.view addSubview:bgImageView];
    
    bgImageView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    //上下滚动线条
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kHeight_QRRect, 4)];
    _lineImageView.image = [NSBundle fan_qrImageWithName:@"fan_qrcode_scan_line@2x"];
    if (self.scanColor) {
        bgImageView.tintColor=self.scanColor;
        _lineImageView.tintColor=self.scanColor;
    }
    [bgImageView addSubview:_lineImageView];
    
    _lineImageView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    //加动画,别忘记移除
    [_lineImageView.layer addAnimation:[self fan_rockWithTime:2.0 fromY:0 toY:kHeight_QRRect repeatCount:INT_MAX] forKey:@"rock.Y"];
    
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bgImageView.frame.origin.y+kHeight_QRRect, kWidth_QR, 30)];
    tipLabel.text = [NSBundle fan_localizedStringForKey:@"FanQRCodeScanTips"];
    tipLabel.textColor = self.themColor;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 2;
    tipLabel.font=[UIFont systemFontOfSize:12];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
    
    tipLabel.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    
    
}
-(UIColor*)themColor{
    if (_themColor==nil) {
        _themColor=[UIColor whiteColor];
    }
    return _themColor;
}
/// 开始扫描
-(void)fan_startScan{
    [_lineImageView.layer addAnimation:[self fan_rockWithTime:2.0 fromY:0 toY:kHeight_QRRect repeatCount:INT_MAX] forKey:@"rock.Y"];
    [self.captureSession startRunning];
}
///  暂停扫描
-(void)fan_stopScan{
    [_lineImageView.layer removeAnimationForKey:@"rock.Y"];
    _lineImageView.frame=CGRectMake(0, 0, kHeight_QRRect, 4);
    [self.captureSession stopRunning];
}
/// 移除扫描
-(void)fan_removeScan{
    [_lineImageView.layer removeAnimationForKey:@"rock.Y"];
    [self.captureSession stopRunning];
    [self.captureVideoPreviewLayer removeFromSuperlayer];
}
#pragma mark 点击按钮
- (void)pressPhotoLibraryButton:(UIButton *)button{
  
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{
        [self fan_stopScan];
    }];
}

- (void)pressCancelButton
{
    [self fan_removeScan];

    if (self.navigationController.viewControllers.count>0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)flashLightClick:(UIButton *)btn{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(![device isTorchModeSupported:AVCaptureTorchModeOn]){
        [self fan_showAlertWithMessage:[NSBundle fan_localizedStringForKey:@"FanQRCodeOpenFlash"]];
        return;
    }
    if (device.torchMode==AVCaptureTorchModeOff) {
        //闪光灯开启
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
    }else {
        //闪光灯关闭
        [device setTorchMode:AVCaptureTorchModeOff];
    }
    
}

#pragma mark 初始化相机处理
/// 打开相机
-(BOOL)openCapture{
    AVAuthorizationStatus deviceStatus=[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (deviceStatus == AVAuthorizationStatusRestricted||deviceStatus==AVAuthorizationStatusDenied) {
        [self fan_showAlertWithMessage:[NSBundle fan_localizedStringForKey:@"FanQRCodeProhibitCameraPermission"]];
        return NO;
    }
//    [self fan_showAlertWithMessage:@"你机制了相机权限"];
    self.captureSession = [[AVCaptureSession alloc]init];
    //摄像头设备
    AVCaptureDevice *captureDevice=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //设备输入口
    NSError *error = nil;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error || !captureInput) {
        NSLog(@"error:%@",[error description]);
        return NO;
    }
    //  把输入口加入会话session
    if ([self.captureSession canAddInput:captureInput]) {
        [self.captureSession addInput:captureInput];
    }
    
    //设置输出参数
    AVCaptureMetadataOutput * captureOutput = [[AVCaptureMetadataOutput alloc]init];
    // 使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];//AVCaptureSessionPresetPhoto
    if ([self.captureSession canAddOutput:captureOutput]) {
        [self.captureSession addOutput:captureOutput];
    }
    //二维码：AVMetadataObjectTypeQRCode,
    //条形码：AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code
//    captureOutput.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    captureOutput.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code];
    //AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code
    
    
    //设置预览层信息
    if (!self.captureVideoPreviewLayer) {
        self.captureVideoPreviewLayer=[AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    self.captureVideoPreviewLayer.frame=self.view.layer.bounds;
    self.captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.captureVideoPreviewLayer];
    
    //启动扫描
    [self.captureSession startRunning];
    return  YES;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate//iOS7以后下触发
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        if (self.qrCodeScanResultBlock) {
            self.qrCodeScanResultBlock(metadataObject.stringValue,YES);
        }
    }
    
    [self pressCancelButton];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [_line.layer removeAnimationForKey:@"rock.Y"];
//    _line.frame = CGRectMake(0, 0, kHeight_QRRect, 2);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{
        [self fan_decodeImage_8_0:image];
    }];
}
//相册关闭
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self fan_startScan];
    }];
}
#pragma mark 对二维码图像进行解码
- (void)fan_decodeImage_8_0:(UIImage *)image
{
    if ([[[UIDevice currentDevice] systemVersion]floatValue]<8.0f) {
        return;
    }
    CIImage *ciImage=[CIImage imageWithCGImage:image.CGImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector=[CIDetector detectorOfType:CIDetectorTypeText context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *features=[detector featuresInImage:ciImage];
    if (features.count>0) {
        CIFeature *feature = [features firstObject];
        if ([feature isKindOfClass:[CIQRCodeFeature class]]) {
            CIQRCodeFeature *qrf=(CIQRCodeFeature *)feature;
            [self.captureSession stopRunning];
            self.qrCodeScanResultBlock(qrf.messageString,YES);
        }
    }else{
        self.qrCodeScanResultBlock(@"error：Parsing failure ",NO);
    }
    [self pressCancelButton];
}

#pragma mark 其他内部方法

-(void)fan_showAlertWithMessage:(NSString *)message{
    [self fan_showAlertWithTitle:[NSBundle fan_localizedStringForKey:@"FanQRCodeWarmTips"] message:message];
}
//根据不同的提示信息，创建警告框
-(void)fan_showAlertWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertController *act=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [act addAction:[UIAlertAction actionWithTitle:[NSBundle fan_localizedStringForKey:@"FanQRCodeConfirm"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//        [act setModalPresentationStyle:UIModalPresentationPopover];
//        UIPopoverPresentationController *popPresenter = [act popoverPresentationController];
//        popPresenter.sourceView = self.lineImageView;
//        popPresenter.sourceRect = self.lineImageView.bounds;
//    }
//    UIViewController *rootVC=(UIViewController*)[UIApplication sharedApplication].windows[0].rootViewController;
    [self presentViewController:act animated:YES completion:^{
        
    }];

}
#pragma mark - 上下晃动的动画
-(CABasicAnimation *)fan_rockWithTime:(float)time fromY:(float)fromY toY:(float)toY repeatCount:(int)repeatCount
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animation setFromValue:[NSNumber numberWithFloat:fromY]];
    animation.toValue=[NSNumber numberWithFloat:toY];
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    
    animation.repeatCount=repeatCount;//动画重复次数
    animation.autoreverses=YES;//是否自动重复
    
    return animation;
}
#pragma mark - 二维码生成和条形码
+(UIImage *)fan_qrCodeImageWithText:(NSString *)text size:(CGSize)size{
    return [[self class] fan_qrCodeImageWithText:text size:size color:[UIColor blackColor] bgColor:[UIColor whiteColor]];
}
+(UIImage *)fan_qrCodeImageWithText:(NSString *)text size:(CGSize)size color:(UIColor *)color bgColor:(UIColor *)bgColor{
    NSData *stringData = [text dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = color;
    UIColor *offColor = bgColor;
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;
}
+ (UIImage *)fan_generateBarImageWithCode:(NSString *)code size:(CGSize)size{
    //生成条形码
    CIImage *barcodeImage;
    //NSISOLatin1StringEncoding
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    barcodeImage = [filter outputImage];
    
    //消除模糊(此种方法，得到的图片不能保存到相册)
//    CGFloat scaleX = size.width / barcodeImage.extent.size.width;// extent 返回图片的frame
//    CGFloat scaleY = size.height / barcodeImage.extent.size.height;
//    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
//    return [UIImage imageWithCIImage:transformedImage];
    
    //用绘制方法（可以保存到相册）不知道什么原因
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:barcodeImage fromRect:barcodeImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;

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
