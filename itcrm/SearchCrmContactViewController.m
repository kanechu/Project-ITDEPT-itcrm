//
//  SearchCrmContactViewController.m
//  itcrm
//
//  Created by itdept on 14-7-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "SearchCrmContactViewController.h"
#import "MZFormSheetController.h"
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
@end

@implementation SearchCrmContactViewController
@synthesize alist_filtered_data;
@synthesize alist_groupNameAndNum;
@synthesize alist_searchCriteria;
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
    [self fn_init_arr];
    self.skstableView.SKSTableViewDelegate=self;
    [self.skstableView fn_expandall];
    self.skstableView.backgroundColor=COLOR_LIGHT_YELLOW;
    self.skstableView.showsVerticalScrollIndicator=NO;
    [expand_helper setExtraCellLineHidden:self.skstableView];
    [self fn_custom_gesture];
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    [_inav_bar setBarTintColor:COLOR_LIGHT_YELLOW];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_arr{
    DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmcontact"];
    alist_searchCriteria=[db fn_get_srchType_data:@"crmcontact"];
    alist_filtered_data=[NSMutableArray array];
    idic_value=[[NSMutableDictionary alloc]initWithCapacity:10];
    idic_parameter=[[NSMutableDictionary alloc]initWithCapacity:10];
    alist_searchData=[[NSMutableArray alloc]initWithCapacity:10];
}
#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    checkText=textField;
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
    return [alist_groupNameAndNum count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    NSString *numOfrow=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"COUNT(group_name)"];
    return [numOfrow integerValue];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
-(UITableViewCell*)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_data[indexPath.section][indexPath.subRow-1];
    //显示的提示名称
    NSString *col_label=[dic valueForKey:@"col_label"];
    //是否为必填项
    NSString *is_mandatory=[dic valueForKey:@"is_mandatory"];
    //相关联的参数
    NSString *col_code=[dic valueForKey:@"col_code"];
    NSString *col_type=[dic valueForKey:@"col_type"];
    if ([is_mandatory isEqualToString:@"1"]) {
        col_label=[col_label stringByAppendingString:@"*"];
    }
    __block SearchCrmContactViewController *blockSelf=self;
    _passvalue=^NSString*(NSInteger tag){
        return [blockSelf-> alist_filtered_data [tag/100-1][tag-TEXT_TAG1-(tag/100-1)*100]
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
        cell.backgroundColor=COLOR_LIGHT_YELLOW;
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
 
   [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
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
    if (_callback) {
        _callback(alist_searchData);
    }
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
}
@end
