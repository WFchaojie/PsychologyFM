//
//  ViewController.m
//  PsychologyFM
//
//  Created by 武超杰 on 15/11/17.
//  Copyright © 2015年 武超杰. All rights reserved.
//

#import "HomeViewController.h"
#import "URLViewController.h"
#import "FMViewController.h"
#import "CategoryCell.h"
#import "HotRecommendCell.h"
#import "NewLessonCell.h"
#import "FooterCell.h"
#import "HeadCell.h"
#import "RecommendCell.h"
#import "CategroyViewController.h"
#import "SpeakListViewController.h"
#import "SpeakViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,CategoryClick,HotClick,PassUser,MoreNewLesson>

@property(nonatomic,strong)UITableView *FMTableView;
@property(nonatomic,strong)NSArray *headArray;
@property(nonatomic,strong)UIScrollView *headScrolView;
@property(nonatomic,strong)NSDictionary *rootDict;
@property(nonatomic,strong)NSArray *categoryArray;
@property(nonatomic,strong)NSArray *hotFMArray;
@property(nonatomic,strong)NSArray *lessonArray;
@property(nonatomic,strong)NSArray *nFMArray;
@property(nonatomic,strong)NSArray *diantaiArray;
@property(nonatomic,strong)NSUserActivity *activity;
@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];

    self.automaticallyAdjustsScrollViewInsets=NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadFinish) name:HTTP_NET_URL object:nil];
    [self downLoadNetWork];
    
    _activity=[[NSUserActivity alloc]initWithActivityType:@"Imitater.PsychologyFM"];
    _activity.title=@"心理FM";
    _activity.keywords=[NSSet setWithObjects:@"郁闷",@"FM",@"不开心",@"治愈系广播",nil];
    _activity.eligibleForSearch=YES;
    [_activity becomeCurrent];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

//全部数据 一个接口
-(void)downLoadFinish
{
    _rootDict=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:HTTP_NET_URL];
    _headArray=[_rootDict objectForKey:@"tuijian"];
    _categoryArray=[_rootDict objectForKey:@"category"];
    _hotFMArray=[_rootDict objectForKey:@"hotfm"];
    _lessonArray=[_rootDict objectForKey:@"newlesson"];
    _nFMArray=[_rootDict objectForKey:@"newfm"];
    _diantaiArray=[_rootDict objectForKey:@"diantai"];

    [self createHeader];
    _FMTableView.alpha=1;
    [_FMTableView reloadData];
}

//创建header
-(void)createHeader
{
    if (!_headScrolView) {
        _headScrolView=[[UIScrollView alloc]init];
        _headScrolView.frame=CGRectMake(0, 0, self.view.bounds.size.width, 320.0/640.0*self.view.bounds.size.width);
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

//请求下载数据
-(void)downLoadNetWork
{
    [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:HTTP_NET_URL and:0];
}

-(void)createTableView
{
    if(!_FMTableView)
    {
        _FMTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49) style:UITableViewStylePlain];
        _FMTableView.delegate=self;
        _FMTableView.dataSource=self;
        [self.view addSubview:_FMTableView];
        _FMTableView.alpha=0;
        _FMTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
}

//category delegate
-(void)categoryClick:(NSInteger)tag
{
    NSLog(@"category tag=%ld",(long)tag);
    CategroyViewController *ca = [[CategroyViewController alloc]init];
    ca.cId = [NSString stringWithFormat:@"%ld",(long)tag];
    ca.cTag = @"0";
    [self.navigationController pushViewController:ca animated:YES];
}

-(void)hotClick:(NSInteger)tag
{
    NSLog(@"hot tag=%ld",(long)tag);
    NSDictionary *dict=[_hotFMArray objectAtIndex:tag];
    FMViewController *fm=[[FMViewController alloc]init];
    fm.value=[dict objectForKey:@"object_id"];
    NSMutableArray *valueArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    for (NSDictionary *dictionary in _hotFMArray) {
        [valueArray addObject:[dictionary objectForKey:@"object_id"]];
    }
    fm.valueArray=valueArray;
    
    [self.navigationController pushViewController:fm animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellIde=@"category";
        CategoryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[CategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.delegate=self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.categoryArray=_categoryArray;
        return cell;
    }else if (indexPath.section==1)
    {
        static NSString *cellIde=@"HotRecommend";
        HotRecommendCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[HotRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;

        }
        cell.hotFM=_hotFMArray;
        return cell;
    }else if (indexPath.section==2)
    {
        if (indexPath.row==0) {
            static NSString *cellIde=@"HotRecommend";
            HeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[HeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;

            }
            cell.headView.subjectLabel.text=@"最新心理课";
            cell.headView.colorView.backgroundColor=[UIColor colorWithRed:0.42 green:0.81 blue:0.7 alpha:1];
            return cell;
        }else if (indexPath.row==_lessonArray.count+1)
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
            static NSString *cellIde=@"NewLesson";
            NewLessonCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[NewLessonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            cell.cellName=@"";
            cell.cellPic=@"";
            cell.cellTitle=@"";
            NSDictionary *dict=[_lessonArray objectAtIndex:indexPath.row-1];
            
            cell.cellPic=[dict objectForKey:@"cover"];
            cell.cellTitle=[dict objectForKey:@"title"];
            cell.cellName=[dict objectForKey:@"speak"];

            return cell;
        }
    }else if (indexPath.section==3)
    {
        if (indexPath.row==0) {
            static NSString *cellIde=@"HotRecommend";
            HeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[HeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            cell.headView.subjectLabel.text=@"最新FM";
            cell.headView.colorView.backgroundColor=[UIColor colorWithRed:0.94 green:0.47 blue:0.5 alpha:1];
            return cell;
        }else if (indexPath.row==_nFMArray.count+1)
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
            static NSString *cellIde=@"NewFM";
            NewLessonCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[NewLessonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            cell.cellName=@"";
            cell.cellPic=@"";
            cell.cellTitle=@"";
            NSDictionary *dict=[_nFMArray objectAtIndex:indexPath.row-1];
            
            cell.cellPic=[dict objectForKey:@"cover"];
            cell.cellTitle=[dict objectForKey:@"title"];
            cell.cellName=[dict objectForKey:@"speak"];
            
            return cell;
        }
    }else if (indexPath.section==4)
    {
        if (indexPath.row==0) {
            static NSString *cellIde=@"FMRecommend";
            HeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
            if (!cell) {
                cell=[[HeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            cell.headView.subjectLabel.text=@"心理电台推荐";
            cell.headView.colorView.backgroundColor=[UIColor colorWithRed:0.94 green:0.47 blue:0.5 alpha:1];
            return cell;
        }else if (indexPath.row==2)
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
            cell.diantai=_diantaiArray;
            
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 70*2+30;
    }else if (indexPath.section==1)
    {
        return (self.view.bounds.size.width-12*4)/3+40+25;
    }else if (indexPath.section==2)
    {
        if (indexPath.row==0) {
            return 40;
        }else
            return 60;
    }else if (indexPath.section==3)
    {
        if (indexPath.row==0) {
            return 40;
        }else
            return 60;
    }else if (indexPath.section==4)
    {
        if (indexPath.row==0) {
            return 40;
        }else if (indexPath.row==1)
        {
            return ((self.view.bounds.size.width-40)-25*3)/4+35;
        }
        else
            return 60;
    }
    else
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2||section==3) {
        return _lessonArray.count+2;
    }else if (section==4)
    {
        return 3;
    }
    else
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        if (indexPath.row!=0) {
            if (indexPath.row==_lessonArray.count+1) {
                
            }else
            {
                NSDictionary *dict=[_lessonArray objectAtIndex:indexPath.row-1];
                FMViewController *fm=[[FMViewController alloc]init];
                fm.value=[dict objectForKey:@"object_id"];
                [self.navigationController pushViewController:fm animated:YES];
            }
        }
    }else if (indexPath.section==3)
    {
        if (indexPath.row!=0) {
            if (indexPath.row==_nFMArray.count+1) {
                
            }else
            {
                NSDictionary *dict=[_nFMArray objectAtIndex:indexPath.row-1];
                FMViewController *fm=[[FMViewController alloc]init];
                fm.value=[dict objectForKey:@"object_id"];
                [self.navigationController pushViewController:fm animated:YES];
            }
        }
    }
}

#pragma mark PassUserDelegate
-(void)userClick:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    SpeakViewController *speak = [[SpeakViewController alloc]init];
    speak.sId = [NSString stringWithFormat:@"%ld",(long)index];
    [self.navigationController pushViewController:speak animated:YES];
}


-(void)moreNewLessonClick:(NSInteger)section
{
    if (section == 2) {
        CategroyViewController *cate = [[CategroyViewController alloc]init];
        cate.cTitle = @"最新心理课";
        cate.cTag = @"newlesson";
        
        [self.navigationController pushViewController:cate animated:YES];
    }else if (section == 3)
    {
        CategroyViewController *cate = [[CategroyViewController alloc]init];
        cate.cTitle = @"最新FM";
        cate.cTag = @"newfm";
        
        [self.navigationController pushViewController:cate animated:YES];
    }else if (section==4)
    {
        SpeakListViewController *speak = [[SpeakListViewController alloc]init];
        [self.navigationController pushViewController:speak animated:YES];
    }

}






@end
