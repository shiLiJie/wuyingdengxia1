//
//  DiscussCollectionView.h
//  WUYINGDENGXIA
//
//  Created by mac on 2018/3/1.
//  Copyright © 2018年 医视中国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "discussModel.h"

@class DiscussCollectionView;

@protocol DiscussCollectionDelegate <NSObject,UICollectionViewDelegate>

//点击对应讨论模块
- (void)clickDiscussToIndex:(NSInteger)index discussModel:(discussModel *)model;

@end

@interface DiscussCollectionView : UICollectionView

@property (nonatomic, weak) id<DiscussCollectionDelegate> delegate1;

//讨论网络数据获取
-(void)getDisNetData;

@end
