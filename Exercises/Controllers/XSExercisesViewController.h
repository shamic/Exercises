//
//  XSExercisesViewController.h
//  Exercises
//
//  Created by Vary Fan on 2017/11/3.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AnswerTypeOrderQuestions,
    AnswerTypeRandomQuestions
} AnswerType;

@interface XSExercisesViewController : UIViewController
@property (nonatomic, assign) AnswerType type;
@property (nonatomic, assign) NSInteger randomQuestionsCount;
@end
