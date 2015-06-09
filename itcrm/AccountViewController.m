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
#import "DB_searchCriteria.h"
#import "RegionViewController.h"
#import "Advance_SearchData.h"

typedef NSMutableDictionary* (^pass_colCode)(NSInteger);
@interface AccountViewController ()
@property (nonatomic,strong)pass_colCode pass_value;
//获取搜索标准数据
@property(nonatomic,strong)NSMutableArray *alist_searchCriteria;
//按组名过滤后的搜索标准数据
@property(nonatomic,strong)NSMutableArray *alist_filtered_data;
//存储搜索标准的组名和该组的行数
@property(nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property (nonatomic,strong)NSMutableArray *alist_searchData;
//存储搜索条件的数据
@property(nonatomic,strong)NSMutableDictionary *idic_search_value;
//存储搜索条件的参数
@property(nonatomic,strong)NSMutableDictionary *idic_parameter;
@property(nonatomic,strong)NSMutableArray *alist_code;
@end

#define TEXT_TAG 100
@implementation AccountViewController
@synthesize checkText;
@synthesize idic_search_value;
@synthesize idic_parameter;
@synthesize alist_searchData;
@synthesize alist_code;

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
    [self fn_show_different_language];
    [self fn_set_property];
    [self fn_custom_gesture];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_property{
    idic_search_value=[[NSMutableDictionary alloc]initWithCapacity:1];
    idic_parameter=[[NSMutableDictionary alloc]initWithCapacity:1];
    alist_searchData=[[NSMutableArray alloc]initWithCapacity:1];
    alist_code=[[NSMutableArray alloc]initWithCapacity:1];
    //设置表的代理
    self.skstableView.SKSTableViewDelegate=self;
    //loadview的时候，打开所有expandable
    [self.skstableView fn_expandall];
    self.skstableView.showsVerticalScrollIndicator=NO;
    [expand_helper setExtraCellLineHidden:self.skstableView];
    //避免键盘挡住UITextfield
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    _ibtn_clear.layer.cornerRadius=3;
}
- (void)fn_show_different_language{
    [_ibtn_clear setTitle:MYLocalizedString(@"lbl_clear", nil) forState:UIControlStateNormal];
    [_ibtn_search setTitle:MYLocalizedString(@"lbl_search", nil) forState:UIControlStateNormal];
    //设置UINavigationBar的标题
    _i_navigationItem.title=MYLocalizedString(@"lbl_advance_title", nil);
}
#pragma mark -获取定制页面的数据
//lazy loading
- (NSMutableArray*)alist_groupNameAndNum{
    if (_alist_groupNameAndNum==nil) {
        DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
        _alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmacct"];
        db=nil;
    }
    return _alist_groupNameAndNum;
}
- (NSMutableArray*)alist_searchCriteria{
    if (_alist_searchCriteria==nil) {
        DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
        _alist_searchCriteria=[db fn_get_srchType_data:@"crmacct"];
        db=nil;
    }
    return _alist_searchCriteria;
}
- (NSMutableArray*)alist_filtered_data{
    if (_alist_filtered_data==nil) {
        _alist_filtered_data=[[NSMutableArray alloc]initWithCapacity:10];
        for (NSMutableDictionary *dic in self.alist_groupNameAndNum) {
            NSString *str_name=[dic valueForKey:@"group_name"];
            NSArray *arr=[expand_helper fn_filtered_criteriaData:str_name arr:self.alist_searchCriteria];
            if (arr!=nil) {
                [_alist_filtered_data addObject:arr];
            }
        }
    }
    return _alist_filtered_data;
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSMutableDictionary *idic=_pass_value(textField.tag);
    NSString *col_option=[idic valueForKey:@"col_option"];
    NSString *col_label=[idic valueForKey:@"col_label"];
    NSString *col_code=[idic valueForKey:@"col_code"];
    NSString *col_type=[idic valueForKey:@"col_type"];
    if ([col_type isEqualToString:@"lookup"]) {
        [self fn_pop_regionView:col_label type:col_option key_flag:col_code];
        col_option=nil;col_label=nil;col_code=nil;col_type=nil;
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    checkText = textField;//设置被点击的对象
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [checkText resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.alist_groupNameAndNum count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *numOfrow=[[self.alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"COUNT(group_name)"];
    return [numOfrow integerValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [self.skstableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor=COLOR_LIGTH_GREEN;
    NSString *str_name=[[self.alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"group_name"];
    cell.textLabel.text=str_name;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.expandable=YES;
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    //提取每行的数据
    NSMutableDictionary *dic=self.alist_filtered_data[indexPath.section][indexPath.subRow-1];
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
        [self fn_isExist:col_code];
    }
    __block AccountViewController *blockSelf=self;
    _pass_value=^NSMutableDictionary*(NSInteger tag){
        return blockSelf-> _alist_filtered_data [tag/100-1][tag-TEXT_TAG-(tag/100-1)*100];
    };
    
    static NSString *cellIdentifier=@"Cell_search1";
    Cell_search *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.il_prompt_label.text=col_label;
    cell.il_prompt_label.textColor=COLOR_DARK_JUNGLE_GREEN;
    cell.itf_searchData.delegate=self;
    cell.backgroundColor=COLOR_LIGHT_GRAY;
    cell.itf_searchData.tag=TEXT_TAG+indexPath.section*100+ indexPath.subRow-1;
    if ([col_stye isEqualToString:@"string"]) {
        
        cell.itf_searchData.text=[idic_search_value valueForKey:col_code];
        return cell;
    }else if([col_stye isEqualToString:@"lookup"]){
        Format_conversion *convert=[[Format_conversion alloc]init];
        NSString *textValue=[idic_search_value valueForKey:col_code];
        NSString *col_option=[dic valueForKey:@"col_option"];
        cell.itf_searchData.text=[convert fn_convert_display_status:textValue col_option:col_option];
    }
    // Configure the cell...
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
#pragma mark 是否已经存在必填项的col_code
-(void)fn_isExist:(NSString*)col_code{
    NSMutableArray *alist_code_copy=[NSMutableArray arrayWithArray:alist_code];
    for (NSString *str in alist_code_copy) {
        if ([str isEqualToString:col_code]) {
            [alist_code removeObject:str];
        }
    }
    [alist_code addObject:col_code];
}

- (IBAction)fn_search_account:(id)sender {
    BOOL isfilled=YES;
    for (NSString *col_code in alist_code) {
        if ([[idic_search_value valueForKey:col_code] length]==0) {
            isfilled=NO;
        }
    }
    if (isfilled) {
        if (_callback_acct) {
            _callback_acct(alist_searchData);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Items with * is required" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}

- (IBAction)fn_go_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fn_pop_regionView:(NSString*)placeholder type:(NSString*)is_type key_flag:(NSString*)key{
    RegionViewController *VC=(RegionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"RegionViewController"];
    VC.is_placeholder=placeholder;
    VC.type=is_type;
    VC.callback_region=^(NSMutableDictionary *dic){
        [self fn_remove_searchData:key];
        [idic_search_value setObject:[dic valueForKey:@"data"] forKey:key];
        [idic_parameter setObject:key forKey:key];
        [alist_searchData addObject:[expand_helper fn_get_searchData:key idic_value:idic_search_value idic_parameter:idic_parameter]];
        [self.skstableView reloadData];
    };
    [self presentViewController:VC animated:YES completion:nil];
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
    NSString *col_code=[_pass_value(textfield.tag) valueForKey:@"col_code"];
    [self fn_remove_searchData:col_code];
    if ([textfield.text length]!=0) {
        [idic_search_value setObject:textfield.text forKey:col_code];
        [idic_parameter setObject:col_code forKey:col_code];
        [alist_searchData addObject:[expand_helper fn_get_searchData:col_code idic_value:idic_search_value idic_parameter:idic_parameter]];
    }
}
-(void)fn_remove_searchData:(NSString*)col_code{
    NSMutableArray *alist_searchData_copy=[NSMutableArray arrayWithArray:alist_searchData];
    for (Advance_SearchData *searchData in alist_searchData_copy) {
        if ([searchData.is_parameter isEqualToString:col_code]) {
            [alist_searchData removeObject:searchData];
        }
    }
}
- (IBAction)fn_clear_input_data:(id)sender {
    idic_search_value=nil;
    idic_search_value=[[NSMutableDictionary alloc]initWithCapacity:10];
    [alist_searchData removeAllObjects];
    [self.skstableView reloadData];
}

@end
