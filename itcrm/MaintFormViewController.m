//
//  MaintFormViewController.m
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "MaintFormViewController.h"
#import "DB_MaintForm.h"
#import "SKSTableViewCell.h"
#import "Cell_maintForm1.h"
#import "Cell_maintForm2.h"
#import "Custom_Color.h"
@interface MaintFormViewController ()

@end

@implementation MaintFormViewController
@synthesize alist_filtered_data;
@synthesize alist_groupNameAndNum;
@synthesize alist_maintForm;
@synthesize checkText;
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
    [self fn_register_notifiction];
    [self fn_custom_gesture];
   
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_register_notifiction{
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 键盘高度变化通知，ios5.0新增的
    
#ifdef __IPHONE_5_0
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version >= 5.0) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillChangeFrameNotification object:nil];
        
    }
    
#endif
}
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification*)notification{
    if (nil == checkText) {
        
        return;
        
    }
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    //设置表视图frame
    [_skstableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-keyboardRect.size.height)];
}

//键盘被隐藏的时候调用的方法
-(void)keyboardWillHide:(NSNotification*)notification {
    if (checkText) {
        //设置表视图frame,ios7的导航条加上状态栏是64
        [_skstableView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    }
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
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    checkText=textField;
}

#pragma mark -初始化数组
-(void)fn_init_arr{
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmacct"];
    alist_maintForm=[db fn_get_MaintForm_data:@"crmacct"];
    alist_filtered_data=[[NSMutableArray alloc]initWithCapacity:10];
}

#pragma mark SKSTableViewDelegate and datasourse
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
    { cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=COLOR_LIGTH_GREEN;
    cell.textLabel.text=[[alist_groupNameAndNum objectAtIndex:indexPath.section]valueForKey:@"group_name"];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.expandable=YES;
    
    NSString *str=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"group_name"];
    NSArray *arr=[self fn_filtered_criteriaData:str];
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
    NSString *is_enable=[dic valueForKey:@"is_enable"];
    if ([col_stye isEqualToString:@"string"] || [col_stye isEqualToString:@"date"]) {
        static NSString *cellIdentifier=@"Cell_maintForm1";
        Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm1 alloc]init];
        }
        cell.il_remind_label.text=col_label;
        cell.itf_data_textfield.delegate=self;
        return cell;
    }
    if ([col_stye isEqualToString:@"checkbox"] ||[col_stye isEqualToString:@"lookup"]) {
        static NSString *cellIdentifier=@"Cell_maintForm2";
        Cell_maintForm2 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm2 alloc]init];
        }
        cell.il_remind_label.text=col_label;
        if ([is_enable isEqualToString:@"1"]) {
        
            cell.ibt_select.titleLabel.text=@"Yes";
        }else{
            cell.ibt_select.titleLabel.text=@"NO";
        }
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
    NSArray *filtered=[alist_maintForm filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(group_name==%@)",key]];
    return filtered;
}

- (IBAction)fn_save_modified_data:(id)sender {
}
@end
