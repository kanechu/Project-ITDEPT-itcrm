//
//  QuotationViewController.m
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "QuotationViewController.h"
#import "DB_systemIcon.h"
@interface QuotationViewController ()

@end

@implementation QuotationViewController

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
    DB_systemIcon *db=[[DB_systemIcon alloc]init];
    NSMutableArray *arr=[db fn_get_systemIcon_data:@"crmacct_task"];
    NSString *millisecond=[[arr objectAtIndex:0]valueForKey:@"upd_date"];
    float millisecond_value=[millisecond floatValue];
    NSTimeInterval timeinterval=millisecond_value/1000.0f;
    
    NSLog(@"更新日期：%@",[self dateFromUnixTimestamp:timeinterval]);
    
    NSLog(@"%@",[db fn_get_last_update_time]);
	// Do any additional setup after loading the view.
}
-(NSDate*)dateFromUnixTimestamp:(NSTimeInterval)timestamp{
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
