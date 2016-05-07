//
//  CommunityViewController.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/4/26.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityCell.h"
#import "CommunityDetailViewController.h"

@interface CommunityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *FMTableView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger hotOffSet;
@property(nonatomic,assign)NSInteger newOffSet;

@end

@implementation CommunityViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden=NO;
    self.tabBarController.tabBar.hidden = NO;
    [self createSelectButton];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 0;
    _hotOffSet = 0;
    _newOffSet = 0;
    
    [self leftButtonWithImage:@"PostEdit.png"];
    
    [self rightButtonWithImage:@"littlePlaying1.png"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
    
    [self addNotification];
    
    [self downLoadHotData];


    // Do any additional setup after loading the view.
}

-(void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadHotFinish) name:Community_Hot(_hotOffSet) object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadNewFinish) name:Community_New(_newOffSet) object:nil];
}

-(void)createSelectButton
{
    UISegmentedControl *segment = [[UISegmentedControl alloc]init];
    segment.frame = CGRectMake(self.view.bounds.size.width/2-60, 3, 120, 30);
    [self.navigationController.navigationBar addSubview:segment];
    [segment insertSegmentWithTitle:@"精华" atIndex:0 animated:NO];
    [segment insertSegmentWithTitle:@"最新" atIndex:1 animated:NO];
    segment.tintColor = [UIColor colorWithRed:0.95 green:0.62 blue:0.40 alpha:1.00];
    segment.selectedSegmentIndex = _index;
    [segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
}

-(void)segmentChange:(UISegmentedControl *)segment
{
    _index = segment.selectedSegmentIndex;
    [_FMTableView.mj_header executeRefreshingCallback];
}

//全部数据 一个接口
-(void)downLoadHotFinish
{
    if (_hotOffSet!=0) {
       _dataArray = [_dataArray arrayByAddingObjectsFromArray:[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Community_Hot(_hotOffSet)]];
        NSLog(@"%@",_dataArray);

    }else
    {
        _dataArray=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Community_Hot(_hotOffSet)];
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


//请求下载数据
-(void)downLoadHotData
{
    [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Community_Hot(_hotOffSet) and:1];

}

-(void)downLoadNewFinish
{
    if (_newOffSet !=0) {
        _dataArray=[_dataArray arrayByAddingObjectsFromArray:[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Community_New(_newOffSet)]];
    }else
    {
        _dataArray=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Community_New(_newOffSet)];
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

-(void)downLoadNewData
{
    [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Community_New(_newOffSet) and:1];
    
}

-(void)createTableView
{
    if(!_FMTableView)
    {
        _FMTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-49-64) style:UITableViewStylePlain];
        _FMTableView.delegate=self;
        _FMTableView.dataSource=self;
        [self.view addSubview:_FMTableView];
        _FMTableView.alpha=0;
        _FMTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        // 下拉刷新
        _FMTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            if (_index == 0) {
                [self downLoadHotData];
            }else if (_index == 1)
            {
                [self downLoadNewData];
            }

        }];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _FMTableView.mj_header.automaticallyChangeAlpha = YES;
        
        // 上拉刷新
        _FMTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (_index == 0) {
                _hotOffSet+=10;
                [self addNotification];
                [self downLoadHotData];
            }else if (_index == 1)
            {
                _newOffSet+=10;
                [self addNotification];
                [self downLoadNewData];
            }


        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    cell.userPic = [[dict objectForKey:@"user"] objectForKey:@"avatar"];
    cell.userNickName = [[dict objectForKey:@"user"] objectForKey:@"nickname"];
    cell.updated = [dict objectForKey:@"updated"];
    cell.title = [dict objectForKey:@"title"];
    cell.content = [dict objectForKey:@"content"];
    cell.images = [dict objectForKey:@"images"];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDict = [_dataArray objectAtIndex:indexPath.row];
    NSString *string=[dataDict objectForKey:@"content"];
    CGSize size=CGSizeMake(self.view.bounds.size.width-10*2, 1000);
    UIFont *font=[UIFont systemFontOfSize:14];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize actualSize=[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    if([[dataDict objectForKey:@"images"] count]!=0)
    {
        return actualSize.height + 40 +40 +35 + 100 +10;
    }else
        
    return actualSize.height + 40 +40 +35;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    CommunityDetailViewController *de= [[CommunityDetailViewController alloc]init];
    de.ID = [dict objectForKey:@"id"];
    [self.navigationController pushViewController:de animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
