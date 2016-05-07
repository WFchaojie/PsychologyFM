//
//  TabbarViewController.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/4/26.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "TabbarViewController.h"
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "UserViewController.h"
#import "CommunityViewController.h"
@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self config];
    
    // Do any additional setup after loading the view.
}

-(void)config
{
    self.tabBar.barTintColor = [UIColor colorWithRed:0.22 green:0.24 blue:0.25 alpha:1.00];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0], NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0],  NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];

    HomeViewController *home = [[HomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:home];
    homeNav.tabBarItem.title = @"首页";
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"shouyeSelectedXiong1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.image = [[UIImage imageNamed:@"shouyeXiong1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    /*
     urL不可用
    SearchViewController *search = [[SearchViewController alloc]init];
    search.tabBarItem.title = @"发现";
    search.tabBarItem.selectedImage = [[UIImage imageNamed:@"faxianSelectedXiong1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    search.tabBarItem.image = [[UIImage imageNamed:@"faxianXiong1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    search.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
*/
    CommunityViewController *community = [[CommunityViewController alloc]init];
    UINavigationController *communityNav = [[UINavigationController alloc]initWithRootViewController:community];
    communityNav.tabBarItem.title = @"社区";
    communityNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"shequSelectedXiong1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    communityNav.tabBarItem.image = [[UIImage imageNamed:@"shequXiong1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    communityNav.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);

    UserViewController *user = [[UserViewController alloc]init];
    UINavigationController *userNav = [[UINavigationController alloc]initWithRootViewController:user];
    userNav.tabBarItem.title = @"我的";
    userNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"mySelectedXiong1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userNav.tabBarItem.image = [[UIImage imageNamed:@"myXiong1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userNav.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);

    SettingViewController *setting = [[SettingViewController alloc]init];
    UINavigationController *settingNav = [[UINavigationController alloc]initWithRootViewController:setting];
    settingNav.tabBarItem.title = @"设置";
    settingNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"shezhiSelectedXiong1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    settingNav.tabBarItem.image = [[UIImage imageNamed:@"shezhiXiong1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    settingNav.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);

    self.viewControllers = @[homeNav,communityNav,userNav,settingNav];
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
