//
//  Crmacct_browseViewController.m
//  itcrm
//
//  Created by itdept on 14-6-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Crmacct_browseViewController.h"
#import "DB_formatlist.h"
#import "DB_crmacct_browse.h"
#import "Cell_armacct_browse.h"
@interface Crmacct_browseViewController ()

@end

@implementation Crmacct_browseViewController
@synthesize ilist_account;
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
    [self fn_init_account];
    self.tableView_acct.delegate=self;
    self.tableView_acct.dataSource=self;
   
	// Do any additional setup after loading the view.
}
-(NSString*)fn_replaceString:(NSString*)string withParameter:(NSArray*)parameter atString:(NSString*)key :(NSDictionary*)dic{
    NSMutableString *resultString = [[NSMutableString alloc]initWithString:string];
    NSRange range ;
    range = [string rangeOfString:key];
    int i = 0;
    while (range.length>0&&i<[parameter count]) {
        if ([dic valueForKey:[parameter objectAtIndex:i]]==nil) {
            [resultString replaceCharactersInRange:range withString:@""];
        }else{
            [resultString replaceCharactersInRange:range withString:[dic valueForKey:[parameter objectAtIndex:i]]];
        }
        i++;
        range = [resultString rangeOfString:key];
    }
    return resultString;
}

-(void)fn_init_account{
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmacct"];
   
    NSString *v_title=[[arr_format objectAtIndex:0] valueForKey:@"v_title"];
     NSLog(@"%@",v_title);
    NSString *v_desc1=[[arr_format objectAtIndex:0] valueForKey:@"v_desc1"];
    NSString *t_desc1=[[arr_format objectAtIndex:0] valueForKey:@"t_desc1"];
      NSString *t_desc2=[[arr_format objectAtIndex:0] valueForKey:@"t_desc2"];
    NSString *v_desc2=[[arr_format objectAtIndex:0] valueForKey:@"v_desc2"];
    NSArray *arr_v_desc1=[v_desc1 componentsSeparatedByString:@","];
    NSArray *arr_v_desc2=[v_desc2 componentsSeparatedByString:@","];
    NSLog(@"%@",arr_v_desc1);
    NSLog(@"%@",arr_v_desc2);
    
    NSMutableArray *arr_account=[NSMutableArray array];
    DB_crmacct_browse *db_crmacct=[[DB_crmacct_browse alloc]init];
    arr_account=[db_crmacct fn_get_data:nil];
     NSMutableDictionary *dic1=[NSMutableDictionary dictionary];
    for (NSDictionary *dic in arr_account) {
        dic1=nil;
        t_desc1=[self fn_replaceString:t_desc1 withParameter:arr_v_desc1 atString:@"%s" :dic];
        [dic1 setObject:t_desc1 forKey:@"t_desc1"];
        
        t_desc2=[self fn_replaceString:t_desc2 withParameter:arr_v_desc2 atString:@"%s" :dic];
        [dic1 setObject:t_desc2 forKey:@"t_desc2"];
    
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_armacct_browse1";
    Cell_armacct_browse *cell=[self.tableView_acct dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil) {
        cell=[[Cell_armacct_browse alloc]init];
    }
    cell.t_desc1.text=@"t_desc1";
    cell.t_desc2.text=@"t_desc2";
    cell.t_desc3.text=@"t_desc3";
    cell.t_desc4.text=@"t_desc4";
    cell.t_desc5.text=@"t_desc5";
    cell.t_title.text=@"t_title";
    return cell;
    
}



#pragma mark UITableViewDelegate

@end
