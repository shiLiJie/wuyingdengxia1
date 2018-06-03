//
//  AnswerViewController.m
//  WUYINGDENGXIA
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 医视中国. All rights reserved.
//

#import "AnswerViewController.h"
#import "inputView.h"
#import "IQKeyboardManager.h"

@interface AnswerViewController ()<inputViewDelegate,WKUIDelegate,WKNavigationDelegate,WKWebViewDelegate>
{
    WKUserContentController * userContentController;
}
@property(strong,nonatomic)WKWebView *webView;
//输入框
@property (nonatomic, strong) inputView *input;
//圆角view
@property (weak, nonatomic) IBOutlet UIView *yuanjiaoview;

@property (nonatomic,copy) NSString *inputStr;
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *shoucangBtn;
//是否收藏的标记
@property (nonatomic, assign) BOOL isShoucang;


@end

@implementation AnswerViewController

#pragma mark - UI -
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self.navigationController.navigationBar setHidden:NO];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //view切圆角
    self.yuanjiaoview.layer.cornerRadius = 17;
    self.yuanjiaoview.layer.masksToBounds = YES;//是否切割
    
    //设置网页
    [self setWeb];
    //问题详情
    [self getQuestionDetail];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"WXShare" object:nil];
    // 检查是否装了微信
    if ([WXApi isWXAppInstalled]) {
        
    }
}

//问题详情
-(void)getQuestionDetail{
    
    [[HttpRequest shardWebUtil] getNetworkRequestURLString:[BaseUrl stringByAppendingString:[NSString stringWithFormat:@"get_question_byquesid?quesid=%@",self.questionModel.question_id]]
                                                parameters:nil
                                                   success:^(id obj) {
                                                       if ([obj[@"code"] isEqualToString:SucceedCoder]) {
                                                           
                                                           NSDictionary *dict = obj[@"data"];
                                                           
                                                           if (!kObjectIsEmpty(dict[@"is_collection"])) {
                                                               if ([dict[@"is_collection"] isEqualToString:@"1"]) {
                                                                   [self.shoucangBtn setImage:GetImage(@"yishoucang") forState:UIControlStateNormal];
                                                                   self.isShoucang = YES;
                                                               }else{
                                                                   [self.shoucangBtn setImage:GetImage(@"shoucang") forState:UIControlStateNormal];
                                                                   self.isShoucang = NO;
                                                               }
                                                           }
                                                       }else{
                                                           [MBProgressHUD showError:obj[@"msg"]];
                                                       }
                                                       
    }
                                                      fail:^(NSError *error) {
        
    }];
}



//设置网页
-(void)setWeb{
    //配置环境
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = userContentController;
    //wkweb
    if (kDevice_Is_iPhoneX) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-48-34)configuration:configuration];
    }else{
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-48)configuration:configuration];
    }
    
    _webView.UIDelegate = self;
    
    UserInfoModel *user = [UserInfoModel shareUserModel];
    [user loadUserInfoFromSanbox];
    
    
    switch (self.choosetype) {
        case questionType:
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cloud.yszg.org/Wuyingdengxia/DetailsProblem.html?quesid=%@&userid=%@",self.questionModel.question_id,user.userid]]]];
            break;
            
        case myquestionType:
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cloud.yszg.org/Wuyingdengxia/DetailsProblemMy.html?quesid=%@&userid=%@",self.questionModel.question_id,user.userid]]]];
            break;
            
        default:
            break;
    }

    [self.view addSubview:_webView];
    
    //注册方法
    WKWebViewDelegate * delegateController = [[WKWebViewDelegate alloc]init];
    delegateController.delegate = self;
    
    [userContentController addScriptMessageHandler:delegateController  name:@"asd"];
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

-(NSMutableAttributedString *)setTitle{
    return [self changeTitle:!kStringIsEmpty(self.questionModel.question_title) ? self.questionModel.question_title : @"问题详情"];
//    return [self changeTitle:@"问题详情"];
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

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    if ([message.name isEqualToString:@"asd"]) {
        //做处理
        [self pushToPersonViewWithUserid:message.body];
    }
}
// oc调用JS方法   页面加载完成之后调用
- (void)webView:(WKWebView *)tmpWebView didFinishNavigation:(WKNavigation *)navigation{
    
    //say()是JS方法名，completionHandler是异步回调block
    [_webView evaluateJavaScript:@"asd()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //        NSLog(@"%@",result);
        
    }];
    
    if (_webView.title.length > 0) {
        self.title = _webView.title;
    }
}

//跳转到个人页
-(void)pushToPersonViewWithUserid:(NSString *)userid{
    PersonViewController *publishPerson = [[PersonViewController alloc] init];
    publishPerson.userid = userid;
    [self.navigationController pushViewController:publishPerson animated:YES];
}

- (void)getOrderPayResult:(NSNotification *)notification
{
    // 注意通知内容类型的匹配
    if (notification.object == 0)
    {
        NSLog(@"分享成功");
    }
}


#pragma mark - 私有方法 -
//弹出问答评论导航控制器
- (IBAction)AnswerQuestionClick:(UIButton *)sender {
    
    self.input = [[inputView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen] .bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.input];
    if (self.inputStr.length > 0) {
        self.input.inputTextView.text = self.inputStr;
    }
    self.input.delegate = self;
    [self.input inputViewShow];
}
- (IBAction)shoucang:(UIButton *)sender {
    UserInfoModel *user = [UserInfoModel shareUserModel];
    [user loadUserInfoFromSanbox];

    NSDictionary *dic = @{
                          @"userid":user.userid,
                          @"toid":self.questionModel.question_id,
                          @"type":@"4"
                          };
    
    __weak typeof(self) weakSelf = self;
    if (!self.isShoucang) {
        //收藏
        [[HttpRequest shardWebUtil] postNetworkRequestURLString:[BaseUrl stringByAppendingString:@"post_collection"]
                                                     parameters:dic
                                                        success:^(id obj) {
                                                            if ([obj[@"code"] isEqualToString:SucceedCoder]) {
                                                                weakSelf.isShoucang = YES;
                                                                [sender setImage:GetImage(@"yishoucang") forState:UIControlStateNormal];
                                                            }else{
                                                                
                                                            }
                                                        }
                                                           fail:^(NSError *error) {
                                                               
                                                           }];
    }else{
        //取消收藏
        [[HttpRequest shardWebUtil] postNetworkRequestURLString:[BaseUrl stringByAppendingString:@"post_cel_collect"]
                                                     parameters:dic
                                                        success:^(id obj) {
                                                            if ([obj[@"code"] isEqualToString:SucceedCoder]) {
                                                                weakSelf.isShoucang = NO;
                                                                [sender setImage:GetImage(@"shoucang") forState:UIControlStateNormal];
                                                            }else{
                                                                
                                                            }
                                                        }
                                                           fail:^(NSError *error) {
                                                               
                                                           }];
    }
    
}
- (IBAction)zhuanfa:(UIButton *)sender {
    
    UserInfoModel *user = [UserInfoModel shareUserModel];
    [user loadUserInfoFromSanbox];
    
    WXMediaMessage * message = [WXMediaMessage message];
    message.title = self.questionModel.question_title;
    message.description = self.questionModel.question_content;
    //    [message setThumbImage:[UIImage imageNamed:self.model.article_img_path]];
    
    WXWebpageObject * webpageObject = [WXWebpageObject object];
    switch (self.choosetype) {
        case questionType:
            webpageObject.webpageUrl = [NSString stringWithFormat:@"http://cloud.yszg.org/Wuyingdengxia/DetailsProblem.html?quesid=%@&userid=%@",self.questionModel.question_id,user.userid];
            break;
            
        case myquestionType:
            webpageObject.webpageUrl = [NSString stringWithFormat:@"http://cloud.yszg.org/Wuyingdengxia/DetailsProblemMy.html?quesid=%@&userid=%@",self.questionModel.question_id,user.userid];
            break;
            
        default:
            break;
    }
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

#pragma mark - textinput代理 -
-(void)giveText:(NSString *)text{
    self.inputStr = text;
}

- (void)sendText:(NSString *)text{
    UserInfoModel *user = [UserInfoModel shareUserModel];
    [user loadUserInfoFromSanbox];
    NSDictionary *dict = @{
                           @"quesid":self.questionModel.question_id,
                           @"userid":user.userid,
                           @"anwContent":text
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:[BaseUrl stringByAppendingString:@"post_anwser"] parameters:dict success:^(id obj) {
        if ([obj[@"code"] isEqualToString:SucceedCoder]) {
            
            [MBProgressHUD showSuccess:obj[@"msg"]];
        }else{
            [MBProgressHUD showError:obj[@"msg"]];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"评论失败"];
    }];
    
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
