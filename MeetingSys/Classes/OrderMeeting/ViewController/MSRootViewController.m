//
//  MSRootViewController.m
//  MeetingSys
//
//  Created by luoyan on 2017/5/5.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSRootViewController.h"
#import "MSNavTabbarView.h"
#import "MSOrderMeetingButtonView.h"
#import "MSMeetingListCell.h"
#import "MSNoticeCellView.h"
#import "MSMeetingDetailCell.h"

@interface MSRootViewController ()<MSNavTabbarViewDelegete,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MSOrderMeetingButtonViewDelegate>
{
    UITableView *tableNoticeView;
    UITableView *tableAllMeetingView;
    UIScrollView *mainScrollView;
    MSNavTabbarView *navTabbarView;
}

@property (nonatomic, strong) NSMutableArray *noticeArray;
@property (nonatomic, strong) NSMutableArray *allMeetingsArray;

@end

@implementation MSRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"會議室管理";
    [self leftBarButtonWithName:nil image:[UIImage imageNamed:@"user_center_icon"] target:self action:@selector(userInfoClick:)];
    
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (void)loadSubView
{
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-64-50-40)];
    [mainScrollView setContentSize:CGSizeMake(kScreenWidth*2, mainScrollView.height)];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.delegate = self;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:mainScrollView];
    
    tableNoticeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, mainScrollView.height) style:UITableViewStyleGrouped];
    tableNoticeView.backgroundColor = UIColorHex(0xf6f6f6);
    tableNoticeView.delegate = self;
    tableNoticeView.dataSource = self;
    [mainScrollView addSubview:tableNoticeView];
    
    tableAllMeetingView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, mainScrollView.height) style:UITableViewStyleGrouped];
    tableAllMeetingView.backgroundColor = UIColorHex(0xf6f6f6);
    tableAllMeetingView.delegate = self;
    tableAllMeetingView.dataSource = self;
    [mainScrollView addSubview:tableAllMeetingView];
    
    //加載導航欄
    navTabbarView = [[MSNavTabbarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    navTabbarView.delegete = self;
    [self.view addSubview:navTabbarView];
    
    //加载底部预约按钮
    MSOrderMeetingButtonView *bottomView = [MSOrderMeetingButtonView new];
    bottomView.backgroundColor = UIColorHex(0xFF845F);
    bottomView.delegate = self;
    bottomView.layer.shadowColor = UIColorHex(0xf6f6f6).CGColor;
    bottomView.layer.shadowOpacity = 0.8;
    bottomView.layer.shadowOffset = CGSizeMake(0, -5);
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@50);
    }];
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cel"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cel"];
    }
    cell.textLabel.text = @"sfef";
    return cell;
}

//個人中心
- (void)userInfoClick:(UIButton*)button
{
    NSLog(@"個人中心");
}

//新增預約
- (void)didClickOrder:(MSOrderMeetingButtonView*)view
{
    NSLog(@"新增會與預約");
}

//切換tabbar
- (void)didClickNavTabbarView:(NSInteger)itemIndex
{
    if (itemIndex == 0) {
        [mainScrollView scrollToHorizontalPageIndex:0 animated:YES];
    } else {
        [mainScrollView scrollToHorizontalPageIndex:1 animated:YES];
    }
}

//滾動視圖時觸發
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    [navTabbarView selectedItemIndex:index];
}

- (NSMutableArray *)noticeArray;
{
    if (!_noticeArray) {
        _noticeArray = [[NSMutableArray alloc] init];
    }
    return _noticeArray;
}
- (NSMutableArray *)allMeetingsArray
{
    if (!_allMeetingsArray) {
        _allMeetingsArray = [[NSMutableArray alloc] init];
    }
    return _allMeetingsArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
