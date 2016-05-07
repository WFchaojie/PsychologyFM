//
//  SpeakIntroductionViewController.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/5/4.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "SpeakIntroductionViewController.h"
#import "SpeakCategoryCell.h"
#import "SpeakViewController.h"

@interface SpeakIntroductionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *FMTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) NSInteger offset;
@end

@implementation SpeakIntroductionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self leftButtonWithImage:@"back.png"];
    [self rightButtonWithImage:@"littlePlaying1.png"];
    self.title = @"新晋主播";
    
    _offset = 0;
    
    [self addNotification];
    
    [self downLoadData];
    
    [self createTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

-(void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadDataFinish) name:Speak_New(_offset) object:nil];
}

//全部数据 一个接口
-(void)downLoadDataFinish
{
    if (_offset!=0) {
        _dataArray = [_dataArray arrayByAddingObjectsFromArray:[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Speak_New(_offset)]];
    }else
    {
        _dataArray=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Speak_New(_offset)];
    }
    
    _FMTableView.alpha=1;
    [_FMTableView reloadData];
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//请求下载数据
-(void)downLoadData
{
    [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Speak_New(_offset) and:1];
    
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
            _offset = 0;
            [self downLoadData];

        }];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _FMTableView.mj_header.automaticallyChangeAlpha = YES;
        
        // 上拉刷新
        _FMTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            _offset+=10;
            [self addNotification];
            [self downLoadData];
            
        }];

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde=@"speakCategory";
    SpeakCategoryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[SpeakCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.cCover = @"";
    cell.cTitle = @"";
    cell.cContent = @"";
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    
    cell.cCover = [dict objectForKey:@"cover"];
    cell.cTitle = [dict objectForKey:@"title"];
    cell.cContent = [dict objectForKey:@"content"];
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    SpeakViewController *fm=[[SpeakViewController alloc]init];
    fm.sId=[dict objectForKey:@"id"];
    [self.navigationController pushViewController:fm animated:YES];
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
