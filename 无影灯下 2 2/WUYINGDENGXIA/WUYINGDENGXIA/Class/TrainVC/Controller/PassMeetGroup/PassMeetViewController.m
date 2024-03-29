//
//  PassMeetViewController.m
//  WUYINGDENGXIA
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 医视中国. All rights reserved.
//

#import "PassMeetViewController.h"
#import "PassMeetTableCell.h"
#import "PlayDetailViewController.h"


@interface PassMeetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) UIImageView *imageview;


@end

@implementation PassMeetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.huiguerArr = [[NSArray alloc] init];

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -80, self.view.frame.size.width, self.view.frame.size.height)];
    self.imageview.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.imageview];
    self.imageview.hidden = YES;

}

#pragma mark - UI -
-(NSMutableAttributedString *)setTitle{
    return [self changeTitle:self.huiguModel.replay_title.length>0 ?self.huiguModel.replay_title : @""];
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

-(UIColor*)set_colorBackground{
    return [UIColor whiteColor];
}

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x000000) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:BOLDSYSTEMFONT(18) range:NSMakeRange(0, title.length)];
    return title;
}

//获取回顾列表
-(void)getVideoList{
    self.imageview.hidden = YES;
    [[HttpRequest shardWebUtil] getNetworkRequestURLString:[BaseUrl stringByAppendingString:[NSString stringWithFormat:@"get_allsub_replay?replay_id=%@",self.huiguModel.replay_id]]
                                                parameters:nil
                                                   success:^(id obj) {
                                                       
                                                       NSArray *arr = obj[@"data"];
                                                       NSMutableArray *arrayM = [NSMutableArray array];
                                                       for (int i = 0; i < arr.count; i ++) {
                                                           NSDictionary *dict = arr[i];
                                                           [arrayM addObject:[huiguErModel huiguErWithDict:dict]];
                                                           
                                                       }
                                                       self.huiguerArr= arrayM;
                                                       [self.tableview reloadData];
                                                   } fail:^(NSError *error) {
                                                       //
                                                   }];
}

//我的收藏视频列表
-(void)getMyshoucangQusetion{
    __weak typeof(self) weakSelf = self;
    UserInfoModel *user = [UserInfoModel shareUserModel];
    [user loadUserInfoFromSanbox];
    [[HttpRequest shardWebUtil] getNetworkRequestURLString:[BaseUrl stringByAppendingString:[NSString stringWithFormat:@"get_mycollection?userid=%@",user.userid]]
                                                parameters:nil
                                                   success:^(id obj) {
                                                       
                                                       NSDictionary *dictObj = obj[@"data"];
                                                       if (IS_NULL_CLASS(dictObj[@"video"])) {
                                                           return;
                                                       }
                                                       NSArray *wenzhangArr = dictObj[@"video"];
                                                       
                                                       if (IS_NULL_CLASS(wenzhangArr)) {
                                                           return;
                                                       }
                                                       
                                                       NSMutableArray *arrayM = [NSMutableArray array];
                                                       for (int i = 0; i < wenzhangArr.count; i ++) {
                                                           NSDictionary *dict = wenzhangArr[i];
                                                           [arrayM addObject:[huiguErModel huiguShoucangWithDict:dict]];
                                                       }
                                                       
                                                       weakSelf.huiguerArr= arrayM;
                                                       if (weakSelf.huiguerArr.count == 0) {
                                                           weakSelf.imageview.image = GetImage(@"wushoucang");
                                                           weakSelf.imageview.hidden = NO;
                                                       }
                                                       [weakSelf.tableview reloadData];
                                                       
                                                       
                                                   } fail:^(NSError *error) {
                                                       
                                                   }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.huiguerArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Main_Screen_Height/6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseID = @"PassMeetTableCell";
    PassMeetTableCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PassMeetTableCell" owner:nil options:nil] firstObject];
    }
    
    huiguErModel *model = self.huiguerArr[indexPath.row];
    if (!kStringIsEmpty(model.meeting_title)) {
        cell.videoName.text = model.meeting_title;
    }
    if (!kStringIsEmpty(model.meeting_specialist)) {
        cell.videoPerson.text = model.meeting_specialist;
    }
    if (!kStringIsEmpty(model.play_num)) {
        cell.playNum.text = model.play_num;
    }
    if (!kStringIsEmpty(model.comment_num)) {
        cell.talkNum.text = model.comment_num;
    }
    if (!kStringIsEmpty(model.support_num)) {
        cell.goodNum.text = model.support_num;
    }

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //耗时操作
        if (!kStringIsEmpty(model.video_url)) {
            UIImage *image = [UIImage thumbnailImageForVideo:[NSURL URLWithString:model.video_url] atTime:1];
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                cell.videoImage.image = image;
            });
        }
        //cell.videoImage.image = [UIImage thumbnailImageForVideo:[NSURL URLWithString:model.video_url] atTime:1];
        
        
    });

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    huiguErModel *model = [[huiguErModel alloc] init];
    model = self.huiguerArr[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(tableviewDidSelectPageWithIndex2:huiguErModel:)]) {
        [self.delegate tableviewDidSelectPageWithIndex2:indexPath huiguErModel:model];
    }
    
    PlayDetailViewController *vc = [[PlayDetailViewController alloc] init];

    vc.huifuerModel = [[huiguErModel alloc] init];
    vc.huifuerModel = model;
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
