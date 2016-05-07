//
//  CategroyViewController.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/4/30.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "CategroyViewController.h"
#import "ColorfulCategoryCell.h"
#import "FMViewController.h"

@interface CategroyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *FMTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSString *urlStringUTF8;
@property (nonatomic,assign) NSInteger offset;

@end

@implementation CategroyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _offset = 0;
    //back
    [self leftButtonWithImage:@"back.png"];
    [self rightButtonWithImage:@"littlePlaying1.png"];
    self.title = _cTitle;
    
    [self addNotification];
    
    [self downLoadData];
    
    [self createTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

-(void)addNotification
{
    if ([_cTag isEqualToString:@"0"]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadDataFinish) name:Home_Class(_offset,_cId) object:nil];
    }else if ([_cTag isEqualToString:@"tag"])
    {
        NSString *url = Home_Tag(_cValue,_offset);
        _urlStringUTF8 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadDataFinish) name:_urlStringUTF8 object:nil];
        NSLog(@"%@",_urlStringUTF8);
    }else if ([_cTag isEqualToString:@"newlesson"])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadDataFinish) name:Home_NewClass(_offset) object:nil];
    }else if ([_cTag isEqualToString:@"newfm"])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadDataFinish) name:Home_NewFM(_offset) object:nil];
    }else if ([_cTag isEqualToString:@"newspeak"])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadDataFinish) name:Speak_New(_offset) object:nil];
    }
    
}

//全部数据 一个接口
-(void)downLoadDataFinish
{
    if (_offset != 0) {
        if ([_cTag isEqualToString:@"0"])
        {
            _dataArray=[_dataArray arrayByAddingObjectsFromArray:[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Home_Class(_offset,_cId)]];
        }else if ([_cTag isEqualToString:@"tag"])
        {
            _dataArray=[_dataArray arrayByAddingObjectsFromArray:[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:_urlStringUTF8]];
        }else if ([_cTag isEqualToString:@"newlesson"])
        {
            _dataArray=[_dataArray arrayByAddingObjectsFromArray:[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Home_NewClass(_offset)]];
        }else if ([_cTag isEqualToString:@"newfm"])
        {
            _dataArray=[_dataArray arrayByAddingObjectsFromArray:[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Home_NewFM(_offset)]];
        }else if ([_cTag isEqualToString:@"newspeak"])
        {
            _dataArray=[_dataArray arrayByAddingObjectsFromArray:[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Speak_New(_offset)]];
        }
    }else
    {
        if ([_cTag isEqualToString:@"0"]) {
            
            _dataArray=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Home_Class(_offset,_cId)];
        }else if ([_cTag isEqualToString:@"tag"])
        {
            _dataArray=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:_urlStringUTF8];
        }else if ([_cTag isEqualToString:@"newlesson"])
        {
            _dataArray=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Home_NewClass(_offset)];
        }else if ([_cTag isEqualToString:@"newfm"])
        {
            _dataArray=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Home_NewFM(_offset)];
        }else if ([_cTag isEqualToString:@"newspeak"])
        {
            _dataArray=[[DownLoadManager sharedDownLoadManager]getDownLoadDataForKey:Speak_New(_offset)];
        }
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
    if ([_cTag isEqualToString:@"0"]) {
        [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Home_Class(_offset,_cId) and:1];
    }else if ([_cTag isEqualToString:@"tag"])
    {
        [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:_urlStringUTF8 and:1];
    }else if ([_cTag isEqualToString:@"newlesson"])
    {
        [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Home_NewClass(_offset) and:1];
    }else if ([_cTag isEqualToString:@"newfm"])
    {
        [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Home_NewFM(_offset) and:1];
    }else if ([_cTag isEqualToString:@"newspeak"])
    {
        [[DownLoadManager sharedDownLoadManager]downLoadWithUrl:Speak_New(_offset) and:1];
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
        _FMTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        
                // 下拉刷新
        _FMTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
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
    static NSString *cellIde=@"colorfulCategory";
    ColorfulCategoryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[ColorfulCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.cCover = @"";
    cell.cTitle = @"";
    cell.cSpeak = @"";
    cell.cFavnum = @"";
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    
    cell.cCover = [dict objectForKey:@"cover"];
    cell.cTitle = [dict objectForKey:@"title"];
    cell.cFavnum = [dict objectForKey:@"favnum"];
    cell.cSpeak = [dict objectForKey:@"speak"];
    
    
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
    FMViewController *fm=[[FMViewController alloc]init];
    fm.value=[dict objectForKey:@"object_id"];
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
