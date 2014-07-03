//
//  AccountViewController.m
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "AccountViewController.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "Cell_search.h"
#import "Cell_search1.h"
#import "DB_searchCriteria.h"
#import "MZFormSheetController.h"
#import "RegionViewController.h"
#import "Custom_Color.h"
#import "Advance_SearchData.h"
@interface AccountViewController ()
//用来记录选择的countryname
@property (strong,nonatomic)NSMutableDictionary *idic_countryname;
//用来记录选择的regionname
@property (strong,nonatomic)NSMutableDictionary *idic_regionname;
//用来记录选择的territoryname
@property (strong,nonatomic)NSMutableDictionary *idic_territoryname;
@property(nonatomic,strong)NSMutableDictionary *idic_lookup_type;
@end
enum TEXTFIELDTAG {
    TAG = 1,
    TAG1,TAG2
    };
enum TEXTFIELD_TAG {
    ITF_TAG = 100,
    ITF_IAG1,ITF_TAG2,ITF_IAG3,ITF_IAG4,ITF_TAG5,ITF_TAG6
    };

@implementation AccountViewController

@synthesize alist_groupNameAndNum;
@synthesize alist_searchCriteria;
@synthesize alist_filtered_data;
@synthesize idic_countryname;
@synthesize idic_regionname;
@synthesize idic_territoryname;
@synthesize checkText;
@synthesize idic_search_value;
@synthesize idic_parameter;
@synthesize idic_lookup_type;

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
    [self fn_init_arr];
    //设置表的代理
    self.skstableView.SKSTableViewDelegate=self;
    //loadview的时候，打开所有expandable
    [self.skstableView fn_expandall];
    [self fn_custom_gesture];
    self.skstableView.backgroundColor=COLOR_LIGHT_YELLOW;
    self.view.backgroundColor=COLOR_LIGHT_YELLOW;
    [self setExtraCellLineHidden:self.skstableView];
    //避免键盘挡住UItextfield
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    [_inav_navBar setBarTintColor:COLOR_LIGHT_YELLOW];
    _ibtn_clear.layer.cornerRadius=8;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    checkText = textField;//设置被点击的对象
   
}

#pragma mark -初始化数组
-(void)fn_init_arr{
    DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmacct"];
    alist_searchCriteria=[db fn_get_srchType_data:@"crmacct"];
    alist_filtered_data=[[NSMutableArray alloc]initWithCapacity:10];
    idic_search_value=[[NSMutableDictionary alloc]initWithCapacity:10];
    idic_parameter=[[NSMutableDictionary alloc]initWithCapacity:10];
    idic_lookup_type=[[NSMutableDictionary alloc]initWithCapacity:10];
}
#pragma mark 将额外的cell的线隐藏

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [alist_groupNameAndNum count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *numOfrow=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"COUNT(group_name)"];
    return [numOfrow integerValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [self.skstableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor=COLOR_LIGTH_GREEN;
    NSString *str_name=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"group_name"];
    cell.textLabel.text=str_name;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.expandable=YES;

    NSArray *arr=[self fn_filtered_criteriaData:str_name];
    if (arr!=nil) {
        [alist_filtered_data addObject:arr];
    }
    
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_data[indexPath.section][indexPath.subRow-1];
    //显示的提示名称
    NSString *col_label=[dic valueForKey:@"col_label"];
    //col_stye 类型名
    NSString *col_stye=[dic valueForKey:@"col_type"];
    //是否为必填项
    NSString *is_mandatory=[dic valueForKey:@"is_mandatory"];
    //相关联的参数
    NSString *col_code=[dic valueForKey:@"col_code"];
    if ([is_mandatory isEqualToString:@"1"]) {
        col_label=[col_label stringByAppendingString:@"*"];
    }
    
    if ([col_stye isEqualToString:@"string"]) {
        static NSString *cellIdentifier=@"Cell_search1";
        Cell_search *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_search alloc]init];
        }
        cell.il_prompt_label.text=col_label;
        cell.il_prompt_label.textColor=COLOR_DARK_JUNGLE_GREEN;
        cell.itf_searchData.delegate=self;
        cell.backgroundColor=COLOR_LIGHT_YELLOW;
        if ([col_code isEqualToString:@"acct_code"]) {
            cell.itf_searchData.tag=ITF_TAG;
            cell.itf_searchData.text=[idic_search_value valueForKey:@"Account_code"];
            [idic_parameter setObject:col_code forKey:@"acct_code"];
        }
        if ([col_code isEqualToString:@"acct_name"]) {
            cell.itf_searchData.tag=ITF_IAG1;
            cell.itf_searchData.text=[idic_search_value valueForKey:@"Account_name"];
            [idic_parameter setObject:col_code forKey:@"acct_name"];
        }
        if ([col_label isEqualToString:@"Address"]) {
            cell.itf_searchData.tag=ITF_TAG2;
            cell.itf_searchData.text=[idic_search_value valueForKey:@"Address"];
            [idic_parameter setObject:col_code forKey:@"acct_addr_01"];
        }
        if ([col_code isEqualToString:@"city"]) {
            cell.itf_searchData.tag=ITF_IAG3;
            cell.itf_searchData.text=[idic_search_value valueForKey:@"City"];
            [idic_parameter setObject:col_code forKey:@"city"];
        }
        if ([col_code isEqualToString:@"acct_tel"]) {
            cell.itf_searchData.tag=ITF_IAG4;
            cell.itf_searchData.text=[idic_search_value valueForKey:@"Tel"];
            [idic_parameter setObject:col_code forKey:@"acct_tel"];
        }
        if ([col_code isEqualToString:@"acct_fax"]) {
            cell.itf_searchData.tag=ITF_TAG5;
            cell.itf_searchData.text=[idic_search_value valueForKey:@"Fax"];
            [idic_parameter setObject:col_code forKey:@"acct_fax"];
        }
        if ([col_code isEqualToString:@"acct_email"]) {
            cell.itf_searchData.tag=ITF_TAG6;
            cell.itf_searchData.text=[idic_search_value valueForKey:@"Email"];
            [idic_parameter setObject:col_code forKey:@"acct_email"];
        }
        
        return cell;
    }
    if ([col_stye isEqualToString:@"lookup"]) {
        static NSString *cellIdentifier=@"Cell_search11";
        Cell_search1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_search1 alloc]init];
        }
        cell.il_prompt_label.text=col_label;
        if ([col_label isEqualToString:@"Country"]) {
            [idic_lookup_type setObject:[dic valueForKey:@"col_option"] forKey:@"country_type"];
            cell.ibtn_skip.tag=TAG;
            cell.itf_input_searchData.text=[idic_countryname valueForKey:@"display"];
            if ([cell.itf_input_searchData.text length]!=0) {
                [idic_search_value setObject:[idic_countryname valueForKey:@"data"] forKey:@"country"];
                [idic_parameter setObject:col_code forKey:@"country"];
            }
            
        }
        if ([col_label isEqualToString:@"Region"]) {
            [idic_lookup_type setObject:[dic valueForKey:@"col_option"] forKey:@"region_type"];
            cell.ibtn_skip.tag=TAG1;
            cell.itf_input_searchData.text=[idic_regionname valueForKey:@"display"];
            if ([cell.itf_input_searchData.text length]!=0) {
                [idic_search_value setObject:[idic_regionname valueForKey:@"data"] forKey:@"region"];
                [idic_parameter setObject:col_code forKey:@"region"];
            }
        }
        if ([col_label isEqualToString:@"Territory"]) {
            [idic_lookup_type setObject:[dic valueForKey:@"col_option"] forKey:@"territory_type"];
            cell.ibtn_skip.tag=TAG2;
            cell.itf_input_searchData.text=[idic_territoryname  valueForKey:@"display"];
            if ([cell.itf_input_searchData.text length]!=0) {
                [idic_search_value setObject:[idic_territoryname valueForKey:@"data"] forKey:@"territory"];
                [idic_parameter setObject:col_code forKey:@"territory"];
            }
        }
        cell.il_prompt_label.textColor=COLOR_DARK_JUNGLE_GREEN;
        cell.itf_input_searchData.delegate=self;
        cell.backgroundColor=COLOR_LIGHT_YELLOW;
        
        return cell;
    }

    // Configure the cell...
    return nil;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark 对数组进行过滤
-(NSArray*)fn_filtered_criteriaData:(NSString*)key{
    NSArray *filtered=[alist_searchCriteria filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(group_name==%@)",key]];
    return filtered;
}
- (IBAction)fn_search_account:(id)sender {
    NSMutableArray *alist_searchData=[[NSMutableArray alloc]initWithCapacity:10];
    [alist_searchData addObject:[self fn_get_searchData:@"Account_code" :@"acct_code"]];
    [alist_searchData addObject:[self fn_get_searchData:@"Account_name" :@"acct_name"]];
    [alist_searchData addObject:[self fn_get_searchData:@"Address" :@"acct_addr_01"]];
    [alist_searchData addObject:[self fn_get_searchData:@"City" :@"city"]];
    [alist_searchData addObject:[self fn_get_searchData:@"Tel" :@"acct_tel"]];
    [alist_searchData addObject:[self fn_get_searchData:@"Fax" :@"acct_fax"]];
    [alist_searchData addObject:[self fn_get_searchData:@"Email" :@"acct_email"]];
    [alist_searchData addObject:[self fn_get_searchData:@"country" :@"country"]];
    [alist_searchData addObject:[self fn_get_searchData:@"region" :@"region"]];
    [alist_searchData addObject:[self fn_get_searchData:@"territory" :@"territory"]];
    if ([[idic_search_value valueForKey:@"Account_code"] length]!=0) {
        if (_callback_acct) {
            _callback_acct(alist_searchData);
        }
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Items with * is required" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}
-(Advance_SearchData*)fn_get_searchData:(NSString*)value_key :(NSString*)parameter_key{
    Advance_SearchData *searchData=[[Advance_SearchData alloc]init];
    if ([[idic_search_value valueForKey:value_key] length]!=0) {
        searchData.is_searchValue=[idic_search_value valueForKey:value_key];
        searchData.is_parameter=[idic_parameter valueForKey:parameter_key];
    }
    return searchData;
}

- (IBAction)fn_go_back:(id)sender {
     [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
}

- (IBAction)fn_skip_region:(id)sender {
    UIButton *btn=(UIButton*)sender;
    if (btn.tag==TAG) {
        NSString *str_type=[idic_lookup_type valueForKey:@"country_type"];
        [self fn_pop_regionView:@"Please fill in Country" type:str_type key_flag:@"country"];
    }
    if (btn.tag==TAG1) {
         NSString *str_type=[idic_lookup_type valueForKey:@"region_type"];
        [self fn_pop_regionView:@"Please fill in Region" type:str_type key_flag:@"region"];
    }
    if (btn.tag==TAG2) {
         NSString *str_type=[idic_lookup_type valueForKey:@"territory_type"];
        [self fn_pop_regionView:@"Please fill in Territory" type:str_type key_flag:@"territory"];
    }
}
-(void)fn_pop_regionView:(NSString*)placeholder type:(NSString*)is_type key_flag:(NSString*)key{
    RegionViewController *VC=(RegionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"RegionViewController"];
    VC.is_placeholder=placeholder;
    VC.type=is_type;
    VC.callback_region=^(NSMutableDictionary *dic){
        if ([key isEqualToString:@"country"]) {
            idic_countryname=dic;
        }
        if ([key isEqualToString:@"region"]) {
            idic_regionname=dic;
        }
        if ([key isEqualToString:@"territory"]) {
            idic_territoryname=dic;
        }
        [self.skstableView reloadData];
    
    };
    PopViewManager *pop=[[PopViewManager alloc]init];
    [pop PopupView:VC Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
}

-(void)fn_custom_gesture{
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapgesture.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapgesture];
}
-(void)fn_keyboardHide:(UITapGestureRecognizer*)tap{
    [checkText resignFirstResponder];
}

- (IBAction)fn_textfield_endEdit:(id)sender {
    UITextField *textfield=(UITextField*)sender;
    if (textfield.tag==ITF_TAG) {
        [idic_search_value setObject:textfield.text forKey:@"Account_code"];
    }
    if (textfield.tag==ITF_IAG1) {
        [idic_search_value setObject:textfield.text forKey:@"Account_name"];
    }
    if (textfield.tag==ITF_TAG2) {
        [idic_search_value setObject:textfield.text forKey:@"Address"];
    }
    if (textfield.tag==ITF_IAG3) {
        [idic_search_value setObject:textfield.text forKey:@"City"];
    }
    if (textfield.tag==ITF_IAG4) {
        [idic_search_value setObject:textfield.text forKey:@"Tel"];
    }
    if (textfield.tag==ITF_TAG5) {
        [idic_search_value setObject:textfield.text forKey:@"Fax"];
    }
    if (textfield.tag==ITF_TAG6) {
        [idic_search_value setObject:textfield.text forKey:@"Email"];
    }
    
    
}

- (IBAction)fn_clear_input_data:(id)sender {
    idic_search_value=nil;
    idic_search_value=[[NSMutableDictionary alloc]initWithCapacity:10];
    [self.skstableView reloadData];
}

@end
