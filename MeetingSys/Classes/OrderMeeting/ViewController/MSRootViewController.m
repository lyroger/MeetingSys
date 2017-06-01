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
#import "MSNoticeDetailCell.h"
#import "MSMeetingUserCenterView.h"
#import "MSAllMeetingModel.h"
#import "MSAllMeetingDetailCell.h"
#import "MSTodayMeetingView.h"
#import "MSNewMeetingViewController.h"
#import "MSNavigationController.h"
#import "MSUserHeadViewController.h"
#import "MSUpdatePwdViewController.h"
#import "CSErrorTips.h"
#import "APSModel.h"

@interface MSRootViewController ()<MSNavTabbarViewDelegete,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MSOrderMeetingButtonViewDelegate,MSAllMeetingDetailCellDelegate,MSMeetingUserCenterViewDelegate,MSNoticeDetailCellDelegate,MSToDayMeetingViewDelegate>
{
    UITableView *tableNoticeView;
    UITableView *tableAllMeetingView;
    UIScrollView *mainScrollView;
    MSNavTabbarView *navTabbarView;
    MSMeetingUserCenterView *userCenterView;
    BOOL isLoadedAllMeetingData;
    BOOL isViewToDayDetail;
    NSInteger lastViewToDayDetailIndex;
}

@property (nonatomic, strong) NSMutableArray *noticeArray;
@property (nonatomic, strong) MSAllMeetingModel *allMeetingModel;
@property (nonatomic, strong) MSTodayMeetingView *todayMeetingView;
@property (nonatomic, strong) CSErrorTips *noMeetingDataTipsView;
@property (nonatomic, strong) MSMeetingDetailModel *todayMeetingDetail;

@end

@implementation MSRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"會議室管理";
    AddNotification(self, @selector(userLoginOut), kLoginOutNotification, nil);
    AddNotification(self, @selector(userTokenExpire), kUserTokenExpireNotification, nil);
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
    tableNoticeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableNoticeView registerClass:[MSNoticeDetailCell class] forCellReuseIdentifier:@"MSNoticeDetailCell"];
    [tableNoticeView registerClass:[MSNoticeCellView class] forCellReuseIdentifier:@"MSNoticeCellView"];
    [mainScrollView addSubview:tableNoticeView];
    @weakify(self)
    tableNoticeView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshNoticeData];
    }];
    [tableNoticeView.mj_header beginRefreshing];
    
    
    tableAllMeetingView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, mainScrollView.height) style:UITableViewStylePlain];
    tableAllMeetingView.backgroundColor = UIColorHex(0xf6f6f6);
    tableAllMeetingView.delegate = self;
    tableAllMeetingView.dataSource = self;
    tableAllMeetingView.separatorStyle = UITableViewCellSelectionStyleNone;
    [tableAllMeetingView registerClass:[MSMeetingListCell class] forCellReuseIdentifier:@"MSMeetingListCell"];
    [tableAllMeetingView registerClass:[MSAllMeetingDetailCell class] forCellReuseIdentifier:@"MSAllMeetingDetailCell"];
    
    tableAllMeetingView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshAllMeetingData];
    }];
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
    bottomView.layer.shadowColor = UIColorHex_Alpha(0x000000, 0.05).CGColor;
    bottomView.layer.shadowOpacity = 1;
    bottomView.layer.shadowOffset = CGSizeMake(0, -5);
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@50);
    }];
}

- (void)needReloadData
{
    [self refreshNoticeData];
}

#pragma mark  加载提醒列表数据
- (void)refreshNoticeData
{
    [MSMeetingDetailModel getNoticesNetworkHUD:NetworkHUDBackground target:self success:^(StatusModel *data) {
        [tableNoticeView.mj_header endRefreshing];
        [tableNoticeView.mj_footer endRefreshing];
        
        if (data.code == 0) {
            NSArray *notices = data.data;
            [self.noticeArray removeAllObjects];
            [self.noticeArray addObjectsFromArray:notices];
            
            if (self.noticeArray.count) {
                [self loadMember:self.noticeArray];
                [self hideTipsView];
            } else {
                [self showLoadTips:@"您暫時還沒有提醒！" type:ErrorTipsType_NoData superView:tableNoticeView frame:CGRectMake(0, 0, kScreenWidth, mainScrollView.height)];
            }
            [tableNoticeView reloadData];
        } else {
            [HUDManager alertWithTitle:data.msg];
        }
    }];
}

#pragma mark 加载所有会议数据
- (void)refreshAllMeetingData
{
    self.allMeetingModel.page = 1;
    [self loadAllMeetingData];
}

- (void)loadAllMeetingData
{
    [MSAllMeetingModel meetingListNetworkHUD:NetworkHUDBackground
                                        page:self.allMeetingModel.page
                                      target:self
                                     success:^(StatusModel *data) {
                                         isLoadedAllMeetingData = YES;
                                         [tableAllMeetingView.mj_header endRefreshing];
                                         [tableAllMeetingView.mj_footer endRefreshing];
                                         MSAllMeetingModel *allMeetings = (MSAllMeetingModel*)data.data;
                                         if (data.code == 0) {
                                             if (allMeetings.firstPage) {
                                                 [self.allMeetingModel.dayGroupList removeAllObjects];
                                             }
                                             if (allMeetings.hasNextPage) {
                                                 self.allMeetingModel.page ++;
                                                 tableAllMeetingView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadAllMeetingData)];
                                                 
                                             } else {
                                                 [tableAllMeetingView.mj_footer endRefreshingWithNoMoreData];
                                             }
                                             
                                             //加载当天会议
                                             [self.allMeetingModel.todayList removeAllObjects];
                                             if (allMeetings.todayList.count) {
                                                 [self loadMember:allMeetings.todayList];
                                                 [self.allMeetingModel.todayList addObjectsFromArray:allMeetings.todayList];
                                                 
                                             }
                                             //加载全部会议
                                             if (allMeetings.dayGroupList.count) {
                                                 [self loadMember:allMeetings.dayGroupList];
                                                 [self.allMeetingModel.dayGroupList addObjectsFromArray:allMeetings.dayGroupList];
                                             }
                                             
                                             //刷新UI
                                             if (self.allMeetingModel.todayList.count) {
                                                 tableAllMeetingView.tableHeaderView = self.todayMeetingView;
                                                 [self.todayMeetingView reloadWithDatas:self.allMeetingModel.todayList];
                                             } else {
                                                 //隐藏
                                                 tableAllMeetingView.tableHeaderView = nil;
                                             }
                                             
                                             if (!self.allMeetingModel.dayGroupList.count && !self.allMeetingModel.todayList.count) {
                                                 self.noMeetingDataTipsView.hidden = NO;
                                                 [self.noMeetingDataTipsView reloadTips:@"您還沒有預訂過會議室" subTips:nil withType:ErrorTipsType_NoData];
                                             } else {
                                                 self.noMeetingDataTipsView.hidden = YES;
                                             }
                                             [tableAllMeetingView reloadData];
                                             
                                         } else {
                                             [HUDManager alertWithTitle:data.msg];
                                         }
    }];
}

- (void)loadMemberHeadImageWithMeetingDetailModel:(MSMeetingDetailModel*)model copyDetailModel:(MSMeetingDetailModel*)copyModel
{
    if (!model.members.count || model.isLoadedHeadURL) {
        return;
    }
    [MSMemberModel memberHeadsWithIds:model.others
                           NetworkHUD:NetworkHUDBackground
                               target:self
                              success:^(StatusModel *data) {
                                  if (data.code == 0) {
                                      NSArray *memberHeads = data.data;
                                      model.isLoadedHeadURL = YES;
                                      [model.members enumerateObjectsUsingBlock:^(MSMemberModel  *member, NSUInteger idx, BOOL * _Nonnull stop) {
                                          [self updateMemberHeadImageDatas:memberHeads matchMember:member];
                                      }];
                                      
                                      [copyModel.members enumerateObjectsUsingBlock:^(MSMemberModel  *member, NSUInteger idx, BOOL * _Nonnull stop) {
                                          [self updateMemberHeadImageDatas:memberHeads matchMember:member];
                                      }];
                                  }
    }];
}

- (void)updateMemberHeadImageDatas:(NSArray*)datas matchMember:(MSMemberModel*)matchModel
{
    for (int i = 0; i<datas.count; i++) {
        MSMemberModel *model = [datas objectAtIndex:i];
        if ([model.memberId isEqualToString:matchModel.memberId]) {
            matchModel.headURL = model.headURL;
            break;
        }
    }
}

- (void)loadMember:(NSArray *)list
{
    for (int i = 0; i<list.count; i++) {
        id obj = [list objectAtIndex:i];
        if ([obj isKindOfClass:[MSMeetingDetailModel class]]) {
            MSMeetingDetailModel *mode = (MSMeetingDetailModel*)obj;
            [self createMemberWithModel:mode];
        } else if ([obj isKindOfClass:[MSDayGroupList class]]){
            MSDayGroupList *dayGroupList = (MSDayGroupList*)obj;
            for (int j = 0; j < dayGroupList.list.count; j++) {
                MSMeetingDetailModel *model = [dayGroupList.list objectAtIndex:j];
                [self createMemberWithModel:model];
            }
        }
    }
}

- (void)createMemberWithModel:(MSMeetingDetailModel*)model
{
    if (model.others.length && model.othersName.length) {
        NSArray *memberIds = [model.others componentsSeparatedByString:@","];
        NSArray *memberNames = [model.othersName componentsSeparatedByString:@","];
        for (int j = 0; j<memberNames.count; j++) {
            MSMemberModel *member = [[MSMemberModel alloc] init];
            if (memberIds.count>j) {
                member.memberId = [memberIds objectAtIndex:j];
            }
            member.name = [memberNames objectAtIndex:j];
            [model.members addObject:member];
        }
    }
}

- (NSInteger)fetchOtherUnfoldCell:(NSInteger)section
{
    __block NSInteger otherUnfoldSection = 0;
    [self.noticeArray enumerateObjectsUsingBlock:^(MSMeetingDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != section && model.isUnfold) {
            otherUnfoldSection = idx;
            model.isUnfold = NO;
            *stop = YES;
        }
    }];
    return otherUnfoldSection;
}

#pragma mark  通知-详情中-点击我知道了
- (void)didClickNoticeDetailSureActionCell:(MSNoticeDetailCell *)cell
{
    NSIndexPath *indexPath = [tableNoticeView indexPathForCell:cell];
    MSMeetingDetailModel *model = [self.noticeArray objectAtIndex:indexPath.section];
    [MSMeetingDetailModel didReadNoticeInfo:model.remindId networkHUD:NetworkHUDBackground target:self success:^(StatusModel *data) {
        if (data.code == 0) {
            NSLog(@"設置已讀成功");
        }
    }];
    //直接删除
    [self.noticeArray removeObject:model];
    [tableNoticeView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 所有会议-详情中-点击确定/取消
- (void)didClickMeetingDetailActionCell:(MSAllMeetingDetailCell *)cell action:(NSInteger)action
{
    if (action == 0) {
        //確定
        NSIndexPath *indexPath = [tableAllMeetingView indexPathForCell:cell];
        if (isViewToDayDetail && indexPath.section == 0) {
            isViewToDayDetail = NO;
            lastViewToDayDetailIndex = -1;
            [tableAllMeetingView reloadData];
        } else {
            NSInteger section = indexPath.section;
            if (isViewToDayDetail) {
                section = section - 1;
            }
            MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:section];
            MSMeetingDetailModel *dayDetailModel = [dayGroupList.list objectAtIndex:indexPath.row-1];
            dayDetailModel.isUnfold = NO;
            
            [dayGroupList.list removeObjectAtIndex:indexPath.row];
            [tableAllMeetingView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //取消會議
                NSIndexPath *indexPath = [tableAllMeetingView indexPathForCell:cell];
                
                NSString *meetingID;
                
                if (isViewToDayDetail) {
                    if (indexPath.section == 0) {
                        MSMeetingDetailModel *detailModel = [self.allMeetingModel.todayList objectAtIndex:lastViewToDayDetailIndex];
                        meetingID = detailModel.remindId;
                    } else {
                        MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:indexPath.section-1];
                        MSMeetingDetailModel *detailModel = [dayGroupList.list objectAtIndex:indexPath.row];
                        meetingID = detailModel.remindId;
                    }
                } else {
                    MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:indexPath.section];
                    MSMeetingDetailModel *detailModel = [dayGroupList.list objectAtIndex:indexPath.row];
                    meetingID = detailModel.remindId;
                }
                
                [MSMeetingDetailModel cancelMeetingInfo:meetingID networkHUD:NetworkHUDLockScreenAndError target:self success:^(StatusModel *data) {
                    if (data.code == 0) {
                        NSIndexPath *indexPath = [tableAllMeetingView indexPathForCell:cell];
                        NSInteger section = indexPath.section;
                        if (isViewToDayDetail) {
                            if (indexPath.section == 0) {
                                [self.allMeetingModel.todayList removeObjectAtIndex:lastViewToDayDetailIndex];
                                [self.todayMeetingView reloadWithDatas:self.allMeetingModel.todayList];
                                lastViewToDayDetailIndex = -1;
                                isViewToDayDetail = NO;
                                [tableAllMeetingView reloadData];
                                return;
                            } else {
                                section = section - 1;
                            }
                        }
                        MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:section];
                        if (dayGroupList.list.count == 2) {
                            //移除整个section
                            [self.allMeetingModel.dayGroupList removeObject:dayGroupList];
                            [tableAllMeetingView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                        } else {
                            //移除其中一个数据，包含详情
                            NSIndexPath *listIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                            [dayGroupList.list removeObjectsInRange:NSMakeRange(indexPath.row-1, 2)];
                            [tableAllMeetingView deleteRowsAtIndexPaths:@[listIndexPath,indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        }
                    }
                }];
            }
        } title:@"提示" message:@"確定要取消該會議嗎？" cancelButtonName:@"取消" otherButtonTitles:@"確定", nil];
        
    }
    
}

#pragma mark 横向滚动视图代理
//所有会议-当天会议
- (void)didClickToDayMeetingView:(MSTodayMeetingView *)view itemIndex:(NSInteger)index
{
    if (index == lastViewToDayDetailIndex) {
        isViewToDayDetail = !isViewToDayDetail;
    } else {
        isViewToDayDetail = YES;
    }
    lastViewToDayDetailIndex = index;
    self.todayMeetingDetail = [self.allMeetingModel.todayList objectAtIndex:index];
    [tableAllMeetingView reloadData];
}

//所有会议-当天滚动时触发
- (void)scrollEndToDayMeetingView:(MSTodayMeetingView*)view itemIndex:(NSInteger)index
{
    if (isViewToDayDetail) {
        if (index != lastViewToDayDetailIndex) {
            isViewToDayDetail = NO;
            self.todayMeetingDetail = nil;
            lastViewToDayDetailIndex = -1;
            [tableAllMeetingView reloadData];
        }
    }
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == tableNoticeView) {
        MSMeetingDetailModel *model = [self.noticeArray objectAtIndex:indexPath.section];
        if (indexPath.row == 0) {
            model.isUnfold = !model.isUnfold;
            [tableNoticeView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            [self loadMemberHeadImageWithMeetingDetailModel:model copyDetailModel:nil];
        }
        //收起其他展开项目
        NSInteger otherUnfoldSecion = [self fetchOtherUnfoldCell:indexPath.section];
        if (otherUnfoldSecion != -1) {
            [tableNoticeView reloadSections:[NSIndexSet indexSetWithIndex:otherUnfoldSecion] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        if (isViewToDayDetail) {
            if (section == 0) {
                return;
            } else {
                section = section - 1;
            }
        }
        MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:section];
        MSMeetingDetailModel *dayDetailModel = [dayGroupList.list objectAtIndex:row];
        if (!dayDetailModel.isDetail) {
            if (dayDetailModel.isUnfold) {
                //折叠详情
                [dayGroupList.list removeObjectAtIndex:row+1];
                NSIndexPath *indexP = [NSIndexPath indexPathForRow:row+1 inSection:section];
                [tableView deleteRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                //展开详情
                MSMeetingDetailModel *copyDetail = [dayDetailModel copy];
                copyDetail.isDetail = YES;
                [dayGroupList.list insertObject:copyDetail atIndex:row+1];
                NSIndexPath *indexP = [NSIndexPath indexPathForRow:row+1 inSection:indexPath.section];
                [tableView insertRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationFade];
                
                [self loadMemberHeadImageWithMeetingDetailModel:dayDetailModel copyDetailModel:copyDetail];
            }
            
            dayDetailModel.isUnfold = !dayDetailModel.isUnfold;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableNoticeView) {
        MSMeetingDetailModel *model = [self.noticeArray objectAtIndex:indexPath.section];
        if (model.isUnfold) {
            if (indexPath.row == 0) {
                return [MSNoticeCellView noticeCellHeight];
            } else {
                return [MSNoticeDetailCell meetingDetailHeight:model];
            }
        } else {
            return [MSNoticeCellView noticeCellHeight];
        }
    } else {
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        if (isViewToDayDetail) {
            if (indexPath.section == 0) {
                return [MSAllMeetingDetailCell meetingDetailHeight:self.todayMeetingDetail];
            } else {
                section = indexPath.section - 1;
            }
        }
        MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:section];
        MSMeetingDetailModel *dayDetailModel = [dayGroupList.list objectAtIndex:row];
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
        if (isViewToDayDetail && section == 0) {
            return 0.001;
        } else {
            return 46;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableNoticeView) {
        MSMeetingDetailModel *model = [self.noticeArray objectAtIndex:section];
        return model.isUnfold?2:1;
    } else {
        NSInteger index = section;
        if (isViewToDayDetail) {
            if (section == 0) {
                return 1;
            } else {
                index = section-1;
            }
        }
        MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:index];
        return dayGroupList.list.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == tableNoticeView) {
        return self.noticeArray.count;
    } else {
        return isViewToDayDetail?self.allMeetingModel.dayGroupList.count+1:self.allMeetingModel.dayGroupList.count;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tableAllMeetingView) {
        NSInteger index = section;
        if (isViewToDayDetail) {
            index = section-1;
            if (section == 0) {
                return nil;
            }
        }
        MSDayGroupList *dayGroupList = [self.allMeetingModel.dayGroupList objectAtIndex:index];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MSMeetingDetailModel *model = [self.noticeArray objectAtIndex:indexPath.section];
        if (model.isUnfold) {
            //考慮一個列表和一個詳情
            if (indexPath.row == 0) {
                [cell data:model];
            } else {
                MSNoticeDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"MSNoticeDetailCell"];
                [detailCell showTopShadow:YES];
                detailCell.delegate = self;
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
        
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        if (isViewToDayDetail) {
            if (section == 0) {
                //展开的详情
                MSAllMeetingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSAllMeetingDetailCell"];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell data:self.todayMeetingDetail];
                return cell;
            } else {
                section = section - 1;
            }
        }
        
        MSDayGroupList *dayGroupModel = [self.allMeetingModel.dayGroupList objectAtIndex:section];
        MSMeetingDetailModel *dayDetailModel = [dayGroupModel.list objectAtIndex:row];
        
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableView *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableAllMeetingView) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark 個人中心
- (void)userInfoClick:(UIButton*)button
{
    NSLog(@"個人中心");
    if (!userCenterView) {
        userCenterView = [MSMeetingUserCenterView new];
        userCenterView.delegate = self;
    }
    [userCenterView showUserCenterView];
}

#pragma mark  新增預約
- (void)didClickOrder:(MSOrderMeetingButtonView*)view
{
    NSLog(@"新增會與預約");
    MSNewMeetingViewController *newMeetingVC = [[MSNewMeetingViewController alloc] init];
    MSNavigationController *newMeetingNav = [[MSNavigationController alloc] initWithRootViewController:newMeetingVC];
    [self presentViewController:newMeetingNav animated:YES completion:^{
        
    }];
}

- (void)didClickMeetingUserCenterViewItem:(NSInteger)itemIndex
{
    [userCenterView hideUserCenterView];
    if (itemIndex == 0) {
        //修改头像
        MSUserHeadViewController *headVC = [[MSUserHeadViewController alloc] init];
        [self.navigationController pushViewController:headVC animated:YES];
    } else if (itemIndex == 1) {
        //修改密碼
        MSUpdatePwdViewController *updatePwdVC = [[MSUpdatePwdViewController alloc] init];
        [self.navigationController pushViewController:updatePwdVC animated:YES];
    } else if (itemIndex == 2) {
        //註銷
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self userLoginOut];
            }
        } title:@"提示" message:@"確定要註銷？" cancelButtonName:@"取消" otherButtonTitles:@"確定", nil];
    }
}

- (void)openURL:(NSString *)urlString
{
//    urlString = @"itms-apps://itunes.apple.com/us/app/aio-會議雲管理/id1238981833?l=zh&ls=1&mt=8";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        NSLog(@"can not open");
    }
}

#pragma mark 检查更新
- (void)checkAppUpdateOnBackgroud:(BOOL)back
{
    //檢查更新
    if (!back) {
        [HUDManager showHUDWithMessage:@"版本檢測中..."];
    }
    [MSUserInfo checkVersionNetworkHUD:NetworkHUDBackground target:self success:^(StatusModel *data) {
        [HUDManager hiddenHUD];
        if (0 == data.code) {
            BOOL isLatest = [[data.originalData objectForKey:@"isLatest"] boolValue];
            BOOL force = [[data.originalData objectForKey:@"force"] boolValue];
            NSString *url = [data.originalData objectForKey:@"url"];
            if (!isLatest) {
                //提示跟新
                [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self openURL:url];
                    }
                } title:@"提示" message:@"發現有新版本！" cancelButtonName:@"取消" otherButtonTitles:@"立即更新", nil];
                
            } else {
                if (!back) {
                    [HUDManager alertWithTitle:@"当前为最新版本"];
                }
            }
        } else {
            if (!back) {
                [HUDManager alertWithTitle:data.msg];
            }
        }
    }];
}

#pragma mark 用户退出
- (void)userLoginOut
{
    //注销推送信息
    NSString *deviceTokenString = [[[[[[MSUserInfo shareUserInfo] getDeviceToken] description]
                                     stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                    stringByReplacingOccurrencesOfString:@">" withString:@""]
                                   stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenString：%@", deviceTokenString);
    NSString *jPushRegistrationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"kJPushRegistrationID"];
    NSString *registerId = jPushRegistrationID.length?jPushRegistrationID:@"";
    deviceTokenString = deviceTokenString.length?deviceTokenString:@"";
    [MSUserInfo unRegisterPush:registerId deviceToken:deviceTokenString target:self success:^(StatusModel *data) {
        
    }];
    
    [MSUserInfo loginOutNetworkHUD:NetworkHUDLockScreen target:self success:^(StatusModel *data) {
        
    }];
    
    [self setLogoutInfo];
}

- (void)setLogoutInfo
{
    //注销token 发送退出登录通知
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MSUserInfo shareUserInfo].token = nil;
        [[MSUserInfo shareUserInfo] deletePassword];
        MSUserInfo *userInfo = [MSUserInfo shareUserInfo];
        if ([userInfo saveToDB]) {
            [kAppDelegate authorizeOperation];
        }
    });
}

- (void)userTokenExpire
{
    [self setLogoutInfo];
}

#pragma mark  切換tabbar
- (void)didClickNavTabbarView:(NSInteger)itemIndex
{
    if (itemIndex == 0) {
        [mainScrollView scrollToHorizontalPageIndex:0 animated:YES];
    } else {
        [mainScrollView scrollToHorizontalPageIndex:1 animated:YES];
        if (!isLoadedAllMeetingData) {
            [tableAllMeetingView.mj_header beginRefreshing];
        }
    }
}

#pragma mark  滾動視圖時觸發
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == mainScrollView) {
        NSInteger index = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
        [navTabbarView selectedItemIndex:index];
        if (index == 1 && !isLoadedAllMeetingData) {
            [tableAllMeetingView.mj_header beginRefreshing];
        }
    }
}

#pragma mark 懒加载
- (NSMutableArray *)noticeArray;
{
    if (!_noticeArray) {
        _noticeArray = [[NSMutableArray alloc] init];
    }
    return _noticeArray;
}

- (MSAllMeetingModel*)allMeetingModel
{
    if (!_allMeetingModel) {
        _allMeetingModel = [[MSAllMeetingModel alloc] init];
    }
    return _allMeetingModel;
}

- (MSTodayMeetingView*)todayMeetingView
{
    if (!_todayMeetingView) {
        _todayMeetingView = [[MSTodayMeetingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 212)];
        _todayMeetingView.delegate = self;
    }
    return _todayMeetingView;
}

- (CSErrorTips*)noMeetingDataTipsView
{
    if (!_noMeetingDataTipsView) {
        _noMeetingDataTipsView = [[CSErrorTips alloc] initWithFrame:CGRectZero];
        [tableAllMeetingView addSubview:_noMeetingDataTipsView];
        _noMeetingDataTipsView.frame = CGRectMake(0, 0, kScreenWidth, mainScrollView.height);
    }
    return _noMeetingDataTipsView;
}

#pragma mark 通知处理
- (void)handleNotification:(NSDictionary *)userInfo isActive:(BOOL)isActive
{
    APSModel *apsMsg = [APSModel mj_objectWithKeyValues:userInfo];
    if (isActive) {
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {

        } title:@"您有新的會議提醒" message:apsMsg.aps.alert.title cancelButtonName:@"我知道了" otherButtonTitles:nil];
    }
    
    [self refreshNoticeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
