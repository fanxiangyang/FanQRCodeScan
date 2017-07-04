# FanQRCodeScan（iOS8+）

### App store 上线地址:[韩QRCode](https://itunes.apple.com/cn/app/id1255037808?mt=8)   上线预览图如下：
<img src="https://github.com/fanxiangyang/FanQRCodeScan/blob/master/Document/appstore3.PNG?raw=true" width="250">       <img src="https://github.com/fanxiangyang/FanQRCodeScan/blob/master/Document/appstore2.PNG?raw=true" width="250">   <img src="https://github.com/fanxiangyang/FanQRCodeScan/blob/master/Document/appstore1.PNG?raw=true" width="250">


##### 系统自带二维码条形码的扫描和生成 （旧版UI图）

<img src="https://github.com/fanxiangyang/FanQRCodeScan/blob/master/Document/qrcode.png?raw=true" width="250">       <img src="https://github.com/fanxiangyang/FanQRCodeScan/blob/master/Document/scan.png?raw=true" width="250">


###  功能介绍

##### 1.二维码条形码扫描 
```
FanQRCodeScanViewController *qrCoreVC=[[FanQRCodeScanViewController alloc]initWithQRBlock:^(NSString *resultSrt,NSString *type, BOOL isSuccess) {
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
    qrCoreVC.themColor=[UIColor redColor];
    qrCoreVC.scanColor=[UIColor yellowColor];
    [self presentViewController:qrCoreVC animated:YES completion:nil];
```
##### 2.二维码生成
```
//二维码调用
UIImage *image=[FanQRCodeScanViewController fan_qrCodeImageWithText:textField.text size:CGSizeMake(300, 300)];

#pragma mark - 二维码生成
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
    if (cgImage==nil) {
        return nil;
    }
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;
}


``` 
##### 3.条形码生成
```
//条形码调用
UIImage *image=[FanQRCodeScanViewController fan_generateBarImageWithCode:textField.text size:CGSizeMake(300, 160)];

//条形码生成
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
    if (cgImage==nil) {
        return nil;
    }
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;

}

```

Like(喜欢)
==============
#### 有问题请直接在文章下面留言,喜欢就给个Star(小星星)吧！ 
#### 简书博客:[FanQRCodeScan(二维码条形码扫描生成解析)](http://www.jianshu.com/p/760e4654394f)说明更详细
#### Email:<fqsyfan@gmail.com>
