//
//  QuoWebViewController.m
//  itcrm
//
//  Created by itdept on 14-7-21.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "QuoWebViewController.h"

@interface QuoWebViewController ()
@property (nonatomic,strong)UIActivityIndicatorView *activityview;
@end

@implementation QuoWebViewController
@synthesize post;
@synthesize url;
@synthesize activityview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _webView.delegate=self;
    _webView.scalesPageToFit=YES;
    [self fn_load];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_load{
    NSData *postData=[post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength=[NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20.0];
    [request setHTTPBody:postData];
    [_webView loadRequest:request];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(_webView.frame.origin.x,_webView.frame.origin.y,_webView.frame.size.width , _webView.frame.size.height)];
    [view setTag:100];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    activityview=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [activityview setCenter:view.center];
    [activityview setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityview];
    [activityview startAnimating];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityview stopAnimating];
    UIView *view=(UIView*)[self.view viewWithTag:100];
    [view removeFromSuperview];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [activityview stopAnimating];
    UIView *view=(UIView*)[self.view viewWithTag:100];
    [view removeFromSuperview];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}

@end
