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
#import "LoginViewController.h"
#import "Web_resquestData.h"
#import "CheckUpdate.h"
#import "DB_RespLogin.h"
#import "DB_systemIcon.h"
#import "DB_Login.h"
#import "Custom_BtnGraphicMixed.h"

@interface MainHomeViewController ()

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_logo;

@property(strong,nonatomic)NSMutableArray *ilist_menu;
@property(weak,nonatomic) Menu_home *menu_item;

@end

@implementation MainHomeViewController
@synthesize menu_item;
@synthesize ilist_menu;

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
        [NSTimer scheduledTimerWithTimeInterval:120.0f target:self selector:@selector(fn_update_to_server) userInfo:nil repeats:YES];
        //定时器要加入runloop中才能执行
        [[NSRunLoop currentRunLoop]run];
        
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
    [_ibtn_logo setTitle:MYLocalizedString(@"lbl_home", nil) forState:UIControlStateNormal];
    [_ibtn_logo setImage:[UIImage imageNamed:@"ic_itcrm_logo"] forState:UIControlStateNormal];
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
    NSInteger  li_item=[indexPath item];
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
#pragma mark -event action
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
        [self fn_refresh_menu];
        
    };
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    [db fn_delete_all_data];
    db=nil;
    DB_systemIcon *dbSystemIcon=[[DB_systemIcon alloc]init];
    [dbSystemIcon fn_delete_systemIcon_data];
    dbSystemIcon=nil;

    NSUserDefaults *user_isLogin=[NSUserDefaults standardUserDefaults];
    [user_isLogin setInteger:0 forKey:@"isLogin"];
    [user_isLogin synchronize];
}

@end
