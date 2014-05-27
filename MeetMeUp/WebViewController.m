//
//  WebViewController.m
//  MeetMeUp
//
//  Created by Thomas Orten on 5/27/14.
//  Copyright (c) 2014 Orten, Thomas. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.myWebView loadRequest:request];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.myWebView.canGoBack) {
        self.backButton.hidden = false;
    }
    if (self.myWebView.canGoForward) {
        self.forwardButton.hidden = false;
    }
    [self.activityIndicator stopAnimating];
}

- (IBAction)goBack:(id)sender
{
    [self.myWebView goBack];
}

- (IBAction)goForward:(id)sender
{
    [self.myWebView goForward];
}


@end
