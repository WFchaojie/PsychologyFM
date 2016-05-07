//
//  SpeakViewController.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/5/3.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "SpeakListViewController.h"
#import "URLViewController.h"
#import "FMViewController.h"
#import "CategroyViewController.h"
#import "HeadCell.h"
#import "FooterCell.h"
#import "RecommendCell.h"
#import "SpeakCell.h"
#import "SpeakIntroductionViewController.h"
#import "SpeakViewController.h"

@interface SpeakListViewController ()<UITableViewDataSource,UITableViewDelegate,MoreNewLesson,PassUser>

@property (nonatomic,strong) UITableView *FMTableView;
@property (nonatomic,strong) NSArray *headArray;
@property (nonatomic,strong) NSArray *hotSpeakArray;
@property (nonatomic,strong) NSArray *newestSpeakArray;
@property (nonatomic,strong) UIScrollView *headScrolView;
@property (nonatomic,assign) NSInteger offset;

@end

@implementation SpeakListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self leftButtonWithImage:@"back.png"];
    [self rightButtonWithImage:@"littlePlaying1.png"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _offset = 0;
    self.title = @"发现主播";
    
    [self createTableView];
    
    [self addNotification];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadDataFinish) name:Home_Speak object:nil];

    [self downLoadNetWork];
    [self downLoadHotSpeakData];
    // Do any additional setup after loading the view.
}

-(void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadHotSpeakFinish) name:Speak_hot(_offset) object:nil];
}

-(void)downLoadHotSpeakFinish
{
    if (_offset != 0) {
        _hotSpeakArray = [_hotSpeakArray arrayByAddingObjectsFromArray:[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Speak_hot(_offset)]];

    }else
    {
        _hotSpeakArray = [[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Speak_hot(_offset)];
    }
    
    [_FMTableView reloadData];
}

-(void)downLoadHotSpeakData
{
    [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Speak_hot(_offset) and:1];
}

//请求下载数据
-(void)downLoadNetWork
{
    [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Home_Speak and:0];
}

//创建header
-(void)createHeader
{
    if (!_headScrolView) {
        _headScrolView=[[UIScrollView alloc]init];
        _headScrolView.frame=CGRectMake(0, 0, self.view.bounds.size.width, 288.0/720.0*self.view.bounds.size.width);
        _FMTableView.tableHeaderView=_headScrolView;
        _headScrolView.pagingEnabled=YES;
        _headScrolView.showsHorizontalScrollIndicator=NO;
        _headScrolView.showsVerticalScrollIndicator=NO;
    }
    
    if (_headArray.count) {
        _headScrolView.contentSize=CGSizeMake(self.view.bounds.size.width*_headArray.count, 0);
        for (int i=0; i<_headArray.count; i++) {
            NSDictionary *headDict=[_headArray objectAtIndex:i];
            UIImageView *pic=[[UIImageView alloc]init];
            pic.frame=CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, _headScrolView.bounds.size.height);
            [pic sd_setImageWithURL:[headDict objectForKey:@"cover"] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            [_headScrolView addSubview:pic];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=pic.bounds;
            [button addTarget:self action:@selector(scrollViewClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=100+i;
            [pic addSubview:button];
            pic.userInteractionEnabled=YES;
        }
    }
}

//滚动视图被点击
-(void)scrollViewClick:(UIButton *)button
{
    //NSLog(@"%@",self.navigationController);
    NSDictionary *headDict=[_headArray objectAtIndex:button.tag-100];
    if ([[headDict objectForKey:@"type"]isEqualToString:@"url"]) {
        URLViewController *url=[[URLViewController alloc]init];
        url.URL=[headDict objectForKey:@"value"];
        [self.navigationController pushViewController:url animated:YES];
    }else if ([[headDict objectForKey:@"type"] isEqualToString:@"fm"])
    {
        FMViewController *fm=[[FMViewController alloc]init];
        fm.value=[headDict objectForKey:@"value"];
        [self.navigationController pushViewController:fm animated:YES];
    }else if ([[headDict objectForKey:@"type"]isEqualToString:@"outurl"])
    {
        [[UIApplication sharedApplication ] openURL: [NSURL URLWithString:[headDict objectForKey:@"value"]]];
    }else if ([[headDict objectForKey:@"type"]isEqualToString:@"tag"])
    {
        CategroyViewController *cate = [[CategroyViewController alloc]init];
        cate.cId = [headDict objectForKey:@"id"];
        cate.cTitle = [headDict objectForKey:@"title"];
        cate.cTag = @"tag";
        cate.cValue = [headDict objectForKey:@"value"];
        
        [self.navigationController pushViewController:cate animated:YES];
    }
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
        _FMTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        
        
        // 上拉刷新
        _FMTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            _offset+=10;
            [self addNotification];
            [self downLoadHotSpeakData];
                        
        }];

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row == 0) {
            static NSString *cellIde=@"FMRecommend";
            HeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[HeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            cell.headView.subjectLabel.text=@"新晋主播";
            cell.headView.colorView.backgroundColor=[UIColor colorWithRed:0.94 green:0.47 blue:0.5 alpha:1];
            return cell;
        }
        
        else if (indexPath.row==2)
        {
            static NSString *cellIde=@"Footer";
            FooterCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[FooterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            cell.section = indexPath.section;
            return cell;
        }
        else
        {
            static NSString *cellIde=@"Recommand";
            RecommendCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[RecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.delegate=self;
            }
            cell.diantai=_newestSpeakArray;
            
            return cell;
        }
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            static NSString *cellIde=@"HotRecommend";
            HeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[HeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            cell.headView.subjectLabel.text=@"热门主播";
            cell.headView.colorView.backgroundColor=[UIColor colorWithRed:0.94 green:0.47 blue:0.5 alpha:1];
            return cell;
        }
        else
        {
            static NSString *cellIde=@"NewFM";
            SpeakCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[SpeakCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            cell.sTitle=@"";
            cell.sContent=@"";
            cell.sCover=@"";
            cell.sFmnum=@"";
            NSDictionary *dict=[_hotSpeakArray objectAtIndex:indexPath.row-1];
            
            cell.sCover=[dict objectForKey:@"cover"];
            cell.sFmnum=[dict objectForKey:@"fmnum"];
            cell.sContent=[dict objectForKey:@"content"];
            cell.sTitle=[dict objectForKey:@"title"];

            return cell;
        }
    }
    else
    {
        static NSString *cellIde=@"category";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        return cell;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 3;
    }else
    {
        return _hotSpeakArray.count+1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//全部数据 一个接口
-(void)downLoadDataFinish
{
    NSDictionary *dict=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Home_Speak];
    
    _headArray = [dict objectForKey:@"tuijian"];
    _newestSpeakArray = [dict objectForKey:@"newlist"];
    
    [self createHeader];

    _FMTableView.alpha=1;
    [_FMTableView reloadData];
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 40;
        }else if (indexPath.row==1)
        {
            return ((self.view.bounds.size.width-40)-25*3)/4+35;
        }
        else
            return 60;
    }else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            return 40;
        }else
            return 80;
    }
    else
        return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[_hotSpeakArray objectAtIndex:indexPath.row-1];

    SpeakViewController *speak = [[SpeakViewController alloc]init];
    speak.sId = [dict objectForKey:@"id"];
    [self.navigationController pushViewController:speak animated:YES];
}

-(void)userClick:(NSInteger)index
{
    SpeakViewController *speak = [[SpeakViewController alloc]init];
    speak.sId = [NSString stringWithFormat:@"%ld",(long)index];
    [self.navigationController pushViewController:speak animated:YES];
}

-(void)moreNewLessonClick:(NSInteger)section
{
    if (section == 0) {
        SpeakIntroductionViewController *ca =[[SpeakIntroductionViewController alloc]init];
        [self.navigationController pushViewController:ca animated:YES];
    }
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
