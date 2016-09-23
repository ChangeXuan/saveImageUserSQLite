//
//  RootViewController.m
//  SQLiteStudy
//
//  Created by 李宁 on 15/10/31.
//  Copyright © 2015年 lining. All rights reserved.
//

#import "RootViewController.h"
#import "MyDataBaseHandle.h"
@interface RootViewController ()
@property(nonatomic,copy)NSString *dbPath;//数据库的路径
@end

@implementation RootViewController
-(NSString*)dbPath{
    
    if (_dbPath==nil) {
        self.dbPath =[MyDataBaseHandle shareDatabase].dataBasePath;
    }
    return _dbPath;
    
}


//创建数据库和表
-(void)create{
    NSLog(@"建表");
    
    [[MyDataBaseHandle shareDatabase] createTable];
    
    
    
}


//将数据写入到数据库
-(void)saveData{
    NSLog(@"添加数据");
    
    UIImage *image = self.saveImage;
    NSData *dataPic = UIImageJPEGRepresentation(image, 0.8);
    
    if (![[MyDataBaseHandle shareDatabase]checkWithDataName:self.nameImage DataType:@"jpg"]) {
         [[MyDataBaseHandle shareDatabase] insertWithDataName:self.nameImage DataType:@"jpg" data:dataPic];
    }
    else {
         [[MyDataBaseHandle shareDatabase] updateWithDataName:self.nameImage DataType:@"jpg" data:dataPic];
    }
    
    
    NSString *str = [self.saveAry componentsJoinedByString:@"-"];
    NSLog(@"%@",str);
    NSData *strData=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    if (![[MyDataBaseHandle shareDatabase]checkWithDataName:self.nameAry DataType:@"ary"]) {
        [[MyDataBaseHandle shareDatabase] insertWithDataName:self.nameAry DataType:@"ary" data:strData];
    }
    else {
        [[MyDataBaseHandle shareDatabase] updateWithDataName:self.nameAry DataType:@"ary" data:strData];
    }
    
    int someInt = 11;
    NSString *aString = [NSString stringWithFormat:@"%d",someInt];
    NSData *someData = [aString dataUsingEncoding:NSUTF8StringEncoding];
    if (![[MyDataBaseHandle shareDatabase]checkWithDataName:@"int" DataType:@"ary"]) {
        [[MyDataBaseHandle shareDatabase] insertWithDataName:@"int" DataType:@"ary" data:someData];
    }
    else {
        [[MyDataBaseHandle shareDatabase] updateWithDataName:@"int" DataType:@"ary" data:someData];
    }
    
}


//从数据库获取数据
-(void)readData{
    
    //获取png图片
    NSData * dataImg=[[MyDataBaseHandle shareDatabase] selectWithDataName:self.nameImage DataType:@"jpg"];
    self.readImage = [UIImage imageWithData:dataImg];
    
    NSData *dataAry=[[MyDataBaseHandle shareDatabase] selectWithDataName:self.nameAry DataType:@"ary"];
    NSString *str=[[NSString alloc] initWithData:dataAry encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    self.readAry=[str componentsSeparatedByString:NSLocalizedString(@"-", nil)];
    NSLog(@"%@",self.readAry);
    
    NSData *dataInt=[[MyDataBaseHandle shareDatabase] selectWithDataName:@"int" DataType:@"ary"];
    NSString *aString = [[NSString alloc] initWithData:dataInt encoding:NSUTF8StringEncoding];
    int someInt = [aString intValue];
    NSLog(@"%d",someInt);
    
}




@end
