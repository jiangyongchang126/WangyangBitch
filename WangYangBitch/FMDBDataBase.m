//
//  FMDBDataBase.m
//  WangYangBitch
//
//  Created by 蒋永昌 on 9/7/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "FMDBDataBase.h"
#import "QuestionsAndAnswers.h"

@implementation FMDBDataBase
singleton_implementation(FMDBDataBase)



//创建数据库对象
static FMDatabase *db = nil;

//打开数据库
- (void)openDataBase{
    
    //创建文件路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    documentPath = [documentPath stringByAppendingString:@"/questionsandanswers.sqlite"];
    NSLog(@"%@",documentPath);
    
    //创建数据库
    db = [FMDatabase databaseWithPath:documentPath];
    
    //打开数据库，并判断是否打开了数据库 open 的返回类型是BOOL
    if ([db open]) {
        
        NSLog(@"数据库打开成功");
        
        NSString *sql = @"CREATE TABLE IF NOT EXISTS questionsandanswers (question_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, letter TEXT NOT NULL, question TEXT NOT NULL, answer TEXT NOT NULL)";
        BOOL result = [db executeUpdate:sql];
        if (result) {
            NSLog(@"创表成功");
        [KVNProgress showSuccessWithStatus:@"打开数据库并创建表成功"];

        }else{
            NSLog(@"创表失败");
        }
        
        
    }else{
        NSLog(@"数据库打开失败");
    }
    
}


//关闭数据库
- (void)closeDataBase{
    //关闭数据库
    NSLog(@"关闭数据库");
    [db close];
    
}

//增
- (void)insertData:(QuestionsAndAnswers *)questionsandanswers{
    
    [db open];
    
    NSMutableArray *array = [NSMutableArray array];
    
    FMResultSet *set = [db executeQuery:@"select *from questionsandanswers"];
    while ([set next]) {
        
        NSString *question = [set stringForColumn:@"question"];
        
        NSLog(@"%@",question);
        [array addObject:question];
    }
    
    
    if ([array containsObject:questionsandanswers.question]) {
        return;
    }else{
        NSString *str = [FMDBDataBase transform:questionsandanswers.question];
        str = [str substringToIndex:1];
        NSString *letter = [str uppercaseString];
        
        NSLog(@"首字母：%@，问题：%@，答案：%@",letter,questionsandanswers.question,questionsandanswers.answer);
        
        [db executeUpdate:@"insert into questionsandanswers (letter,question,answer) values(?,?,?)",letter,questionsandanswers.question,questionsandanswers.answer];
    }
    
    
    
    
}

// 加强版增加
- (void)insertData:(QuestionsAndAnswers * _Nonnull)questionsandanswers
           success:(nullable void (^)(id _Nullable responseObject))success
           failure:(nullable void (^)(id _Nullable errorObject))failure
     fromClassName:(NSString * _Nonnull)className{
    
    
    BOOL openData = [db open];
    if (openData) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        FMResultSet *set = [db executeQuery:@"select *from questionsandanswers"];
        while ([set next]) {
            
            NSString *question = [set stringForColumn:@"question"];
            
            NSLog(@"%@",question);
            [array addObject:question];
        }
            
        if ([array containsObject:questionsandanswers.question]) {
            if (failure) {
                
                failure(@"数据库中此问题已存在！");
            }
            return;
        }else{
            NSString *str = [FMDBDataBase transform:questionsandanswers.question];
            str = [str substringToIndex:1];
            NSString *letter = [str uppercaseString];
            
            NSLog(@"首字母：%@，问题：%@，答案：%@",letter,questionsandanswers.question,questionsandanswers.answer);
            
            BOOL suc = [db executeUpdate:@"insert into questionsandanswers (letter,question,answer) values(?,?,?)",letter,questionsandanswers.question,questionsandanswers.answer];
            
            if (suc) {
                if (success) {
                    
                    NSDictionary *dict = @{@"status":@"0",@"info":@"数据添加成功！"};
                    
                    NSLog(@"%@\n传参：%@\n回参：%@", className, questionsandanswers,dict);

                    success(dict);

                }
                
            }else{
                
                if (success) {
                    
                    NSDictionary *dict = @{@"status":@"1",@"msg":@"数据添加失败！"};
                    NSLog(@"%@\n传参：%@\n回参：%@", className, questionsandanswers,dict);

                    success(dict);
                    
                }
 
            }
        }
        
        
    }else{
        
        if (failure) {
            
            failure(@"打开数据库失败！");

        }
    }
}




//删
- (void)deleteData:(NSString *)question{
    
    [db open];
    
    [db executeUpdate:@"delete from questionsandanswers where question = ?",question];
    
    
}

- (void)deleteData:(NSString *_Nonnull)question
           success:(nullable void (^)(id _Nullable responseObject))success
           failure:(nullable void (^)(id _Nullable errorObject))failure
     fromClassName:(NSString * _Nonnull)className{
    
    BOOL openData = [db open];
    if (openData) {
        
        BOOL suc = [db executeUpdate:@"delete from questionsandanswers where question = ?",question];
        
        if (suc) {
            if (success) {
                
                NSDictionary *dict = @{@"status":@"0",@"info":@"数据删除成功！"};
                
                NSLog(@"%@\n传参：%@\n回参：%@", className, question,dict);
                
                success(dict);
                
            }
            
        }else{
            
            if (success) {
                
                NSDictionary *dict = @{@"status":@"1",@"msg":@"数据删除失败！"};
                NSLog(@"%@\n传参：%@\n回参：%@", className, question,dict);
                
                success(dict);
                
            }
            
        }

        
    }else{
        
        if (failure) {
            
            failure(@"打开数据库失败！");
            
        }
    }

}

//查
- (NSArray *)queryData{
    
    [db open];
    NSMutableArray *array = [NSMutableArray array];
    
    FMResultSet *set = [db executeQuery:@"select *from questionsandanswers"];
    while ([set next]) {
        QuestionsAndAnswers *questionsandanswers = [QuestionsAndAnswers new];
        
        questionsandanswers.letter = [set stringForColumn:@"letter"];
        questionsandanswers.question = [set stringForColumn:@"question"];
        questionsandanswers.answer = [set stringForColumn:@"answer"];
        
//        NSLog(@"%@",questionsandanswers);
        [array addObject:questionsandanswers];
    }
    
    return array;
    
}


- (void)queryDataWithPram:(NSDictionary *_Nonnull)dict
                  success:(nullable void (^)(id _Nullable responseObject))success
                  failure:(nullable void (^)(id _Nullable errorObject))failure
            fromClassName:(NSString * _Nonnull)className{
    
    BOOL openData = [db open];
    if (openData) {
        
        
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *allArray = [NSMutableArray array];
        
        FMResultSet *set = [db executeQuery:@"select *from questionsandanswers"];
        
        while ([set next]) {
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            
            [dictionary setObject:[set stringForColumn:@"letter"] forKey:@"letter"];
            [dictionary setObject:[set stringForColumn:@"question"] forKey:@"question"];
            [dictionary setObject:[set stringForColumn:@"answer"] forKey:@"answer"];
            
            [allArray addObject:dictionary];
        }
        
        NSInteger allData = allArray.count;
        
        for (int i = 0; i < allData; i++) {
            
            NSInteger num = 10*[dict[@"page"] integerValue];
            if (array.count >= num) {
                
                break;
            }
            
            [array addObject:allArray[i]];
            
        }
        
        NSInteger arrayCount = array.count;
        
        if (array.count == allData) {
            
            if (failure) {
                
                failure(@"没有更多数据啦！");
            }
        }

//        while ([set next]) {
//            
//            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
////            QuestionsAndAnswers *questionsandanswers = [QuestionsAndAnswers new];
////            questionsandanswers.letter = [set stringForColumn:@"letter"];
////            questionsandanswers.question = [set stringForColumn:@"question"];
////            questionsandanswers.answer = [set stringForColumn:@"answer"];
//
//            [dictionary setObject:[set stringForColumn:@"letter"] forKey:@"letter"];
//            [dictionary setObject:[set stringForColumn:@"question"] forKey:@"question"];
//            [dictionary setObject:[set stringForColumn:@"answer"] forKey:@"answer"];
//
//            
//            
//            NSInteger num = 10*[dict[@"page"] integerValue];
//            if (array.count >= num) {
//                
//                break;
//            }
//            
//            [array addObject:dictionary];
//
//        }
        
        BOOL countMoreZero = array.count;
        
        if (countMoreZero) {
            
            if (success) {
                
                NSMutableDictionary *responseOb = [NSMutableDictionary dictionary];
                [responseOb setObject:@"0" forKey:@"status"];
                [responseOb setObject:array forKey:@"info"];
                [responseOb setObject:[NSString stringWithFormat:@"%ld",allData] forKey:@"allData"];
                
                NSLog(@"%@\n传参：%@\n回参：%@", className, dict,responseOb);
                success(responseOb);
 
            }
            
        }else{
            
            if (success) {
                
                NSDictionary *responseOb = @{@"status":@"1",@"msg":@"数据库没有数据！"};
                
                NSLog(@"%@\n传参：%@\n回参：%@", className, dict,responseOb);

                success(responseOb);

            }
        }
        
        
        
    }else{
        
        if (failure) {
            
            failure(@"打开数据库失败！");
            
        }
    }

    
}




+ (NSString *)transform:(NSString *)chinese{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    //返回最近结果
    return pinyin;
}


@end
