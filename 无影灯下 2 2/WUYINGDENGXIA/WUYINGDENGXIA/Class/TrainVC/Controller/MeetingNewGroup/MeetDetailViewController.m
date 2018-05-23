//
//  MeetDetailViewController.m
//  WUYINGDENGXIA
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 医视中国. All rights reserved.
//

#import "MeetDetailViewController.h"
#import "MeetRichengCell.h"
#import "SignUpViewController.h"
#import "meetingDetailModel.h"
#import "RenzhengOneVc.h"

@interface MeetDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
//会议介绍按钮是否展开
@property (nonatomic, assign) BOOL isJieshao;
//会议日程按钮是否展开
@property (nonatomic, assign) BOOL isRicheng;
//自定义cell
@property (nonatomic, strong) MeetRichengCell * cell;
//时间段模拟数据
@property (nonatomic, strong) NSMutableArray *timeaArr;
//具体内容模拟数据
@property (nonatomic, strong) NSMutableArray *detailaArr;
//加载数据的条数
@property (nonatomic, assign) NSInteger arrCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (nonatomic, assign) CGFloat viewheight;

@property (nonatomic, strong) meetingDetailModel *meetdetailModel;



@end

@implementation MeetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取会议详情信息
    [self getMeetDetailInfo];
    
    self.timeaArr = [[NSMutableArray alloc] init];
    self.detailaArr = [[NSMutableArray alloc] init];
    
    //给会议日程加载多少条赋值
    self.arrCount = self.timeaArr.count>2 ? 2 : self.timeaArr.count;
    
    //默认不展开
    self.isJieshao = NO;
    self.isRicheng = NO;
    

    //报名按钮切圆角
    self.baomingBtn.layer.cornerRadius = 42/2;//半径大小
    self.baomingBtn.layer.masksToBounds = YES;//是否切割
    
    
    self.richengTableView.rowHeight = UITableViewAutomaticDimension;
    self.richengTableView.estimatedRowHeight = 120;
    //tableview设置代理
    self.richengTableView.delegate = self;
    self.richengTableView.dataSource = self;
    self.richengTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置Scroller的代理
    self.scroller.delegate = self;
    
    self.viewheight = 100;
    
    //禁止滚动
    self.richengTableView.userInteractionEnabled = NO;

    //设置会议详情内容
    self.meetDetailText.text = @"        移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限移动设备的屏幕⼤大⼩小是极其有限的,因此直接展⽰示在⽤用户眼前的内容也相当有限";
    
    //设置lab行间距
    [self setLabelHangjianj:self.meetDetailText];
    [self setLabelHangjianj:self.meetAddress];
    
    // 接收分享回调通知
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"WXShare" object:nil];
    // 检查是否装了微信
    if ([WXApi isWXAppInstalled]) {
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    //判断会议是否已经结束
    if (self.isJieshu) {
        [self.baomingBtn setTitle:@"已结束" forState:UIControlStateNormal];
        [self.baomingBtn setUserInteractionEnabled:NO];
    }else{
        [self.baomingBtn setTitle:@"报名" forState:UIControlStateNormal];
        [self.baomingBtn setUserInteractionEnabled:YES];
    }
    self.isJieshu = NO;
}

//由于Scroller不滚动,没办法才在didappear里设置滚动范围
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scroller.contentSize =  CGSizeMake(0, CGRectGetMaxY(self.huiyiRichengView.frame));
    
    //设置阴影
    CALayer *layer = [CALayer layer];
    layer.frame = self.baomingBtn.frame;
    layer.backgroundColor = RGB(45, 163, 255).CGColor;
    layer.shadowColor = RGB(45, 163, 255).CGColor;
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowOpacity = 0.5;
    layer.cornerRadius = 42/2;
    [self.view.layer addSublayer:layer];
    //一到最上层
    [self.view bringSubviewToFront:self.baomingBtn];

}

#pragma mark - UI -
-(void)getMeetDetailInfo{
    [[HttpRequest shardWebUtil] getNetworkRequestURLString:[BaseUrl stringByAppendingString:[NSString stringWithFormat:@"get_meeting_byid?meet_id=%@",self.meetId]]
                                                parameters:nil
                                                   success:^(id obj) {
//                                                       NSLog(@"%@",obj);
                                                       NSDictionary *dict = obj[@"data"];
                                                       self.meetdetailModel = [meetingDetailModel meedetailtWithDict:dict];
                                                       //设置视图内容
                                                       self.meetName.text = self.meetdetailModel.meet_title;
                                                       self.meetTime.text = self.meetdetailModel.begin_time;
                                                       self.meetAddress.text = self.meetdetailModel.meet_address;
                                                       self.meetDetailText.text = self.meetdetailModel.meet_content;
                                                       
                                                       self.meetdetailModel.meet_date = dict[@"meet_date"];
                                                       NSArray *arr = dict[@"meet_date"];
                                                       if (kArrayIsEmpty(arr)) {
                                                           return;
                                                       }
                                                       NSDictionary *dic = arr[0];
                                                       NSArray *arry = [dic objectForKey:@"meet_class"];
                                                       NSDictionary *dicy = [[NSDictionary alloc] init];
                                                       for (dicy in arry) {
//                                                           [self.timeaArr addObject:dicy[@"meet_class_begin"]];
//                                                           [self.timeaArr addObject:dicy[@"meet_class_end"]];
                                                           NSString *timeStr = [NSString stringWithFormat:@"%@-%@",dicy[@"meet_class_begin"],dicy[@"meet_class_end"]];
                                                           [self.timeaArr addObject:timeStr];
                                                           [self.detailaArr addObject:dicy[@"main_content"]];
                                                           
                                                       }
                                                       
                                                       //给会议日程加载多少条赋值
                                                       self.arrCount = self.timeaArr.count>2 ? 2 : self.timeaArr.count;
                                                       [self.meetImage sd_setImageWithURL:[NSURL URLWithString:self.meetdetailModel.meeting_image] placeholderImage:GetImage(@"")];
                                                       [self.richengTableView reloadData];

    }
                                                      fail:^(NSError *error) {
        
    }];
}

-(NSMutableAttributedString *)setTitle{
    return [self changeTitle:@"会议名称不能也不能太长"];
}

-(UIColor*)set_colorBackground{
    return [UIColor whiteColor];
}

-(BOOL)hideNavigationBottomLine{
    return NO;
}

#pragma mark - 私有action -
- (void)getOrderPayResult:(NSNotification *)notification
{
    // 注意通知内容类型的匹配
    if (notification.object == 0)
    {
        NSLog(@"分享成功");
    }
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

////右上角分享
//-(UIButton *)set_rightButton{
//    UIButton *btn = [[UIButton alloc] init];
//    btn.frame = CGRectMake(kScreen_Width-44, 0, 44, 60);
//    [btn setImage:GetImage(@"fenxiang") forState:UIControlStateNormal];
//    return btn;
//}
//
//-(void)right_button_event:(UIButton *)sender{
//    WXMediaMessage * message = [WXMediaMessage message];
//    message.title = @"会议名称";
//    message.description = @"会议摘要";
//    [message setThumbImage:[UIImage imageNamed:@"tx"]];
//    
//    WXWebpageObject * webpageObject = [WXWebpageObject object];
//    webpageObject.webpageUrl = @"http://www.yszg.org";
//    message.mediaObject = webpageObject;
//    
//    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    
//    req.message = message;
//    req.scene = WXSceneSession;
//    
//    [WXApi sendReq:req];
//    
//}

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x000000) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(18) range:NSMakeRange(0, title.length)];
    return title;
}

#pragma mark - 私有方法 -
-(void)setLabelHangjianj:(UILabel *)lab{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lab.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lab.text length])];
    lab.attributedText = attributedString;
}

//参会按钮点击
- (IBAction)joinMeetBtnClick:(UIButton *)sender {
    
    UserInfoModel *user = [UserInfoModel shareUserModel];
    [user loadUserInfoFromSanbox];
    __weak typeof(self) weakSelf = self;
    //判断用户登录状态
    if (user.loginStatus) {
        
        if ([user.isfinishCer isEqualToString:@"1"]) {
            SignUpViewController *vc = [[SignUpViewController alloc] init];
            vc.meetdetailModel = [[meetingDetailModel alloc] init];
            vc.meetdetailModel = weakSelf.meetdetailModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            RenzhengOneVc *vc = [[RenzhengOneVc alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        LoginVc *loginVc = [LoginVc loginControllerWithBlock:^(BOOL result, NSString *message) {
            
        }];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
}

//会议介绍按钮点击
- (IBAction)huiyijieshaoBtnClick:(UIButton *)sender {

    if (self.isJieshao) {
        //收起,展示两行
        self.isJieshao = NO;
        self.meetDetailText.numberOfLines = 2;
        [self.huiyijieshaoBtn setTitle:@"展开全部" forState:UIControlStateNormal];
        
    }else{
        //展开,展示全部
        self.isJieshao = YES;
        self.meetDetailText.numberOfLines = 0;
        [self.huiyijieshaoBtn setTitle:@"点击收起" forState:UIControlStateNormal];
    }
    
    [self.scroller layoutIfNeeded];
    [self.view layoutIfNeeded];
    self.scroller.contentSize =  CGSizeMake(0, CGRectGetMaxY(self.huiyiRichengView.frame));
   
}

// 根据字符串计算label高度
-(float)getContactHeight:(NSString*)contact
{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contact];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [paragraphStyle setLineSpacing:4];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contact length])];
    
    NSDictionary *attrs = @{
                            NSFontAttributeName : [UIFont systemFontOfSize:14.0],
                            NSParagraphStyleAttributeName : paragraphStyle
                            
                            };
    CGSize maxSize = CGSizeMake(kScreen_Width-20-90.5-30-10, MAXFLOAT);
    
    // 计算文字占据的高度
    CGSize size = [contact boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

    return size.height;
}

//会议日程按钮点击
- (IBAction)huiyiRichengBtnClick:(UIButton *)sender {
    
    if (self.isRicheng) {
        self.viewheight = 100;
        //收起,展示两行
        [self.huiyiRichengBtn setTitle:@"展开全部" forState:UIControlStateNormal];
        self.isRicheng = NO;
        self.arrCount = self.timeaArr.count>2 ? 2 : self.timeaArr.count;
        [self.richengTableView reloadData];
        
    }else{
        [self.huiyiRichengBtn setTitle:@"点击收起" forState:UIControlStateNormal];
        self.viewheight = 100;
        //展开,展示全部
        self.isRicheng = YES;
        self.arrCount = self.timeaArr.count;
        [self.richengTableView reloadData];
    }
    [self.view layoutIfNeeded];
    [self.scroller layoutIfNeeded];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.scroller layoutIfNeeded];
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5 animations:^{
            self.scroller.contentSize =  CGSizeMake(0, CGRectGetMaxY(self.huiyiRichengView.frame));
            
        }];
    });
}


#pragma mark - tableview代理 -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *str = self.detailaArr[indexPath.row];

    CGFloat height = [self getContactHeight:str] +5;

    self.viewheight+= height;
    self.viewHeight.constant = self.viewheight;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseID = @"MeetRichengCell";
    self.cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
//    if (!self.cell) {
    
    self.cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetRichengCell" owner:nil options:nil] firstObject];
    self.cell.timeLab.text = self.timeaArr[indexPath.row];
    self.cell.detailLab.text = self.detailaArr[indexPath.row];
    [self.cell.detailLab alignTop];
//    [self.cell.detailLab sizeToFit];
//    [self setLabelHangjianj:self.cell.detailLab];
    
//    }
    
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self.cell;
}

#pragma mark - scrollerview代理 -
//scrollView滚动时，就调用该方法。任何offset值改变都调用该方法。即滚动过程中，调用多次
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    NSLog(@"scrollViewDidScroll");
//    CGPoint point=scrollView.contentOffset;
//    NSLog(@"%f,%f",point.x,point.y);
//
}

#pragma mark - 懒加载 -
-(MeetRichengCell *)cell{
    if(!_cell){//如果没有创建mycell的话
        //通过xib的方式加载单元格
        _cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetRichengCell" owner:nil options:nil] firstObject];
    }
    return _cell;
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
