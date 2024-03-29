//
//  WeikaishiVc.m
//  WUYINGDENGXIA
//
//  Created by mac on 2018/4/18.
//  Copyright © 2018年 医视中国. All rights reserved.
//

#import "WeikaishiVc.h"
#import "WeikaishiCell.h"
#import "MyHuodongModel.h"

@interface WeikaishiVc ()

@property (nonatomic, strong) UIImageView *imageview;

@end

@implementation WeikaishiVc

- (void)viewDidLoad {
    [super viewDidLoad];


    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (kDevice_Is_iPhoneX) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 133, 0);
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 113, 0);
    }
    
    self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -80, self.view.frame.size.width, self.view.frame.size.height)];
    self.imageview.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.imageview];
}


//-(void)setWeikaishiArr:(NSMutableArray *)weikaishiArr{
//    
//    [self.tableView reloadData];
//}

#pragma mark - tableviewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.weikaishiArr.count == 0) {
        
        self.imageview.image = GetImage(@"wuhuodong");
        self.imageview.hidden = NO;
        return 0;
    }else{
        self.imageview.hidden = YES;
        return self.weikaishiArr.count;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 93;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseID = @"WeikaishiCell";
    WeikaishiCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WeikaishiCell" owner:nil options:nil] firstObject];
    }
    
    
    MyHuodongModel *model = [[MyHuodongModel alloc] init];
    model = self.weikaishiArr[indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.meeting_image] placeholderImage:GetImage(@"")];
    cell.titleLab.text = model.meet_title;
    cell.timeLab.text = [NSString stringWithFormat:@"%@-%@",model.begin_time,model.end_time];
    if ([model.is_check isEqualToString:@"0"]) {
        cell.choosetype = shenhezhongType;
        [cell setUpUi:cell.choosetype];
    }else{
        cell.choosetype = weiqiandaoType;//审核通过
        [cell setUpUi:cell.choosetype];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(tableviewDidSelectPageWithIndex3:)]) {
        [self.delegate tableviewDidSelectPageWithIndex3:indexPath];
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
