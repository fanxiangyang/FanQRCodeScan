//
//  NSObject+Dictionary.m
//  FanTextViewRich
//
//  Created by 向阳凡 on 15/7/14.
//  Copyright © 2015年 向阳凡. All rights reserved.
//

#import "NSObject+FMDB.h"
#import <objc/runtime.h>

@implementation NSObject (FMDB)

//-(id)valueForKey:(NSString *)key
//{
//
//}
//-(void)setValue:(id)value forKey:(NSString *)key
//
//{
//
//}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //NSLog(@"forUndefinedKey::%@",key);
}
-(id)valueForUndefinedKey:(NSString *)key
{
    //NSLog(@"valueForUndefinedKey::%@",key);
    return nil;
}

#pragma mark - FMDB数据库使用方法
/**
 *  获取该类的所有属性及类型
 */
+ (NSDictionary *)fmdb_getPropertys
{
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    NSArray *theTransients = [[self class] fmdb_transients];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([theTransients containsObject:propertyName]) {
            continue;
        }
        [proNames addObject:propertyName];
        //获取属性类型等参数
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         c char         C unsigned char
         i int          I unsigned int
         l long         L unsigned long
         s short        S unsigned short
         d double       D unsigned double
         f float        F unsigned float
         q long long    Q unsigned long long
         B BOOL
         @ 对象类型 //指针 对象类型 如NSString 是@“NSString”
         
         
         64位下long 和long long 都是Tq
         SQLite 默认支持五种数据类型TEXT、INTEGER、REAL、BLOB、NULL
         */
        if ([propertyType hasPrefix:@"T@"]) {
            [proTypes addObject:SQL_TEXT];
        } else if ([propertyType hasPrefix:@"Ti"]||[propertyType hasPrefix:@"TI"]||[propertyType hasPrefix:@"Ts"]||[propertyType hasPrefix:@"TS"]||[propertyType hasPrefix:@"TB"]) {
            [proTypes addObject:SQL_INTEGER];
        } else {
            [proTypes addObject:SQL_REAL];
        }
        
    }
    free(properties);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}

/** 获取所有属性，包含主键pk */
+ (NSDictionary *)fmdb_getAllProperties
{
    NSDictionary *dict = [self.class fmdb_getPropertys];
    
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    [proNames addObject:SQL_primaryId];
    [proTypes addObject:[NSString stringWithFormat:@"%@ %@",SQL_INTEGER,SQL_PrimaryKey]];
    [proNames addObjectsFromArray:[dict objectForKey:@"name"]];
    [proTypes addObjectsFromArray:[dict objectForKey:@"type"]];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}
#pragma mark - must be override method
/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写
 */
+ (NSArray *)fmdb_transients
{
    return [NSArray array];
}
/**得到拼接的fmdb创建表的字符串*/
+ (NSString *)fmdb_getColumeAndTypeString:(BOOL)autoIncrement
{
    NSMutableString* pars = [NSMutableString string];
    NSDictionary *dict = autoIncrement?[self.class fmdb_getAllProperties]:[self.class fmdb_getPropertys];
    
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    NSMutableArray *proTypes = [dict objectForKey:@"type"];
    
    for (int i=0; i< proNames.count; i++) {
        [pars appendFormat:@"%@ %@",[proNames objectAtIndex:i],[proTypes objectAtIndex:i]];
        if(i+1 != proNames.count)
        {
            [pars appendString:@","];
        }
    }
    return pars;
}

@end
