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
@property (nonatomic, assign) BOOL isShowAnswer;
@property (weak, nonatomic) IBOutlet UIView *toolView;

@end

static NSString *cellIdentifier = @"cellIdentifier";

@implementation XSExercisesViewController

- (void)dealloc {
    NSLog(@"XSExercisesViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // init collectionView
    self.isShowAnswer = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.toolView];
    
    [self getData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
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
    [[XSDBCenter shareManager] getAllSingleExercisesDataOnComplete:^(NSArray * _Nullable array) {
        if (self.type == AnswerTypeOrderQuestions) {
            self.data = array;
        } else {
            NSMutableSet *randomSet = [[NSMutableSet alloc] init];
            NSInteger randomCount = ((self.randomQuestionsCount == 0 || self.randomQuestionsCount > array.count) ? 50 : self.randomQuestionsCount);
            while ([randomSet count] < randomCount) {
                int r = arc4random() % [array count];
                [randomSet addObject:[array objectAtIndex:r]];
            }
            
            NSArray *randomArray = [randomSet allObjects];
            self.data = randomArray;
        }
        
        [self.collectionView reloadData];
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
        label.numberOfLines = 0;
        label.text = [NSString stringWithFormat:@"您完成了 %lu 道题\n\n", (unsigned long)self.data.count];
        [cell.contentView addSubview:label];
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count + 1;
}

#pragma mark - XSExercisesCollectionViewCellDelegate
- (void)didSelectedCellAtIndex:(NSInteger)index {
    NSInteger row = [[self.collectionView indexPathsForVisibleItems] firstObject].row + 1;
    if (row < self.data.count) {
//        [self.collectionView layoutIfNeeded];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    } else {
        // 到最后一条了
//        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜！你已完成所有题目" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            __strong typeof(weakSelf) strongSelf = weakSelf;
        }];
        
//        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {}];
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
