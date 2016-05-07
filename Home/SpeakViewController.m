//
//  SpeakViewController.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/5/4.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "SpeakViewController.h"
#import "SpeakPersonCell.h"
#import "FMViewController.h"
#import "HeadCell.h"
@interface SpeakViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *FMTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,assign) NSInteger offset;

@end

@implementation SpeakViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _offset = 0;
    [self addNotification];
    [self downLoadData];
    
    [self createTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBackButton];
    
    
    // Do any additional setup after loading the view.
}

-(void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadHeadFinish) name:Speak_Detail(_sId) object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadListFinish) name:Speak_Show(_offset,_sId) object:nil];
}

-(void)createBackButton
{
    UIButton *follow = [UIButton buttonWithType:UIButtonTypeCustom];
    follow.frame = CGRectMake(10, 25, 24, 24);
    [follow setImage:[UIImage imageNamed:@"broadcasterBack.png"] forState:UIControlStateNormal];
    [self.view addSubview:follow];
    [follow addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)downLoadListFinish
{
    if (_offset!=0) {
        _dataArray = [_dataArray arrayByAddingObjectsFromArray:[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Speak_Show(_offset,_sId)]];
    }else
    {
        _dataArray=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Speak_Show(_offset,_sId)];
    }
    
    _FMTableView.alpha=1;
    [_FMTableView reloadData];
}

//请求下载数据
-(void)downLoadData
{
    [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Speak_Detail(_sId) and:0];
    [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Speak_Show(_offset,_sId) and:1];
}

//全部数据 一个接口
-(void)downLoadHeadFinish
{
    _dataDict=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Speak_Detail(_sId)];
    [self createHead];
}

-(void)createHead
{
    UIView *headView=[[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 230);
    
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(0, 0, self.view.bounds.size.width, 160);
    [image sd_setImageWithURL:[NSURL URLWithString:[_dataDict objectForKey:@"gcover"]]];
    [headView addSubview:image];

    
    UIImageView *userImage = [[UIImageView alloc]init];
    userImage.frame = CGRectMake(10, image.frame.size.height - 55, 44, 44);
    [userImage sd_setImageWithURL:[NSURL URLWithString:[_dataDict objectForKey:@"cover"]]];
    [headView addSubview:userImage];
    userImage.layer.cornerRadius = 22;
    userImage.clipsToBounds = YES;
    userImage.layer.borderWidth = 2;
    userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UILabel *name = [[UILabel alloc]init];
    name.text = [_dataDict objectForKey:@"title"];
    [headView addSubview:name];
    name.frame = CGRectMake(userImage.frame.origin.x*2 +userImage.frame.size.width, userImage.frame.origin.y, 200, userImage.frame.size.height/2);
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = [UIColor whiteColor];
    
    UILabel *viewNum = [[UILabel alloc]init];
    viewNum.text = [NSString stringWithFormat:@"收听 %@ | 关注 %@",[_dataDict objectForKey:@"viewnum"],[_dataDict objectForKey:@"favnum"]];
    [headView addSubview:viewNum];
    viewNum.frame = CGRectMake(userImage.frame.origin.x*2 +userImage.frame.size.width, name.frame.origin.y + name.frame.size.height, 200, userImage.frame.size.height/2);
    viewNum.font = [UIFont systemFontOfSize:13];
    viewNum.textColor = [UIColor whiteColor];
    
    UIButton *follow = [UIButton buttonWithType:UIButtonTypeCustom];
    follow.frame = CGRectMake(headView.frame.size.width - 62 - 10, image.frame.size.height -26 -10, 124/2, 52/2);
    [follow setImage:[UIImage imageNamed:@"unFollow.png"] forState:UIControlStateNormal];
    [headView addSubview:follow];
    [follow addTarget:self action:@selector(followClick) forControlEvents:UIControlEventTouchUpInside];
    _FMTableView.tableHeaderView = headView;
    
    UIImageView *icon = [[UIImageView alloc]init];
    icon.frame = CGRectMake(userImage.frame.origin.x,image.frame.size.height+10, 15, 15);
    [icon setImage:[UIImage imageNamed:@"shenfenPic.png"]];
    [headView addSubview:icon];
    
    UILabel *content = [[UILabel alloc]init];
    content.text = [_dataDict objectForKey:@"content"];
    [headView addSubview:content];
    content.frame = CGRectMake(icon.frame.origin.x*2 +icon.frame.size.width, icon.frame.origin.y-1, self.view.bounds.size.width - icon.frame.origin.x *2 - icon.frame.size.width,30);
    content.font = [UIFont boldSystemFontOfSize:13];
    content.textColor = [UIColor grayColor];
    content.numberOfLines =2;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:[_dataDict objectForKey:@"content"]];
    
    NSMutableParagraphStyle*style = [[NSMutableParagraphStyle alloc]init];
    
    //style.headIndent = 30; //缩进
    
    //style.firstLineHeadIndent = 0;
    
    style.lineSpacing=5;//行距
    
    //style.alignment=NSTextAlignmentCenter;
    
    //需要设置的范围
    
    NSRange range =NSMakeRange(0,[[_dataDict objectForKey:@"content"] length]);
    
    [text addAttribute:NSParagraphStyleAttributeName value:style range:range];
    
    content.attributedText= text;
    
    [content sizeToFit];
    
    UIView *gray = [[UIView alloc]init];
    gray.frame = CGRectMake(0, headView.bounds.size.height -10, headView.frame.size.width, 10);
    gray.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [headView addSubview:gray];
    
}

-(void)followClick
{
    
}

-(void)createTableView
{
    if(!_FMTableView)
    {
        _FMTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _FMTableView.delegate=self;
        _FMTableView.dataSource=self;
        [self.view addSubview:_FMTableView];
        _FMTableView.alpha=0;
        _FMTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [self setExtraCellLineHidden:_FMTableView];
        if ([_FMTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_FMTableView setSeparatorInset: UIEdgeInsetsZero];
        }
        if ([_FMTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_FMTableView setLayoutMargins: UIEdgeInsetsZero];
        }
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
    
    if (indexPath.row==0) {
        static NSString *cellIde=@"title";
        HeadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[HeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        cell.headView.subjectLabel.text=[NSString stringWithFormat:@"全部节目(%lu)",(unsigned long)_dataArray.count];
        cell.headView.colorView.backgroundColor=[UIColor colorWithRed:0.94 green:0.47 blue:0.5 alpha:1];
        return cell;
    }else
    {
        static NSString *cellIde=@"colorfulCategory";
        SpeakPersonCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell=[[SpeakPersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.sCover = @"";
        cell.sTitle = @"";
        cell.sFmnum = @"";
        
        NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row-1];
        
        cell.sCover = [dict objectForKey:@"cover"];
        cell.sTitle = [dict objectForKey:@"title"];
        cell.sFmnum = [dict objectForKey:@"favnum"];
        
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 40;
    }else
        return 70;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count+1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    FMViewController *fm=[[FMViewController alloc]init];
    fm.value=[dict objectForKey:@"object_id"];
    [self.navigationController pushViewController:fm animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableview分割线左边有空隙
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
