//
//  DFSegmentView1.h
//  WUYINGDENGXIA
//
//  Created by mac on 2018/5/22.
//  Copyright © 2018年 医视中国. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DFSegmentViewDelegate <NSObject>

@required
/**
 *  导航栏数组
 */
//- (NSArray *)titlesForDFSegmentViewHeadView;
/**
 *  指明父控制器
 */
- (UIViewController *)superViewController;
/**
 *  导航栏index 对应的子控制器
 */
- (UIViewController *)subViewControllerWithIndex:(NSInteger)index;

@optional
/**
 *  点击导航栏的回调
 */
- (void)headTitleSelectWithIndex:(NSInteger)index;


@end

@interface DFSegmentView1 : UIView

@property (nonatomic, weak) id<DFSegmentViewDelegate> delegate;
/**
 *  设置导航条高
 */
@property (nonatomic, assign) CGFloat headViewHeight;
/**
 *  设置导航条文字颜色
 */
@property (nonatomic, copy) UIColor *headViewTextLabelColor;
/**
 *  设置导航条下滑线颜色
 */
@property (nonatomic, copy) UIColor *headViewLinelColor;
/**
 *  reloadTitleArr 赋值后要调用 reloadData
 */
@property (nonatomic, strong) NSArray *reloadTitleArr;

- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate andTitlArr:(NSArray *)titleArr;

- (void)reloadData;

@end
