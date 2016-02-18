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
    
    self.navigationItem.title = @"Menu";
    [self loadWebPage];
}

- (void)viewDidAppear:(BOOL)animated {
    // Prevents UIWebView from caching web pages
    // Caching can cause old menus to be displayed
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert {
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
    _pageTimeout = [NSTimer scheduledTimerWithTimeInterval:12.0 target:self selector:@selector(showAlert) userInfo:nil repeats:NO];
    // [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    
    self.progressView.progress = 0;
    self.didLoad = false;
    self.progressTime = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.didLoad = true;
    [_pageTimeout invalidate];
}

-(void)timerCallback {
    if (self.didLoad) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [self.progressTime invalidate];
        }
        else {
            self.progressView.progress += 0.1;
        }
    }
    else {
        self.progressView.progress += 0.05;
        if (self.progressView.progress >= 0.95) {
            self.progressView.progress = 0.95;
        }
    }
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
