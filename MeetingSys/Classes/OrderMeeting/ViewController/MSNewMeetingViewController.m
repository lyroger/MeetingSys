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
    [newMeetingTableView registerClass:[MSNewMeetingInputCell class] forCellReuseIdentifier:@"MSNewMeetingInputCell.h"];
    [newMeetingTableView registerClass:[MSNewMeetingSelectCell class] forCellReuseIdentifier:@"MSNewMeetingSelectCell"];
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
    return 70;
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
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            UILabel *bottomLine = [UILabel new];
            bottomLine.backgroundColor = UIColorHex(0xE3E3E3);
            [cell.contentView addSubview:bottomLine];
            [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@0);
                make.left.equalTo(@12);
                make.right.equalTo(@(-12));
                make.height.equalTo(@(0.6));
            }];
        }
        
        return cell;
    } else if (indexPath.row == 1) {
        MSNewMeetingSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingSelectCell"];
        [cell title:@"會議類型" placeholder:@"請選擇" mustItem:YES rightView:NO];
        return cell;
    } else {
        MSNewMeetingTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSNewMeetingTimeCell"];
        cell.textLabel.text = @"預約信息";
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
