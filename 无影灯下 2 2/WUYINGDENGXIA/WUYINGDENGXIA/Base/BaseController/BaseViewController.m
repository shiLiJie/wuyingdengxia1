//
//  BaseViewController.m
//  ModuleProject
//
//  Created by 李奕辰 on 2017/1/5.
//  Copyright © 2017年 Twinkle. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationBar+Awesome.h"

static NSString* const kURL_Reachability__Address=@"www.baidu.com";

@interface BaseViewController ()
{
    CGFloat navigationY;
    CGFloat navBarY;
    CGFloat verticalY;
    BOOL _isShowMenu;
}
@property CGFloat original_height;
@property (nonatomic,weak) Reachability *hostReach;
@end

@implementation BaseViewController

- (instancetype)init
{
    if (self == [super init]) {
        [self.navigationController setNavigationBarHidden:YES];
        navBarY = 0;
        navigationY = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars=YES;
    [self.navigationController setNavigationBarHidden:NO];
    if ([self respondsToSelector:@selector(backgroundImage)]) {
        UIImage *bgimage = [self navBackgroundImage];
        [self setNavigationBack:bgimage];
    }
    if ([self respondsToSelector:@selector(setTitle)]) {
        NSMutableAttributedString *titleAttri = [self setTitle];
        [self set_Title:titleAttri];
    }
    if (![self leftButton]) {
        [self configLeftBaritemWithImage];
    }
    
    if (![self rightButton]) {
        [self configRightBaritemWithImage];
    }
    
    //监听网络变化
    Reachability *reach = [Reachability reachabilityWithHostName:kURL_Reachability__Address];
    
    self.hostReach = reach;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netStatusChange:) name:kReachabilityChangedNotification object:nil];
    //实现监听
    [reach startNotifier];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(set_colorBackground)]) {
        UIColor *backgroundColor =  [self set_colorBackground];
        UIImage *bgimage = [UIImage imageWithColor:backgroundColor];
        
        [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    }
    
    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //默认显示黑线
    blackLineImageView.hidden = NO;
    if ([self respondsToSelector:@selector(hideNavigationBottomLine)]) {
        if ([self hideNavigationBottomLine]) {
            //隐藏黑线
            blackLineImageView.hidden = YES;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_setTranslationY:0];
}

-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//通知监听回调 网络状态发送改变 系统会发出一个kReachabilityChangedNotification通知，然后会触发此回调方法
- (void)netStatusChange:(NSNotification *)noti{
    //判断网络状态
    switch (self.hostReach.currentReachabilityStatus) {
        case NotReachable:
//            [self showErrorText:@"当前网络连接失败"];
            break;
        case ReachableViaWiFi:
//            YCLog(@"wifi上网");
            break;
        case ReachableViaWWAN:
//            YCLog(@"手机上网");
            break;
        default:
            break;
    }
}


-(void)setNavigationBack:(UIImage*)image
{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:image ];
    [self.navigationController.navigationBar setShadowImage:image];
}

#pragma mark --- NORMAl

-(void)set_Title:(NSMutableAttributedString *)title
{
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    navTitleLabel.numberOfLines = 1;//可能出现多行的标题
    [navTitleLabel setAttributedText:title];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    navTitleLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
    [navTitleLabel addGestureRecognizer:tap];
    self.navigationItem.titleView = navTitleLabel;
}


-(void)titleClick:(UIGestureRecognizer*)Tap
{
    UIView *view = Tap.view;
    if ([self respondsToSelector:@selector(title_click_event:)]) {
        [self title_click_event:view];
    }
}

#pragma mark -- left_item
-(void)configLeftBaritemWithImage
{
    // 替换废弃样式UIBarButtonItemStyleBordered
    if ([self respondsToSelector:@selector(set_leftBarButtonItemWithImage)]) {
        UIImage *image = [self set_leftBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self  action:@selector(left_click:)];
        self.navigationItem.backBarButtonItem = item;
    }
}

-(void)configRightBaritemWithImage
{
    // 替换废弃样式UIBarButtonItemStyleBordered
    if ([self respondsToSelector:@selector(set_rightBarButtonItemWithImage)]) {
        UIImage *image = [self set_rightBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self  action:@selector(right_click:)];
        self.navigationItem.rightBarButtonItem = item;
    }
}


#pragma mark -- left_button
-(BOOL)leftButton
{
    BOOL isleft =  [self respondsToSelector:@selector(set_leftButton)];
    if (isleft) {
        UIButton *leftbutton = [self set_leftButton];
        [leftbutton addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
        leftbutton.contentEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
        self.navigationItem.leftBarButtonItem = item;
    }
    return isleft;
}

#pragma mark -- right_button
-(BOOL)rightButton
{
    BOOL isright = [self respondsToSelector:@selector(set_rightButton)];
    if (isright) {
        self.right_button = [self set_rightButton];
        [self.right_button addTarget:self action:@selector(right_click:) forControlEvents:UIControlEventTouchUpInside];
        self.right_button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -22);
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.right_button];
        
        self.navigationItem.rightBarButtonItem =  item;
    }
    return isright;
}


-(void)left_click:(id)sender
{
    if ([self respondsToSelector:@selector(left_button_event:)]) {
        [self left_button_event:sender];
    }
}

-(void)right_click:(id)sender
{
    if ([self respondsToSelector:@selector(right_button_event:)]) {
        [self right_button_event:sender];
    }
}

-(void)changeNavigationBarHeight:(CGFloat)offset
{
    [UIView animateWithDuration:0.3f animations:^{
        self.navigationController.navigationBar.frame  = CGRectMake(
                                                                    self.navigationController.navigationBar.frame.origin.x,
                                                                    navigationY,
                                                                    self.navigationController.navigationBar.frame.size.width,
                                                                    offset
                                                                    );
    }];
    
}

-(void)changeNavigationBarTranslationY:(CGFloat)translationY
{
    self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, translationY);
}

//找查到Nav底部的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


@end
