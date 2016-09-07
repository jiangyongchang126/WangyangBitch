//
//  QuestionsAndAnswers.m
//  WangYangBitch
//
//  Created by 蒋永昌 on 9/7/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "QuestionsAndAnswers.h"

@implementation QuestionsAndAnswers

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@",self.letter,self.question,self.answer];
}

@end
