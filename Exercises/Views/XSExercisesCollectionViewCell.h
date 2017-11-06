//
//  XSExercisesCollectionViewCell.h
//  Exercises
//
//  Created by Vary Fan on 2017/11/3.
//  Copyright © 2017年 shamic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSExercisesModel.h"

@protocol XSExercisesCollectionViewCellDelegate;

@interface XSExercisesCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) XSExercisesModel *exModel;
@property (nonatomic, assign) BOOL isShowAnswer;
@property (nonatomic, weak) id<XSExercisesCollectionViewCellDelegate> delegate;

@end

@protocol XSExercisesCollectionViewCellDelegate <NSObject>

- (void)didSelectedCellAtIndex:(NSInteger)index;

@end
