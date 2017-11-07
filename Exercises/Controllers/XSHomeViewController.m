//
//  XSHomeViewController.m
//  Exercises
//
//  Created by Vary Fan on 2017/11/6.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import "XSHomeViewController.h"
#import "XSExercisesViewController.h"

@interface XSHomeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation XSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
}

//- (void)hiddenKeyboard {
//    [self.textField resignFirstResponder];
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"order_questions"]) {
        XSExercisesViewController *viewController = [segue destinationViewController];
        viewController.type = AnswerTypeOrderQuestions;
    } else if ([segue.identifier isEqualToString:@"random_questions"]) {
        XSExercisesViewController *viewController = [segue destinationViewController];
        viewController.type = AnswerTypeRandomQuestions;
        viewController.randomQuestionsCount = [self.textField.text integerValue];
    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

@end
