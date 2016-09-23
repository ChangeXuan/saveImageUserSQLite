//
//  RootViewController.h
//  SQLiteStudy
//
//  Created by 李宁 on 15/10/31.
//  Copyright © 2015年 lining. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : NSObject
@property(nonatomic,strong)NSString *nameImage;
@property(nonatomic,strong)UIImage *saveImage;
@property(nonatomic,strong)UIImage *readImage;
@property(nonatomic,strong)NSString *nameAry;
@property(nonatomic,strong)NSArray *saveAry;
@property(nonatomic,strong)NSArray *readAry;
-(void)create;
-(void)saveData;
-(void)readData;
@end
