//
//  MyDataBaseHandle.m
//  SQLiteStudy
//
//  Created by 李宁 on 15/10/31.
//  Copyright © 2015年 lining. All rights reserved.
//

#import "MyDataBaseHandle.h"
#import <sqlite3.h>

static MyDataBaseHandle *dataBase=nil;
static sqlite3 *db=nil;//数据库指针

@interface MyDataBaseHandle ()


@end

@implementation MyDataBaseHandle

-(NSString *)dataBasePath{
    //懒加载
    if (_dataBasePath==nil) {
        NSString * documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        // NSLog(@"documents=%@",documents);
        
        self.dataBasePath=[documents stringByAppendingPathComponent:@"myTestDB.sqlite"];
        
    }
    
    return _dataBasePath;
    
}
+(instancetype)shareDatabase{
    //写成单例
    if (dataBase==nil) {
        dataBase=[[MyDataBaseHandle alloc]init];
    }
    return dataBase;
}

//打开数据库
-(void)openDB{
    int result =  sqlite3_open(self.dataBasePath.UTF8String, &db);
    
    if (result==SQLITE_OK)
    {
        //NSLog(@"数据库打开成功");
    }
    else
        NSLog(@"数据库打开失败");
    
    
}


//关闭数据库
-(void)closeDB{
    //关闭数据库
    int result =  sqlite3_close(db);
    
    if (result==SQLITE_OK){
        //NSLog(@"数据库关闭成功");
    }
    else NSLog(@"数据库关闭失败");
}

//创建表
-(void)createTable{
    [self openDB];
    
    //1.准备sql语句  设置表名，字段，设置逐渐
    NSString *sqlString=@"create table  if not exists myTable(m_id integer primary key autoincrement not null,m_name text,m_type text,m_time text,m_data blob) ";
    
    //2.执行sql语句
    int result = sqlite3_exec(db, sqlString.UTF8String, NULL, NULL, NULL);
    
    if (result==SQLITE_OK)
        NSLog(@"建表成功");
    else NSLog(@"建表失败");
    
    [self closeDB];
}


//添加图片、音乐、视频(数据类型、数据名、数据)
-(void)insertWithDataName:(NSString*)dataName DataType:(NSString*)dataType data:(NSData*)data{
    
    [self openDB];
    NSString *sqlString=@"insert into myTable (m_name ,m_type,m_data,m_time) values (?,?,?,?)";

    
    sqlite3_stmt *stmt=NULL;
  
    int result = sqlite3_prepare(db, sqlString.UTF8String, -1, &stmt, NULL);
    
    if (result==SQLITE_OK) {
        
        NSLog(@"预执行正确");
        
        //绑定参数
        //第1个问号
        sqlite3_bind_text(stmt, 1, dataName.UTF8String, -1, NULL);
        //第2个问号
        sqlite3_bind_text(stmt, 2, dataType.UTF8String, -1, NULL);
        //第3个问号
        sqlite3_bind_blob(stmt, 3, [data bytes], (int)[data length], NULL);
        //第4个问号
        sqlite3_bind_text(stmt, 4, [self getNowDate].UTF8String, -1, NULL);
        
        //执行
        if(sqlite3_step(stmt)==SQLITE_DONE)
            NSLog(@"插入成功");
        else NSLog(@"插入失败");
        
    }
    else NSLog(@"预执行错误");
    
   
    sqlite3_finalize(stmt);
    [self closeDB];
    
    
}

//删
-(void)deletetWithDataName:(NSString*)dataName DataType:(NSString*)dataType{
    
    
    [self openDB];
    NSString *sqlString=@"delete from myTable where m_name =? and m_type = ?";
    
    
    sqlite3_stmt *stmt=NULL;
    
    int result = sqlite3_prepare(db, sqlString.UTF8String, -1, &stmt, NULL);
    
    if (result==SQLITE_OK) {
        
        NSLog(@"预执行正确");
        
        //绑定参数
        //第1个问号
        sqlite3_bind_text(stmt, 1, dataName.UTF8String, -1, NULL);
        //第2个问号
        sqlite3_bind_text(stmt, 2, dataType.UTF8String, -1, NULL);
       
        
        
        //执行
        if(sqlite3_step(stmt)==SQLITE_DONE)
            NSLog(@"删除成功");
        else NSLog(@"删除失败");
        
    }
    else NSLog(@"预执行错误");
    
    sqlite3_finalize(stmt);
    [self closeDB];
   
    
}

//查
-(NSData *)selectWithDataName:(NSString*)dataName DataType:(NSString*)dataType{
    
    [self openDB];
    NSData * data = nil;
    NSString *sqlString=@"select m_data from myTable where m_name=? and m_type = ?";
    
    
    //2.伴随指针
    sqlite3_stmt *stmt=NULL;
    
    //3.预执行
    int result = sqlite3_prepare(db, sqlString.UTF8String, -1, &stmt, NULL);
    
    if (result==SQLITE_OK) {
        
        NSLog(@"语句正确");
        
        //4.绑定参数
        sqlite3_bind_text(stmt, 1, dataName.UTF8String, -1, NULL);
         sqlite3_bind_text(stmt, 2, dataType.UTF8String, -1, NULL);
        
        //5.执行(N次,因为有可能有N条数据符合条件)//循环判断是否还有符合查询条件的数据
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            
           data =[[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, 0) length: sqlite3_column_bytes(stmt, 0)];
        }
        
    }
    else NSLog(@"语句错误");
    
    //6.关闭伴随指针
    sqlite3_finalize(stmt);
  [self closeDB];
    return data;
}

//改
-(void)updateWithDataName:(NSString*)dataName DataType:(NSString*)dataType data:(NSData*)data{
    
    [self openDB];
    NSString * sqlString=@"update   myTable set m_data = ? ,m_time = ? where m_name = ? and m_type = ?";
    
    
    sqlite3_stmt *stmt=NULL;
    
    int result = sqlite3_prepare(db, sqlString.UTF8String, -1, &stmt, NULL);
    
    if (result==SQLITE_OK) {
        sqlite3_bind_text(stmt, 2, [self getNowDate].UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 3, dataName.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 4, dataType.UTF8String, -1, NULL);
        
        sqlite3_bind_blob(stmt, 1, [data bytes], (int)[data length], NULL);
        
        
        if (sqlite3_step(stmt)==SQLITE_DONE) {
            NSLog(@"更新成功");
        }
        else NSLog(@"更新失败");
    }
    
    sqlite3_finalize(stmt);
    
    [self closeDB];

    
}

//验证是否含有某个类型的某个资源
-(BOOL)checkWithDataName:(NSString*)dataName DataType:(NSString*)dataType{
    BOOL checkOK=NO;
    
    [self openDB];
    
    NSString *sqlString=@"select m_id from MyTable where  m_name = ? and m_type = ?  ";
    
    
    sqlite3_stmt *stmt=NULL;
    
    
    int result = sqlite3_prepare(db, sqlString.UTF8String, -1, &stmt, NULL);
    
    if (result==SQLITE_OK) {
        
        
        
        
        sqlite3_bind_text(stmt, 1, dataName.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 2, dataType.UTF8String, -1, NULL);
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            
            
            checkOK=YES;
            
            
        }
        
    }
    else NSLog(@"语句错误");
    
    
    sqlite3_finalize(stmt);
    
    [self closeDB];

    
    
    
    
    return checkOK;
}
//获取当前时间
-(NSString *)getNowDate{
    NSDate *date = [NSDate date];
    
    // NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    //NSInteger interval = [zone secondsFromGMTForDate: date];
    
    // NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
   // NSLog(@"localeDate=%@", destDateString);
    return destDateString;
}



@end
