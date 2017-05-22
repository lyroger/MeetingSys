//
//  MSAgreementViewController.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSAgreementViewController.h"

@interface MSAgreementViewController ()

@end

@implementation MSAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"協議";
    self.view.backgroundColor = UIColorHex_Alpha(0x000000, 0.1);
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, kScreenHeight-64);
    webView.backgroundColor = UIColorHex(0xffffff);
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"agreement" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    // Do any additional setup after loading the view.
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
