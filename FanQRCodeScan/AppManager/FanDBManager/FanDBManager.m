//
//  FanDBManager.m
//  FanFMDBManager
//
//  Created by qianfeng on 15-7-23.
//  Copyright (c) 2015年 凡向阳. All rights reserved.
//

#import "FanDBManager.h"

#define Table_RobotInfo @"create table if not exists FanQRCodeModel(qrId integer primary key autoincrement,title varchar(50) default '',qrType int default 0,insertType int default 0,message varchar(255) default '',uploadTime datetime)"

@implementation FanDBManager
{
//    FMDatabase *_dataBase;
}

#pragma mark - FMDB初始化
static FanDBManager *manager=nil;
/**
 *  数据库单例类
 *
 *  @return
 */
+(FanDBManager *)shareManager{
    //防止多个线程同时调用shareManager方法
    //@synchronized 一次只能允许一个线程访问关键字中的代码
    @synchronized(self){
        if (manager==nil) {
            manager=[[FanDBManager alloc]init];
        }
    }
    return manager;
}
//重写init 进行一些必要的初始化操作
-(id)init{
    self=[super init];
    if (self) {
        //创建fmdb对象，并将路径传递过去
        _dataBase=[[FMDatabase alloc]initWithPath:[self dbPath]];
        //open dbPath中没有数据库文件，会创建并打开数据库；有文件，则直接打开
        if([_dataBase open]){
            //executeUpdate 增，删 ，改，创建表 的SQL全用此方法
           [self fan_createTableSql:Table_RobotInfo];
        }
        //[_dataBase close];
    }
    return self;
}
/**数据库路径*/
-(NSString *)dbPath
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    docsdir = [docsdir stringByAppendingPathComponent:@"FMDB"];
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbpath = [docsdir stringByAppendingPathComponent:@"FanQRCodeScan.sqlite"];
    NSLog(@"dbPath:%@",dbpath);
//    return @"~/Desktop/kydb.sqlite";
    return dbpath;
}
-(FMDatabaseQueue *)dbQueue{
    if (!_dbQueue) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self  dbPath]];
    }
    return _dbQueue;
}
-(void)addd{
  
}
#pragma mark - FMDB基本功能
/**
 *  创建数据表
 *
 *  @param createSql 创建数据表的sql
 *
 *  @return 是否创建成功
 */
-(BOOL)fan_createTableSql:(NSString *)createSql{
    if([_dataBase open]){
        //创建表
        //NSString *createSql=@"create table if not exists userInfo(id integer primary key autoincrement,name varchar(256),age integer,image blob)";
        //executeUpdate 增，删 ，改，创建表 的SQL全用此方法
        //返回值为执行的结果 yes no
        BOOL isSuccessed=[_dataBase executeUpdate:createSql];
        if (!isSuccessed) {
            //打印失败信息
            NSLog(@"create error:%@",_dataBase.lastErrorMessage);
        }
        return isSuccessed;
    }else{
        return NO;
    }
}
/**
 *数据库的增加，删除，更新 通过字典
 *INSERT INTO myTable VALUES (:id, :name, :value)
 */
-(BOOL)fan_executeUpdateWithSql:(NSString *)sql valueInDictionary:(NSDictionary *)dict{
    //executeUpdate 要求后面跟的参数必须是NSObject类型，否则会抛出EXC_BAD_ACCESS错误，fmdb会在将数据写入之前对数据进行自动转化
    BOOL isSuccessed=[_dataBase executeUpdate:sql withParameterDictionary:dict];
    if (!isSuccessed) {
        NSLog(@"execute error:%@",_dataBase.lastErrorMessage);
    }
    return isSuccessed;
}

/**数据库的增加，删除，更新 通过字典*/
-(BOOL)fan_executeUpdateWithSql:(NSString *)sql valueInArray:(NSArray *)array{
    //executeUpdate 要求后面跟的参数必须是NSObject类型，否则会抛出EXC_BAD_ACCESS错误，fmdb会在将数据写入之前对数据进行自动转化
    BOOL isSuccessed=[_dataBase executeUpdate:sql withArgumentsInArray:array];
    if (!isSuccessed) {
        NSLog(@"execute error:%@",_dataBase.lastErrorMessage);
    }
    return  isSuccessed;
}

/**获取全部数据*/
-(FMResultSet *)fan_selectAllFromTableWithSql:(NSString *)sql
{
    //查询的SQL语句用executeQuery
    //FMResultSet 查询结果的集合类
    FMResultSet *set=[_dataBase executeQuery:sql];
    return set;
}

#pragma mark - FMDB高级智能
/**自动创建表（含默认递增的主键）*/
- (BOOL)fan_createTableWithClass:(Class)AnyClasss  primaryKey:(BOOL)primaryKey
{
    if([_dataBase open]){
        NSString *tableName = NSStringFromClass(AnyClasss);
        NSString *columeAndType = [AnyClasss fmdb_getColumeAndTypeString:primaryKey];
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName,columeAndType];
        BOOL isSuccessed=[_dataBase executeUpdate:sql];
        if (!isSuccessed) {
            //打印失败信息
            NSLog(@"create error:%@",_dataBase.lastErrorMessage);
        }
//        不知道有什么卵用，估计是存在时重新命名列表名称
        
//        NSMutableArray *columns = [NSMutableArray array];
//        FMResultSet *resultSet = [_dataBase getTableSchema:tableName];
//        while ([resultSet next]) {
//            NSString *column = [resultSet stringForColumn:@"name"];
//            [columns addObject:column];
//        }
//        NSDictionary *dict = [AnyClasss fmdb_getAllProperties];
//        NSArray *properties = [dict objectForKey:@"name"];
//        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",columns];
//        //过滤数组
//        NSArray *resultArray = [properties filteredArrayUsingPredicate:filterPredicate];
//        
//        for (NSString *column in resultArray) {
//            NSUInteger index = [properties indexOfObject:column];
//            NSString *proType = [[dict objectForKey:@"type"] objectAtIndex:index];
//            NSString *fieldSql = [NSString stringWithFormat:@"%@ %@",column,proType];
//            NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ ",NSStringFromClass(AnyClasss),fieldSql];
//            if (![_dataBase executeUpdate:sql]) {
//                return NO;
//            }
//        }
        return isSuccessed;
    }else{
        return NO;
    }
}

/**查询所有字段数组*/
-(NSArray *)fan_selectTableDataWithSql:(NSString *)sql saveModel:(Class)AnyClass primaryKey:(BOOL)primaryKey{
    //查询的SQL语句用executeQuery
    //FMResultSet 查询结果的集合类
    FMResultSet *set=[_dataBase executeQuery:sql];
    NSMutableArray *columnNames = [NSMutableArray array];
    NSMutableArray *columnTypes = [NSMutableArray array];
    
    NSMutableArray *array=[NSMutableArray array];
    //next 从第一条数据开始，一直能取到最后一条，能取到返回YES
    while ([set next]) {
        //根据字段名称，获取字段的值
        id anyModel=[[AnyClass alloc]init];
     
        NSDictionary *dicPro=primaryKey?[AnyClass fmdb_getAllProperties]:[AnyClass fmdb_getPropertys];
        [columnNames addObjectsFromArray:[dicPro objectForKey:@"name"]];
        [columnTypes addObjectsFromArray:[dicPro objectForKey:@"type"]];
        for (int i=0; i<columnNames.count; i++) {
            NSString *columeName = [columnNames objectAtIndex:i];
            NSString *columeType = [columnTypes objectAtIndex:i];
            if ([columeType isEqualToString:SQL_TEXT]) {
                [anyModel setValue:[set stringForColumn:columeName] forKey:columeName];
            }else if([columeType isEqualToString:SQL_BLOB]) {
                [anyModel setValue:[set dataForColumn:columeName] forKey:columeName];
            }
            else {
                [anyModel setValue:[NSNumber numberWithLongLong:[set longLongIntForColumn:columeName]] forKey:columeName];
            }

        }
        [array addObject:anyModel];
    }
    return array;
}
/**查询所有字段数组*/
-(NSArray *)fan_selectAllTableDataWithModel:(Class)AnyClass primaryKey:(BOOL)primaryKey{
    NSString *sql=[NSString stringWithFormat:@"select * from %@;",NSStringFromClass(AnyClass)];
    return [self fan_selectTableDataWithSql:sql saveModel:AnyClass primaryKey:primaryKey];
}

#pragma mark - get set 方法

@end
