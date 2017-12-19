//
//  XSExercisesCollectionViewCell.m
//  Exercises
//
//  Created by Vary Fan on 2017/11/3.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import "XSExercisesCollectionViewCell.h"
#import "UIColor+XSColor.h"

@interface XSExercisesCollectionViewCell()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL completeSubmit;

@end

static NSString *cellId = @"cellId";

@implementation XSExercisesCollectionViewCell

- (void)dealloc {
    XSLog(@"XSExercisesCollectionViewCell dealloc");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

- (void)setExModel:(XSExercisesModel *)exModel {
    _exModel = exModel;
    
    CGFloat width = self.bounds.size.width;
    NSString *showTitle = [NSString stringWithFormat:@"%@、%@", _exModel.number, _exModel.title];
    CGFloat height = [self getHeightOfString:showTitle font:[UIFont systemFontOfSize:20.0] width:(width - 30)] + 20;
    if (height < 60.0) {
        height = 60.0;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 15 + height + 25)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, width - 30, height)];
    label.numberOfLines = 0;
    label.text = showTitle;
    label.textColor = [UIColor titleColor];
    label.font = [UIFont systemFontOfSize:20.0];
    [view addSubview:label];
    self.tableView.tableHeaderView = view;
}

- (void)setIsShowAnswer:(BOOL)isShowAnswer {
    _isShowAnswer = isShowAnswer;
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.exModel.options[indexPath.row];
    
    cell.backgroundColor = [UIColor backgroundColor];
    cell.textLabel.textColor = [UIColor titleColor];
    
    if (self.exModel.type == ExercisesTypeSingle) {
        if (indexPath.section == 0) {
            if (self.exModel.selectedIndex != 0) { // 选择过
                // 正确答案高亮
                if (indexPath.row + 1 == self.exModel.answerIndex) {
                    cell.textLabel.textColor = [UIColor redColor];
                }
                
                if (self.exModel.selectedIndex == self.exModel.answerIndex) {
                    // 对
                    if (indexPath.row + 1 == self.exModel.selectedIndex) {
                        cell.backgroundColor = [UIColor greenColor];
                    }
                } else {
                    // 错
                    if (indexPath.row + 1 == self.exModel.selectedIndex) {
                        cell.backgroundColor = [UIColor greenColor];
                        cell.textLabel.text = [NSString stringWithFormat:@"%@    %@", self.exModel.options[indexPath.row], @"❌"];
                    }
                }
            }
        } else {
            NSString *answer = @"";
            if (self.exModel.answerIndex > self.exModel.options.count) {
                answer = @"无答案";
            } else {
                answer = self.exModel.options[self.exModel.answerIndex - 1];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%@    %@", @"✅正确答案：\n\n", answer];
        }
    } else if (self.exModel.type == ExercisesTypeExtended) {
        if (indexPath.section == 0) {
            if (self.completeSubmit) {
                if ([self.exModel isSelected:indexPath.row]) {
                    if ([self.exModel isCorrectAnswer:indexPath.row]) {
                        cell.textLabel.textColor = [UIColor redColor];
                        cell.backgroundColor = [UIColor greenColor];
                    } else {
                        cell.backgroundColor = [UIColor greenColor];
                        cell.textLabel.text = [NSString stringWithFormat:@"%@    %@", self.exModel.options[indexPath.row], @"❌"];
                    }
                } else {
                    if ([self.exModel isCorrectAnswer:indexPath.row]) {
                        cell.textLabel.textColor = [UIColor redColor];
                    } else {
                    }
                }
            } else {
                if ([self.exModel isSelected:indexPath.row]) {
                    cell.backgroundColor = [UIColor greenColor];
                } else {
                    cell.backgroundColor = [UIColor backgroundColor];
                }
            }
        } else if (indexPath.section == 1) {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
            cell.textLabel.text = @"<提 交>";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor blueColor];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@    %@", @"✅正确答案：", [self.exModel getShortAnswer]];
        }
    } else {
        cell.textLabel.text = @"未知类型";
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.exModel.type == ExercisesTypeSingle) {
        if (self.exModel.selectedIndex != 0 || self.isShowAnswer) {
            return 2;
        }
        return 1;
    } else if (self.exModel.type == ExercisesTypeExtended) {
        if ((self.exModel.selectedAnswers.count != 0 && self.completeSubmit) || self.isShowAnswer) {
            return 3;
        }
        return 2;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.exModel.options.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat height = [self getHeightOfString:self.exModel.options[indexPath.row] font:[UIFont systemFontOfSize:16.0f] width:self.bounds.size.width - 30];
        return height + 20;
    }
    
    // ExercisesTypeExtended
    if (self.exModel.type == ExercisesTypeExtended && indexPath.section == 1) {
        return 80.0f;
    } else if (self.exModel.type == ExercisesTypeExtended && indexPath.section == 2) {
        return 80.0f;
    }
    
    // ExercisesTypeSimple
    NSString *string = @"";
    if (self.exModel.answerIndex > self.exModel.options.count) {
        string = @"✅正确答案：\n\n无答案";
    } else {
        string = [NSString stringWithFormat:@"%@    %@", @"✅正确答案：\n\n", self.exModel.options[self.exModel.answerIndex - 1]];
    }

    CGFloat height = [self getHeightOfString:string font:[UIFont systemFontOfSize:16.0f] width:self.bounds.size.width - 30];
    return height + 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //  ExercisesTypeSingle
    if (indexPath.section == 0 && self.exModel.type == ExercisesTypeSingle) {
        if (self.exModel.selectedIndex != 0) {
            return;
        }
        
        self.exModel.selectedIndex = indexPath.row+1;
        [self.tableView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(didSelectedCellWithItem:)]) {
            [self.delegate didSelectedCellWithItem:self.exModel];
        }
    }
    //  ExercisesTypeExtended
    if (indexPath.section == 0 && self.exModel.type == ExercisesTypeExtended) {
        [self.exModel selectedRow:indexPath.row];
        [self.tableView reloadData];
    } else if (indexPath.section == 1 && self.exModel.type == ExercisesTypeExtended) {
        if (self.exModel.selectedAnswers.count > 0) {
            self.completeSubmit = YES;
            [self.tableView reloadData];
            
            if ([self.delegate respondsToSelector:@selector(didSelectedCellWithItem:)]) {
                [self.delegate didSelectedCellWithItem:self.exModel];
            }
        } else {
            // TODO: toast tips
        }
    }
    
}

#define mark - custom method
- (CGFloat)getHeightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGSize stringSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return stringSize.height;
}

@end
