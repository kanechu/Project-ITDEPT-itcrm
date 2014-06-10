//
//  ActivityViewController.m
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "ActivityViewController.h"
#import "DB_formatlist.h"
#import "DB_crmtask_browse.h"
#import "Cell_armtask_browse.h"
@interface ActivityViewController ()

@end

@implementation ActivityViewController
@synthesize alist_crmtask;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fn_init_crmtask_arr];
  
    
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_crmtask_arr{
    //获取crmtask列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmtask"];
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
    
    NSMutableArray *arr_crmtask=[NSMutableArray array];
    DB_crmtask_browse *db_crmtask=[[DB_crmtask_browse alloc]init];
    arr_crmtask=[db_crmtask fn_get_crmtask_data];
    alist_crmtask=[[NSMutableArray alloc]init];
    NSMutableDictionary *dic1=[[NSMutableDictionary alloc]init];
    for (NSDictionary *dic in arr_crmtask) {
        t_title=[self fn_replaceString:t_title withParameter:arr_t_title atString:@"%s" :dic];
        [dic1 setObject:t_title forKey:@"t_title"];
        t_desc1=[self fn_replaceString:t_desc1 withParameter:arr_v_desc1 atString:@"%s" :dic];
        [dic1 setObject:t_desc1 forKey:@"t_desc1"];
        
        t_desc2=[self fn_replaceString:t_desc2 withParameter:arr_v_desc2 atString:@"%s" :dic];
        [dic1 setObject:t_desc2 forKey:@"t_desc2"];
        
        t_desc3=[self fn_replaceString:t_desc3 withParameter:arr_v_desc3 atString:@"%s" :dic];
        [dic1 setObject:t_desc3 forKey:@"t_desc3"];
        
        [alist_crmtask addObject:dic1];
        
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [alist_crmtask count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell_armtask_browse";
    Cell_armtask_browse *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"Cell_armtask_browse" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    cell.il_title.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"t_title"];
    cell.il_desc1.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"t_desc1"];
    cell.il_desc2.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"t_desc2"];
    cell.il_desc3.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"t_desc3"];
    // Configure the cell...
    
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
