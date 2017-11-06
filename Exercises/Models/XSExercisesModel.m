//
//  XSExercisesModel.m
//  Exercises
//
//  Created by Vary Fan on 2017/11/3.
//  Copyright © 2017年 shamic. All rights reserved.
//

#define kKeyNumber       @"number"
#define kKeyTitle        @"title"
#define kKeyType         @"type"
#define kKeyOptions      @"options"
#define kKeyanswer       @"answer"


#import "XSExercisesModel.h"

@implementation XSExercisesModel

- (XSExercisesModel *)initWithDictionary:(NSDictionary *)dic {
    if (self = [self init]) {
        _number = [NSString stringWithFormat:@"%@", dic[kKeyNumber]];
        _title = dic[kKeyTitle];
        _type = [dic[kKeyType] integerValue];
        _options = [self optionsFromOptionsStr:dic[kKeyOptions]];
        _answerIndex = [self answerIndexFromAnswer:dic[kKeyanswer]];
        
        _selectedIndex = 0;
    }
    
    return self;
}

- (NSInteger)answerIndexFromAnswer:(NSString *)answer {
    if ([answer isEqualToString:@"A"]) {
        return 1;
    } else if ([answer isEqualToString:@"B"]) {
        return 2;
    } else if ([answer isEqualToString:@"C"]) {
        return 3;
    } else if ([answer isEqualToString:@"D"]) {
        return 4;
    } else {
        return 1111; // 无答案
    }
}

- (NSArray *)optionsFromOptionsStr:(NSString *)optionStr {
    NSArray *arr = [optionStr componentsSeparatedByString:@"&&&"];
    return arr;
}

@end
