//
//  ViewController.m
//  WangYangBitch
//
//  Created by 蒋永昌 on 9/7/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "ViewController.h"
#import "QuestionsAndAnswers.h"
#import "MJRefresh.h"

@interface ViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong)UIView *topView;
@property (nonatomic,retain)UISearchBar *searchBar;


@property(nonatomic,strong)UITableView *showTableView;
@property(nonatomic,strong)UITableView *searchTableView;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *searchArray;

@property(nonatomic,strong)UIButton *iphoneBtn;
@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topView];
    
    self.dataArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
    
    self.topView.frame = CGRectMake(0, 0, k_width, 64);
    
    
    
    // 打开数据库
    [[FMDBDataBase sharedFMDBDataBase] openDataBase];
    
    
    [self layoutViews];
    
//    [self getData];
    
    // 向右轻扫展示所有数据（也是从搜索后结果回来的手势）
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    

}

-(void)swipeAction:(UISwipeGestureRecognizer *)swipe{
    
    self.showTableView.alpha = 1;
    self.searchTableView.alpha = 0;
    self.iphoneBtn.alpha = 1;
    self.titleLabel.alpha = 0;
    [self.showTableView.mj_header beginRefreshing];
    NSLog(@"向右滑动");
}

- (void)layoutViews{
    
    self.showTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, k_width, k_height-64) style:UITableViewStylePlain];
    [self.view addSubview:self.showTableView];
    self.showTableView.delegate = self;
    self.showTableView.dataSource = self;
    
    [self.view addSubview:self.showTableView];
    
    self.showTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self.showTableView.mj_header beginRefreshing];
    
    
    
    
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, k_width, k_height-64) style:UITableViewStylePlain];
    [self.view addSubview:self.searchTableView];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.alpha = 0;
    self.searchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];

    
    [self.view addSubview:self.searchTableView];
    
    
    UIButton *iphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iphoneBtn.frame = CGRectMake(k_width-70, k_height-150, 46, 46);
    
    [iphoneBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [iphoneBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateSelected];
    
    self.iphoneBtn = iphoneBtn;
    [self.view addSubview:self.iphoneBtn];
    
    [self.iphoneBtn addTarget:self action:@selector(iPhoneCallAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.titleLabel = [UILabel new];
    self.titleLabel.frame = CGRectMake(k_width-150, k_height-100, 130, 25);
    [self.view addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor redColor];
    self.titleLabel.text = @"右滑返回主界面";
    self.titleLabel.alpha = 0;


}

- (void)getData{
    
    NSArray *array = [[FMDBDataBase sharedFMDBDataBase] queryData];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [self.showTableView reloadData];
    [self.showTableView.mj_header endRefreshing];
    [self.searchTableView reloadData];
    [self.searchTableView.mj_header endRefreshing];
}



#pragma mark ------tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.showTableView) {
        return self.dataArray.count;

    }else{
        
        return self.searchArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    
    QuestionsAndAnswers *quesAnser ;
    
    if (tableView == self.showTableView) {
        
        quesAnser = self.dataArray[indexPath.row];
    }else{
        
        quesAnser = self.searchArray[indexPath.row];
    }
    
    cell.textLabel.text = quesAnser.question;
    cell.detailTextLabel.text = quesAnser.answer;
    return cell;
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.showTableView) {
        
        QuestionsAndAnswers *questAnser = self.dataArray[indexPath.row];
        
        [[FMDBDataBase sharedFMDBDataBase]deleteData:questAnser.question];
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        
        // 创建indexPath
        NSIndexPath *ind = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        
        //        NSIndexPath *ind2 = [NSIndexPath indexPathWithIndex:indexPath.section];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath,ind] withRowAnimation:(UITableViewRowAnimationFade)];

    }
    

}


#pragma mark-----------添加问题动画------------

- (void)iPhoneCallAction{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加问题"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alertView textFieldAtIndex:1].secureTextEntry = NO;
    [alertView textFieldAtIndex:0].placeholder = @"请输入问题！";
    [alertView textFieldAtIndex:1].placeholder = @"请输入答案！";
    
    [alertView show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex == 1) {

        NSLog(@"确定");
        
        NSString *question = [alertView textFieldAtIndex:0].text;
        NSString *answer   = [alertView textFieldAtIndex:1].text;
        
        QuestionsAndAnswers *questAnswer = [[QuestionsAndAnswers alloc]init];
        questAnswer.question = question;
        questAnswer.answer   = answer;
        
        [[FMDBDataBase sharedFMDBDataBase]insertData:questAnswer];
        
        [self.showTableView.mj_header beginRefreshing];
        
    }else{
        
        NSLog(@"取消");
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    [self.searchBar resignFirstResponder];
}


#pragma mark-------搜索框---------
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    for (id subView in [searchBar subviews]) {
        for (id sub in [subView subviews]) {
            if ([sub isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)sub;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    NSLog(@"%@",searchBar.text);
    NSString *searchText = searchBar.text;
    
    for (QuestionsAndAnswers *model in self.dataArray) {
        
        
        if ([model.question containsString:searchText]) {
            
            [self.searchArray addObject:model];
            
        }
        
    }
    
    self.showTableView.alpha = 0;
    self.searchTableView.alpha = 1;
    self.iphoneBtn.alpha = 0;
    self.titleLabel.alpha = 1;

    [self.searchTableView.mj_header beginRefreshing];
    
    //跳转到搜索结果页
//    ApartmentViewController *apartVC = [[ApartmentViewController alloc] init];
//    apartVC.RequestType = HotelListKeyWords;
//    apartVC.KeyWord = searchBar.text;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:apartVC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    searchBar.text = @"";
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        self.searchBar = [[UISearchBar alloc]init];
        self.searchBar.placeholder = @"搜索汉字/字母";
        [self.searchBar sizeToFit];
    }
    return _searchBar;
}


-(UIView *)topView{
    
    if (!_topView) {
        
        UIView *topView = [UIView new];
        
        topView.backgroundColor = [UIColor redColor];
        self.navigationItem.titleView = self.searchBar;
        self.searchBar.delegate = self;
        
        _topView = topView;
    }
    
    return _topView;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
