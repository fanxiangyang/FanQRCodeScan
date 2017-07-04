//
//  FanDBManager.m
//  FanFMDBManager
//
//  Created by Fan on 15-7-23.
//  Copyright (c) 2015年 凡向阳. All rights reserved.
//

/**
 *  FMDB_Fan 版本1.0
 *  注意:1.版本依赖（FMDB,NSObject+FMDB.h)
 *      2.创建model时，不要加主键的属性，不然会重复，SQL不通过
 
 
使用方法：
    1.model 
     #import <Foundation/Foundation.h>
     
     @interface UserModel : NSObject
     //此处不能创建这个属性（想修改请修改NSObject+Dictionary.h里面的宏）
     //@property(nonatomic,copy)NSString *pk;
     
     @property(nonatomic,copy)NSString *uid;
     @property(nonatomic,copy)NSString *username;
     @property(nonatomic,copy)NSString *headimage;
     @property(nonatomic,copy)NSString *lastactivity;
     
     @end
    2.调用
     //数据库初始化
     [FanDBManager shareManager];
     
     [[FanDBManager shareManager]fan_createTableWithModel:[UserModel new]];
     
     //创建表
     NSString *tableSql=@"create table if not exists stu(serial integer primary key autoincrement,uid varchar(20),username varchar(50),headimage varchar(256),lastactivity text)";
     [[FanDBManager shareManager]fan_createTableSql:tableSql];
     
     
     
     //数据库插入数据（通过数组）
     NSString *insertSql=@"insert into UserModel(uid,username,headimage,lastactivity)values(?,?,?,?)";
     [[FanDBManager shareManager]fan_executeUpdateWithSql:insertSql valueInArray:@[@"2",@"fan",@"jpg",@"xiangyang"]];
     
     NSString *insertDicSql=@"insert into userInfo(uid,username,headimage,lastactivity)values(:uid,:username,:headimage,:lastactivity)";
     [[FanDBManager shareManager]fan_executeUpdateWithSql:insertDicSql valueInArray:@[@"2",@"fan",@"jpg",@"xiangyang"]];
     
     
     //插入数据（通过字典）
     [[FanDBManager shareManager]fan_executeUpdateWithSql:insertDicSql valueInDictionary:@{@"uid":@"2",@"username":@"fanDic",@"headimage":@"gif",@"lastactivity":@"wangtao"}];
     
     NSString *updateSql=@"update userInfo set username=:username where uid=:uid";//参数可以为 ( ？ or  :uid )
     [[FanDBManager shareManager]fan_executeUpdateWithSql:updateSql valueInArray:@[@"ddd",@"1"]];
     [[FanDBManager shareManager]fan_executeUpdateWithSql:updateSql valueInDictionary:@{@"username":@"dic",@"uid":@"1"}];
     
     
     //删除数据
     NSString *deleteSql=@"delete from userInfo where uid=:uid";
     [[FanDBManager shareManager]fan_executeUpdateWithSql:deleteSql valueInArray:@[@"1"]];
     [[FanDBManager shareManager]fan_executeUpdateWithSql:deleteSql valueInDictionary:@{@"uid":@"1"}];
     
     
     //通过model创建对应表
     [[FanDBManager shareManager]fan_createTableWithModel:[UserModel new]];
     
     
     NSArray *arr=[[FanDBManager shareManager]fan_selectAllTableDataWithModel:[UserModel class]];
     if (arr) {
     UserModel *model=(UserModel *)arr[0];
     NSLog(@"%@",model.username);
     }
     
     
     FMResultSet *set=[[FanDBManager shareManager]fan_selectAllFromTableWithSql:@"select * from UserModel;"];
     while ([set next]) {
     NSLog(@"ddddd");
     }
 *
 *
 *
 */


#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "NSObject+FMDB.h"

@interface FanDBManager : NSObject

/**
*  创建默认数据库表，调入项目时需要修改get 方法
*/
@property(nonatomic,copy)NSString *dbPath;
@property(nonatomic, strong)FMDatabaseQueue *dbQueue;
@property(nonatomic,strong)FMDatabase *dataBase;

#pragma mark - FMDB的初始化
/**数据库单例类*/
+(FanDBManager *)shareManager;
/**数据库存放路径*/
//-(NSString *)dbPath;

#pragma mark - FMDB基本功能
/**创建数据表*/
-(BOOL)fan_createTableSql:(NSString *)createSql;
/**
 *数据库的增加，删除，更新 通过数组(按照数组顺序）
 *INSERT INTO myTable VALUES (:id, :name, :value)  【Update/Delete同理】
 *INSERT INTO myTable VALUES (?, ?, ?)
 */
-(BOOL)fan_executeUpdateWithSql:(NSString *)sql valueInArray:(NSArray *)array;
/**
 *数据库的增加，删除，更新 通过字典(通过key value)
 *字典配合[model fan_propertyList:YES]使用，可以快速获取
 *INSERT INTO myTable VALUES (:id, :name, :value)  【Update/Delete同理】
 */
-(BOOL)fan_executeUpdateWithSql:(NSString *)sql valueInDictionary:(NSDictionary *)dict;

/**查询结果集*/
-(FMResultSet *)fan_selectAllFromTableWithSql:(NSString *)sql;


#pragma mark - FMDB高级智能
/**自动创建表（含默认递增的主键）*/
- (BOOL)fan_createTableWithClass:(Class)AnyClasss  primaryKey:(BOOL)primaryKey;

/**查询表所有列字段数组*/
-(NSArray *)fan_selectAllTableDataWithModel:(Class)AnyClass primaryKey:(BOOL)primaryKey;
/**有条件的查询列字段数组*/
-(NSArray *)fan_selectTableDataWithSql:(NSString *)sql saveModel:(Class)AnyClass primaryKey:(BOOL)primaryKey;

@end
