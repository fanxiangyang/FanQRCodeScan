//
//  NSObject+Dictionary.h
//  FanTextViewRich
//
//  Created by 向阳凡 on 15/7/14.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import <Foundation/Foundation.h>

/** SQLite五种数据类型 */
#define SQL_TEXT     @"TEXT"
#define SQL_INTEGER  @"INTEGER"
#define SQL_REAL     @"REAL"
#define SQL_BLOB     @"BLOB"
#define SQL_NULL     @"NULL"
#define SQL_PrimaryKey  @"primary key"

//自增的ID
#define SQL_primaryId   @"pk"


@interface NSObject (FMDB)

#pragma mark- FMDB数据库使用
/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写*/
+ (NSArray *)fmdb_transients;
/**获取该类的所有属性及类型*/
+ (NSDictionary *)fmdb_getPropertys;
/** 获取所有属性，包含主键pk */
+ (NSDictionary *)fmdb_getAllProperties;
/**得到拼接的fmdb创建表的字符串*/
+ (NSString *)fmdb_getColumeAndTypeString:(BOOL)autoIncrement;


@end
