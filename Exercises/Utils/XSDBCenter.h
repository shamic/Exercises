//
//  XSDBCenter.h
//  Exercises
//
//  Created by fancy on 2017/11/5.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSDBCenter : NSObject

+ (_Nonnull instancetype)shareManager;

- (void)getAllSingleExercisesDataOnComplete:(void(^_Nullable)(NSArray* _Nullable array))complete;

- (NSInteger)getLastNumberOfOrderQuestions;
- (void)saveLastNumberOfOrderQuestions: (NSInteger)number;

- (void)setItemBank:(NSString *_Nullable)bank;

@end
