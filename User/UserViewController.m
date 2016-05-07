//
//  UserViewController.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/4/26.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

-(void)setUpUI
{
    UIImageView *headImageView= [[UIImageView alloc]init];
    headImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 150);
    headImageView.image = [UIImage imageNamed:@"bg1.png"];
    [self.view addSubview:headImageView];
    
    UIImageView *people = [[UIImageView alloc]init];
    people.image = [UIImage imageNamed:@"fm50.png"];
    people.frame = CGRectMake(self.view.bounds.size.width/2-30, headImageView.bounds.size.height-30, 60, 60);
    people.layer.cornerRadius = 30;
    people.clipsToBounds = YES;
    [self.view addSubview:people];
    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.backgroundColor = [UIColor colorWithRed:0.95 green:0.62 blue:0.40 alpha:1.00];
    login.clipsToBounds = YES;
    login.layer.cornerRadius = 10;
    login.frame = CGRectMake(20, people.frame.origin.y + people.frame.size.height +10, self.view.bounds.size.width - 40, 40);
    [self.view addSubview:login];
    [login addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [login setTitle:@"登陆" forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [login setTintColor:[UIColor whiteColor]];
    
    UILabel *hint = [[UILabel alloc]init];
    hint.frame = CGRectMake(0, login.frame.origin.y + login.frame.size.height , self.view.bounds.size.width, 30);
    hint.textColor = [UIColor grayColor];
    hint.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:hint];
    hint.text = @"登陆后可收藏，下载节目，与主播私信！";
    hint.textAlignment = NSTextAlignmentCenter;
}

-(void)loginClick
{
    
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
