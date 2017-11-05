//
//  XSExercisesModel.m
//  Exercises
//
//  Created by Vary Fan on 2017/11/3.
//  Copyright © 2017年 shamic. All rights reserved.
//

#define kKeyExId         @"ex_id"
#define kKeyExTitle      @"ex_title"
#define kKeyExType       @"ex_type"
#define kKeyExOptions    @"ex_options"
#define kKeyAnswerIndex  @"ex_answerIndex"


#import "XSExercisesModel.h"

@implementation XSExercisesModel

- (XSExercisesModel *)initWithDictionary:(NSDictionary *)dic {
    if (self = [self init]) {
        _ex_id = dic[kKeyExId];
        _ex_title = dic[kKeyExTitle];
        _ex_type = [dic[kKeyExType] integerValue];
        _ex_options = dic[kKeyExOptions];
        _ex_answerIndex = [dic[kKeyAnswerIndex] integerValue];
        
        _selectedIndex = 0;
    }
    
    return self;
}

@end
