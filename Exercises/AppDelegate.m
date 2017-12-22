//
//  AppDelegate.m
//  Exercises
//
//  Created by fancy on 2017/11/2.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import "AppDelegate.h"
#import "XSDBCenter.h"
#import "BRAOfficeDocumentPackage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [XSDBCenter shareManager];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    __weak typeof(self) weakSelf = self;
    NSString *message = [NSString stringWithFormat:@"接收到文件《%@》，是否导入数据库？", url.absoluteString.lastPathComponent];
    [XSAlertView showAlertWithTitle:@"提示" message:message buttonTilte:@"导入" cancelButtonTitle:@"取消" origin:weakSelf.window.rootViewController onHandler:^(UIAlertAction *action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (action.style == UIAlertActionStyleDefault) {
            XSLog(@"default");
            [SVProgressHUD showProgress:0.0 status:@"正在导入..."];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [strongSelf readFile:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"导入成功"];
                });
            });
        } else if (action.style == UIAlertActionStyleCancel) {
            XSLog(@"cancel");
        } else {
            XSLog(@"undefined");
        }
    }];
    
    
    return YES;
}


- (BOOL)readFile:(NSURL *)url {
    BRAOfficeDocumentPackage *spreadsheet = [BRAOfficeDocumentPackage open:url.path];
    BRAWorksheet *firstWorksheet = spreadsheet.workbook.worksheets[0]; //exercises
    
    //    NSString *errorValue = nil;
    //    if ([[firstWorksheet cellForCellReference:@"D2"] hasError]) {
    //        errorValue = [[firstWorksheet cellForCellReference:@"D2"] stringValue];
    //        NSLog(@"errorValue: %@", errorValue);
    //    }
    NSString *temp = @"C";
    for (NSInteger i = 1; i < firstWorksheet.rows.count; i++) {
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)i]];
        BRACell *cell = [firstWorksheet cellForCellReference:temp];
        NSString *formula = [cell stringValue];
        if (formula.length == 0) {
            temp = @"C";
            continue;
        }
        NSLog(@"%@: %@", temp, formula);
        temp = @"C";
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:(float)i / firstWorksheet.rows.count status:@"正在导入..."];
        });
    }
    //    NSString *formula = [[firstWorksheet cellForCellReference:@"D2"] formulaString];
    //    NSString *string = [[firstWorksheet cellForCellReference:@"D2"] stringValue];
    //
    //    NSLog(@"D2: %@\nD2: %@", formula, string);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
