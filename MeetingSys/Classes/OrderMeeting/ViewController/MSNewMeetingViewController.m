//
//  MSNewMeetingViewController.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/13.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSNewMeetingViewController.h"
#import "MSNewMeetingTimeCell.h"
#import "MSNewMeetingInputCell.h"
#import "MSNewMeetingSelectCell.h"
#import "MSNewMeetingHeadView.h"
#import "MSNewMeetingONOffCell.h"
#import "SHMSelectActionView.h"
#import "MSSelectMemeberViewController.h"
#import "MSMeetingDetailModel.h"
#import "CSDatePickView.h"
#import "MSMeetingRoomModel.h"

@interface MSNewMeetingViewController ()<MSNewMeetingTimeCellDelegate,CSDatePickViewDelegate,SHMSelectActionViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *newMeetingTableView;
    UIButton    *newMeetingButton;
    SHMSelectActionView *selectThemeView;
    SHMSelectActionView *selectRoomsView;
    CSDatePickView *_datePickerView;
    BOOL isSelectBeginTimeing;
}

@property (nonatomic, strong) MSNewMeetingHeadView *headView;

@property (nonatomic, strong) NSMutableArray *meetingTypeData;//會議類型

@property (nonatomic, strong) NSMutableArray *roomsData;//會議地點

@property (nonatomic, strong) NSMutableArray *meetingOthers;//參與人員

@property (nonatomic, strong) MSMeetingDetailModel *meetingInfoObj;

@end

@implementation MSNewMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增預約";
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (MSMeetingDetailModel*)meetingInfoObj
{
    if (!_meetingInfoObj) {
        _meetingInfoObj = [[MSMeetingDetailModel alloc] init];
    }
    return _meetingInfoObj;
}

- (MSNewMeetingHeadView*)headView
{
    if (!_headView) {
        _headView = [[MSNewMeetingHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    }
    return _headView;
}

- (NSMutableArray*)meetingTypeData
{
    if (!_meetingTypeData) {
        _meetingTypeData = [[NSMutableArray alloc] init];
        [_meetingTypeData addObject:@"會議使用"];
        [_meetingTypeData addObject:@"洽談使用"];
    }
    return _meetingTypeData;
}

- (NSMutableArray*)roomsData
{
    if (!_roomsData) {
        _roomsData = [[NSMutableArray alloc] init];
    }
    return _roomsData;
}

- (NSMutableArray*)meetingOthers
{
    if (!_meetingOthers) {
        _meetingOthers = [[NSMutableArray alloc] init];
    }
    return _meetingOthers;
}

- (void)loadSubView
{
    [self leftBarButtonWithName:@"" image:[UIImage imageNamed:@"guanbi"] target:self action:@selector(closeView:)];
    
    [self rightBarButtonWithName:@"確認" normalImgName:@"" highlightImgName:@"" target:self action:@selector(submitMeetingAction:)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    newMeetingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    newMeetingTableView.backgroundColor = UIColorHex(0xf6f6f6);
    newMeetingTableView.delegate = self;
    newMeetingTableView.dataSource = self;
    newMeetingTableView.tableHeaderView = self.headView;
    newMeetingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [newMeetingTableView registerClass:[MSNewMeetingTimeCell class] forCellReuseIdentifier:@"MSNewMeetingTimeCell"];
    [newMeetingTableView registerClass:[MSNewMeetingInputCell class] forCellReuseIdentifier:@"MSNewMeetingInputCell"];
    [newMeetingTableView registerClass:[MSNewMeetingSelectCell class] forCellReuseIdentifier:@"MSNewMeetingSelectCell"];
    [newMeetingTableView registerClass:[MSNewMeetingONOffCell class] forCellReuseIdentifier:@"MSNewMeetingONOffCell"];
    [self.view addSubview:newMeetingTableView];
}

- (void)submitMeetingAction:(UIButton*)button
{

}

- (void)selectMeetingTheme
{
    if (!selectThemeView) {
        selectThemeView = [[SHMSelectActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        selectThemeView.delegate = self;
    }
    selectThemeView.title = @"會議類型";
    selectThemeView.isMutibleSelect = NO;
    
    selectThemeView.dataArray = self.meetingTypeData;
    [selectThemeView showSelectActionView];
}

- (void)selectRooms
{
    if (!selectRoomsView) {
        selectRoomsView = [[SHMSelectActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        selectRoomsView.delegate = self;
    }
    selectRoomsView.title = @"會議地點";
    selectRoomsView.isMutibleSelect = NO;
    [selectRoomsView showSelectActionView];
    
    [self loadMeetingRooms];
}

- (void)loadMeetingRooms
{
    [MSMeetingRoomModel getRoomsWithMeetingType:self.meetingInfoObj.meetingType
                                      beginTime:self.meetingInfoObj.beginTime
                                        endTime:self.meetingInfoObj.endTime
                                     networkHUD:NetworkHUDBackground
                                         target:self
                                        success:^(StatusModel *data) {
        
                                            if (data.code == 0) {
                                                NSArray *rooms = [MSMeetingRoomModel mj_objectArrayWithKeyValuesArray:[data.originalData objectForKey:@"rooms"]];
                                                [self.roomsData removeAllObjects];
                                                [self.roomsData addObjectsFromArray:rooms];
                                                selectRoomsView.dataArray = [self roomsName];
                                                [selectRoomsView showLoading:NO];
                                            } else {
                                                [HUDManager alertWithTitle:data.msg];
                                                [selectRoomsView hideSelectActionView];
                                            }
    }];
}

- (NSMutableArray*)roomsName
{
    NSMutableArray *names = [[NSMutableArray alloc] init];
    [self.roomsData enumerateObjectsUsingBlock:^(MSMeetingRoomModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [names addObject:model.mName];
    }];
    return names;
}

#pragma mark SHMSelectActionViewDelegate
/**
 *  视图隐藏完成时调用的代理方法
 *
 *  @param view 返回操作的视图对象
 */
- (void)didHideSelectItemView:(SHMSelectActionView *)view
{
    //取消先前选中的状态
//    [tableViewList deselectRowAtIndexPath:tableViewList.indexPathForSelectedRow animated:YES];
}

/**
 *  选择完选项代理方法
 *
 *  @param view   返回操作的视图对选
 *  @param indexs 返回选择操作的数据索引，若是单选，数组只包含一个索引，若为多选是选中的数据索引集合。
 */
- (void)didSelectItemWithView:(SHMSelectActionView*)view itemIndexs:(NSMutableArray*)indexs
{
    if (view == selectThemeView) {
        NSInteger indexItem = [[indexs objectAtIndex:0] integerValue];
        NSString *meetingTypeString = [self.meetingTypeData objectAtIndex:indexItem];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        MSNewMeetingSelectCell *cell = [newMeetingTableView cellForRowAtIndexPath:indexPath];
        self.meetingInfoObj.meetingType = indexItem+1;
        [cell contentText:meetingTypeString];
    } else if (view == selectRoomsView) {
        NSInteger indexItem = [[indexs objectAtIndex:0] integerValue];
        MSMeetingRoomModel *room = [self.roomsData objectAtIndex:indexItem];
        self.meetingInfoObj.roomId = room.roomId;
        self.meetingInfoObj.address = room.mName;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        MSNewMeetingSelectCell *cell = [newMeetingTableView cellForRowAtIndexPath:indexPath];
        [cell contentText:self.meetingInfoObj.address];
    }
}

- (void)didClickSelectDateTimeView:(MSNewMeetingTimeCell*)cell itemIndex:(NSInteger)index
{
    //日期
    NSDate *date;
    if (!_datePickerView) {
        _datePickerView = [[CSDatePickView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _datePickerView.delegate = self;
    }
    isSelectBeginTimeing = index==0?YES:NO;
    if (index == 0) {
        //開始時間
        if (self.meetingInfoObj.beginTime) {
            date = self.meetingInfoObj.beginTime;
        }else{
            date = [NSDate date];
        }
        _datePickerView.title = @"開始時間";
    } else {
        //結束時間
        if (self.meetingInfoObj.endTime) {
            date = self.meetingInfoObj.endTime;
        }else{
            date = [NSDate date];
        }
        _datePickerView.title = @"結束時間";
    }
    _datePickerView.datePicker.maximumDate = nil;
    _datePickerView.datePicker.minimumDate = [NSDate date];
    [_datePickerView.datePicker setDate:date];
    [_datePickerView showDatePickerView];
}

#pragma mark- CSDatePickViewDelegate
- (void)didPickerDate:(NSDate *)date
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    if (isSelectBeginTimeing) {
        if (!self.meetingInfoObj.endTime) {
            //不需要比較
            self.meetingInfoObj.beginTime = date;
            [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            if ([date compare:self.meetingInfoObj.endTime] != NSOrderedAscending) {
                [HUDManager alertWithTitle:@"開始時間不能大於結束時間！"];
            } else {
                self.meetingInfoObj.beginTime = date;
                [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    } else {
        if (!self.meetingInfoObj.beginTime) {
            //不需要比較
            self.meetingInfoObj.endTime = date;
            [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            if ([self.meetingInfoObj.beginTime compare:date] != NSOrderedAscending) {
                [HUDManager alertWithTitle:@"結束時間不能小於開始時間！"];
            } else {
                self.meetingInfoObj.endTime = date;
                [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        [self selectMeetingTheme];
    } else if (indexPath.row == 5 || indexPath.row == 6) {
        MSNewMeetingSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        MSSelectMemeberViewController *memberVC = [[MSSelectMemeberViewController alloc] init];
        memberVC.memberType = indexPath.row == 5 ? MSSelectMemeber_Organizer:MSSelectMemeber_Others;
        if (indexPath.row == 6) {
            [memberVC.selectedMemebers addObjectsFromArray:self.meetingOthers];
        }
        @weakify(self)
        memberVC.selectBlock = ^(MSSelectMemeberType selectType, NSArray *members) {
            @strongify(self)
            if (selectType == MSSelectMemeber_Organizer) {
                MSMemberModel *model = [members objectAtIndex:0];
                self.meetingInfoObj.organizeName = model.name;
                self.meetingInfoObj.organizeId = model.memberId;
                [cell contentText:model.name];
            } else {
                NSMutableString *names = [[NSMutableString alloc] init];
                NSMutableString *ids = [[NSMutableString alloc] init];
                for (int i = 0; i< members.count; i++) {
                    MSMemberModel *model = [members objectAtIndex:i];
                    if (i == 0) {
                        [names appendString:model.name];
                        [ids appendString:model.memberId];
                    } else {
                        [names appendFormat:@",%@",model.name];
                        [ids appendFormat:@",%@",model.memberId];
                    }
                }
                self.meetingInfoObj.others = ids;
                self.meetingInfoObj.othersName = names;
                [self.meetingOthers removeAllObjects];
                [self.meetingOthers addObjectsFromArray:members];
                [cell contentText:names];
            }
        };
        [self.navigationController pushViewController:memberVC animated:YES];
    } else if (indexPath.row == 4) {
        if (!self.meetingInfoObj.beginTime || !self.meetingInfoObj.endTime) {
            [HUDManager alertWithTitle:@"請完善預約時間！"];
            return;
        } else if (!self.meetingInfoObj.meetingType) {
            [HUDManager alertWithTitle:@"請選擇會議類型！"];
            return;
        } else {
            [self selectRooms];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7 || indexPath.row == 8) {
        return 110;
    } else if (indexPath.row == 0){
        return 50;
    } else {
        return 70;
    }
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
    return 9;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 7 || indexPath.row == 8) {
        NSArray *titles = @[@"會議主題",@"會議議程",@"會議要求"];
        NSArray *placeholders = @[@"請輸入會議主題",@"請輸入會議議程",@"請輸入會議要求"];
        MSNewMeetingInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingInputCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger index = indexPath.row==1?0:indexPath.row-6;
        [cell multipleLineInput:indexPath.row == 1?NO:YES title:titles[index] placeholder:placeholders[index] must:indexPath.row==1?YES:NO];
        return cell;
    } else if (indexPath.row >= 3 && indexPath.row <= 6) {
        NSArray *titles = @[@"會議類型",@"會議地點",@"會議組織者",@"參與人員"];
        MSNewMeetingSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingSelectCell"];
        [cell title:titles[indexPath.row-3] placeholder:@"請選擇" mustItem:indexPath.row==6?NO:YES rightView:NO];
        if (indexPath.row == 3 && self.meetingInfoObj.meetingType) {
            [cell contentText:[self.meetingTypeData objectAtIndex:self.meetingInfoObj.meetingType-1]];
        }
        if (indexPath.row == 4 && self.meetingInfoObj.address.length) {
            [cell contentText:self.meetingInfoObj.address];
        }
        if (indexPath.row == 5 && self.meetingInfoObj.organizeName.length) {
            [cell contentText:self.meetingInfoObj.organizeName];
        }
        if (indexPath.row == 6 && self.meetingInfoObj.othersName.length) {
            [cell contentText:self.meetingInfoObj.othersName];
        }
        return cell;
    } else if (indexPath.row == 2){
        MSNewMeetingTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingTimeCell"];
        cell.delegate = self;
        NSString *begin = self.meetingInfoObj.beginTime?[self.meetingInfoObj.beginTime dateWithFormat:@"yyyy-MM-dd HH:mm"]:@"請選擇開始時間";
        NSString *end = self.meetingInfoObj.endTime?[self.meetingInfoObj.endTime dateWithFormat:@"yyyy-MM-dd HH:mm"]:@"請選擇結束時間";
        [cell title:@"會議時間" mustItem:YES begin:begin end:end];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        MSNewMeetingONOffCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingONOffCell"];
        
        [cell title:@"隱藏個人半身照" mustItem:NO on:self.meetingInfoObj.hideThemeHead];
        cell.actionBlock = ^(BOOL isON) {
            self.meetingInfoObj.hideThemeHead = !isON;
        };
        return cell;
    }
}

- (void)closeView:(UIButton*)button
{
    [self dismissViewControllerAnimated:YES completion:^(){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImage *bgImage = [UIImage imageWithColor:UIColorHex(0xFF845F)];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 2,1) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBarTintColor:UIColorHex(0xFF845F)];
    [self.navigationController.navigationBar setTintColor:UIColorHex(0xFF845F)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(0xffffff), NSFontAttributeName:kNavTitleFont}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
