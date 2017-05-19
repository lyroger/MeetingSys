//
//  SHMSelectActionView.m
//  SellHouseManager
//
//  Created by luoyan on 16/5/11.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "SHMSelectActionView.h"
#import "SHMSelectActionCell.h"

#define GreyishWhiteColor UIColorRGB(242, 242, 242)
#define GrayWhiteColor UIColorRGB(230, 230, 230)
#define kButtonViewHeight 50
//#define kTableViewHeight 176
#define kTableRowHeight 50
#define kSelectActionCellIndentifier @"selectActionCellIndentifier"

@interface SHMSelectActionView()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *dataTableView;
    UIButton    *buttonOK;
    UILabel     *titleLabel;
    UIActivityIndicatorView *loadingView;
}

@property (nonatomic,strong) NSMutableArray *selectItemIndexs;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIControl *backShadowView;
@end

@implementation SHMSelectActionView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self loadBackShadowView];
        [self loadContentView];
        self.backShadowView.alpha = 0;
        self.dataArray = [[NSMutableArray alloc] init];
        self.selectedIndexs = [[NSMutableArray alloc] init];
        UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
        keyWindow.windowLevel = UIWindowLevelNormal;
        [keyWindow addSubview:self];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if (_dataArray.count > 0) {
        self.contentView.height = [self tableHeight];
        [self showSelectActionView];
    }
    [dataTableView reloadData];
}

- (id)selectItemIndexs
{
    if (!_selectItemIndexs) {
        _selectItemIndexs = [[NSMutableArray alloc] init];
    }
    return _selectItemIndexs;
}

- (void)setSelectedIndexs:(NSMutableArray *)selectedIndexs
{
    _selectedIndexs = selectedIndexs;
    [self.selectItemIndexs removeAllObjects];
    [self.selectItemIndexs addObjectsFromArray:selectedIndexs];
}

- (void)reloadSelectActionViewData
{
    [dataTableView reloadData];
    if (self.isMutibleSelect) {
        buttonOK.hidden = NO;
    } else {
        buttonOK.hidden = YES;
    }
    
    if (self.subTitle.length) {
        NSString *titleString = [NSString stringWithFormat:@"%@%@",self.title,self.subTitle];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleString];
        [str addAttribute:NSForegroundColorAttributeName value:kFontBlackColor range:NSMakeRange(0, self.title.length)];
        [str addAttribute:NSForegroundColorAttributeName value:kFontGrayColor range:NSMakeRange(self.title.length, self.subTitle.length)];
        
        titleLabel.attributedText = str;
    } else {
        titleLabel.attributedText = nil;
        titleLabel.text = self.title;
    }
}

- (void)showSelectActionView
{
    self.hidden = NO;
    [self reloadSelectActionViewData];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){
        self.backShadowView.alpha = 0.6;
        self.contentView.frame = CGRectMake(0, self.frame.size.height - self.contentView.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL isfinished){
        
    }];
}

- (void)hideSelectActionView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
        self.backShadowView.alpha = 0;
        self.contentView.frame = CGRectMake(0, self.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL isfinished){
        self.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didHideSelectItemView:)]) {
            [self.delegate didHideSelectItemView:self];
        }
    }];
}

- (void)loadBackShadowView
{
    self.backShadowView = [[UIControl alloc] initWithFrame:self.bounds];
    self.backShadowView.backgroundColor = [UIColor blackColor];
    self.backShadowView.alpha = 0.8;
    [self.backShadowView addTarget:self action:@selector(hideSelectActionView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backShadowView];
}

- (void)loadContentView
{
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, [self tableHeight]+kButtonViewHeight)];
    self.contentView.backgroundColor = GreyishWhiteColor;
    [self addSubview:self.contentView];
    
    UIView *navContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kButtonViewHeight)];
    navContentView.backgroundColor = kColorWhite;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, navContentView.bottom - 0.5, navContentView.width, 0.5)];
    lineView.backgroundColor = kSplitLineColor;
    [navContentView addSubview:lineView];
    
    
    CGFloat buttonWidth = 80;
    
    UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCancel.frame = CGRectMake(0, 1, 80, kButtonViewHeight-2);
    buttonCancel.backgroundColor = kColorWhite;
    buttonCancel.tag = 2;
    [buttonCancel setTitleColor:kFontGrayColor forState:UIControlStateNormal];
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    buttonCancel.titleLabel.font = kTitleTextFont;
    [buttonCancel addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [navContentView addSubview:buttonCancel];
    
    
    titleLabel = [UILabel new];
    titleLabel.font = kTitleTextFont;
    titleLabel.textColor = kFontBlackColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(buttonWidth+10, (navContentView.mj_h-25)/2, navContentView.mj_w-buttonWidth*2-10*2, 25);
    [navContentView addSubview:titleLabel];
    
    
    buttonOK = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonOK.frame = CGRectMake(navContentView.mj_w-81, 1, buttonWidth, kButtonViewHeight-2);
    [buttonOK setTitle:@"保存" forState:UIControlStateNormal];
    buttonOK.backgroundColor = kColorWhite;
    buttonOK.tag = 1;
    buttonOK.titleLabel.font = kTitleTextFont;
    [buttonOK setTitleColor:kMainColor forState:UIControlStateNormal];
    [buttonOK addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [navContentView addSubview:buttonOK];
    
    [self.contentView addSubview:navContentView];
    
    if (!dataTableView) {
        dataTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        dataTableView.delegate = self;
        dataTableView.dataSource = self;
        dataTableView.backgroundColor = GreyishWhiteColor;
        dataTableView.separatorColor = GrayWhiteColor;
        dataTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        dataTableView.contentInset = UIEdgeInsetsMake(-0.5, 0, 10, 0);
        [dataTableView registerClass:[SHMSelectActionCell class] forCellReuseIdentifier:kSelectActionCellIndentifier];
        [self.contentView addSubview:dataTableView];
        
        [dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@kButtonViewHeight);
            make.left.right.bottom.equalTo(@0);
        }];
    }
    
    loadingView = [UIActivityIndicatorView new];
    loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.contentView addSubview:loadingView];
    
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
}

- (void)showLoading:(BOOL)show
{
    loadingView.hidden = !show;
    dataTableView.hidden = show;
    if (show) {
        [loadingView startAnimating];
    } else {
        [loadingView stopAnimating];
    }
}

- (CGFloat)tableHeight
{
    CGFloat height = kButtonViewHeight + kTableRowHeight *self.dataArray.count;
    return  height>kScreenHeight - 120?kScreenHeight-120:height;
}

- (void)buttonClickAction:(UIButton*)button
{
    if (button.tag == 1) {
        if (self.selectItemIndexs.count) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemWithView:itemIndexs:)]) {
                [self.delegate didSelectItemWithView:self itemIndexs:self.selectItemIndexs];
                [self hideSelectActionView];
            }
        } else {
            [HUDManager alertWithTitle:@"请先选择选项!"];
        }
    } else if (button.tag == 2) {
        [self hideSelectActionView];
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isMutibleSelect) {
        SHMSelectActionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (![self.selectItemIndexs containsObject:@(indexPath.row)]) {
            [self.selectItemIndexs addObject:@(indexPath.row)];
            [cell showSelected];
        } else {
            [self.selectItemIndexs removeObject:@(indexPath.row)];
            [cell hideSelected];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemWithView:itemIndexs:)]) {
            [self.delegate didSelectItemWithView:self itemIndexs:@[@(indexPath.row)]];
            [self hideSelectActionView];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHMSelectActionCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectActionCellIndentifier];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.isMultipleSelect = self.isMutibleSelect;
    if ([self.selectItemIndexs containsObject:@(indexPath.row)]) {
        [cell showSelected];
    } else {
        [cell hideSelected];
    }
    return cell;
}

@end
