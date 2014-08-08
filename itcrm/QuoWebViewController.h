//
//  QuoWebViewController.h
//  itcrm
//
//  Created by itdept on 14-7-21.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoWebViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic,copy)NSString *php_addr;
@property (nonatomic,copy)NSString *skip_url;
@property (nonatomic,copy)NSString *post;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
