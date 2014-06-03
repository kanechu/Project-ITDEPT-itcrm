//
//  AccountViewController.h
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface AccountViewController : UIViewController<SKSTableViewDelegate>
@property(nonatomic,strong)NSArray *groudarr;

@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;

@end
