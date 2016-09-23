//
//  MyDataBaseHandle.h
//  SQLiteStudy
//
//  Created by 李宁 on 15/10/31.
//  Copyright © 2015年 lining. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDataBaseHandle : NSObject
@property(nonatomic,copy)NSString *dataBasePath;//用来保存数据库地址字符串

+(instancetype)shareDatabase;

//打开数据库
-(void)openDB;


//关闭数据库
-(void)closeDB;

//创建表
-(void)createTable;


//添加图片、音乐、视频(数据类型、数据名、数据)
-(void)insertWithDataName:(NSString*)dataName DataType:(NSString*)dataType data:(NSData*)data;

//删
-(void)deletetWithDataName:(NSString*)dataName DataType:(NSString*)dataType;

//查
-(NSData *)selectWithDataName:(NSString*)dataName DataType:(NSString*)dataType;

//改
-(void)updateWithDataName:(NSString*)dataName DataType:(NSString*)dataType data:(NSData*)data;

//验证是否含有某个类型的某个资源
-(BOOL)checkWithDataName:(NSString*)dataName DataType:(NSString*)dataType;







@end
