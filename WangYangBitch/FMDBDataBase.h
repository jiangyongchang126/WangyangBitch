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

// 加强版增加
- (void)insertData:(QuestionsAndAnswers * _Nonnull)questionsandanswers
           success:(nullable void (^)(id _Nullable responseObject))success
           failure:(nullable void (^)(id _Nullable errorObject))failure
     fromClassName:(NSString * _Nonnull)className;




//删
- (void)deleteData:(NSString *)question;

// 删除增强版
- (void)deleteData:(NSString *_Nonnull)question
           success:(nullable void (^)(id _Nullable responseObject))success
           failure:(nullable void (^)(id _Nullable errorObject))failure
     fromClassName:(NSString * _Nonnull)className;

//查
- (NSArray *)queryData;

// 查询增强版
- (void)queryDataWithPram:(NSDictionary *_Nonnull)dict
                  success:(nullable void (^)(id _Nullable responseObject))success
                  failure:(nullable void (^)(id _Nullable errorObject))failure
            fromClassName:(NSString * _Nonnull)className;

//改
//- (void)updateData:(NSString *)question name:(NSString *)answer;


@end
