//
//  MenuBrowserViewController.m
//  NYUDining
//
//  Created by Ross Freeman on 1/27/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

#import "RFMenuBrowserViewController.h"

@interface RFMenuBrowserViewController ()

@end

@implementation RFMenuBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Prevents UIWebView from displaying under nav bar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"Menu";
}

- (void)viewDidAppear:(BOOL)animated {
    // Prevents UIWebView from caching web pages
    // Caching can cause old menus to be displayed
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    [self loadWebPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    [_webView stopLoading];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Connection Error"
                                                                   message:@"It looks like you're not connected to the internet :("
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self loadWebPage];
                                                        }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:retryAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)loadWebPage {
    NSURL *url = [NSURL URLWithString:_location.menuURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _timer = [NSTimer scheduledTimerWithTimeInterval:12.0 target:self selector:@selector(showAlert) userInfo:nil repeats:NO];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_timer invalidate];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
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
