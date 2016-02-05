//
//  MenuBrowserViewController.h
//  NYUDining
//
//  Created by Ross Freeman on 1/27/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFDiningLocation.h"

@interface RFMenuBrowserViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) RFDiningLocation *location;
@property (strong, nonatomic) NSTimer *pageTimeout;
@property (strong, nonatomic) NSTimer *progressTime;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (assign, nonatomic) BOOL didLoad;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)showAlert;
- (void)loadWebPage;
- (void)timerCallback;

@end
