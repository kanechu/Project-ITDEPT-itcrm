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
#import "Advance_SearchData.h"

typedef NSString* (^pass_colCode)(NSInteger);
@interface AccountViewController ()
//用来记录选择的countryname
@property (strong,nonatomic)NSMutableDictionary *idic_countryname;
//用来记录选择的regionname
@property (strong,nonatomic)NSMutableDictionary *idic_regionname;
//用来记录选择的territoryname
@property (strong,nonatomic)NSMutableDictionary *idic_territoryname;
@property (nonatomic,strong)NSMutableDictionary *idic_lookup_type;
@property (nonatomic,strong)pass_colCode pass_value;
@property (nonatomic,strong)NSMutableArray *alist_searchData;
@end
enum TEXTFIELDTAG {
    TAG = 1,
    TAG1,TAG2
};
enum TEXTFIELD_TAG {
    TEXT_TAG=100,
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
@synthesize alist_searchData;

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
    self.skstableView.showsVerticalScrollIndicator=NO;
    [self fn_custom_gesture];
    self.skstableView.backgroundColor=COLOR_LIGHT_YELLOW;
    self.view.backgroundColor=COLOR_LIGHT_YELLOW;
    [expand_helper setExtraCellLineHidden:self.skstableView];
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
    alist_searchData=[[NSMutableArray alloc]initWithCapacity:10];
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
    NSArray *arr=[expand_helper fn_filtered_criteriaData:str_name arr:alist_searchCriteria];
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
    __block AccountViewController *blockSelf=self;
    _pass_value=^NSString*(NSInteger tag){
        return [blockSelf-> alist_filtered_data [tag/100-1][tag-TEXT_TAG-(tag/100-1)*100]
                valueForKey:@"col_code"];
    };
    
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
        cell.itf_searchData.tag=TEXT_TAG+indexPath.section*100+ indexPath.subRow-1;
        cell.itf_searchData.text=[idic_search_value valueForKey:col_code];
        return cell;
    }
    if ([col_stye isEqualToString:@"lookup"]) {
        static NSString *cellIdentifier=@"Cell_search11";
        Cell_search1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_search1 alloc]init];
        }
        cell.il_prompt_label.text=col_label;
        cell.itf_input_searchData.tag=TEXT_TAG+indexPath.section*100+ indexPath.subRow-1;
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

- (IBAction)fn_search_account:(id)sender {
    [alist_searchData addObject:[expand_helper fn_get_searchData:@"country" idic_value:idic_search_value idic_parameter:idic_parameter]];
    [alist_searchData addObject:[expand_helper fn_get_searchData:@"region" idic_value:idic_search_value idic_parameter:idic_parameter]];
    [alist_searchData addObject:[expand_helper fn_get_searchData:@"territory" idic_value:idic_search_value idic_parameter:idic_parameter]];
    if ([[idic_search_value valueForKey:@"acct_code"] length]!=0) {
        if (_callback_acct) {
            _callback_acct(alist_searchData);
        }
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Items with * is required" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
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
    NSString *col_code=_pass_value(textfield.tag);
    NSMutableArray *alist_searchData_copy=[NSMutableArray arrayWithArray:alist_searchData];
    for (Advance_SearchData *searchData in alist_searchData_copy) {
        if ([searchData.is_parameter isEqualToString:col_code]) {
            [alist_searchData removeObject:searchData];
        }
    }
    if ([textfield.text length]!=0) {
        [idic_search_value setObject:textfield.text forKey:col_code];
        [idic_parameter setObject:col_code forKey:col_code];
        [alist_searchData addObject:[expand_helper fn_get_searchData:col_code idic_value:idic_search_value idic_parameter:idic_parameter]];
    }
}

- (IBAction)fn_clear_input_data:(id)sender {
    idic_search_value=nil;
    idic_search_value=[[NSMutableDictionary alloc]initWithCapacity:10];
    [self.skstableView reloadData];
}

@end
