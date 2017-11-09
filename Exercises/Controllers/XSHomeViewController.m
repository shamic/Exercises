//
//  XSHomeViewController.m
//  Exercises
//
//  Created by Vary Fan on 2017/11/6.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import "XSHomeViewController.h"
#import "XSExercisesViewController.h"
#import "ActionSheetPicker.h"
#import "XSDBCenter.h"

@interface XSHomeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *itemBankLabel;

@end

@implementation XSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSArray *itemBank = [NSArray arrayWithArray:[[XSDBCenter shareManager] allItemBanks]];

        [ActionSheetStringPicker showPickerWithTitle:@"选择一个题库" rows:itemBank initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger  selectedIndex, id selectedValue) {
                XSLog(@"Picker: %@, Index: %ld, value: %@", picker, (long)selectedIndex, selectedValue);
                self.itemBankLabel.text = itemBank[selectedIndex];
                [[XSDBCenter shareManager] setItemBank:itemBank[selectedIndex]];
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                XSLog(@"Block Picker Canceled");
            }
        origin:self.view];
    }
}

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
