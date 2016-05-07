//
//  CommunityDetailViewController.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/5/5.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "CommunityDetailViewController.h"
#import "CommunityCell.h"
#import "CommentCell.h"

@interface CommunityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) NSInteger offset;
@property (nonatomic,strong) NSDictionary *userDict;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UITableView *FMTableView;

@end

@implementation CommunityDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden=NO;
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    for (UISegmentedControl *control in self.navigationController.navigationBar.subviews) {
        if ([control isKindOfClass:[UISegmentedControl class]]) {
            [control removeFromSuperview];
        }
    }
    [self leftButtonWithImage:@"back.png"];
    [self rightButtonWithImage:@"littlePlaying1.png"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
    
    
    [self addNotification];
    [self downLoadUserData];
    [self downLoadCommentData];
    
    // Do any additional setup after loading the view.
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadUserFinish) name:Community_User(_ID) object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadNewFinish) name:Community_Comment(_ID, _offset) object:nil];
}

//请求下载数据
-(void)downLoadCommentData
{
    [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Community_Comment(_ID, _offset) and:1];
    
}

-(void)downLoadUserData
{
    [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Community_User(_ID) and:1];
    
}

-(void)downLoadNewFinish
{
    if (_offset !=0) {
        _dataArray=[_dataArray arrayByAddingObjectsFromArray:[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Community_Comment(_ID, _offset)]];
    }else
    {
        _dataArray=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Community_Comment(_ID, _offset)];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_FMTableView.mj_header.isRefreshing) {
            [_FMTableView.mj_header endRefreshing];
        }
        
        if (_FMTableView.mj_footer.isRefreshing) {
            [_FMTableView.mj_footer endRefreshing];
        }
        _FMTableView.alpha=1;
        [_FMTableView reloadData];
    });
    
}
//全部数据 一个接口
-(void)downLoadUserFinish
{
    _userDict=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Community_User(_ID)];
    
    _FMTableView.alpha=1;
    [_FMTableView reloadData];
    
}

-(void)createTableView
{
    if(!_FMTableView)
    {
        _FMTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
        _FMTableView.delegate=self;
        _FMTableView.dataSource=self;
        [self.view addSubview:_FMTableView];
        _FMTableView.alpha=0;
        _FMTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        
        // 下拉刷新
        _FMTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self downLoadCommentData];
        }];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _FMTableView.mj_header.automaticallyChangeAlpha = YES;
        
        // 上拉刷新
        _FMTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            _offset+=10;
            [self addNotification];
            [self downLoadCommentData];
            
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellIde=@"community";
        CommunityCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[CommunityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.userPic = @"";
        cell.userNickName = @"";
        cell.updated = @"";
        cell.title = @"";
        cell.content = @"";
        cell.images = nil;
        
        NSDictionary *dict = _userDict;
        cell.userPic = [[dict objectForKey:@"user"] objectForKey:@"avatar"];
        cell.userNickName = [[dict objectForKey:@"user"] objectForKey:@"nickname"];
        cell.updated = [dict objectForKey:@"updated"];
        cell.title = [dict objectForKey:@"title"];
        cell.content = [dict objectForKey:@"content"];
        cell.images = [dict objectForKey:@"images"];
        return cell;
    }else
    {
        static NSString *cellIde=@"comment";
        CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.cTitle =@"";
        cell.content =@"";
        cell.cover =@"";
        cell.time =@"";
        
        NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row -1];
        
        cell.cTitle = [NSString stringWithFormat:@"%@楼 %@",[dict objectForKey:@"floor"],[[dict objectForKey:@"user"] objectForKey:@"nickname"]];
        cell.content = [dict objectForKey:@"content"];
        cell.cover = [[dict objectForKey:@"user"] objectForKey:@"avatar"];
        cell.time = [dict objectForKey:@"created"];
        
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        NSString *string=[_userDict objectForKey:@"content"];
        CGSize size=CGSizeMake(self.view.bounds.size.width-10*2, 1000);
        UIFont *font=[UIFont systemFontOfSize:14];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        if([[_userDict objectForKey:@"images"] count]!=0)
        {
            return actualSize.height + 40 +40 +35 + 100 +10;
        }else
            
            return actualSize.height + 40 +40 +35;
    }else
    {
        NSDictionary *dataDict = [_dataArray objectAtIndex:indexPath.row - 1];
        NSString *string=[dataDict objectForKey:@"content"];
        CGSize size=CGSizeMake(self.view.bounds.size.width-10*2-30, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        return actualSize.height + 25 + 20 +20;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count + 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
