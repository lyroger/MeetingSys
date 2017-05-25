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

@interface MSNewMeetingViewController ()<MSNewMeetingTimeCellDelegate,CSDatePickViewDelegate,SHMSelectActionViewDelegate,UITableViewDelegate,UITableViewDataSource,MSNewMeetingHeadViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
{
    UITableView *newMeetingTableView;
    UIButton    *newMeetingButton;
    SHMSelectActionView *selectThemeView;
    SHMSelectActionView *selectRoomsView;
    CSDatePickView *_datePickerView;
    BOOL isSelectBeginTimeing;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

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
        _headView.delegate = self;
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
    selectThemeView.title = @"會議類型";
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

- (void)loadMeetingRooms
{
    [MSMeetingRoomModel getRoomsWithMeetingType:self.meetingInfoObj.meetingType
                                      beginTime:self.meetingInfoObj.beginTime
                                        endTime:self.meetingInfoObj.endTime
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

- (void)checkInfoComplete
{
    if (self.meetingInfoObj.title.length
        && self.meetingInfoObj.beginTime
        && self.meetingInfoObj.endTime
        && self.meetingInfoObj.meetingType
        && self.meetingInfoObj.roomId.length
        && self.meetingInfoObj.organizeId.length) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark SHMSelectActionViewDelegate
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
        self.meetingInfoObj.roomTheme = room.roomStyle;
        self.meetingInfoObj.roomTimeTips = [NSString stringWithFormat:@"最長可預訂%zd分鐘",room.maxMinutes];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        MSNewMeetingSelectCell *cell = [newMeetingTableView cellForRowAtIndexPath:indexPath];
        [cell contentText:[NSString stringWithFormat:@"%@(%@)",self.meetingInfoObj.address,self.meetingInfoObj.roomTimeTips]];
        
        MSNewMeetingONOffCell *switchCell = [newMeetingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ([self.meetingInfoObj.roomTheme isEqualToString:@"Legend"]) {
            [switchCell setSwitchEnble:YES];
        } else {
            [switchCell setSwitchEnble:NO];
        }
        [self.headView theme:self.meetingInfoObj.roomTheme hideImage:NO];
        
    }
    [self checkInfoComplete];
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

//换头像
- (void)didClickHeadView
{
    [self selectPic];
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
                [self checkInfoComplete];
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
            [self loadMeetingRooms];
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
        @weakify(self)
        cell.inputBlock = ^(NSString *inputText) {
            @strongify(self)
            if (indexPath.row == 1) {
                self.meetingInfoObj.title = inputText;
            } else if (indexPath.row == 7) {
                self.meetingInfoObj.agenda = inputText;
            } else if (indexPath.row == 8) {
                self.meetingInfoObj.demand = inputText;
            }
            [self checkInfoComplete];
        };
        NSInteger index = indexPath.row==1?0:indexPath.row-6;
        [cell multipleLineInput:indexPath.row == 1?NO:YES title:titles[index] placeholder:placeholders[index] must:indexPath.row==1?YES:NO];
        
        if (indexPath.row == 1) {
            [cell contentText:self.meetingInfoObj.title multipleLine:NO];
        } else if (indexPath.row == 7) {
            [cell contentText:self.meetingInfoObj.agenda multipleLine:YES];
        } else if (indexPath.row == 8) {
            [cell contentText:self.meetingInfoObj.demand multipleLine:YES];
        }
        
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
        @weakify(self)
        cell.actionBlock = ^(BOOL isON) {
            @strongify(self)
            self.meetingInfoObj.hideThemeHead = isON;
            [self.headView theme:self.meetingInfoObj.roomTheme hideImage:isON];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
