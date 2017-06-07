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
#import "HAlertController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "MSNavBarView.h"

@interface MSNewMeetingViewController ()<MSNewMeetingTimeCellDelegate,CSDatePickViewDelegate,SHMSelectActionViewDelegate,UITableViewDelegate,UITableViewDataSource,MSNewMeetingHeadViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
{
    UITableView *newMeetingTableView;
    UIButton    *newMeetingButton;
    SHMSelectActionView *selectThemeView;
    SHMSelectActionView *selectRoomsView;
    SHMSelectActionView *selectTimeView;  //验证类型选择时间段
    SHMSelectActionView *selectCustomerNumView;  //验证类型选择客户数
    SHMSelectActionView *selectInsuranceNumView;  //验证类型选择保单数
    SHMSelectActionView *selectIsPayView;  //验证类型选择是否缴费
    CSDatePickView *_datePickerView;
    CSDatePickView *_dateDayPickerView;
    BOOL isSelectBeginTimeing;
    
    MSNavBarView *navBarView;
    CGFloat offsetY;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) MSNewMeetingHeadView *headView;

@property (nonatomic, strong) NSMutableArray *meetingTypeData;//會議類型

@property (nonatomic, strong) NSMutableArray *roomsData;//會議地點

@property (nonatomic, strong) NSMutableArray *holidays;//公休假

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
        _meetingInfoObj.organizeName = [MSUserInfo shareUserInfo].nickName;
        _meetingInfoObj.organizeId = [MSUserInfo shareUserInfo].userId;
        _meetingInfoObj.customePay = -1;
    }
    return _meetingInfoObj;
}

- (MSNewMeetingHeadView*)headView
{
    if (!_headView) {
        _headView = [[MSNewMeetingHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 304)];
        _headView.delegate = self;
    }
    return _headView;
}

- (NSMutableArray*)meetingTypeData
{
    if (!_meetingTypeData) {
        _meetingTypeData = [[NSMutableArray alloc] init];
        [_meetingTypeData addObject:@"理财培训学院"];
        [_meetingTypeData addObject:@"理财中心"];
        [_meetingTypeData addObject:@"验证中心"];
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
    [self loadHolidays:0];
    
    newMeetingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
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
    
    navBarView = [[MSNavBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navBarView.navRightButton.enabled = NO;
    navBarView.titleLabel.text = @"新增預約";
    @weakify(self)
    navBarView.actionBlock = ^(NSInteger actionType) {
        @strongify(self)
        if (actionType == 0) {
            [self closeView:nil];
        } else if (actionType == 1) {
            [self submitMeetingAction:nil];
        }
    };
    [self.view addSubview:navBarView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY = %.1f",offsetY);
    if (offsetY<=0) {
        navBarView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    } else if (offsetY <= 64 ) {
        navBarView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:offsetY/64];
    }
    
    if (offsetY > 30) {
        navBarView.titleLabel.textColor = kColorBlack;
        [navBarView.navRightButton setTitleColor:UIColorHex_Alpha(0x333333, 0.6) forState:UIControlStateDisabled];
        [navBarView.navRightButton setTitleColor:UIColorHex_Alpha(0x333333, 1) forState:UIControlStateNormal];
        [navBarView.closeButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        navBarView.titleLabel.textColor = UIColorHex(0xffffff);
        [navBarView.navRightButton setTitleColor:UIColorHex_Alpha(0xffffff, 0.6) forState:UIControlStateDisabled];
        [navBarView.navRightButton setTitleColor:UIColorHex_Alpha(0xffffff, 1) forState:UIControlStateNormal];
        [navBarView.closeButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)submitMeetingAction:(UIButton*)button
{
    [MSMeetingDetailModel submitOrderMeetingInfo:self.meetingInfoObj networkHUD:NetworkHUDLockScreenButNavWithMsg target:self success:^(StatusModel *data) {
        if (data.code == 0) {
            [self closeView:nil];
        }
    }];
}

- (void)selectMeetingTheme
{
    if (!selectThemeView) {
        selectThemeView = [[SHMSelectActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        selectThemeView.delegate = self;
    }
    selectThemeView.title = @"預約類型";
    selectThemeView.isMutibleSelect = NO;
    
    selectThemeView.dataArray = self.meetingTypeData;
    [selectThemeView showSelectActionView];
}

- (void)selectRooms:(NSMutableArray *)rooms
{
    if (!selectRoomsView) {
        selectRoomsView = [[SHMSelectActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        selectRoomsView.delegate = self;
    }
    selectRoomsView.title = @"會議地點";
    selectRoomsView.isMutibleSelect = NO;
    selectRoomsView.dataArray = rooms;
    [selectRoomsView showSelectActionView];
}

- (void)selectTimeWithDay:(NSString *)day
{
    if (!selectTimeView) {
        selectTimeView = [[SHMSelectActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        selectTimeView.delegate = self;
    }
    selectTimeView.title = day;
    selectTimeView.isMutibleSelect = NO;
    selectTimeView.dataArray = [self getTimesWithDay:day];
    [selectTimeView showSelectActionView];
}

- (void)selectCustomerNum
{
    if (!selectCustomerNumView) {
        selectCustomerNumView = [[SHMSelectActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        selectCustomerNumView.delegate = self;
    }
    selectCustomerNumView.title = @"客戶數";
    selectCustomerNumView.isMutibleSelect = NO;
    selectCustomerNumView.dataArray = @[@"1",@"2"];
    [selectCustomerNumView showSelectActionView];
}

- (void)selectInsuranceNum
{
    if (!selectInsuranceNumView) {
        selectInsuranceNumView = [[SHMSelectActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        selectInsuranceNumView.delegate = self;
    }
    selectInsuranceNumView.title = @"保單數";
    selectInsuranceNumView.isMutibleSelect = NO;
    selectInsuranceNumView.dataArray = @[@"1",@"2",@"3"];
    [selectInsuranceNumView showSelectActionView];
}

- (void)selectIsPay
{
    if (!selectIsPayView) {
        selectIsPayView = [[SHMSelectActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        selectIsPayView.delegate = self;
    }
    selectIsPayView.title = @"是否及時繳費";
    selectIsPayView.isMutibleSelect = NO;
    selectIsPayView.dataArray = @[@"是",@"否"];
    [selectIsPayView showSelectActionView];
}

- (NSMutableArray*)getTimesWithDay:(NSString *)day
{
    //判断是否是週六，週六時間段 9:00-14:30
    NSDate *date = [NSDate dateWithString:self.meetingInfoObj.meetingDay format:@"yyyy-MM-dd"];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitDay | NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:date];
    
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowComps = [calendar components:(NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:nowDate];
    
    if (comps.weekday == 7) {
        //周六
        if (nowComps.hour < 9 || nowComps.hour > 15) {
            return nil;
        }
        NSArray *times = @[@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00"];
        NSMutableArray *mutTimes = [[NSMutableArray alloc] initWithArray:times];
        
        if (nowComps.day == comps.day) {
            if (nowComps.hour>=9 && nowComps.hour <= 14) {
                NSInteger stepIndex = (nowComps.hour - 9)*2;
                if (nowComps.minute >= 30) {
                    stepIndex++;
                }
                [mutTimes removeObjectsInRange:NSMakeRange(0, stepIndex+1)];
            }
        }
        
        return mutTimes;
    } else {
        //周一到周五 9:00-17:30
        if (nowComps.hour < 9 || nowComps.hour > 18) {
            return nil;
        }
        NSArray *times = @[@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00"];
        NSMutableArray *mutTimes = [[NSMutableArray alloc] initWithArray:times];
        if (nowComps.day == comps.day) {
            if (nowComps.hour>=9 && nowComps.hour <= 17) {
                NSInteger stepIndex = (nowComps.hour - 9)*2;
                if (nowComps.minute >= 30) {
                    stepIndex++;
                }
                [mutTimes removeObjectsInRange:NSMakeRange(0, stepIndex+1)];
            }
        }
        return mutTimes;
    }
    return nil;
}

- (void)loadMeetingRooms
{
    NSString *begin;
    NSString *end;
    if (self.meetingInfoObj.meetingType == MeetingType_Validate) {
        begin = [NSString stringWithFormat:@"%@ %@",self.meetingInfoObj.meetingDay,self.meetingInfoObj.meetingTime];
        end = nil;
    } else {
        begin = [self.meetingInfoObj.beginTime stringWithFormat:@"yyyy-MM-dd HH:mm"];
        end = [self.meetingInfoObj.endTime stringWithFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    [MSMeetingRoomModel getRoomsWithMeetingType:self.meetingInfoObj.meetingType
                                      beginTime:begin
                                        endTime:end
                                     networkHUD:NetworkHUDLockScreenButNavWithError
                                         target:self
                                        success:^(StatusModel *data) {
        
                                            if (data.code == 0) {
                                                NSArray *rooms = [MSMeetingRoomModel mj_objectArrayWithKeyValuesArray:[data.originalData objectForKey:@"rooms"]];
                                                [self.roomsData removeAllObjects];
                                                [self.roomsData addObjectsFromArray:rooms];
                                                [self selectRooms:[self roomsName]];
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

- (void)loadHolidays:(NSInteger)operate
{
    [MSMeetingDetailModel getHolidayInfoNetworkHUD:NetworkHUDLockScreenButNavWithError
                                            target:self
                                           success:^(StatusModel *data) {
                                               self.holidays = [data.originalData mj_JSONObject];
                                               if (operate == 1) {
                                                   [self pickerDateDayView];
                                               }
    }];
}

- (void)checkInfoComplete
{
    if (self.meetingInfoObj.meetingType == MeetingType_Train) {
        if (self.meetingInfoObj.title.length
            && self.meetingInfoObj.beginTime
            && self.meetingInfoObj.endTime
            && self.meetingInfoObj.meetingType
            && self.meetingInfoObj.roomId.length
            && self.meetingInfoObj.organizeId.length) {
            navBarView.navRightButton.enabled = YES;
        } else {
            navBarView.navRightButton.enabled = NO;
        }
    } else if (self.meetingInfoObj.meetingType == MeetingType_Money) {
        if (self.meetingInfoObj.beginTime
            && self.meetingInfoObj.endTime
            && self.meetingInfoObj.meetingType
            && self.meetingInfoObj.roomId.length
            && self.meetingInfoObj.organizeId.length) {
            navBarView.navRightButton.enabled = YES;
        } else {
            navBarView.navRightButton.enabled = NO;
        }
    } else if (self.meetingInfoObj.meetingType == MeetingType_Validate) {
        if (self.meetingInfoObj.meetingDay.length
            && self.meetingInfoObj.meetingTime.length
            && self.meetingInfoObj.meetingType
            && self.meetingInfoObj.roomId.length
            && self.meetingInfoObj.organizeId.length
            && self.meetingInfoObj.customerName.length
            && self.meetingInfoObj.customerNum
            && self.meetingInfoObj.insuranceNum
            && self.meetingInfoObj.customePay>=0
            && self.meetingInfoObj.productType.length
            && self.meetingInfoObj.contactNum.length) {
            navBarView.navRightButton.enabled = YES;
        } else {
            navBarView.navRightButton.enabled = NO;
        }
    } else {
        navBarView.navRightButton.enabled = NO;
    }
    
}

#pragma mark 选择完选项代理方法 SHMSelectActionViewDelegate
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        MSNewMeetingSelectCell *cell = [newMeetingTableView cellForRowAtIndexPath:indexPath];
        
        NSInteger meetingType = indexItem+1;
        if (meetingType != self.meetingInfoObj.meetingType) {
            //值改变了
            self.meetingInfoObj.meetingType = indexItem+1;
            //清空选择会议地址信息
            self.meetingInfoObj.roomId = nil;
            self.meetingInfoObj.address = nil;
            self.meetingInfoObj.roomTheme = nil;
            self.meetingInfoObj.roomTheme = nil;
            self.meetingInfoObj.roomTimeTips = nil;
            [newMeetingTableView reloadData];
        }
        [cell contentText:meetingTypeString];
        
    } else if (view == selectRoomsView) {
        NSInteger indexItem = [[indexs objectAtIndex:0] integerValue];
        MSMeetingRoomModel *room = [self.roomsData objectAtIndex:indexItem];
        self.meetingInfoObj.roomId = room.roomId;
        self.meetingInfoObj.address = room.mName;
        self.meetingInfoObj.roomTheme = room.roomStyle;
        self.meetingInfoObj.roomTimeTips = [NSString stringWithFormat:@"最長可預訂%zd分鐘",room.maxMinutes];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        MSNewMeetingSelectCell *cell = [newMeetingTableView cellForRowAtIndexPath:indexPath];
        [cell contentText:[NSString stringWithFormat:@"%@(%@)",self.meetingInfoObj.address,self.meetingInfoObj.roomTimeTips]];
        
        MSNewMeetingONOffCell *switchCell = [newMeetingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ([self.meetingInfoObj.roomTheme isEqualToString:@"Legend"]) {
            [switchCell setSwitchEnble:YES];
        } else {
            [switchCell setSwitchEnble:NO];
        }
        [self.headView theme:self.meetingInfoObj.roomTheme hideImage:NO];
        
    } else if (view == selectTimeView) {
        NSInteger indexItem = [[indexs objectAtIndex:0] integerValue];
        self.meetingInfoObj.meetingTime = [[self getTimesWithDay:self.meetingInfoObj.meetingDay] objectAtIndex:indexItem];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (view == selectCustomerNumView) {
        NSInteger indexItem = [[indexs objectAtIndex:0] integerValue];
        self.meetingInfoObj.customerNum = indexItem+1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (view == selectInsuranceNumView) {
        NSInteger indexItem = [[indexs objectAtIndex:0] integerValue];
        self.meetingInfoObj.insuranceNum = indexItem+1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (view == selectIsPayView) {
        NSInteger indexItem = [[indexs objectAtIndex:0] integerValue];
        self.meetingInfoObj.customePay = indexItem==0?0:1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
        [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self checkInfoComplete];
}

- (void)pickerDateDayView
{
    if (!_dateDayPickerView) {
        _dateDayPickerView = [[CSDatePickView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _dateDayPickerView.delegate = self;
    }
    //日期
    NSDate *date = [NSDate date];
    if (self.meetingInfoObj.meetingDay.length) {
        date = [NSDate dateWithString:self.meetingInfoObj.meetingDay format:@"yyyy-MM-dd"];
    }
    _dateDayPickerView.title = @"選擇日期";
    _dateDayPickerView.datePicker.maximumDate = [[NSDate date] dateByAddingYears:1];
    _dateDayPickerView.datePicker.minimumDate = [NSDate date];
    [_dateDayPickerView.datePicker setDate:date];
    [_dateDayPickerView.datePicker setDatePickerMode:UIDatePickerModeDate];
    [_dateDayPickerView showDatePickerView];
}

- (void)didClickSelectDateTimeView:(MSNewMeetingTimeCell*)cell itemIndex:(NSInteger)index
{
    if (self.meetingInfoObj.meetingType == MeetingType_Validate) {
        if (index == 0) {
            
            if (!self.holidays.count) {
                [self loadHolidays:1];
            } else {
                [self pickerDateDayView];
            }
            
        } else {
            if (!self.meetingInfoObj.meetingDay.length) {
                [HUDManager alertWithTitle:@"請先選擇日期"];
            } else {
                [self selectTimeWithDay:self.meetingInfoObj.meetingDay];
            }
        }
        
    } else {
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
    
}

#pragma mark- CSDatePickViewDelegate
- (void)didPickerView:(CSDatePickView *)view date:(NSDate *)date
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    if (self.meetingInfoObj.meetingType == MeetingType_Validate) {
        NSString *selectedDay = [date stringWithFormat:@"yyyy-MM-dd"];
        NSCalendar*calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
                           fromDate:date];
        
        //先判断是否是周日，再判断是否是法定假
        if (comps.weekday == 1 || [self.holidays containsObject:selectedDay]) {
            [HUDManager alertWithTitle:@"不能選擇公休日期，請重新選擇！"];
        } else {
            self.meetingInfoObj.meetingDay = selectedDay;
            self.meetingInfoObj.meetingTime = nil;
            [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self checkInfoComplete];
        }
        NSLog(@"选择日期%@，周%zd", selectedDay,comps.weekday);
    } else {
        if (isSelectBeginTimeing) {
            if (!self.meetingInfoObj.endTime) {
                //不需要比較
                self.meetingInfoObj.beginTime = date;
                [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self checkInfoComplete];
            } else {
                if ([date compare:self.meetingInfoObj.endTime] != NSOrderedAscending) {
                    [HUDManager alertWithTitle:@"開始時間不能大於結束時間！"];
                } else {
                    self.meetingInfoObj.beginTime = date;
                    [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self checkInfoComplete];
                }
            }
        } else {
            if (!self.meetingInfoObj.beginTime) {
                //不需要比較
                self.meetingInfoObj.endTime = date;
                [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self checkInfoComplete];
            } else {
                if ([self.meetingInfoObj.beginTime compare:date] != NSOrderedAscending) {
                    [HUDManager alertWithTitle:@"結束時間不能小於開始時間！"];
                } else {
                    self.meetingInfoObj.endTime = date;
                    [newMeetingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self checkInfoComplete];
                }
            }
        }
    }
    
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        
        [self selectMeetingTheme];
        
    } else if (indexPath.row == 3) {
        if (self.meetingInfoObj.meetingType == MeetingType_Validate) {
            if (!self.meetingInfoObj.meetingType) {
                [HUDManager alertWithTitle:@"請選擇預約類型！"];
                return;
            } else if (!self.meetingInfoObj.meetingDay.length || !self.meetingInfoObj.meetingTime.length) {
                [HUDManager alertWithTitle:@"請完善預約時間！"];
                return;
            }
        } else {
            //加载会议地点
            if (!self.meetingInfoObj.meetingType) {
                [HUDManager alertWithTitle:@"請選擇預約類型！"];
                return;
            } else if (!self.meetingInfoObj.beginTime || !self.meetingInfoObj.endTime) {
                [HUDManager alertWithTitle:@"請完善預約時間！"];
                return;
            }
        }
        
        [self loadMeetingRooms];
        
    } else if (indexPath.row == 4) {
        //选择组织者
        MSNewMeetingSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        MSSelectMemeberViewController *memberVC = [[MSSelectMemeberViewController alloc] init];
        memberVC.memberType = MSSelectMemeber_Organizer;
        @weakify(self)
        memberVC.selectBlock = ^(MSSelectMemeberType selectType, NSArray *members) {
            @strongify(self)
            MSMemberModel *model = [members objectAtIndex:0];
            self.meetingInfoObj.organizeName = model.name;
            self.meetingInfoObj.organizeId = model.memberId;
            [cell contentText:model.name];
            [self checkInfoComplete];
        };
        [self.navigationController pushViewController:memberVC animated:YES];
    } else {
        if (self.meetingInfoObj.meetingType <= MeetingType_Train) {
            if (indexPath.row == 5) {
                //选择参与人员
                MSNewMeetingSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                MSSelectMemeberViewController *memberVC = [[MSSelectMemeberViewController alloc] init];
                memberVC.memberType = MSSelectMemeber_Others;
                [memberVC.selectedMemebers addObjectsFromArray:self.meetingOthers];
                @weakify(self)
                memberVC.selectBlock = ^(MSSelectMemeberType selectType, NSArray *members) {
                    @strongify(self)
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
                };
                [self.navigationController pushViewController:memberVC animated:YES];
            }
        } else {
            //验证类型
            if (indexPath.row == 6) {
                [self selectCustomerNum];
            } else if (indexPath.row == 7) {
                [self selectInsuranceNum];
            } else if (indexPath.row == 8) {
                [self selectIsPay];
            }
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    }
    
    if (self.meetingInfoObj.meetingType <= MeetingType_Train) {
        if (indexPath.row == 7 || indexPath.row == 8) {
            return 110;
        } else {
            return 70;
        }
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
    if (self.meetingInfoObj.meetingType == MeetingType_Money) {
        return 5;
    } else if (self.meetingInfoObj.meetingType == MeetingType_Validate) {
        return 11;
    } else {
        return 9;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MSNewMeetingONOffCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingONOffCell"];
        [cell title:@"隱藏個人半身照" mustItem:NO on:self.meetingInfoObj.hideThemeHead];
        @weakify(self)
        cell.actionBlock = ^(BOOL isON) {
            @strongify(self)
            self.meetingInfoObj.hideThemeHead = isON;
            [self.headView theme:self.meetingInfoObj.roomTheme hideImage:isON];
        };
        return cell;
    } else if (indexPath.row <= 4) {
        if (indexPath.row == 2) {
            MSNewMeetingTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingTimeCell"];
            cell.delegate = self;
            if (self.meetingInfoObj.meetingType == MeetingType_Validate) {
                NSString *begin = self.meetingInfoObj.meetingDay?self.meetingInfoObj.meetingDay:@"請選擇日期";
                NSString *end = self.meetingInfoObj.meetingTime?self.meetingInfoObj.meetingTime:@"請選擇時間段";
                [cell title:@"會議時間" mustItem:YES begin:begin end:end];
            } else {
                NSString *begin = self.meetingInfoObj.beginTime?[self.meetingInfoObj.beginTime dateWithFormat:@"yyyy-MM-dd HH:mm"]:@"請選擇開始時間";
                NSString *end = self.meetingInfoObj.endTime?[self.meetingInfoObj.endTime dateWithFormat:@"yyyy-MM-dd HH:mm"]:@"請選擇結束時間";
                [cell title:@"會議時間" mustItem:YES begin:begin end:end];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            if (indexPath.row == 1) {
                MSNewMeetingSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingSelectCell"];
                [cell title:@"預約類型" placeholder:@"請選擇" mustItem:YES rightView:NO];
                if (self.meetingInfoObj.meetingType) {
                    [cell contentText:[self.meetingTypeData objectAtIndex:self.meetingInfoObj.meetingType-1]];
                }
                return cell;
            } else {
                NSArray *titles = @[@"會議地點",@"會議組織者"];
                MSNewMeetingSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingSelectCell"];
                [cell title:titles[indexPath.row-3] placeholder:@"請選擇" mustItem:YES rightView:NO];
                if (indexPath.row == 3 && self.meetingInfoObj.address.length) {
                    [cell contentText:self.meetingInfoObj.address];
                }
                if (indexPath.row == 4 && self.meetingInfoObj.organizeName.length) {
                    [cell contentText:self.meetingInfoObj.organizeName];
                }
                return cell;
            }
        }
    } else {
        //验证类型和理财中心不需要 主题，参与人员，议程，要求四个选项
        if (self.meetingInfoObj.meetingType <= MeetingType_Train) {
            if (indexPath.row == 5) {
                //参与人员
                MSNewMeetingSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingSelectCell"];
                [cell title:@"參與人員" placeholder:@"請選擇" mustItem:NO rightView:NO];
                if (self.meetingInfoObj.othersName.length) {
                    [cell contentText:self.meetingInfoObj.othersName];
                }
                return cell;
            } else {
                NSArray *titles = @[@"會議主題",@"會議議程",@"會議要求"];
                NSArray *placeholders = @[@"請輸入會議主題",@"請輸入會議議程",@"請輸入會議要求"];
                MSNewMeetingInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingInputCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                @weakify(self)
                cell.inputBlock = ^(NSString *inputText) {
                    @strongify(self)
                    if (indexPath.row == 6) {
                        self.meetingInfoObj.title = inputText;
                    } else if (indexPath.row == 7) {
                        self.meetingInfoObj.agenda = inputText;
                    } else if (indexPath.row == 8) {
                        self.meetingInfoObj.demand = inputText;
                    }
                    [self checkInfoComplete];
                };
                NSInteger index = indexPath.row-6;
                [cell multipleLineInput:indexPath.row == 6?NO:YES title:titles[index] placeholder:placeholders[index] must:indexPath.row==6?YES:NO];
                
                if (indexPath.row == 6) {
                    [cell contentText:self.meetingInfoObj.title multipleLine:NO];
                } else if (indexPath.row == 7) {
                    [cell contentText:self.meetingInfoObj.agenda multipleLine:YES];
                } else if (indexPath.row == 8) {
                    [cell contentText:self.meetingInfoObj.demand multipleLine:YES];
                }
                
                return cell;
            }
            
        } else {
            //验证类型
            if (indexPath.row >=6 && indexPath.row <=8) {
                NSArray *titles = @[@"客人數量",@"保單數量",@"是否及時繳費"];
                MSNewMeetingSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingSelectCell"];
                [cell title:titles[indexPath.row-6] placeholder:@"請選擇" mustItem:YES rightView:NO];
                if (indexPath.row == 6 && self.meetingInfoObj.customerNum) {
                    [cell contentText:[NSString stringWithFormat:@"%zd個",self.meetingInfoObj.customerNum]];
                } else if (indexPath.row == 7 && self.meetingInfoObj.insuranceNum) {
                    [cell contentText:[NSString stringWithFormat:@"%zd個",self.meetingInfoObj.insuranceNum]];
                } else if (indexPath.row == 8 && self.meetingInfoObj.customePay!=-1) {
                    [cell contentText:self.meetingInfoObj.customePay==0?@"是":@"否"];
                }
                return cell;
            } else {
                if (indexPath.row == 5) {
                    //客戶姓名
                    MSNewMeetingInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingInputCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    @weakify(self)
                    cell.inputBlock = ^(NSString *inputText) {
                        @strongify(self)
                        self.meetingInfoObj.customerName = inputText;
                        [self checkInfoComplete];
                    };
                    [cell multipleLineInput:NO title:@"客戶姓名" placeholder:@"請輸入" must:YES];
                    [cell contentText:self.meetingInfoObj.customerName multipleLine:NO];
                    return cell;
                } else {
                    NSArray *titles = @[@"投保產品類別",@"理財顧問聯絡電話"];
                    NSArray *placeholders = @[@"請輸入",@"請輸入"];
                    MSNewMeetingInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingInputCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    @weakify(self)
                    cell.inputBlock = ^(NSString *inputText) {
                        @strongify(self)
                        if (indexPath.row == 9) {
                            self.meetingInfoObj.productType = inputText;
                        } else if (indexPath.row == 10) {
                            self.meetingInfoObj.contactNum = inputText;
                        }
                        [self checkInfoComplete];
                    };
                    NSInteger index = indexPath.row-9;
                    [cell multipleLineInput:NO title:titles[index] placeholder:placeholders[index] must:YES];
                    
                    if (indexPath.row == 9) {
                        [cell contentText:self.meetingInfoObj.productType multipleLine:NO];
                    } else if (indexPath.row == 10) {
                        [cell contentText:self.meetingInfoObj.contactNum multipleLine:NO];
                    }
                    
                    return cell;
                }
            }
        }
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
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    UIImage *bgImage = [UIImage imageWithColor:UIColorHex(0xFF845F)];
//    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 2,1) resizingMode:UIImageResizingModeStretch];
//    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    
//    [self.navigationController.navigationBar setBarTintColor:UIColorHex(0xFF845F)];
//    [self.navigationController.navigationBar setTintColor:UIColorHex(0xFF845F)];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(0xffffff), NSFontAttributeName:kNavTitleFont}];
    
    if (offsetY < 30 ) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//}

//换头像
- (void)didClickHeadView
{
    [self selectPic];
}

- (void)selectPic
{
    //去除更新头像功能
    return;
    // 上传头像
    @weakify(self);
    HAlertController *alertController = [HAlertController alertControllerWithTitle:nil message:nil cannelButton:@"取消" otherButtons:@[@"從手機相冊選取",@"拍照"] type:HAlertControllerTypeCustomValue1 complete:^(NSUInteger buttonIndex, HAlertController *actionController) {
        @strongify(self)
        if (buttonIndex == 2) {
            // 拍照
            [self takePhoto];
        } else if (buttonIndex == 1) {
            // 从相册选择
            [self pushImagePickerController];
        }
    }];
    NSArray *array = [alertController buttonArrayWithCustomValue1];
    [array[0] setTitleColor:kFontBlackColor forState:UIControlStateNormal];
    [array[1] setTitleColor:kFontBlackColor forState:UIControlStateNormal];
    [array[2] setTitleColor:kFontGrayColor forState:UIControlStateNormal];
    [alertController showInController:self];
}

- (void)takePhoto {
    if (![[MicAssistant sharedInstance] checkAccessPermissions:NoAccessCamaratype]) {
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self.navigationController presentViewController:self.imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image) {
        // 上传头像
        [self uploadPhoto:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- upload
- (void)uploadPhoto:(UIImage *)photo
{
    if (!photo) {
        [HUDManager alertWithTitle:@"上传的头像为空!"];
        return;
    }
    
    @weakify(self);
    [MSUserInfo uploadHeadPhoto:photo hud:NetworkHUDLockScreenAndError target:self success:^(StatusModel *data) {
        @strongify(self);
        if (0 == data.code) {
            [HUDManager alertWithTitle:@"头像设置成功!"];
            [self.headView reloadHeadImage:photo];
            [MSUserInfo shareUserInfo].headerImg = data.originalData;
        } else {
            [HUDManager alertWithTitle:data.msg];
        }
    }];
}

#pragma mark - UIImagePickerController
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        _imagePickerVc.allowsEditing = YES;
    }
    return _imagePickerVc;
}

#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
    //    if (![[MicAssistant sharedInstance] checkAccessPermissions:NoAccessPhotoType]) {
    //        return;
    //    }
    
    @weakify(self);
    [[MicAssistant sharedInstance] checkPhotoServiceOnCompletion:^(BOOL isPermision, BOOL isFirstAsked) {
        @strongify(self);
        if (isPermision) {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            imagePickerVc.isSelectOriginalPhoto = NO;
            imagePickerVc.allowTakePicture = NO;
            imagePickerVc.navigationBar.barTintColor = UIColorHex(0xffffff);
            imagePickerVc.navigationBar.tintColor = UIColorHex(0xffffff);
            [imagePickerVc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(0x262626), NSFontAttributeName:[UIFont systemFontOfSize:17]}];
            [self setNaviBack];
            imagePickerVc.barItemTextColor = UIColorHex(0x262626);
            imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
            imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
            imagePickerVc.allowPickingVideo = NO;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            imagePickerVc.sortAscendingByModificationDate = YES;
            [self presentViewController:imagePickerVc animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }];
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                if (photos.count > 0) {
                    [self uploadPhoto:photos[0]];
                }
            }];
        } else {
            [MicAssistant guidUserToSettingsWhenNoAccessRight:NoAccessPhotoType];
        }
    }];
    
}

- (void)setNaviBack{
    
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    
    //返回按钮的箭头颜色
    
    [navigationBar setTintColor:UIColorHex(0x262626)];
    
    //设置返回样式图片
    
    UIImage *image = [UIImage imageNamed:@"return_bar"];
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    navigationBar.backIndicatorImage = image;
    
    navigationBar.backIndicatorTransitionMaskImage = image;
    
    UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    
    UIOffset offset;
    
    offset.horizontal = - 500;
    
    offset.vertical =  - 500;
    
    [buttonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
