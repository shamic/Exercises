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

@interface XSExercisesModel ()
@property (nonatomic, strong) NSString *shortAnswer;
@end

@implementation XSExercisesModel

- (XSExercisesModel *)initWithDictionary:(NSDictionary *)dic {
    if (self = [self init]) {
        _number = [NSString stringWithFormat:@"%@", dic[kKeyNumber]];
        _title = dic[kKeyTitle];
        _type = [dic[kKeyType] integerValue];
        _options = [self optionsFromOptionsStr:dic[kKeyOptions]];
        
        _shortAnswer = dic[kKeyanswer];
        
        if (_type == ExercisesTypeSingle) {
            _answerIndex = [self answerIndexFromAnswer:dic[kKeyanswer]];
        } else if (_type == ExercisesTypeExtended) {
            _answers = [self answerIndexesFromAnswer:dic[kKeyanswer]];
        } else {
            _type = ExercisesTypeSingle;
            _answerIndex = 1111;
        }
        
        _selectedIndex = 0;
        _selectedAnswers = [NSMutableArray array];
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
        return 1111;
    }
}

- (NSArray *)answerIndexesFromAnswer:(NSString *)answer {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < answer.length; i++) {
        unichar c = [answer characterAtIndex:i];
        NSString *cStr = [NSString stringWithFormat: @"%C", c];
        [arr addObject:@([self answerIndexFromAnswer:cStr])];
    }
    if (arr.count > 0) {
        return arr;
    }
    return nil;
}

- (NSArray *)optionsFromOptionsStr:(NSString *)optionStr {
    NSArray *arr = [optionStr componentsSeparatedByString:@"&&&"];
    return arr;
}

- (NSString *)getShortAnswer {
    return _shortAnswer;
}

- (void)selectedRow:(NSInteger)row {
    NSNumber *selectNum = [NSNumber numberWithInteger:row + 1];

    if ([self isSelected:row]) {
        [self.selectedAnswers removeObject:selectNum];
    } else {
        [self.selectedAnswers addObject:selectNum];
    }
}

- (BOOL)isSelected:(NSInteger)row {
    NSNumber *selectNum = [NSNumber numberWithInteger:row + 1];
    for (NSNumber *num in self.selectedAnswers) {
        if (num == selectNum) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)isCorrectAnswer:(NSInteger)row {
    NSNumber *selectNum = [NSNumber numberWithInteger:row + 1];
    for (NSNumber *answer in self.answers) {
        if (answer == selectNum) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)isCorrect {
    if (self.type == ExercisesTypeSingle) {
        if (self.selectedIndex != self.answerIndex) {
            return NO;
        } else if (self.selectedIndex == self.answerIndex) {
            return YES;
        }
    } else if (self.type == ExercisesTypeExtended) {
        NSInteger count = 0;
        for (NSNumber *num in self.selectedAnswers) {
            for (NSNumber *answer in self.answers) {
                if (answer == num) {
                    count++;
                }
            }
        }
        if (count == self.answers.count) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

@end
