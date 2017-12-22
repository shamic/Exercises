//
//  XSExercisesViewController.m
//  Exercises
//
//  Created by Vary Fan on 2017/11/3.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import "XSExercisesViewController.h"
#import "XSExercisesCollectionViewCell.h"
#import "XSExercisesModel.h"
#import "UIColor+XSColor.h"
#import "XSDBCenter.h"

@interface XSExercisesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, XSExercisesCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *correctArr;
@property (nonatomic, strong) NSMutableArray *failureArr;
@property (nonatomic, assign) BOOL isShowAnswer;
@property (weak, nonatomic) IBOutlet UIView *toolView;

@end

static NSString *cellIdentifier = @"cellIdentifier";

@implementation XSExercisesViewController

- (void)dealloc {
    XSLog(@"XSExercisesViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // init collectionView
    self.isShowAnswer = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.toolView];
    
    self.correctArr = [NSMutableArray array];
    self.failureArr = [NSMutableArray array];
    
    [self getData];
}

- (void)jumpTo {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"跳转到指定题目" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *searchIndex = alert.textFields.firstObject;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSInteger row = [searchIndex.text integerValue] - 1;
        if (row >= 0 && row < self.data.count) {
            [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            [strongSelf.collectionView reloadData];
        }
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"输入题号定位";
    }];

    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.type == AnswerTypeOrderQuestions) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(jumpTo)];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.type == AnswerTypeOrderQuestions) {
        NSInteger row = [[self.collectionView indexPathsForVisibleItems] firstObject].row;
        if (row != 0 && row < self.data.count) {
            [[XSDBCenter shareManager] saveLastNumberOfOrderQuestions: row+1];
        }
    }
}

- (IBAction)showAnswer:(UISwitch *)sender {
    self.isShowAnswer = [sender isOn];
    [self.collectionView reloadData];
}
- (IBAction)favoriteBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = [[UIScreen mainScreen] bounds].size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"XSExercisesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"finishedCell"];
    }
    
    return _collectionView;
}

- (void)getData {
    __weak typeof(self) weakSelf = self;

    [[XSDBCenter shareManager] getAllExercisesDataOnComplete:^(NSArray * _Nullable array) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (strongSelf.type == AnswerTypeOrderQuestions) {
            strongSelf.data = array;
        } else {
            NSMutableSet *randomSet = [[NSMutableSet alloc] init];
            NSInteger randomCount = ((strongSelf.randomQuestionsCount == 0 || strongSelf.randomQuestionsCount > array.count) ? 50 : strongSelf.randomQuestionsCount);
            while ([randomSet count] < randomCount) {
                int r = arc4random() % [array count];
                [randomSet addObject:[array objectAtIndex:r]];
            }
            
            NSArray *randomArray = [randomSet allObjects];
            strongSelf.data = randomArray;
        }
        
        strongSelf.title = [NSString stringWithFormat:@"总题数：%ld", strongSelf.data.count];
        
        [strongSelf.collectionView reloadData];
        
        if (strongSelf.type == AnswerTypeOrderQuestions) {
            // scroll to last browsed item
            NSInteger row = [[XSDBCenter shareManager] getLastNumberOfOrderQuestions] - 1;
            if (row != 0 && row < strongSelf.data.count) {
                [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
        }
    }];
}

#pragma mark - collectionview delegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row < self.data.count) {
        XSExercisesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.exModel = self.data[indexPath.row];
        cell.isShowAnswer = self.isShowAnswer;
        cell.delegate = self;
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"finishedCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor backgroundColor];
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
        label.numberOfLines = 0;
        label.text = [NSString stringWithFormat:@"您完成了 %lu 道题\n\n❌ %lu 道题\n\n✅ %lu 道题\n\n本次成绩： %lu 分", (unsigned long)self.data.count, self.failureArr.count,  self.correctArr.count, self.correctArr.count*100/self.data.count];
        [cell.contentView addSubview:label];
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count + (self.data.count>0?1:0);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = cell.reuseIdentifier;
    if ([identifier isEqualToString:@"finishedCell"]) {
        self.toolView.hidden = YES;
    } else {
        self.toolView.hidden = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    //NSLog(@"index: %ld", (long)index);
    if (index == self.data.count) {
        self.toolView.hidden = YES;
    } else {
        self.toolView.hidden = NO;
    }
}

#pragma mark - XSExercisesCollectionViewCellDelegate
- (void)didSelectedCellWithItem:(XSExercisesModel *)item {
    if ([item isCorrect]) {
        [self.correctArr addObject:item];
    } else {
        [self.failureArr addObject:item];
    }
    
    NSInteger row = [[self.collectionView indexPathsForVisibleItems] firstObject].row + 1;
    if (row < self.data.count) {
        if (![item isCorrect]) {
            // 选择错误❌
            return;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    } else {
        // 到最后一条了
        __weak typeof(self) weakSelf = self;
        [self.collectionView reloadData];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜！你已完成所有题目" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
             
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
