//
//  MSUserHeadViewController.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/17.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSUserHeadViewController.h"
#import "HAlertController.h"
#import <TZImagePickerController/TZImagePickerController.h>
@interface MSUserHeadViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
{

}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UIScrollView            *scrollView;
@property (nonatomic, strong) UIImageView             *imageView;
@end

@implementation MSUserHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更換頭像";
    self.view.backgroundColor = UIColorHex(0x000000);
    [self leftBarButtonWithName:@"" image:[UIImage imageNamed:@"return"] target:self action:@selector(closeView)];
    
    [self rightBarButtonWithName:@"" normalImgName:@"more" highlightImgName:@"more" target:self action:@selector(selectPic)];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.zoomScale = 1;
    self.scrollView.backgroundColor = UIColorHex_Alpha(0x000000, 0);
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenWidth);
    //设置实现缩放
    //设置代理scrollview的代理对象
    self.scrollView.delegate = self;
    //设置最大伸缩比例
    self.scrollView.maximumZoomScale = 1.8;
    //设置最小伸缩比例
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    self.imageView.center = self.scrollView.center;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[MSUserInfo shareUserInfo].headerImg] placeholderImage:[UIImage imageNamed:@"portrait_big"]];
    [self.scrollView addSubview:self.imageView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
    tap.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:tap];
}

- (void)doubleClick:(UITapGestureRecognizer*)gest
{
    CGFloat zoomScale = 1.0;
    if (self.scrollView.zoomScale == 1.0) {
        zoomScale = 1.8;
    }
    self.imageView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.zoomScale = zoomScale;
    } completion:^(BOOL finished) {
        self.imageView.userInteractionEnabled = YES;
    }];
}
//告诉scrollview要缩放的是哪个子控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [self.imageView setCenter:CGPointMake(xcenter, ycenter)];
    
}

- (void)closeView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectPic
{
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
            self.imageView.image = photo;
            [MSUserInfo shareUserInfo].headerImg = [data.data string];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorHex_Alpha(0x000000, 0.92)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(0xffffff), NSFontAttributeName:kNavTitleFont}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    UIImage *bgImage = [UIImage imageWithColor:UIColorHex(0xffffff)];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 2,1) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(0x000000), NSFontAttributeName:kNavTitleFont}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
