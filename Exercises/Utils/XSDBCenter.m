//
//  XSDBCenter.m
//  Exercises
//
//  Created by fancy on 2017/11/5.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import "XSDBCenter.h"
#import "BGFMDB.h"
#import "XSExercisesModel.h"

@interface XSDBCenter()
//@property (nonatomic, strong) NSArray *data;
@end

static XSDBCenter *dbCenter = nil;

@implementation XSDBCenter

+ (_Nonnull instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbCenter = [[XSDBCenter alloc] init];
        [dbCenter initDB];
    });
    return dbCenter;
}

- (void)initDB {
    bg_setDebug(YES);//打开调试模式,打印输出调试信息.
    // 如果频繁操作数据库时,建议进行此设置(即在操作过程不关闭数据库);
    //bg_setDisableCloseDB(YES);
    bg_setSqliteName(@"Exercises");
//    [self testSaveArray];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%@", @(1)] forKey:@"ex_id"];
    [dic setValue:[NSString stringWithFormat:@"%@：巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉", @(1)] forKey:@"ex_title"];
    [dic setValue:@(0) forKey:@"ex_type"];
    [dic setValue:@[@"A: 巴拉巴拉巴拉巴拉巴拉巴拉巴拉", @"B: 巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉", @"C: 巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉", @"D: 巴拉巴拉巴拉巴"] forKey:@"ex_options"];
    [dic setValue:@(2) forKey:@"ex_answerIndex"];
    XSExercisesModel *exerciese = [[XSExercisesModel alloc] initWithDictionary:dic];
    [exerciese bg_save];
}

@end
