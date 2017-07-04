//
//  FanMyViewController.m
//  FanQRCodeScan
//
//  Created by 向阳凡 on 2017/6/30.
//  Copyright © 2017年 凡向阳. All rights reserved.
//

#import "FanMyViewController.h"
#import "FanQRCell.h"
#import "FanDBManager.h"
#import "FanQRCodeModel.h"
#import "FanQRPreePopViewController.h"
#import "FanCommonHead.h"

@interface FanMyViewController ()<UIViewControllerPreviewingDelegate,FanQRPreePopViewControllerDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation FanMyViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[self myQRCodeList]];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray=[@[]mutableCopy];
    
    //注册3D Touch
    if ([self respondsToSelector:@selector(registerForPreviewingWithDelegate:sourceView:)]) {
        [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
    }
    
    UIBarButtonItem *deleteItem=[[UIBarButtonItem alloc]initWithTitle:@"全部删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAll)];
    deleteItem.tintColor=[UIColor redColor];
    self.navigationItem.rightBarButtonItem=deleteItem;
    
}
-(void)deleteAll{
    [[FanDBManager shareManager]fan_executeUpdateWithSql:@"delete from FanQRCodeModel where insertType = 1" valueInArray:nil];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[self myQRCodeList]];
    [self.tableView reloadData];
}
#pragma mark -  数据处理
-(NSArray *)myQRCodeList{
    NSMutableArray *localArray=[[NSMutableArray alloc]init];
    
    FMResultSet *set=[[FanDBManager shareManager]fan_selectAllFromTableWithSql:@"select * from FanQRCodeModel where insertType = 1 order by uploadTime desc;"];
    while ([set next]) {
        FanQRCodeModel *model=[[FanQRCodeModel alloc]init];
        [model configWithSet:set];
        [localArray addObject:model];
    }
    return localArray;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FanQRCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell==nil) {
        NSLog(@"111111");
    }
   
    FanQRCodeModel *model=self.dataArray[indexPath.row];
    [cell configWith:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FanQRPreePopViewController *preeVC=[[FanQRPreePopViewController alloc]init];
    preeVC.hidesBottomBarWhenPushed=YES;
    FanQRCodeModel *model=[self.dataArray objectAtIndex:indexPath.row];
    preeVC.qrCodeModel=model;
    
    [self.navigationController pushViewController:preeVC animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //此种写法，tableView会自动开启多行选择模式
    //return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        FanQRCodeModel *model=self.dataArray[indexPath.row];
        [[FanDBManager shareManager]fan_executeUpdateWithSql:@"delete from FanQRCodeModel where qrId=?" valueInArray:@[@(model.qrId)]];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        //tableView根据indexPath来删除行，并设置动画效果
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark - 3D-Touch  UIViewControllerPreviewingDelegate
-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    FanQRPreePopViewController *childVC = [[FanQRPreePopViewController alloc] init];
    childVC.delegate=self;
    CGFloat minWH=MIN(FanScreenWidth, FanScreenHeight);

    childVC.preferredContentSize = CGSizeMake(minWH,minWH);
    childVC.hidesBottomBarWhenPushed=YES;
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:location];
    CGRect rect1=[self.tableView rectForRowAtIndexPath:path];
    FanQRCodeModel *model=[self.dataArray objectAtIndex:path.row];
    childVC.qrCodeModel=model;
    previewingContext.sourceRect = rect1;
    return childVC;
}
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    [self showViewController:viewControllerToCommit sender:self];
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
