//
//  MyDuihuanVc.m
//  WUYINGDENGXIA
//
//  Created by mac on 2018/4/11.
//  Copyright © 2018年 医视中国. All rights reserved.
//

#import "MyDuihuanVc.h"
#import "MyDuihuanCell.h"
#import "MyDuihuanDetailVc.h"
#import "DuihuanModel.h"

@interface MyDuihuanVc ()<UITableViewDelegate,UITableViewDataSource>
//兑换列表
@property (weak, nonatomic) IBOutlet UITableView *tableview;
//兑换礼物数组
@property (nonatomic, strong) NSArray *duihuanArr;

@property (nonatomic, strong) UIImageView *imageview;


@end

@implementation MyDuihuanVc

-(void)viewDidLayoutSubviews{
    self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, self.view.frame.size.height)];
    self.imageview.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.imageview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.duihuanArr = [[NSArray alloc] init];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    
    UserInfoModel *user = [UserInfoModel shareUserModel];
    [user loadUserInfoFromSanbox];
    if (user.loginStatus) {
        //获取兑换记录
        [self getDuihuanList];
    }
    
}

#pragma mark - UI -
-(BOOL)hideNavigationBottomLine{
    return NO;
}

-(UIColor *)set_colorBackground{
    return [UIColor whiteColor];
}

-(NSMutableAttributedString *)setTitle{
    return [self changeTitle:@"我的兑换"];
}

//获取兑换记录
-(void)getDuihuanList{
    UserInfoModel *user = [UserInfoModel shareUserModel];
    [user loadUserInfoFromSanbox];
    __weak typeof(self) weakSelf = self;
    [[HttpRequest shardWebUtil] getNetworkRequestURLString:[BaseUrl stringByAppendingString:[NSString stringWithFormat:@"get_goods_by_userid?user_id=%@",user.userid]]
                                                parameters:nil
                                                   success:^(id obj) {
                                                       NSArray *arr = obj[@"data"];
                                                       
//                                                       NSLog(@"%@",arr);
                                                       NSMutableArray *arrayM = [NSMutableArray array];
                                                       for (int i = 0; i < arr.count; i ++) {
                                                           NSDictionary *dict = arr[i];
                                                           [arrayM addObject:[DuihuanModel DuihuanModelWithDict:dict]];
  
                                                       }
                                                       weakSelf.duihuanArr= [[arrayM reverseObjectEnumerator] allObjects];
                                                       [weakSelf.tableview reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}

//左侧按钮设置点击
-(UIButton *)set_leftButton{
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 44, 60);
    [btn setImage:GetImage(@"fanhui") forState:UIControlStateNormal];
    return btn;
}

-(void)left_button_event:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x000000) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(18) range:NSMakeRange(0, title.length)];
    return title;
}

#pragma mark - 私有方法 -

#pragma mark - tableviewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.duihuanArr.count == 0) {
        
        self.imageview.image = GetImage(@"wuduihuan");
        self.imageview.hidden = NO;
        return 0;
    }else{
        self.imageview.hidden = YES;
        return self.duihuanArr.count;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 149;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseID = @"MyDuihuanCell";
    MyDuihuanCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyDuihuanCell" owner:nil options:nil] firstObject];
    }
    //设置背景色,切圆角,点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = RGB(243, 244, 248);
    self.tableview.backgroundColor = RGB(243, 244, 248);
    cell.cellView.layer.cornerRadius = 10;//半径大小
    cell.cellView.layer.masksToBounds = YES;//是否切割
    
    DuihuanModel *model = self.duihuanArr[indexPath.row];
    cell.nameLab.text = model.goods_name;
    cell.jiageLab.text = model.moon_cash;
    cell.dingdanhaoLab.text = [NSString stringWithFormat:@"订单号 %@",model.order_num];
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:GetImage(@"")];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDuihuanDetailVc *vc = [[MyDuihuanDetailVc alloc] init];
    DuihuanModel *model = self.duihuanArr[indexPath.row];
    vc.duihuanmodel = [[DuihuanModel alloc] init];
    vc.duihuanmodel = model;
    [self.navigationController pushViewController:vc animated:YES];
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
