//
//  TongzhiVc.h
//  WUYINGDENGXIA
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 医视中国. All rights reserved.
//

#import "BaseViewController.h"
//typedef void(^TongzhiVcBlcok) (NSIndexPath *index);
@protocol TongzhiVcDelegate <NSObject>//协议

- (void)transIndex:(NSIndexPath *)index isTuigao:(BOOL)istuigao dataDict:(NSDictionary *)dict;//协议方法

@end

@interface TongzhiVc : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) id<TongzhiVcDelegate> delegate;//代理属性

//@property (nonatomic,assign)TongzhiVcBlcok TongzhiVcBlcok;

@property (nonatomic, strong) NSMutableArray *dataArr;


@end
