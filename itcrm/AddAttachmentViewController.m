//
//  AddAttachmentViewController.m
//  itcrm
//
//  Created by itdept on 15/3/31.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "AddAttachmentViewController.h"
#import "Cell_maintForm1.h"
#import "Custom_BtnGraphicMixed.h"
#import "Format_conversion.h"
#import "DB_Login.h"
#import "AuthContract.h"

#define TEXTVIEW_TAG 100
typedef NSString* (^passValue)(NSInteger tag);

@interface AddAttachmentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_attachment_logo;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_upload;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_clear;

@property (strong, nonatomic) UITextView *checkTextView;
@property (strong, nonatomic) UIDatePicker *idp_picker;

@property (strong, nonatomic) passValue pass_Value;
@property (strong, nonatomic) NSMutableArray *alist_labels;
@property (strong, nonatomic) NSMutableDictionary *idic_values;
@property (strong, nonatomic) NSArray *alist_keys;
@property (strong, nonatomic) NSDate *select_date;

@end

@implementation AddAttachmentViewController
@synthesize idp_picker;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fn_set_control_property];
    [self fn_hiden_extra_line];
    [self fn_create_datePick];
    [KeyboardNoticeManager sharedKeyboardNoticeManager];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fn_set_control_property{
    self.tableview.backgroundColor=COLOR_LIGHT_GRAY;
    self.view.backgroundColor=COLOR_LIGHT_GRAY;
    
    DB_Login *dbLogin=[[DB_Login alloc]init];
    AuthContract *auth=[dbLogin fn_request_auth];
    _idic_values=[[NSMutableDictionary alloc]init];
    if (_account_name!=nil) {
        [_idic_values setObject:_account_name forKey:@"account_name"];
    }
    if (auth.user_code!=nil) {
          [_idic_values setObject:auth.user_code forKey:@"assign_to"];
    }
    dbLogin=nil;
    auth=nil;
  
    _alist_labels=[[NSMutableArray alloc]initWithObjects:MYLocalizedString(@"lbl_attachment", nil),MYLocalizedString(@"lbl_file_name", nil),MYLocalizedString(@"lbl_doc_rec_date", nil),MYLocalizedString(@"lbl_eff_date", nil),MYLocalizedString(@"lbl_exp_date", nil),MYLocalizedString(@"lbl_desc", nil), nil];
    _alist_keys=@[@"attachment",@"file_name",@"rec_date",@"eff_date",@"exp_date",@"desc"];
    
    [_ibtn_attachment_logo setTitle:MYLocalizedString(@"lbl_attachment_logo", nil) forState:UIControlStateNormal];
    [_ibtn_attachment_logo setImage:[UIImage imageNamed:@"ic_itcrm_logo"] forState:UIControlStateNormal];
    [_ibtn_cancel setTitle:MYLocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
    
    [_ibtn_upload setTitle:MYLocalizedString(@"lbl_upload", nil) forState:UIControlStateNormal];
    _ibtn_upload.layer.cornerRadius=4;
    _ibtn_upload.layer.borderColor=[UIColor blueColor].CGColor;
    _ibtn_upload.layer.borderWidth=1;
    
    [_ibtn_clear setTitle:MYLocalizedString(@"lbl_clear", nil) forState:UIControlStateNormal];
    _ibtn_clear.layer.cornerRadius=4;
    _ibtn_clear.layer.borderWidth=1;
    _ibtn_clear.layer.borderColor=[UIColor blueColor].CGColor;
    
}
#pragma mark -event action
- (IBAction)fn_upload_attachment:(id)sender {
    
    
}
- (IBAction)fn_clear_input_data:(id)sender {
    
    [_idic_values removeAllObjects];
    [self.tableview reloadData];
    
}
- (IBAction)fn_cancel_addAttachment:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark create toolbar
-(UIToolbar*)fn_create_toolbar{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(fn_Click_done:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    return toolbar;
}
-(void)fn_Click_done:(id)sender{
    [self.tableview reloadData];
}

#pragma mark UIDatePick
-(void)fn_create_datePick{
    //初始化UIDatePicker
    idp_picker=[[UIDatePicker alloc]init];
    [idp_picker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:[Format_conversion fn_get_lang_code]]];
    
    [idp_picker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    //设置UIDatePicker的显示模式
    [idp_picker setDatePickerMode:UIDatePickerModeDate];
    _select_date=[idp_picker date];
    //当值发生改变的时候调用的方法
    [idp_picker addTarget:self action:@selector(fn_change_date) forControlEvents:UIControlEventValueChanged];
    
}
-(void)fn_change_date{
    //获得当前UIPickerDate所在的日期
    _select_date=[idp_picker date];
    
}
#pragma mark -UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _checkTextView=textView;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSString *str_key=_pass_Value(textView.tag);
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    if ([str_key isEqualToString:@"rec_date"]||[str_key isEqualToString:@"eff_date"] || [str_key isEqualToString:@"exp_date"]) {
        NSString *str_date=[dateformatter stringFromDate:_select_date];
        dateformatter=nil;
        [_idic_values setObject:str_date forKey:str_key];
    }else{
        [_idic_values setObject:textView.text forKey:str_key];
    }
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_alist_labels count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"cell_add_attachment";
    Cell_maintForm1 *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    __block AddAttachmentViewController * blockSelf=self;
    _pass_Value=^NSString*(NSInteger tag){
        return blockSelf->_alist_keys[tag-TEXTVIEW_TAG];
    };
    
    cell.backgroundColor=COLOR_LIGHT_GRAY;
    cell.il_remind_label.text=[NSString stringWithFormat:@"%@:",[_alist_labels objectAtIndex:indexPath.row]];
    cell.is_enable=YES;
    cell.itv_data_textview.tag=TEXTVIEW_TAG+indexPath.row;
    cell.itv_data_textview.delegate=self;
    
    NSString *str_key=[_alist_keys objectAtIndex:indexPath.row];
    NSString *str_value=[_idic_values valueForKey:str_key];
    cell.itv_data_textview.inputAccessoryView=nil;
    cell.itv_data_textview.inputView=nil;
    
    if ([str_key isEqualToString:@"rec_date"] || [str_key isEqualToString:@"eff_date"] || [str_key isEqualToString:@"exp_date"]) {
        cell.itv_data_textview.inputView=idp_picker;
        cell.itv_data_textview.inputAccessoryView=[self fn_create_toolbar];
        
    }
    cell.itv_data_textview.text=str_value;
    return cell;
}
#pragma mark -UITableViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_checkTextView resignFirstResponder];
}
- (void)fn_hiden_extra_line{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    [self.tableview setTableFooterView:view];
    view=nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
