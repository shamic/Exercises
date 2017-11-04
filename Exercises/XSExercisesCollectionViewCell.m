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

@end

static NSString *cellId = @"cellId";

@implementation XSExercisesCollectionViewCell

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
    CGFloat height = [self getHeightOfString:_exModel.ex_title font:[UIFont systemFontOfSize:20.0] width:(width - 30)] + 20;
    if (height < 60.0) {
        height = 60.0;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height + 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, width - 30, height)];
    label.numberOfLines = 0;
    label.text = _exModel.ex_title;
    label.textColor = [UIColor titleColor];
    label.font = [UIFont systemFontOfSize:20.0];
    [view addSubview:label];
    self.tableView.tableHeaderView = view;
    
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.exModel.ex_options[indexPath.row];
    
    cell.backgroundColor = [UIColor backgroundColor];
    cell.textLabel.textColor = [UIColor titleColor];
    
    if (indexPath.section == 0) {
        if (self.exModel.selectedIndex != 0) { // 选择过
            // 正确答案高亮
            if (indexPath.row + 1 == self.exModel.ex_answerIndex) {
                cell.textLabel.textColor = [UIColor redColor];
            }
            
            if (self.exModel.selectedIndex == self.exModel.ex_answerIndex) {
                // 对
                if (indexPath.row + 1 == self.exModel.selectedIndex) {
                    cell.backgroundColor = [UIColor greenColor];
                }
            } else {
                // 错
                if (indexPath.row + 1 == self.exModel.selectedIndex) {
                    cell.backgroundColor = [UIColor greenColor];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@    %@", self.exModel.ex_options[indexPath.row], @"❌"];
                }
            }
        }
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@    %@", @"✅正确答案：\n\n", self.exModel.ex_options[self.exModel.ex_answerIndex - 1]];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.exModel.selectedIndex != 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.exModel.ex_options.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat height = [self getHeightOfString:self.exModel.ex_options[indexPath.row] font:[UIFont systemFontOfSize:16.0f] width:self.bounds.size.width - 30];
        return height + 20;
        
    }
    NSString *string = [NSString stringWithFormat:@"%@    %@", @"✅正确答案：\n\n", self.exModel.ex_options[self.exModel.ex_answerIndex - 1]];

    CGFloat height = [self getHeightOfString:string font:[UIFont systemFontOfSize:16.0f] width:self.bounds.size.width - 30];
    return height + 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.exModel.selectedIndex != 0) {
            return;
        }
        
        self.exModel.selectedIndex = indexPath.row+1;
        if (self.exModel.selectedIndex != self.exModel.ex_answerIndex) {
            // 选择错误❌
            [self.tableView reloadData];
            return;
        }
        if ([self.delegate respondsToSelector:@selector(didSelectedCellAtIndex:)]) {
            [self.tableView reloadData];
            [self.delegate didSelectedCellAtIndex:indexPath.row+1];
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