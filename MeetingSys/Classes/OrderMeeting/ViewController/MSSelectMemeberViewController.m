//
//  MSSelectMemeberViewController.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/18.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSSelectMemeberViewController.h"
#import "MSMemberView.h"
#import "MSSelMemberCell.h"
#import "MSMeetingDetailModel.h"

@interface MSSelectMemeberViewController ()<MSMemberCellViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UISearchBar *_searchBar;
    NSInteger page;
}

@property (nonatomic, strong) UITableView    *memberTableView;
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) NSMutableArray *selectedMemebers;
@property (nonatomic, strong) MSMemberView   *headMemberView;

@end

@implementation MSSelectMemeberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (MSMemberView*)headMemberView
{
    if (!_headMemberView) {
        _headMemberView = [MSMemberView new];
        _headMemberView.delegate = self;
        _headMemberView.backgroundColor = UIColorHex(0xffffff);
    }
    return _headMemberView;
}

- (void)loadSubView
{
    [self rightBarButtonWithName:@"確定" normalColor:UIColorHex(0xFF7B54) disableColor:UIColorHex_Alpha(0xFF7B54, 0.6) target:self action:@selector(selectMemeberOK)];
    
    /* searchbar */
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    _searchBar.placeholder = @"請輸入姓名或職位";
    _searchBar.barTintColor = UIColorHex(0xffffff);
    //去掉上下两条黑线
    _searchBar.layer.borderWidth = 1;
    _searchBar.layer.borderColor = [_searchBar.barTintColor CGColor];
    _searchBar.delegate = self;
    _searchBar.tintColor = UIColorHex(0xFF7B54);
    UIView *searchTextField = [[[_searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = UIColorHex(0xeeeeee);
    [self.view addSubview:_searchBar];
    
    self.memberTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, kScreenWidth,kScreenHeight-64-50) style:UITableViewStylePlain];
    self.memberTableView.backgroundColor = UIColorHex(0xf6f6f6);
    self.memberTableView.delegate = self;
    self.memberTableView.dataSource = self;
    self.memberTableView.separatorColor = kSplitLineColor;
    [self.memberTableView registerClass:[MSSelMemberCell class] forCellReuseIdentifier:@"MSSelMemberCell"];
    @weakify(self)
    self.memberTableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshMemberData];
    }];
    [self.view addSubview:self.memberTableView];
}

- (void)selectMemeberOK
{
    
}

- (void)doSearch
{
    NSString *keyInfo = [_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (keyInfo.length) {
        [self.memberTableView.mj_header beginRefreshing];
    } else {
        [HUDManager alertWithTitle:@"請輸入姓名或職位"];
    }
}

- (void)didClickMemberCell:(MSMemberCellView*)view
{
    //删除成员
    NSInteger index = [self fetchMemberOfSelectedIndex:view.memberModel];
    if (index>=0) {
        [self.selectedMemebers removeObjectAtIndex:index];
        [self.headMemberView membersData:self.selectedMemebers];
    }
    //更新tableview列表的状态，
    [self.members enumerateObjectsUsingBlock:^(MSMemberModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.memberId isEqualToString:view.memberModel.memberId]) {
            model.isSelected = NO;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            MSSelMemberCell *cell = [self.memberTableView cellForRowAtIndexPath:indexPath];
            [cell showSelected:NO];
            *stop = YES;
        };
    }];
    //隐藏
    if (self.selectedMemebers.count==0) {
        [self.memberTableView reloadData];
    }
}

/*  选中的元素和数据源同步 */
- (void)refreshSelectedItems:(NSArray*)members
{
    [self.selectedMemebers enumerateObjectsUsingBlock:^(MSMemberModel *selectedModel, NSUInteger idx, BOOL * _Nonnull stop) {
        for (int i = 0; i<members.count; i++) {
            MSMemberModel *model = [members objectAtIndex:i];
            if ([model.memberId isEqualToString:selectedModel.memberId]) {
                model.isSelected = YES;
            }
        }
    }];
}

- (void)refreshMemberData
{
    page = 1;
    [self loadMoreMemberData];
}

- (void)loadMoreMemberData
{
    NSString *keyInfo = [_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [MSMemberModel getuserlistKeywords:keyInfo page:page networkHUD:NetworkHUDError target:self success:^(StatusModel *data) {
        
        [self.memberTableView.mj_header endRefreshing];
        [self.memberTableView.mj_footer endRefreshing];
        
        if (data.code == 0) {
            BOOL firstPage = [[data.originalData objectForKey:@"firstPage"] boolValue];
            BOOL hasNextPage = [[data.originalData objectForKey:@"hasNextPage"] boolValue];
            NSArray *members = [MSMemberModel mj_objectArrayWithKeyValuesArray:[data.originalData objectForKey:@"list"]];
            
            if (firstPage) {
                [self.members removeAllObjects];
            }
            if (hasNextPage) {
                page ++;
                self.memberTableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMemberData)];
            } else {
                [self.memberTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (members.count) {
                [self refreshSelectedItems:members];
                [self.members addObjectsFromArray:members];
            }
            [self.memberTableView reloadData];
        } else {
            [HUDManager alertWithTitle:data.msg];
        }
    }];
}

- (NSInteger)fetchMemberOfSelectedIndex:(MSMemberModel*)model
{
    for (int i = 0; i<self.selectedMemebers.count; i++) {
        MSMemberModel *selectedModel = [self.selectedMemebers objectAtIndex:i];
        if ([selectedModel.memberId isEqualToString:model.memberId]) {
            return i;
        }
    }
    return -1;
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MSMemberModel *model = [self.members objectAtIndex:indexPath.row];
    MSSelMemberCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self fetchMemberOfSelectedIndex:model]>=0) {
        [cell showSelected:NO];
        model.isSelected = NO;
        [self.selectedMemebers removeObject:model];
    } else {
        [cell showSelected:YES];
        model.isSelected = YES;
        [self.selectedMemebers addObject:model];
    }
    [self.headMemberView membersData:self.selectedMemebers];
    [self.memberTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.selectedMemebers.count?127:0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        headerView.frame = CGRectMake(0 , 0, kScreenWidth, 127);
        [headerView addSubview:self.headMemberView];
        
        [self.headMemberView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(@0);
        }];
    }
    return self.selectedMemebers.count?headerView:nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSSelMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSSelMemberCell"];
    MSMemberModel *model = [self.members objectAtIndex:indexPath.row];
    [cell data:model];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xffffff)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(0x000000), NSFontAttributeName:kNavTitleFont}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark- UI_searchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar endEditing:YES];
    
    [self doSearch];
}

- (NSMutableArray*)members
{
    if (!_members) {
        _members = [[NSMutableArray alloc] init];
    }
    return _members;
}

- (NSMutableArray*)selectedMemebers
{
    if (!_selectedMemebers) {
        _selectedMemebers = [[NSMutableArray alloc] init];
    }
    return _selectedMemebers;
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
