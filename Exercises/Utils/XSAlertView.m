//
//  XSAlertView.m
//  Exercises
//
//  Created by Vary Fan on 2017/12/22.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import "XSAlertView.h"

@interface XSAlertView ()

@end

@implementation XSAlertView

+ (instancetype)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTilte:(NSString *)buttonTitle cancelButtonTitle:(NSString *)cancelButtonTitle origin:(id)origin onHandler:(void(^)(UIAlertAction *action))onHandler {
    
    NSAssert([origin isKindOfClass:[UIViewController class]], @"origin must be UIViewController.");
    
    XSAlertView *alert = [XSAlertView alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        onHandler(action);
    }];
    [alert addAction:ok];
    
    if (cancelButtonTitle) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            onHandler(action);
        }];
        [alert addAction:cancel];
    }
    
    [origin presentViewController:alert animated:YES completion:nil];
    
    return alert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
