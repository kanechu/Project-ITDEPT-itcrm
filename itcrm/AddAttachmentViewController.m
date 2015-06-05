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
#import "DB_RespLogin.h"
#import "AuthContract.h"
#import "RespCrm_attachment_upload.h"
#import "UpdateFormAttachment.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "Web_base.h"
#import "AppConstants.h"
#import "CheckUpdate.h"

#define TEXTVIEW_TAG 100
typedef NSString* (^passValue)(NSInteger tag);

@interface AddAttachmentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
    if (_account_id!=nil) {
        [_idic_values setObject:_account_id forKey:@"ls_acct_id"];
    }
    if (auth.user_code!=nil) {
        [_idic_values setObject:auth.user_code forKey:@"ls_assign_to"];
    }
    dbLogin=nil;
    auth=nil;
    _alist_keys=@[@"ls_filedata_base64",@"ls_att_name",@"ldt_doc_recv_date",@"ldt_effective_date",@"ldt_expiry_date",@"ls_att_desc"];
    
    for (NSString *key in _alist_keys) {
        [_idic_values setObject:@"" forKey:key];
    }
    
    _alist_labels=[[NSMutableArray alloc]initWithObjects:MYLocalizedString(@"lbl_attachment", nil),MYLocalizedString(@"lbl_file_name", nil),MYLocalizedString(@"lbl_doc_rec_date", nil),MYLocalizedString(@"lbl_eff_date", nil),MYLocalizedString(@"lbl_exp_date", nil),MYLocalizedString(@"lbl_desc", nil), nil];
    
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
- (void)fn_show_actionSheet{
    UIActionSheet *actionsheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:MYLocalizedString(@"lbl_select_picture", nil),MYLocalizedString(@"lbl_take_a_picture", nil), nil];
    [actionsheet showFromRect:self.view.bounds inView:self.view animated:YES];
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==[actionSheet firstOtherButtonIndex]) {
        UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.delegate=self;
        imagePicker.sourceType=sourceType;
        imagePicker.allowsEditing=YES;
        [self presentViewController:imagePicker animated:YES completion:^(){}];
    }
    if (buttonIndex==1) {
        UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.delegate=self;
        imagePicker.sourceType=sourceType;
        imagePicker.allowsEditing=YES;
        [self presentViewController:imagePicker animated:YES completion:^(){}];
    }

}
#pragma mark -UIImagePickerControllerDelegate
//选择完毕
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^(){}];
    UIImage *image=[info valueForKey:UIImagePickerControllerOriginalImage];
    NSString *filePath=[Format_conversion fn_saveImage:image WithName:@"attachment.png"];
    [_idic_values setObject:filePath forKey:@"ls_filedata_base64"];
    [self.tableview reloadData];
}

#pragma mark -KVC
//KVC会将字典所有的键值对（key_value)赋值给模型对象的属性。只有当字典的键值对个数跟模型的属性个数相等，并且属性名必须和字典的键值对一样时才可以使用kvc
- (UpdateFormAttachment*)fn_get_DataModel_WithDict:(NSDictionary *)dict{
    UpdateFormAttachment *attachment_obj=[[UpdateFormAttachment alloc]init];
    [attachment_obj setValuesForKeysWithDictionary:dict];
    NSString *filePath=attachment_obj.ls_filedata_base64;
    UIImage *image=[UIImage imageWithContentsOfFile:filePath];
    attachment_obj.ls_filedata_base64=[Format_conversion fn_image_convert_base64Str:image];
    return attachment_obj;
}
#pragma mark -event action
- (IBAction)fn_upload_attachment:(id)sender {
    UpdateFormAttachment *receive_obj=[self fn_get_DataModel_WithDict:self.idic_values];
    if ([receive_obj.ls_filedata_base64 length]==0 || [receive_obj.ls_att_name length]==0) {
        
        [self fn_show_alertView:MYLocalizedString(@"lbl_is_mandatory", nil)];
    }else{
        CheckUpdate *check_obj=[[CheckUpdate alloc]init];
        if ([check_obj fn_check_isNetworking]) {
            [self fn_upload_attechment_toServer:receive_obj];
        }else{
            [self fn_show_alertView:MYLocalizedString(@"msg_network_fail", nil)];
        }
        check_obj=nil;
    }
}
- (void)fn_show_alertView:(NSString*)msg_prompt{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:msg_prompt delegate:nil cancelButtonTitle:MYLocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
    [alertView show];
    alertView=nil;
}
- (IBAction)fn_clear_input_data:(id)sender {
    
    [_idic_values removeAllObjects];
    [self.tableview reloadData];
    
}
- (IBAction)fn_cancel_addAttachment:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -upload attechment to web server
- (void)fn_upload_attechment_toServer:(UpdateFormAttachment*)receive_obj{
    [SVProgressHUD showWithStatus:MYLocalizedString(@"lbl_upload_prompt", nil)];
    UploadingAttachmentContract *upload=[[UploadingAttachmentContract alloc]init];
    upload.UpdateForm=receive_obj;
    DB_Login *db_login=[[DB_Login alloc]init];
    AuthContract *auth=[db_login fn_request_auth];
    upload.Auth=auth;
    db_login=nil;
    
    DB_RespLogin *db_respLogin=[[DB_RespLogin alloc]init];
    Web_base *web_obj=[[Web_base alloc]init];
    web_obj.il_url=STR_UPLOAD_ATTACHMENT_URL;
    web_obj.base_url=[db_respLogin fn_get_field_content:kWeb_addr];
    db_respLogin=nil;
    
    web_obj.iresp_class=[RespCrm_attachment_upload class];
    web_obj.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespCrm_attachment_upload class]];
    
    web_obj.callback=^(NSMutableArray* arr_resp_result,BOOL isTimeOut){
        [SVProgressHUD dismissWithSuccess:MYLocalizedString(@"lbl_upload_success", nil)];
    };
    [web_obj fn_upload_Attachment:upload Auth:auth];
    upload=nil;
    web_obj=nil;
    auth=nil;
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
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSString *str_key=_pass_Value(textView.tag);
    if ([str_key isEqualToString:@"ls_filedata_base64"]) {
        [self fn_show_actionSheet];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _checkTextView=textView;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSString *str_key=_pass_Value(textView.tag);
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    if ([str_key isEqualToString:@"ldt_doc_recv_date"]||[str_key isEqualToString:@"ldt_effective_date"] || [str_key isEqualToString:@"ldt_expiry_date"]) {
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
    NSString *str_key=[_alist_keys objectAtIndex:indexPath.row];
    NSString *str_value=[_idic_values valueForKey:str_key];
    cell.itv_data_textview.inputAccessoryView=nil;
    cell.itv_data_textview.inputView=nil;
    
    if ([str_key isEqualToString:@"ls_filedata_base64"]||[str_key isEqualToString:@"ls_att_name"]) {
        cell.il_remind_label.text=[NSString stringWithFormat:@"%@:*",[_alist_labels objectAtIndex:indexPath.row]];
    }
    else{
        cell.il_remind_label.text=[NSString stringWithFormat:@"%@:",[_alist_labels objectAtIndex:indexPath.row]];
    }
    cell.is_enable=YES;
    cell.itv_data_textview.tag=TEXTVIEW_TAG+indexPath.row;
    cell.itv_data_textview.delegate=self;
    
   
    
    if ([str_key isEqualToString:@"ldt_doc_recv_date"] || [str_key isEqualToString:@"ldt_effective_date"] || [str_key isEqualToString:@"ldt_expiry_date"]) {
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
