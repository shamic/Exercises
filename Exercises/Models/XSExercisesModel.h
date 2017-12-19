//
//  XSExercisesModel.h
//  Exercises
//
//  Created by Vary Fan on 2017/11/3.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

typedef enum : NSUInteger {
    ExercisesTypeSingle,
    ExercisesTypeExtended
} ExercisesType;

@interface XSExercisesModel : NSObject

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) ExercisesType type;
@property (nonatomic, strong) NSArray *options;

@property (nonatomic, assign) NSInteger answerIndex;
@property (nonatomic, assign) NSInteger selectedIndex; // 默认值 0: 未选择过

@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, strong) NSMutableArray *selectedAnswers;

- (XSExercisesModel *)initWithDictionary: (NSDictionary *)dic;
- (NSString *)getShortAnswer;
- (void)selectedRow:(NSInteger)row;
- (BOOL)isSelected:(NSInteger)row;
- (BOOL)isCorrectAnswer:(NSInteger)row;
- (BOOL)isCorrect;

@end
