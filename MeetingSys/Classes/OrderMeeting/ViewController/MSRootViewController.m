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
#import "MSAllMeetingModel.h"
#import "MSAllMeetingDetailCell.h"
#import "MSTodayMeetingView.h"

@interface MSRootViewController ()<MSNavTabbarViewDelegete,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MSOrderMeetingButtonViewDelegate,MSAllMeetingDetailCellDelegate>
{
    UITableView *tableNoticeView;
    UITableView *tableAllMeetingView;
    UIScrollView *mainScrollView;
    MSNavTabbarView *navTabbarView;
    MSMeetingUserCenterView *userCenterView;
}

@property (nonatomic, strong) NSMutableArray *noticeArray;
@property (nonatomic, strong) MSAllMeetingModel *allMeetingModel;
@property (nonatomic, strong) MSTodayMeetingView *todayMeetingView;

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
    
    tableAllMeetingView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, mainScrollView.height) style:UITableViewStylePlain];
    tableAllMeetingView.backgroundColor = UIColorHex(0xf6f6f6);
    tableAllMeetingView.delegate = self;
    tableAllMeetingView.dataSource = self;
    tableAllMeetingView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableAllMeetingView registerClass:[MSMeetingListCell class] forCellReuseIdentifier:@"MSMeetingListCell"];
    [tableAllMeetingView registerClass:[MSAllMeetingDetailCell class] forCellReuseIdentifier:@"MSAllMeetingDetailCell"];
    tableAllMeetingView.tableHeaderView = self.todayMeetingView;
    [mainScrollView addSubview:tableAllMeetingView];
    
    [self.todayMeetingView reloadWithDatas:self.allMeetingModel.todayList];
    
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
    //加载提醒demo数据
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
    
    //加载所有会议数据
    self.allMeetingModel = [[MSAllMeetingModel alloc] init];
    NSArray *meetingDate = @[@"2017-05-05",@"2017-05-06",@"2017-05-07",@"2017-05-08",@"2017-05-09"];
    
    for (int section = 0; section < meetingDate.count; section++) {
        MSDayGroupList *dayGroupList = [[MSDayGroupList alloc] init];
        dayGroupList.meetingDate = meetingDate[section];
        
        for (int row = 0; row < 3; row++) {
            MSMeetingDetailModel *detailModel = [[MSMeetingDetailModel alloc] init];
            detailModel.title = @"月度總結報告";
            detailModel.organizeName = @"roger";
            detailModel.beginTime = @"10:00";
            detailModel.endTime = @"10:30";
            detailModel.address = @"s1";
            detailModel.agenda = @"保險專業知識培訓保險專業知識培訓保險專業知識培訓保險專業知識培訓";
            detailModel.demand = @"保險專業知識培訓保險專業知識培訓保險專業知識培訓";
            
            
            for (int j = 0; j < 8; j++) {
                MSMemberModel *member = [[MSMemberModel alloc] init];
                member.headURL = @"";
                member.name = @"roger";
                [detailModel.members addObject:member];
            }
            [dayGroupList.list addObject:detailModel];
        }
        [self.allMeetingModel.dayGroupList addObject:dayGroupList];
    }
    
    //加載當天數據
    for (int i = 0; i<8; i++) {
        MSMeetingDetailModel *detailModel = [[MSMeetingDetailModel alloc] init];
        detailModel.title = @"月度總結報告";
        detailModel.organizeName = @"roger";
        detailModel.beginTime = @"10:00";
        detailModel.endTime = @"10:30";
        detailModel.address = @"s1";
        detailModel.agenda = @"保險專業知識培訓保險專業知識培訓保險專業知識培訓保險專業知識培訓";
        detailModel.demand = @"保險專業知識培訓保險專業知識培訓保險專業知識培訓";
        
        
        for (int j = 0; j < 8; j++) {
            MSMemberModel *member = [[MSMemberModel alloc] init];
            member.headURL = @"";
            member.name = @"roger";
            [detailModel.members addObject:member];
        }
        [self.allMeetingModel.todayList addObject:detailModel];
    }
}

- (NSInteger)fetchOtherUnfoldCell:(NSInteger)section
{
    __block NSInteger otherUnfoldSection = 0;
    [self.noticeArray enumerateObjectsUsingBlock:^(MSNoticeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != section && model.isUnfold) {
            otherUnfoldSection = idx;
            model.isUnfold = NO;
            *stop = YES;
        }
    }];
    return otherUnfoldSection;
}

- (void)didClickSureActionCell:(MSAllMeetingDetailCell*)cell
{
    NSIndexPath *indexPath = [tableAllMeetingView indexPathForCell:cell];
    
    MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:indexPath.section];
    MSMeetingDetailModel *dayDetailModel = [dayGroupList.list objectAtIndex:indexPath.row-1];
    dayDetailModel.isUnfold = NO;
    
    [dayGroupList.list removeObjectAtIndex:indexPath.row];
    [tableAllMeetingView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
        //收起其他展开项目
        NSInteger otherUnfoldSecion = [self fetchOtherUnfoldCell:indexPath.section];
        if (otherUnfoldSecion != -1) {
            [tableNoticeView reloadSections:[NSIndexSet indexSetWithIndex:otherUnfoldSecion] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:indexPath.section];
        MSMeetingDetailModel *dayDetailModel = [dayGroupList.list objectAtIndex:indexPath.row];
        if (!dayDetailModel.isDetail) {
            if (dayDetailModel.isUnfold) {
                //折叠详情
                [dayGroupList.list removeObjectAtIndex:indexPath.row+1];
                NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                [tableView deleteRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                //展开详情
                MSMeetingDetailModel *copyDetail = [dayDetailModel copy];
                copyDetail.isDetail = YES;
                [dayGroupList.list insertObject:copyDetail atIndex:indexPath.row+1];
                NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                [tableView insertRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            dayDetailModel.isUnfold = !dayDetailModel.isUnfold;
        }
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
        
        MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:indexPath.section];
        MSMeetingDetailModel *dayDetailModel = [dayGroupList.list objectAtIndex:indexPath.row];
        if (!dayDetailModel.isDetail) {
            return [MSMeetingListCell meetingListCellHeight];
        } else {
            return [MSAllMeetingDetailCell meetingDetailHeight:dayDetailModel];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == tableNoticeView) {
        if (section == 0) {
            return 12;
        } else {
            return 8;
        }
    } else {
        return 46;
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
        MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:section];
        return dayGroupList.list.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == tableNoticeView) {
        return self.noticeArray.count;
    } else {
        return self.allMeetingModel.dayGroupList.count;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tableAllMeetingView) {
        MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:section];
        UIView *sectionContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
        sectionContentView.backgroundColor = UIColorHex(0xf6f6f6);
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame = sectionContentView.bounds;
        titleLabel.font = kFontPingFangRegularSize(14);
        titleLabel.textColor = UIColorHex(0xFF7B54);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = sectionContentView.backgroundColor;
        titleLabel.text = dayGroupList.meetingDate;
        [sectionContentView addSubview:titleLabel];
        return sectionContentView;
    } else {
        return nil;
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
        MSDayGroupList *dayGroupModel = [self.allMeetingModel.dayGroupList objectAtIndex:indexPath.section];
        MSMeetingDetailModel *dayDetailModel = [dayGroupModel.list objectAtIndex:indexPath.row];
        
        if (dayDetailModel.isDetail) {
            //展开的详情
            MSAllMeetingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSAllMeetingDetailCell"];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell data:dayDetailModel];
            return cell;
        } else {
            //列表
            MSMeetingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSMeetingListCell"];
            [cell data:dayDetailModel];
            return cell;
        }
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
    if (scrollView == mainScrollView) {
        NSInteger index = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
        [navTabbarView selectedItemIndex:index];
    }
}

- (NSMutableArray *)noticeArray;
{
    if (!_noticeArray) {
        _noticeArray = [[NSMutableArray alloc] init];
    }
    return _noticeArray;
}

- (MSTodayMeetingView*)todayMeetingView
{
    if (!_todayMeetingView) {
        _todayMeetingView = [[MSTodayMeetingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 212)];
    }
    return _todayMeetingView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
