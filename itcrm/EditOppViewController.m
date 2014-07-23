//
//  EditOppViewController.m
//  itcrm
//
//  Created by itdept on 14-7-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "EditOppViewController.h"
#import "DB_MaintForm.h"
#import "SKSTableViewCell.h"
#import "Cell_maintForm1.h"
#import "Cell_lookup.h"
#import "DB_crmopp_browse.h"
#import "DB_crmacct_browse.h"
#import "OptionViewController.h"
#import "RegionViewController.h"
enum TEXT_TAG{
    TEXT_TAG=100
};
typedef NSMutableDictionary* (^passValue_opp)(NSInteger tag);
@interface EditOppViewController ()
@property(nonatomic,strong)NSMutableArray *alist_maintOpp;
@property (nonatomic,strong)NSMutableArray *alist_filtered_oppdata;
@property (nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property (nonatomic,strong)NSMutableArray *alist_option;
@property (nonatomic,strong)NSMutableDictionary *idic_parameter_opp;
@property (nonatomic,strong)NSMutableDictionary *idic_parameter_opp_copy;
@property (nonatomic,strong)Format_conversion *convert;
@property (nonatomic,strong)passValue_opp pass_value;
@property (nonatomic,strong)UITextView *textViewCheck;
@end

@implementation EditOppViewController
@synthesize opp_id;
@synthesize alist_filtered_oppdata;
@synthesize alist_groupNameAndNum;
@synthesize alist_maintOpp;
@synthesize idic_parameter_opp;
@synthesize convert;
@synthesize pass_value;
@synthesize idic_parameter_opp_copy;
@synthesize alist_option;
@synthesize textViewCheck;
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
    [self fn_get_maint_crmopp];
    [self fn_get_idic_parameter];
    self.skstableView.SKSTableViewDelegate=self;
    [expand_helper setExtraCellLineHidden:self.skstableView];
    [self.skstableView fn_expandall];
    self.skstableView.showsVerticalScrollIndicator=NO;
    convert=[[Format_conversion alloc]init];
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    [self fn_custom_gesture];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  自定义一个手势，点击空白的地方，隐藏键盘
 */
-(void)fn_custom_gesture{
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapgesture.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapgesture];
}
-(void)fn_keyboardHide:(UITapGestureRecognizer*)tap{
    [textViewCheck resignFirstResponder];
}
#pragma mark -获取要修改的opp数据
-(void)fn_get_idic_parameter{
    DB_crmopp_browse *db=[[DB_crmopp_browse alloc]init];
    NSMutableArray *arr_crmcontact=[db fn_get_crmopp_with_id:opp_id];
    if ([arr_crmcontact count]!=0) {
        idic_parameter_opp=[arr_crmcontact objectAtIndex:0];
    }
    idic_parameter_opp_copy=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_opp];
}
#pragma mark -获取定制opp maint版面的数据
-(void)fn_get_maint_crmopp{
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmopp"];
    alist_maintOpp=[db fn_get_MaintForm_data:@"crmopp"];
    alist_filtered_oppdata=[[NSMutableArray alloc]initWithCapacity:10];
    alist_option=[[NSMutableArray alloc]initWithCapacity:10];
}

#pragma mark SKSTableViewDelegate 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [alist_groupNameAndNum count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    NSString *numofrows=[[alist_groupNameAndNum objectAtIndex:indexPath.section]valueForKey:@"COUNT(group_name)"];
    return [numofrows integerValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [self.skstableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    { cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=COLOR_LIGTH_GREEN;
    NSString *str_name=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"group_name"];
    cell.textLabel.text=str_name;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.expandable=YES;
    NSArray *arr=[expand_helper fn_filtered_criteriaData:str_name arr:alist_maintOpp];
    if (arr!=nil) {
        [alist_filtered_oppdata addObject:arr];
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_oppdata[indexPath.section][indexPath.subRow-1];
    //显示的提示名称
    NSString *col_label=[dic valueForKey:@"col_label"];
    NSString *col_code=[dic valueForKey:@"col_code"];
    //col_stye 类型名
    NSString *col_stye=[dic valueForKey:@"col_type"];
    //is_enable
    NSString *is_enable=[dic valueForKey:@"is_enable"];
    NSInteger is_enable_flag=[is_enable integerValue];
    //col_opption
    NSString *col_option=[dic valueForKey:@"col_option"];
    [self fn_get_choice_arr:col_option];
    //blockSelf是本地变量，是弱引用，_block被retain的时候，并不会增加retain count
     __block EditOppViewController *blockSelf=self;
    NSMutableDictionary *idic=[NSMutableDictionary dictionary];
     pass_value=^NSMutableDictionary*(NSInteger tag){
         NSMutableDictionary *dic_opp=blockSelf-> alist_filtered_oppdata [indexPath.section][tag-TEXT_TAG-indexPath.section*100];
         NSString *col_code=[dic_opp valueForKey:@"col_code"];
         NSString *col_type=[dic_opp valueForKey:@"col_type"];
         NSString *col_option=[dic_opp valueForKey:@"col_option"];
         [idic setObject:col_code forKey:@"col_code"];
         [idic setObject:col_type forKey:@"col_type"];
         [idic setObject:col_option forKey:@"col_option"];
         return idic;
     };
    if ([col_stye isEqualToString:@"int"]) {
        static NSString *cellIdentifier=@"Cell_maintForm1_opp";
        Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm1 alloc]init];
        }
        cell.is_enable=is_enable_flag;
        cell.il_remind_label.text=col_label;
        cell.itv_data_textview.delegate=self;
        cell.itv_data_textview.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        NSString *text_value=[idic_parameter_opp valueForKey:col_code];
        NSString *text_display=[convert fn_convert_display_status:text_value col_option:col_option];
        cell.itv_data_textview.text=text_display;
        //UITextView 上下左右有8px
        CGFloat height=[convert fn_heightWithString:cell.itv_data_textview.text font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
        [cell.itv_data_textview setFrame:CGRectMake(cell.itv_data_textview.frame.origin.x, cell.itv_data_textview.frame.origin.y, cell.itv_data_textview.frame.size.width, height+16)];
        return cell;
    }else{
        static NSString *cellIndentifer=@"Cell_lookup_opp";
        Cell_lookup *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (cell==nil) {
            cell=[[Cell_lookup alloc]init];
        }
        cell.is_enable=is_enable_flag;
        cell.il_remind_label.text=col_label;
        cell.itv_edit_textview.delegate=self;
        cell.itv_edit_textview.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        cell.ibtn_lookup.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        NSString *text_value=[idic_parameter_opp valueForKey:col_code];
        NSString *text_display=nil;
        if ([col_stye isEqualToString:@"choice"]){
            text_display=[self fn_convert_display_status:text_value];
        }else{
            text_display=[convert fn_convert_display_status:text_value col_option:col_option];
        }
        cell.itv_edit_textview.text=text_display;
        //UITextView 上下左右有8px
        CGFloat height=[convert fn_heightWithString:cell.itv_edit_textview.text font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_edit_textview.contentSize.width-16];
        [cell.itv_edit_textview setFrame:CGRectMake(cell.itv_edit_textview.frame.origin.x, cell.itv_edit_textview.frame.origin.y, cell.itv_edit_textview.frame.size.width, height+16)];
        return cell;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_oppdata[indexPath.section][indexPath.subRow-1];
    NSString *col_code=[dic valueForKey:@"col_code"];
    NSString *col_option=[dic valueForKey:@"col_option"];
    NSString *col_type=[dic valueForKey:@"col_type"];
    NSString *text_value=[idic_parameter_opp valueForKey:col_code];
    NSString *text_display=[convert fn_convert_display_status:text_value col_option:col_option];
    CGFloat height=0;
    if ([col_type isEqualToString:@"int"]) {
        static NSString *cellIdentifier=@"Cell_maintForm1_opp";
        Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
         height=[convert fn_heightWithString:text_display font:cell.itv_data_textview.font constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
    }else{
        static NSString *cellIndentifer=@"Cell_lookup_opp";
        Cell_lookup *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifer];
        height=[convert fn_heightWithString:text_display font:cell.itv_edit_textview.font constrainedToWidth:cell.itv_edit_textview.contentSize.width-16];
    }
   height=height+16+10;
    if (height<44) {
        height=44;
    }
    return height;
}
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textViewCheck=textView;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSMutableDictionary *dic=pass_value(textView.tag);
    NSString *col_code=[dic valueForKey:@"col_code"];
    if (textView.text!=nil) {
        [idic_parameter_opp setObject:textView.text forKey:col_code];
    }
}
- (IBAction)fn_save_modified_data:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"whether to save the modified data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [alert show];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"保存数据");
    }
    if (buttonIndex==1) {
        NSLog(@"不保存数据");
        idic_parameter_opp=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_opp_copy];
        [self.skstableView reloadData];
    }
    
}
- (IBAction)fn_lookup_data:(id)sender {
    UIButton *ibtn=(UIButton*)sender;
    NSMutableDictionary *idic=pass_value(ibtn.tag);
    NSString *col_type=[idic valueForKey:@"col_type"];
    NSString *col_option=[idic valueForKey:@"col_option"];
    NSString *col_code=[idic valueForKey:@"col_code"];
    NSString *str_placeholder=[NSString stringWithFormat:@"please input a %@",col_code];
    if ([col_type isEqualToString:@"choice"]||[col_type isEqualToString:@"local_lookup"]) {
        OptionViewController *VC=(OptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
        DB_crmacct_browse *db=[[DB_crmacct_browse alloc]init];
        if ([col_type isEqualToString:@"choice"]) {
            [self fn_get_choice_arr:col_option];
            VC.alist_option=alist_option;
            VC.lookup_title=[NSString stringWithFormat:@"select the %@",col_code];
            VC.callback=^(NSMutableDictionary *dic){
                [idic_parameter_opp setObject:[dic valueForKey:@"data"] forKey:col_code];
                [self.skstableView reloadData];
            };
            
        }else{
            VC.alist_option=[db fn_get_data:@"" select_sql:@"acct_name"];
            VC.lookup_title=@"select the account name";
            VC.flag=1;
            VC.callback=^(NSMutableDictionary *dic){
                [idic_parameter_opp setObject:[dic valueForKey:@"acct_name"] forKey:col_code];
                [self.skstableView reloadData];
            };
        }
        PopViewManager *popView=[[PopViewManager alloc]init];
        [ popView PopupView:VC Size:CGSizeMake(250, 300) uponView:self];
    }else{
        [self fn_pop_regionView:str_placeholder type:col_option key_flag:col_code];
    }
}
-(void)fn_get_choice_arr:(NSString*)col_option{
    [alist_option removeAllObjects];
    NSArray *arr_option=[col_option componentsSeparatedByString:@","];
    for (NSString *str_option in arr_option) {
        NSArray *arr=[str_option componentsSeparatedByString:@"/"];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        if ([arr count]==2) {
            [dic setObject:[arr objectAtIndex:0] forKey:@"data"];
            [dic setObject:[arr objectAtIndex:1] forKey:@"display"];
        }
        [alist_option addObject:dic];
    }
}
-(NSString*)fn_convert_display_status:(NSString*)data{
    NSString *display_str=nil;
    NSInteger flag=0;
    for (NSMutableDictionary *dic in alist_option) {
        if ([data isEqualToString:[dic valueForKey:@"data"]]) {
            display_str=[dic valueForKey:@"display"];
            flag=1;
        }
    }
    if (flag==0) {
        display_str=data;
    }
    return display_str;
}

-(void)fn_pop_regionView:(NSString*)placeholder type:(NSString*)is_type key_flag:(NSString*)key{
    RegionViewController *VC=(RegionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"RegionViewController"];
    VC.is_placeholder=placeholder;
    VC.type=is_type;
    VC.callback_region=^(NSMutableDictionary *dic){
        NSString *str_data=[dic valueForKey:@"data"];
        [idic_parameter_opp setObject:str_data forKey:key];
        [self.skstableView reloadData];
        
    };
    PopViewManager *pop=[[PopViewManager alloc]init];
    [pop PopupView:VC Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
}
@end
