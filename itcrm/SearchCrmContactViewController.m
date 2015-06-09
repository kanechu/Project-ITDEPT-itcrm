//
//  SearchCrmContactViewController.m
//  itcrm
//
//  Created by itdept on 14-7-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "SearchCrmContactViewController.h"
#import "Cell_search.h"
#import "DB_searchCriteria.h"
#import "Advance_SearchData.h"
#import "SKSTableViewCell.h"

typedef NSString* (^pass_value_block)(NSInteger);
enum TEXT_TAG {
    TEXT_TAG1 = 100
};
@interface SearchCrmContactViewController ()
@property(nonatomic,strong)NSMutableArray *alist_filtered_data;
@property(nonatomic,strong)NSMutableArray * alist_groupNameAndNum;
@property(nonatomic,strong)NSMutableArray * alist_searchCriteria;
@property(nonatomic,strong)NSMutableArray *alist_searchData;
@property(nonatomic,strong)UITextField *checkText;
@property(nonatomic,strong)pass_value_block passvalue;
@property(nonatomic,strong)NSMutableDictionary *idic_value;
@property(nonatomic,strong)NSMutableDictionary *idic_parameter;
//存储必填项的col_code
@property(nonatomic,strong)NSMutableDictionary *idic_col_code;
@end

@implementation SearchCrmContactViewController
@synthesize checkText;
@synthesize idic_parameter;
@synthesize idic_value;
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
    [self fn_set_property];
    [self fn_show_different_language];
    [self fn_custom_gesture];
    
   	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_property{
    idic_value=[[NSMutableDictionary alloc]initWithCapacity:10];
    idic_parameter=[[NSMutableDictionary alloc]initWithCapacity:10];
    alist_searchData=[[NSMutableArray alloc]initWithCapacity:10];
    _idic_col_code=[[NSMutableDictionary alloc]initWithCapacity:10];
    self.skstableView.SKSTableViewDelegate=self;
    [self.skstableView fn_expandall];
    self.skstableView.showsVerticalScrollIndicator=NO;
    [expand_helper setExtraCellLineHidden:self.skstableView];
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
}
- (void)fn_show_different_language{
    [_ibtn_search setTitle:MYLocalizedString(@"lbl_search", nil) forState:UIControlStateNormal];
    _i_navigationItem.title=MYLocalizedString(@"lbl_advance_title", nil);
    
}
#pragma mark -获取定制页面的数据
//lazy loading
- (NSMutableArray*)alist_groupNameAndNum{
    if (_alist_groupNameAndNum ==nil) {
        DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
        _alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmcontact"];
        db=nil;
    }
    return _alist_groupNameAndNum;
}
- (NSMutableArray*)alist_searchCriteria{
    if (_alist_searchCriteria ==nil) {
        DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
        _alist_searchCriteria=[db fn_get_srchType_data:@"crmcontact"];
        db=nil;
    }
    return _alist_searchCriteria;
}
- (NSMutableArray*)alist_filtered_data{
    if (_alist_filtered_data ==nil) {
        _alist_filtered_data=[NSMutableArray array];
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
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    checkText=textField;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [checkText resignFirstResponder];
    return YES;
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
#pragma mark SKSTableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.alist_groupNameAndNum count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    NSString *numOfrow=[[self.alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"COUNT(group_name)"];
    return [numOfrow integerValue];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
-(UITableViewCell*)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    //提取每行的数据
    NSMutableDictionary *dic=self.alist_filtered_data[indexPath.section][indexPath.subRow-1];
    //显示的提示名称
    NSString *col_label=[dic valueForKey:@"col_label"];
    //是否为必填项
    NSString *is_mandatory=[dic valueForKey:@"is_mandatory"];
    //相关联的参数
    NSString *col_code=[dic valueForKey:@"col_code"];
    NSString *col_type=[dic valueForKey:@"col_type"];
    if ([is_mandatory isEqualToString:@"1"]) {
        col_label=[col_label stringByAppendingString:@"*"];
        [_idic_col_code setObject:col_code forKey:col_code];
    }
    __block SearchCrmContactViewController *blockSelf=self;
    _passvalue=^NSString*(NSInteger tag){
        return [blockSelf-> _alist_filtered_data [tag/100-1][tag-TEXT_TAG1-(tag/100-1)*100]
                valueForKey:@"col_code"];
    };
    if ([col_type isEqualToString:@"string"]) {
        
        static NSString *cellIndentifier=@"Cell_search_contact";
        Cell_search *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell==nil) {
            cell=[[Cell_search alloc]init];
        }
        cell.il_prompt_label.text=col_label;
        cell.il_prompt_label.textColor=COLOR_DARK_JUNGLE_GREEN;
        cell.itf_searchData.delegate=self;
        cell.itf_searchData.tag=TEXT_TAG1+indexPath.section*100+indexPath.subRow-1;
        cell.itf_searchData.text=[idic_value valueForKey:col_code];
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (IBAction)fn_go_back:(id)sender {
 
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fn_textfield_endEdit:(id)sender {
    UITextField *textfield=(UITextField*)sender;
    NSString *col_code=_passvalue(textfield.tag);
    NSMutableArray *alist_searchData_copy=[NSMutableArray arrayWithArray:alist_searchData];
    for (Advance_SearchData *searchData in alist_searchData_copy) {
        if ([searchData.is_parameter isEqualToString:col_code]) {
            [alist_searchData removeObject:searchData];
        }
    }
    if ([textfield.text length]!=0) {
        [idic_value setObject:textfield.text forKey:col_code];
        [idic_parameter setObject:col_code forKey:col_code];
        [alist_searchData addObject:[expand_helper fn_get_searchData:col_code idic_value:idic_value idic_parameter:idic_parameter]];
    }

}

- (IBAction)fn_search_crmContact:(id)sender {
    BOOL isfilled=YES;
    for (NSString *col_code in [_idic_col_code allKeys]) {
        if ([[idic_value valueForKey:col_code]length] ==0) {
            isfilled=NO;
        }
    }
    if (isfilled) {
        if (_callback) {
            _callback(alist_searchData);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:MYLocalizedString(@"lbl_is_mandatory", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:MYLocalizedString(@"lbl_ok", nil), nil];
        [alert show];
    }
}
@end
