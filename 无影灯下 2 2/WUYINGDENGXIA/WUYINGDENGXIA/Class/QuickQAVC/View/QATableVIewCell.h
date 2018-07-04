//
//  QATableVIewCell.h
//  WUYINGDENGXIA
//
//  Created by mac on 2018/1/16.
//  Copyright © 2018年 医视中国. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QATableVIewCellDelegate<NSObject>

@optional
//监听点击table点击的索引
-(void)tableviewDidSelectUserHeadImage:(NSInteger )indexPath;

@end

@interface QATableVIewCell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIButton *headImage;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *userName;
//主标题
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
//内容详情
@property (weak, nonatomic) IBOutlet UILabel *detailPage;
//回答时间
@property (weak, nonatomic) IBOutlet UILabel *answerTime;
//回答次数
@property (weak, nonatomic) IBOutlet UILabel *answerNum;
//回答按钮
@property (weak, nonatomic) IBOutlet UIButton *answer;
//月亮币
@property (weak, nonatomic) IBOutlet UILabel *mooncash;


//头像
@property (weak, nonatomic) IBOutlet UIButton *headImage1;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *userName1;
//主标题
@property (weak, nonatomic) IBOutlet UILabel *mainTitle1;
//内容详情
@property (weak, nonatomic) IBOutlet UILabel *detailPage1;
//回答时间
@property (weak, nonatomic) IBOutlet UILabel *answerTime1;
//回答次数
@property (weak, nonatomic) IBOutlet UILabel *answerNum1;
//回答按钮
@property (weak, nonatomic) IBOutlet UIButton *answer1;
//月亮币
@property (weak, nonatomic) IBOutlet UILabel *mooncash1;
@property (weak, nonatomic) IBOutlet UIImageView *image1;



//头像
@property (weak, nonatomic) IBOutlet UIButton *headImage2;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *userName2;
//主标题
@property (weak, nonatomic) IBOutlet UILabel *mainTitle2;
//内容详情
@property (weak, nonatomic) IBOutlet UILabel *detailPage2;
//回答时间
@property (weak, nonatomic) IBOutlet UILabel *answerTime2;
//回答次数
@property (weak, nonatomic) IBOutlet UILabel *answerNum2;
//回答按钮
@property (weak, nonatomic) IBOutlet UIButton *answer2;
//月亮币
@property (weak, nonatomic) IBOutlet UILabel *mooncash2;
@property (weak, nonatomic) IBOutlet UIImageView *image21;
@property (weak, nonatomic) IBOutlet UIImageView *image22;
@property (weak, nonatomic) IBOutlet UIImageView *image23;


@property (nonatomic,weak) id<QATableVIewCellDelegate>delegate;

/**
 设置行间距
 */
-(void)setLabelSpace;





@end





