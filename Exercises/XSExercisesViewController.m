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

@interface XSExercisesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, XSExercisesCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *data;

@end

static NSString *cellIdentifier = @"cellIdentifier";

@implementation XSExercisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // init collectionView
    [self.view addSubview:self.collectionView];
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
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"XSExercisesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    }
    
    return _collectionView;
}

- (NSArray *)data {
    if (_data == nil) {
        NSMutableArray *muArr = [NSMutableArray array];
//        NSDictionary *dic = @{@"ex_id":@"1", @"ex_title":@"fjalkjsdfk", @"ex_type":@(0), @"ex_options":@[@"a,jlkjlkj",@"b,fdsf"]};
        for (NSInteger i = 0; i < 10; i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:[NSString stringWithFormat:@"%@", @(i + 1)] forKey:@"ex_id"];
            [dic setValue:[NSString stringWithFormat:@"%@：巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉", @(i + 1)] forKey:@"ex_title"];
            [dic setValue:@(0) forKey:@"ex_type"];
            [dic setValue:@[@"A: 巴拉巴拉巴拉巴拉巴拉巴拉巴拉", @"B: 巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉", @"C: 巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉", @"D: 巴拉巴拉巴拉巴"] forKey:@"ex_options"];
            [dic setValue:@(2) forKey:@"ex_answerIndex"];

            XSExercisesModel *model = [[XSExercisesModel alloc] initWithDictionary:dic];
            [muArr addObject:model];
        }
        _data = muArr;
    }
    
    return _data;
}

#pragma mark - collectionview delegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XSExercisesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.exModel = self.data[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
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
