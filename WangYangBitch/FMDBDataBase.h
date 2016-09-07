//
//  FMDBDataBase.h
//  WangYangBitch
//
//  Created by 蒋永昌 on 9/7/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QuestionsAndAnswers;

@interface FMDBDataBase : NSObject
singleton_interface(FMDBDataBase)

//打开数据库
- (void)openDataBase;

//关闭数据库
- (void)closeDataBase;

//增
- (void)insertData:(QuestionsAndAnswers *)QuestionsAndAnswers;

//删
- (void)deleteData:(NSString *)question;

//查
- (NSArray *)queryData;

//改
//- (void)updateData:(NSString *)question name:(NSString *)answer;


@end
