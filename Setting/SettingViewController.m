//
//  SettingViewController.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/4/26.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property(nonatomic,strong) UITableView *FMTableView;
@property(nonatomic,strong) UIView *bottomView;

@end

@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self rightButtonWithImage:@"littlePlaying1.png"];
    [self firstPart];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

-(void)firstPart
{
    UIImageView *login =[[UIImageView alloc]init];
    login.frame = CGRectMake(10 ,64 + 20, self.view.bounds.size.width - 20, 60);
    login.image = [UIImage imageNamed:@"changePicBackground.png"];
    [self.view addSubview:login];
    
    UIImageView *loginUser = [[UIImageView alloc]init];
    loginUser.image = [UIImage imageNamed:@"fm100.png"];
    loginUser.frame = CGRectMake(10, 5, 50, 50);
    [login addSubview:loginUser];
    loginUser.clipsToBounds = YES;
    loginUser.layer.cornerRadius = 20;
    
    UILabel *loginLabel = [[UILabel alloc]init];
    loginLabel.frame = CGRectMake(loginUser.frame.origin.x + loginUser.frame.size.width + 15, 0, 100, 60);
    loginLabel.text = @"立即登录";
    loginLabel.textColor = [UIColor orangeColor];
    [login addSubview:loginLabel];
    loginLabel.font = [UIFont boldSystemFontOfSize:16];
    
    UILabel *hintLabel = [[UILabel alloc]init];
    hintLabel.textColor = [UIColor grayColor];
    [login addSubview:hintLabel];
    hintLabel.text = @"登录可下载节目";
    hintLabel.frame = CGRectMake(login.frame.size.width - 125, 0, 120, 60);
    hintLabel.font = [UIFont systemFontOfSize:15];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = login.bounds;
    login.userInteractionEnabled = YES;
    [login addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *clock =[[UIImageView alloc]init];
    clock.frame = CGRectMake(10 ,login.frame.origin.y + login.frame.size.height + 20, self.view.bounds.size.width - 20, 100);
    clock.image = [UIImage imageNamed:@"2background.png"];
    [self.view addSubview:clock];
    
    UIImageView *clockTime = [[UIImageView alloc]init];
    clockTime.image = [UIImage imageNamed:@"setTime.png"];
    clockTime.frame = CGRectMake(10, 13, 24, 24);
    [clock addSubview:clockTime];
    
    UIImageView *clockClock = [[UIImageView alloc]init];
    clockClock.image = [UIImage imageNamed:@"clock.png"];
    clockClock.frame = CGRectMake(10, 50+13, 24, 24);
    [clock addSubview:clockClock];
    
    UILabel *clockMotion = [[UILabel alloc]init];
    clockMotion.textColor = [UIColor blackColor];
    [clock addSubview:clockMotion];
    clockMotion.text = @"心情闹钟";
    clockMotion.frame = CGRectMake(clockTime.frame.origin.x + clockTime.frame.size.width + 15, 0, 100, 50);
    clockMotion.font = [UIFont systemFontOfSize:15];
    
    UILabel *clockClose = [[UILabel alloc]init];
    clockClose.textColor = [UIColor blackColor];
    [clock addSubview:clockClose];
    clockClose.text = @"定时关闭";
    clockClose.frame = CGRectMake(clockTime.frame.origin.x + clockTime.frame.size.width + 15, 50, 100, 50);
    clockClose.font = [UIFont systemFontOfSize:15];
    
    UISwitch *change = [[UISwitch alloc]init];
    change.frame = CGRectMake(clock.frame.size.width - 70, 50 + 10, 60, 40);
    [clock addSubview:change];
    clock.userInteractionEnabled = YES;
    [change addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
    
    
    _bottomView = [[UIView alloc]init];
    _bottomView.frame = CGRectMake(0, clock.frame.origin.y + clock.frame.size.height+20, self.view.bounds.size.width , self.view.bounds.size.height - clock.bounds.size.height - login.frame.size.height -20);
    [self.view addSubview:_bottomView];
    
    UIImageView *cache =[[UIImageView alloc]init];
    cache.frame = CGRectMake(10 ,0, self.view.bounds.size.width - 20, 50);
    cache.image = [UIImage imageNamed:@"changePicBackground.png"];
    [_bottomView addSubview:cache];
    
    UIImageView *cacheImage = [[UIImageView alloc]init];
    cacheImage.image = [UIImage imageNamed:@"clearImage.png"];
    cacheImage.frame = CGRectMake(10, 13, 24, 24);
    [cache addSubview:cacheImage];

    
    UILabel *cacheLabel = [[UILabel alloc]init];
    cacheLabel.frame = CGRectMake(cacheImage.frame.origin.x + cacheImage.frame.size.width + 15, 0, 100, 50);
    cacheLabel.text = @"清理图片缓存";
    cacheLabel.textColor = [UIColor blackColor];
    [cache addSubview:cacheLabel];
    cacheLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *cacheHintLabel = [[UILabel alloc]init];
    cacheHintLabel.textColor = [UIColor grayColor];
    [cache addSubview:cacheHintLabel];
    cacheHintLabel.text = @"0M";
    cacheHintLabel.frame = CGRectMake(login.frame.size.width - 125, 0, 110, 50);
    cacheHintLabel.font = [UIFont systemFontOfSize:15];
    cacheHintLabel.textAlignment = NSTextAlignmentRight;
    
    UIButton *cacheButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cacheButton.frame = login.bounds;
    cache.userInteractionEnabled = YES;
    [cache addSubview:cacheButton];
    [cacheButton addTarget:self action:@selector(cacheClick) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *rest =[[UIImageView alloc]init];
    rest.frame = CGRectMake(10 ,cache.frame.origin.y + cache.frame.size.height + 20, self.view.bounds.size.width - 20, 150);
    rest.image = [UIImage imageNamed:@"threeLines.png"];
    [_bottomView addSubview:rest];
    
    UIImageView *restShare = [[UIImageView alloc]init];
    restShare.image = [UIImage imageNamed:@"_0003_share.png"];
    restShare.frame = CGRectMake(10, 13, 24, 24);
    [rest addSubview:restShare];
    
    UIImageView *restFeedBack = [[UIImageView alloc]init];
    restFeedBack.image = [UIImage imageNamed:@"_0002_like.png"];
    restFeedBack.frame = CGRectMake(10, 50+13, 24, 24);
    [rest addSubview:restFeedBack];
    
    UIImageView *restComment = [[UIImageView alloc]init];
    restComment.image = [UIImage imageNamed:@"_0000_pen.png"];
    restComment.frame = CGRectMake(10, 100+13, 24, 24);
    [rest addSubview:restComment];
    
    UILabel *restShareLabel = [[UILabel alloc]init];
    restShareLabel.textColor = [UIColor blackColor];
    [rest addSubview:restShareLabel];
    restShareLabel.text = @"分享给好友";
    restShareLabel.frame = CGRectMake(restShare.frame.origin.x + restShare.frame.size.width + 15, 0, 100, 50);
    restShareLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *restCommentLabel = [[UILabel alloc]init];
    restCommentLabel.textColor = [UIColor blackColor];
    [rest addSubview:restCommentLabel];
    restCommentLabel.text = @"亲~给个好评鼓励下嘛!";
    restCommentLabel.frame = CGRectMake(restFeedBack.frame.origin.x + restFeedBack.frame.size.width + 15, 50, 100, 50);
    restCommentLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *restFeedBackLabel = [[UILabel alloc]init];
    restFeedBackLabel.textColor = [UIColor blackColor];
    [rest addSubview:restFeedBackLabel];
    restFeedBackLabel.text = @"亲~给个好评鼓励下嘛!";
    restFeedBackLabel.frame = CGRectMake(restFeedBack.frame.origin.x + restFeedBack.frame.size.width + 15, 100, 100, 50);
    restFeedBackLabel.font = [UIFont systemFontOfSize:15];
}

-(void)switchChange
{
    
}

-(void)cacheClick
{
    
}

-(void)loginClick
{
    NSLog(@"登陆");
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
