//
//  MainHomeViewController.m
//  itcrm
//
//  Created by itdept on 14-5-27.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "MainHomeViewController.h"
#import "Menu_home.h"
#import "Cell_menu_item.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"
#import "Web_resquestData.h"
#import "CheckUpdate.h"

#import "DB_RespLogin.h"
#import "DB_Login.h"
#import "DB_crmacct_browse.h"
#import "DB_formatlist.h"
#import "DB_searchCriteria.h"
#import "DB_systemIcon.h"
#import "DB_MaintForm.h"
#import "DB_crmtask_browse.h"
#import "DB_crmopp_browse.h"
#import "DB_crmcontact_browse.h"
#import "DB_crmhbl_browse.h"
#import "DB_crmquo_browse.h"
#import "DB_Region.h"
@interface MainHomeViewController ()
@property(nonatomic,assign)NSInteger flag_isUpdate;
@end

@implementation MainHomeViewController
@synthesize menu_item;
@synthesize ilist_menu;
@synthesize flag_isUpdate;
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
    //[self fn_show_userLogo];
    [self fn_isLogin_crm];
    [self fn_refresh_menu];
    [self fn_open_new_thread];
    flag_isUpdate=0;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)fn_get_lang_code{
    DB_Login *db=[[DB_Login alloc]init];
    NSMutableArray *arr=[db fn_get_allData];
    NSString *lang_code=@"";
    if ([arr count]!=0) {
        lang_code=[[arr objectAtIndex:0]valueForKey:@"lang_code"];
        if ([lang_code isEqualToString:@"EN"]) {
            lang_code=@"en";
        }
        if ([lang_code isEqualToString:@"CN"]) {
            lang_code=@"zh-Hans";
        }
        if ([lang_code isEqualToString:@"TCN"]) {
            lang_code=@"zh-Hant";
        }
    }
    return lang_code;
}
-(void)fn_show_userLogo{
    DB_Login *db_login=[[DB_Login alloc]init];
    NSMutableArray *arr_loginInfo=[db_login fn_get_allData];
    if ([arr_loginInfo count]!=0 && arr_loginInfo!=0) {
        NSString *userlogo=[[arr_loginInfo objectAtIndex:0]valueForKey:@"user_logo"];
        Format_conversion *convert=[[Format_conversion alloc]init];
        _user_logo.image=[convert fn_binaryData_convert_image:userlogo];
    }
}
-(void)fn_open_new_thread{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self fn_update_to_server];
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSTimer scheduledTimerWithTimeInterval:120.0f target:self selector:@selector(fn_update_to_server) userInfo:nil repeats:YES];
        });
    });
}
-(void)fn_update_to_server{
    CheckUpdate *update=[[CheckUpdate alloc]init];
    [update fn_checkUpdate_all_db];
}

-(void)fn_isLogin_crm{
    NSUserDefaults *user_isLogin=[NSUserDefaults standardUserDefaults];
    NSInteger flag_isLogin=[user_isLogin integerForKey:@"isLogin"];
    if (flag_isLogin==0) {
        LoginViewController *VC=(LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:VC animated:NO completion:^{}];
        VC.callback=^(){
            [self fn_refresh_menu];
            [self fn_resquestAndsave_data];
        };
    }else{
        NSString *lang=[self fn_get_lang_code];
        [[MYLocalizedString getshareInstance]fn_setLanguage_type:lang];
    }
}

//初始化Item
- (void) fn_refresh_menu;
{
    [_ibtn_logout setTitle:MYLocalizedString(@"lbl_logout", nil)];
    self.title=MYLocalizedString(@"lbl_home", nil);
    self.navigationItem.backBarButtonItem.title=MYLocalizedString(@"lbl_back", nil);
    ilist_menu = [[NSMutableArray alloc] init];
    [ilist_menu addObject:[Menu_home fn_create_item:MYLocalizedString(@"lbl_account", nil) image:@"ic_acct"segue:@"segue_account"]];
    [ilist_menu addObject:[Menu_home fn_create_item:MYLocalizedString(@"lbl_task", nil) image:@"ic_task" segue:@"segue_activity"]];
    [ilist_menu addObject:[Menu_home fn_create_item:MYLocalizedString(@"lbl_contact", nil) image:@"ic_contact" segue:@"segue_crmcontact_browse"]];
    [ilist_menu addObject:[Menu_home fn_create_item:MYLocalizedString(@"lbl_quo", nil) image:@"ic_quo" segue:@"segue_crmquo_browse"]];
   // [ilist_menu addObject:[Menu_home fn_create_item:@"Shipment" image:@"ic_menu3" segue:@"segue_ShipmentHistory"]];
    [ilist_menu addObject:[Menu_home fn_create_item:MYLocalizedString(@"lbl_opp", nil) image:@"ic_opp" segue:@"segue_opportunities"]];
    self.iui_collectionview.delegate = self;
    
    self.iui_collectionview.dataSource = self;
    
    [self.iui_collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell_menu"];
    [self.iui_collectionview reloadData];
}

#pragma mark UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [ilist_menu count];
}
// 一个collectionView中的分区数
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Cell_menu_item *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_menu_item" forIndexPath:indexPath];
    cell.ibt_itemButton.layer.cornerRadius=7;
    int  li_item=[indexPath item];
    menu_item=[ilist_menu objectAtIndex:li_item];
    cell.ilb_menuName.text=menu_item.is_label;
    [cell.ibt_itemButton setImage:[UIImage imageNamed:menu_item.is_image] forState:UIControlStateNormal];
    cell.ibt_itemButton.tag=indexPath.item;
    return cell;
}
#pragma mark – UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(15, 10, 0, 10);
    
}

- (IBAction)fn_menu_btn_clicked:(id)sender {
    UIButton *btn=(UIButton*)sender;
    //button.tag用来区分点击那个Item
    menu_item=[ilist_menu objectAtIndex:btn.tag];
    [self performSegueWithIdentifier:menu_item.is_segue sender:self];
}

- (IBAction)fn_Logout_crm:(id)sender {
    LoginViewController *VC=(LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:VC animated:YES completion:^{}];
    
    VC.callback=^(){
        //[self fn_set_lang_code];
        [self fn_refresh_menu];
        [self fn_resquestAndsave_data];
        
    };
    [self fn_delete_all_data];
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    [db fn_delete_all_data];
    DB_systemIcon *dbSystemIcon=[[DB_systemIcon alloc]init];
    [dbSystemIcon fn_delete_systemIcon_data];
    NSUserDefaults *user_isLogin=[NSUserDefaults standardUserDefaults];
    [user_isLogin setInteger:0 forKey:@"isLogin"];
    [user_isLogin synchronize];
}
-(void)fn_delete_all_data{
    
    DB_searchCriteria *db_search=[[DB_searchCriteria alloc]init];
    [db_search fn_delete_all_data];
    
    DB_crmacct_browse *db_crmacct=[[DB_crmacct_browse alloc]init];
    [db_crmacct fn_delete_all_data];
    
    DB_crmtask_browse *db_crmtask=[[DB_crmtask_browse alloc]init];
    [db_crmtask fn_delete_all_data];
    
    DB_crmopp_browse *db_crmopp=[[DB_crmopp_browse alloc]init];
    [db_crmopp fn_delete_all_data];
    
    DB_crmcontact_browse *db_crmcontact=[[DB_crmcontact_browse alloc]init];
    [db_crmcontact fn_delete_all_crmcontact_data];
    
    DB_crmhbl_browse *db_crmhbl=[[DB_crmhbl_browse alloc]init];
    [db_crmhbl fn_delete_all_data];
    
    DB_formatlist *db_formtlist=[[DB_formatlist alloc]init];
    [db_formtlist fn_delete_all_data];
    
    DB_MaintForm *db_MaintForm=[[DB_MaintForm alloc]init];
    [db_MaintForm fn_delete_all_data];
    
    DB_crmquo_browse *db_crmquo=[[DB_crmquo_browse alloc]init];
    [db_crmquo fn_delete_all_crmquo_data];
    
    DB_Region *db_mslookup=[[DB_Region alloc]init];
    [db_mslookup fn_delete_region_data];
}

- (IBAction)fn_Refresh_data:(id)sender {
    [self fn_delete_all_data];
    flag_isUpdate=1;
    [self fn_resquestAndsave_data];
}
#pragma mark 请求全部的数据
-(void)fn_resquestAndsave_data{
    [SVProgressHUD showWithStatus:MYLocalizedString(@"dialog_prompt", nil)];
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    NSMutableArray *arr=[db fn_get_all_data];
    NSString* base_url=nil;
    if (arr!=nil && [arr count]!=0) {
        base_url=[[arr objectAtIndex:0] valueForKey:@"web_addr"];
    }
    Web_resquestData *data=[[Web_resquestData alloc]init];
    [data fn_get_search_data:base_url];
    [data fn_get_formatlist_data:base_url];
    [data fn_get_crmacct_browse_data:base_url];
    [data fn_get_mslookup_data:base_url];
    [data fn_get_crmopp_browse_data:base_url];
    [data fn_get_maintForm_data:base_url];
    [data fn_get_crmtask_browse_data:base_url];
    [data fn_get_crmhbl_browse_data:base_url];
    [data fn_get_crmcontact_browse_data:base_url];
    if (flag_isUpdate==1) {
        DB_systemIcon *db_systemIcon=[[DB_systemIcon alloc]init];
        NSString *recentDate=nil;
        if ([[db_systemIcon fn_get_last_update_time] count]!=0) {
            recentDate=[[[db_systemIcon fn_get_last_update_time]objectAtIndex:0]valueForKey:@"recent_date"];
        }
        [data fn_get_systemIcon_data:base_url os_value:recentDate isUpdate:1];
        flag_isUpdate=0;
    }else{
        
        [data fn_get_systemIcon_data:base_url os_value:@"1400231924493" isUpdate:0];
    }
    [data fn_get_crmquo_browse_data:base_url];
}

@end
