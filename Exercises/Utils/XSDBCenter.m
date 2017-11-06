//
//  XSDBCenter.m
//  Exercises
//
//  Created by fancy on 2017/11/5.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import "XSDBCenter.h"
#import "BGDB.h"
#import "XSExercisesModel.h"
#import "XSExercisesModel.h"

@interface XSDBCenter()
@property (nonatomic, strong) NSArray *data;
@end

static XSDBCenter *dbCenter = nil;
static NSString *singleExercisesTable = @"single_exercise";
static NSString *singleExercisesTablePrimaryKey = @"number";

@implementation XSDBCenter

+ (_Nonnull instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbCenter = [[XSDBCenter alloc] init];
        [dbCenter copyDBFileToDocumentPath];
        [dbCenter initDB];
    });
    return dbCenter;
}

- (void)copyDBFileToDocumentPath {
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPathStr = [[NSBundle mainBundle] pathForResource:@"Exercises" ofType:@"bundle"];
    NSURL *srcUrl = [NSURL URLWithString:[dbPathStr stringByAppendingPathComponent:@"Exercises.db"]];
    NSURL *dstUrl = [NSURL URLWithString:[document stringByAppendingString:@"/Exercises.db"]];
    
    NSError *error = nil;
    BOOL bl3 = [manager copyItemAtPath:[srcUrl path] toPath:[dstUrl path] error:&error];
    if (!bl3) {
        NSLog(@"copyDBFileToDocumentPath fail:\n%@", error);
    }
}

- (void)initDB {
    bg_setDebug(YES);//打开调试模式,打印输出调试信息.
    // 如果频繁操作数据库时,建议进行此设置(即在操作过程不关闭数据库);
    //bg_setDisableCloseDB(YES);
    bg_setSqliteName(@"Exercises");
}

- (void)getAllSingleExercisesDataOnComplete:(void (^)(NSArray * _Nullable))complete {
    NSString *condition = [NSString stringWithFormat:@"order by %@ asc",singleExercisesTablePrimaryKey];
    [[BGDB shareManager] queryWithTableName:singleExercisesTable conditions:condition complete:^(NSArray * _Nullable array) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            XSExercisesModel *model = [[XSExercisesModel alloc] initWithDictionary:dic];
            [arr addObject:model];
        }
        complete(arr);
    }];
    //关闭数据库
    [[BGDB shareManager] closeDB];
}

@end
