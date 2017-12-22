//
//  XSAlertView.h
//  Exercises
//
//  Created by Vary Fan on 2017/12/22.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSAlertView : UIAlertController

// cancelButtonTitle为空时，不显示cancel button
+ (instancetype)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTilte:(NSString *)buttonTitle cancelButtonTitle:(NSString *)cancelButtonTitle origin:(id)origin onHandler:(void(^)(UIAlertAction *action))onHandler;

@end
