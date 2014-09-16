//
//  WebViewController.m
//  Recipes
//
//  Created by Jan Lottermoser on 01.09.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}
- (IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

- (IBAction)back:(UIBarButtonItem *)sender
{
    [self.webView goBack];
}


- (IBAction)forward:(UIBarButtonItem *)sender
{
    [self.webView goForward];
}
- (IBAction)openInBrowser:(UIBarButtonItem *)sender
{
    [[UIApplication sharedApplication] openURL:self.webView.request.URL];
}

- (IBAction)goFullscreen:(UIButton *)sender
{
    [self.delegate toggleFullscreenAnimated:YES];
}


@end
