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

@interface MSNewMeetingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *newMeetingTableView;
    UIButton    *newMeetingButton;
}

@property (nonatomic, strong) MSNewMeetingHeadView *headView;

@end

@implementation MSNewMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增預約";
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (MSNewMeetingHeadView*)headView
{
    if (!_headView) {
        _headView = [[MSNewMeetingHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    }
    return _headView;
}

- (void)loadSubView
{
    UIImage *bgImage = [UIImage imageWithColor:UIColorHex(0xFF845F)];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 2,1) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBarTintColor:UIColorHex(0xFF845F)];
    [self.navigationController.navigationBar setTintColor:UIColorHex(0xFF845F)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(0xffffff), NSFontAttributeName:kNavTitleFont}];

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

#pragma mark UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        return cell;
    } else if (indexPath.row == 2){
        MSNewMeetingTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingTimeCell"];
        [cell title:@"會議時間" mustItem:YES begin:@"2017-05-16 10:30" end:@"2017-05-16 11:10"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        MSNewMeetingONOffCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingONOffCell"];
        [cell title:@"隱藏個人半身照" mustItem:NO];
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
