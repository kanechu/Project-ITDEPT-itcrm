//
//  OpportunitiesViewController.m
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "OpportunitiesViewController.h"
#import "DB_crmopp_browse.h"
#import "DB_formatlist.h"
#import "Cell_opportunities.h"
@interface OpportunitiesViewController ()

@end

@implementation OpportunitiesViewController
@synthesize alist_crmopp_browse;
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
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self fn_init_crmopp_browse_arr];
  
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_crmopp_browse_arr{
    //获取crmopp列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmacct_opp"];
    NSString *t_title=nil;
    NSString *v_title=nil;
    NSString *t_desc1=nil;
    NSString *v_desc1=nil;
    NSString *t_desc2=nil;
    NSString *v_desc2=nil;
    NSString *t_desc3=nil;
    NSString *v_desc3=nil;
    /*NSString *t_desc4=nil;
     NSString *v_desc4=nil;
     NSString *t_desc5=nil;
     NSString *v_desc5=nil;*/
    NSArray *arr_t_title=nil;
    NSArray *arr_v_desc1=nil;
    NSArray *arr_v_desc2=nil;
    NSArray *arr_v_desc3=nil;
    if (arr_format!=nil && [arr_format count]!=0) {
        t_title=[[arr_format objectAtIndex:0] valueForKey:@"t_title"];
        v_title=[[arr_format objectAtIndex:0] valueForKey:@"v_title"];
        t_desc1=[[arr_format objectAtIndex:0] valueForKey:@"t_desc1"];
        v_desc1=[[arr_format objectAtIndex:0] valueForKey:@"v_desc1"];
        
        t_desc2=[[arr_format objectAtIndex:0] valueForKey:@"t_desc2"];
        v_desc2=[[arr_format objectAtIndex:0] valueForKey:@"v_desc2"];
        t_desc3=[[arr_format objectAtIndex:0] valueForKey:@"t_desc3"];
        v_desc3=[[arr_format objectAtIndex:0] valueForKey:@"v_desc3"];
        arr_t_title=[v_title componentsSeparatedByString:@","];
        arr_v_desc1=[v_desc1 componentsSeparatedByString:@","];
        arr_v_desc2=[v_desc2 componentsSeparatedByString:@","];
        arr_v_desc3=[v_desc3 componentsSeparatedByString:@","];
    }
    
    NSMutableArray *arr_crmopp=[NSMutableArray array];
    DB_crmopp_browse *db_crmopp=[[DB_crmopp_browse alloc]init];
    arr_crmopp=[db_crmopp fn_get_data];
    alist_crmopp_browse=[[NSMutableArray alloc]init];
    NSMutableDictionary *dic1=[[NSMutableDictionary alloc]init];
    for (NSDictionary *dic in arr_crmopp) {
        t_title=[self fn_replaceString:t_title withParameter:arr_t_title atString:@"%s" :dic];
        [dic1 setObject:t_title forKey:@"t_title"];
        t_desc1=[self fn_replaceString:t_desc1 withParameter:arr_v_desc1 atString:@"%s" :dic];
        [dic1 setObject:t_desc1 forKey:@"t_desc1"];
        
        t_desc2=[self fn_replaceString:t_desc2 withParameter:arr_v_desc2 atString:@"%s" :dic];
        [dic1 setObject:t_desc2 forKey:@"t_desc2"];
        
        t_desc3=[self fn_replaceString:t_desc3 withParameter:arr_v_desc3 atString:@"%s" :dic];
        [dic1 setObject:t_desc3 forKey:@"t_desc3"];
        [alist_crmopp_browse addObject:dic1];
        
    }
    
}

#pragma mark 格式转换 %s用参数里面的值来替换
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

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_crmopp_browse count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_opportunities";
    Cell_opportunities *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[Cell_opportunities alloc]init];
    }
    cell.il_title.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"t_title"];
    cell.il_desc1.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"t_desc1"];
    cell.il_desc2.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"t_desc2"];
    cell.il_desc3.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"t_desc3"];
    
    return cell;
}
#pragma mark UITableViewDelegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

@end
