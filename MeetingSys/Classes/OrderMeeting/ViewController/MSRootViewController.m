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
#import "MSMeetingUserCenterView.h"

@interface MSRootViewController ()<MSNavTabbarViewDelegete,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MSOrderMeetingButtonViewDelegate>
{
    UITableView *tableNoticeView;
    UITableView *tableAllMeetingView;
    UIScrollView *mainScrollView;
    MSNavTabbarView *navTabbarView;
    MSMeetingUserCenterView *userCenterView;
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
    [self loadDemoData];
    
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
    tableNoticeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableNoticeView registerClass:[MSMeetingDetailCell class] forCellReuseIdentifier:@"MSMeetingDetailCell"];
    [tableNoticeView registerClass:[MSNoticeCellView class] forCellReuseIdentifier:@"MSNoticeCellView"];
    [mainScrollView addSubview:tableNoticeView];
    
    tableAllMeetingView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, mainScrollView.height) style:UITableViewStyleGrouped];
    tableAllMeetingView.backgroundColor = UIColorHex(0xf6f6f6);
    tableAllMeetingView.delegate = self;
    tableAllMeetingView.dataSource = self;
    tableAllMeetingView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableAllMeetingView registerClass:[MSMeetingListCell class] forCellReuseIdentifier:@"MSMeetingListCell"];
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

- (void)loadDemoData
{
    for (int i = 0; i < 10; i++) {
        MSNoticeModel *model = [[MSNoticeModel alloc] init];
        model.noticeDate = @"五分鐘前";
        model.noticeContent = @"保險專業知識培訓01";
        model.noticeTitle = @"會議通知";
        model.meetingDate = @"2017-04-04 10:00";
        model.isUnfold = NO;
        //第一个展开
//        model.isUnfold = i==0?YES:NO;
        
        MSMeetingDetailModel *detailModel = [[MSMeetingDetailModel alloc] init];
        detailModel.beginTime = @"2017-04-04 10:00";
        detailModel.endTime = @"2017-04-04 10:30";
        detailModel.address = @"s1";
        detailModel.agenda = @"保險專業知識培訓保險專業知識培訓保險專業知識培訓保險專業知識培訓";
        detailModel.demand = @"保險專業知識培訓保險專業知識培訓保險專業知識培訓";
        
        for (int j = 0; j < 8; j++) {
            MSMemberModel *member = [[MSMemberModel alloc] init];
            member.headURL = @"";
            member.name = @"roger";
            [detailModel.members addObject:member];
        }
        
        model.meetingDetailModel = detailModel;
        [self.noticeArray addObject:model];
    }
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == tableNoticeView) {
        MSNoticeModel *model = [self.noticeArray objectAtIndex:indexPath.section];
        if (indexPath.row == 0) {
            model.isUnfold = !model.isUnfold;
            [tableNoticeView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableNoticeView) {
        MSNoticeModel *model = [self.noticeArray objectAtIndex:indexPath.section];
        if (model.isUnfold) {
            if (indexPath.row == 0) {
                return [MSNoticeCellView noticeCellHeight];
            } else {
                return [MSMeetingDetailCell meetingDetailHeight:model];
            }
        } else {
            return [MSNoticeCellView noticeCellHeight];
        }
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 12;
    } else {
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableNoticeView) {
        MSNoticeModel *model = [self.noticeArray objectAtIndex:section];
        return model.isUnfold?2:1;
    } else {
        return 10;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == tableNoticeView) {
        return self.noticeArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableNoticeView) {
        MSNoticeCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNoticeCellView"];
        cell.backgroundColor = tableNoticeView.backgroundColor;
        MSNoticeModel *model = [self.noticeArray objectAtIndex:indexPath.section];
        if (model.isUnfold) {
            //考慮一個列表和一個詳情
            if (indexPath.row == 0) {
                [cell data:model];
            } else {
                MSMeetingDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"MSMeetingDetailCell"];
                detailCell.selectionStyle = UITableViewCellSeparatorStyleNone;
                detailCell.backgroundColor = tableNoticeView.backgroundColor;
                [detailCell data:model];
                return detailCell;
            }
        } else {
            //考慮列表即可
            [cell data:model];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cel"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cel"];
        }
        cell.textLabel.text = @"sfef";
        return cell;
    }
}

//個人中心
- (void)userInfoClick:(UIButton*)button
{
    NSLog(@"個人中心");
    if (!userCenterView) {
        userCenterView = [MSMeetingUserCenterView new];
    }
    [userCenterView showUserCenterView];
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
