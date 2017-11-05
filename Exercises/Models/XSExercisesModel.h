//
//  XSExercisesModel.h
//  Exercises
//
//  Created by Vary Fan on 2017/11/3.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ExercisesTypeSingle,
    ExercisesTypeExtended,
    ExercisesTypeTrueOrFalse
} ExercisesType;

@interface XSExercisesModel : NSObject

@property (nonatomic, strong) NSString *ex_id;
@property (nonatomic, strong) NSString *ex_title;
@property (nonatomic, assign) ExercisesType ex_type;
@property (nonatomic, strong) NSArray *ex_options;
@property (nonatomic, assign) NSInteger ex_answerIndex;

@property (nonatomic, assign) NSInteger selectedIndex; // 默认值 0: 未选择过

- (XSExercisesModel *)initWithDictionary: (NSDictionary *)dic;

@end
