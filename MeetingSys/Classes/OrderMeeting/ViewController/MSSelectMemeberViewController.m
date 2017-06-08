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
#import "MSSearchHeadMemberView.h"
#import "MSSearchBottomView.h"

@interface MSSelectMemeberViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,MSMemberCollectionCellViewDelegate,MSSearchBottomViewDelegate>
{
    UISearchBar *_searchBar;
    UISearchBar *_searchBar2;
    NSInteger page;
}

@property (nonatomic, strong) UITableView    *memberTableView;
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) MSSearchHeadMemberView   *headMemberView;
@property (nonatomic, assign) NSInteger      selectedItemCount;
@property (nonatomic, strong) MSSearchBottomView *bottomView;

@end

@implementation MSSelectMemeberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (MSSearchHeadMemberView*)headMemberView
{
    if (!_headMemberView) {
        _headMemberView = [[MSSearchHeadMemberView alloc] initWithFrame:CGRectMake(0, 46, kScreenWidth, 127)];
        _headMemberView.delegate = self;
        _headMemberView.backgroundColor = UIColorHex(0xffffff);
    }
    return _headMemberView;
}

- (UISearchBar*)creatSearchBarPlaceHolder:(NSString*)placeholder
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    searchBar.placeholder = placeholder;
    searchBar.barTintColor = UIColorHex(0xffffff);
    //去掉上下两条黑线
    searchBar.layer.borderWidth = 1;
    searchBar.layer.borderColor = [searchBar.barTintColor CGColor];
    searchBar.delegate = self;
    searchBar.tintColor = UIColorHex(0xFF7B54);
    UIView *searchTextField = [[[searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = UIColorHex(0xeeeeee);
    
    return searchBar;
}

- (void)loadSubView
{
    UIView *searchBarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    [self.view addSubview:searchBarContentView];
    
    if (self.memberType == MSSelectMemeber_Others) {
        /* searchbar */
        _searchBar = [self creatSearchBarPlaceHolder:@"營業處/分區D"];
        _searchBar.frame = CGRectMake(0, 0, kScreenWidth/2, 46);
        [searchBarContentView addSubview:_searchBar];
        [_searchBar becomeFirstResponder];
        
        _searchBar2 = [self creatSearchBarPlaceHolder:@"名稱/職位"];
        _searchBar2.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 46);
        [searchBarContentView addSubview:_searchBar2];
        
    } else {
        _searchBar = [self creatSearchBarPlaceHolder:@"請輸入姓名或職位"];
        [searchBarContentView addSubview:_searchBar];
        [_searchBar becomeFirstResponder];
    }
    
    
    if (self.memberType == MSSelectMemeber_Others) {
        [self.view addSubview:self.headMemberView];
    }
    
    self.memberTableView = [[UITableView alloc] initWithFrame:[self getTableViewFrame] style:UITableViewStylePlain];
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
    
    
    if (self.memberType == MSSelectMemeber_Others) {
        self.title = @"選擇參與人員";
        [self rightBarButtonWithName:@"確定" normalColor:kMainColor disableColor:UIColorHex_Alpha(0xDF1B20, 0.6) target:self action:@selector(selectMemeberOK)];
        [self racForNavRightBt];
        self.selectedItemCount = self.selectedMemebers.count;
        if (self.selectedMemebers.count) {
            [self.memberTableView reloadData];
            self.headMemberView.dataSources = self.selectedMemebers;
            [self.headMemberView reloadView];
        }
        
        //加载底部预约按钮
        self.bottomView = [MSSearchBottomView new];
        self.bottomView.backgroundColor = UIColorHex(0xffffff);
        self.bottomView.delegate = self;
        self.bottomView.layer.shadowColor = UIColorHex_Alpha(0x000000, 0.05).CGColor;
        self.bottomView.layer.shadowOpacity = 1;
        self.bottomView.layer.shadowOffset = CGSizeMake(0, -5);
        [self.view addSubview:self.bottomView];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@50);
        }];
        
    } else {
        self.title = @"選擇組織者";
    }
}

- (CGRect)getTableViewFrame
{
    CGRect tableFrame = CGRectZero;
    if (self.memberType == MSSelectMemeber_Others) {
        if (self.selectedMemebers.count) {
            tableFrame = CGRectMake(0, 46+127, kScreenWidth,kScreenHeight-64-50-127);
        } else {
            tableFrame = CGRectMake(0, 46, kScreenWidth,kScreenHeight-64-46-50);
        }
    } else {
        tableFrame = CGRectMake(0, 46, kScreenWidth,kScreenHeight-64-46);
    }
    return tableFrame;
}

- (void)racForNavRightBt
{
    //满足条件的情况才使得按钮可用
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [RACSignal combineLatest:@[RACObserve(self, selectedItemCount)] reduce:^(NSNumber *countVal){
        return @([countVal integerValue] > 0);
    }];
}

- (void)selectMemeberOK
{
    if (self.selectBlock) {
        self.selectBlock(self.memberType, self.selectedMemebers);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)doSearch
{
    if (self.memberType == MSSelectMemeber_Others) {
        NSString *keyInfo = [_searchBar2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *dpName = [_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (keyInfo.length || dpName.length) {
            [self.bottomView setSelectedAllStatus:NO];
            [self.memberTableView.mj_header beginRefreshing];
        } else {
            [HUDManager alertWithTitle:@"請輸入搜索條件"];
        }
    } else {
        NSString *keyInfo = [_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (keyInfo.length) {
            [self.memberTableView.mj_header beginRefreshing];
        } else {
            [HUDManager alertWithTitle:@"請輸入姓名或職位"];
        }
    }
}

- (void)didClickMemberCollectionCell:(MSMemberCollectionCell*)view
{
    //删除成员
    NSInteger index = [self fetchMemberOfSelectedIndex:view.memberModel];
    if (index>=0) {
        [self.selectedMemebers removeObjectAtIndex:index];
        self.headMemberView.dataSources = self.selectedMemebers;
        [self.headMemberView reloadView];
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
    [self memberChangedEvent];
    
    self.selectedItemCount = self.selectedMemebers.count;
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

- (void)didClickAllSelected:(MSSearchBottomView *)view
{
    if (view.isSelectedAll) {
        //将self.members里不在self.selectedMembers中的成员加入
        [self.members enumerateObjectsUsingBlock:^(MSMemberModel *member, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self fetchMemberOfSelectedIndex:member]<0) {
                member.isSelected = YES;
                [self.selectedMemebers addObject:member];
            }
        }];
    } else {
        //将self.members在self.selectedMembers中的成员移除
        [self.members enumerateObjectsUsingBlock:^(MSMemberModel *member, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = [self fetchMemberOfSelectedIndex:member];
            if (index >= 0) {
                member.isSelected = NO;
                [self.selectedMemebers removeObjectAtIndex:index];
            }
        }];
    }
    self.selectedItemCount = self.selectedMemebers.count;
    [self memberChangedEvent];
    [self.memberTableView reloadData];
}

- (void)refreshMemberData
{
    page = 1;
    [self loadMoreMemberData];
}

- (void)loadMoreMemberData
{
    NSString *keyInfo;
    NSString *dpName;
    if (self.memberType == MSSelectMemeber_Others) {
        keyInfo = [_searchBar2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        dpName = [_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (!keyInfo.length && !dpName.length) {
            [self.memberTableView.mj_header endRefreshing];
            [self.memberTableView.mj_footer endRefreshing];
            return;
        }
    } else {
        keyInfo = [_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (!keyInfo.length) {
            [self.memberTableView.mj_header endRefreshing];
            [self.memberTableView.mj_footer endRefreshing];
            return;
        }
    }
    
    [MSMemberModel getuserlistKeywords:keyInfo dpName:dpName page:page networkHUD:NetworkHUDError target:self success:^(StatusModel *data) {
        
        [self.memberTableView.mj_header endRefreshing];
        [self.memberTableView.mj_footer endRefreshing];
        
        if (data.code == 0) {
            BOOL firstPage = [[data.originalData objectForKey:@"firstPage"] boolValue];
            BOOL hasNextPage = [[data.originalData objectForKey:@"hasNextPage"] boolValue];
            NSArray *members = [MSMemberModel mj_objectArrayWithKeyValuesArray:[data.originalData objectForKey:@"list"]];
            
            if (self.bottomView.isSelectedAll) {
                [members enumerateObjectsUsingBlock:^(MSMemberModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![self isContainMember:model]) {
                        model.isSelected = YES;
                        [self.selectedMemebers addObject:model];
                    }
                }];
                [self memberChangedEvent];
            }
            
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

- (BOOL)isContainMember:(MSMemberModel*)model
{
    for (int i = 0; i < self.selectedMemebers.count; i++) {
        MSMemberModel *m = [self.selectedMemebers objectAtIndex:i];
        if ([m.memberId isEqualToString:model.memberId]) {
            return YES;
        }
    }
    return NO;
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

- (void)memberChangedEvent
{
    if (self.selectedMemebers.count) {
        self.headMemberView.hidden = NO;
    } else {
        self.headMemberView.hidden = YES;
    }
    self.memberTableView.frame = [self getTableViewFrame];
    self.headMemberView.dataSources = self.selectedMemebers;
    [self.headMemberView reloadView];
    [self.bottomView setSelectedAllStatus:[self isAllSelected]];
}

- (BOOL)isAllSelected
{
    //判断  selectedMemebers 是否全部包含 members 数组的数据  是的表示当前要全选
    if (self.members.count) {
        __block BOOL allSelected = YES;
        [self.members enumerateObjectsUsingBlock:^(MSMemberModel *member, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self fetchMemberOfSelectedIndex:member]<0) {
                allSelected = NO;
                *stop = YES;
            }
        }];
        return allSelected;
    } else {
        return NO;
    }
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MSMemberModel *model = [self.members objectAtIndex:indexPath.row];
    if (self.memberType == MSSelectMemeber_Others) {
        MSSelMemberCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSInteger index = [self fetchMemberOfSelectedIndex:model];
        if (index>=0) {
            [cell showSelected:NO];
            model.isSelected = NO;
            //备注 由于刷新或退出搜索页面再进入带入的旧成员，其中的model跟selectedMemebers对象已经不是同一个了，只是id相同，所以必须使用removeObjectAtIndex方法移除，而不能使用removeObject方法移除（会发现找不到对象）；
            [self.selectedMemebers removeObjectAtIndex:index];
        } else {
            [cell showSelected:YES];
            model.isSelected = YES;
            [self.selectedMemebers addObject:model];
        }
        [self memberChangedEvent];
        self.selectedItemCount = self.selectedMemebers.count;
    } else if (self.memberType == MSSelectMemeber_Organizer) {
        if (self.selectBlock) {
            self.selectBlock(self.memberType, @[model]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    [searchBar endEditing:YES];
    
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
