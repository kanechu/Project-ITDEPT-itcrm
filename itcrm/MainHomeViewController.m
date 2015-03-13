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
#import "DB_crmacct_browse.h"
#import "Custom_BtnGraphicMixed.h"
#import "QuickSearchListViewController.h"
@interface MainHomeViewController ()<UISearchBarDelegate,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ilb_version;

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_logo;
@property (weak, nonatomic) IBOutlet UISearchBar *iSearchBar;
@property (strong, nonatomic) QuickSearchListViewController *quickSearchVC;
@property(strong,nonatomic)NSMutableArray *ilist_menu;
@property(weak,nonatomic) Menu_home *menu_item;
@property(assign,nonatomic)NSInteger flag_first_isLogin;
@property(strong,nonatomic)DB_crmacct_browse *db_acct;
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
    _quickSearchVC=[self.storyboard instantiateViewControllerWithIdentifier:@"QuickSearchListViewController"];
    _iSearchBar.delegate=self;
    _ilb_version.text=[NSString stringWithFormat:@"Version %@",ITCRM_VERSION];
    _db_acct=[[DB_crmacct_browse alloc]init];
    //[self fn_show_userLogo];
    [self fn_isLogin_crm];
    [self fn_refresh_menu];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    if (_flag_first_isLogin==0) {
        [self fn_present_loginView];
    }
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _quickSearchVC.view.frame=CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+108,self.view.bounds.size.width, self.view.bounds.size.height-108);
    [_db_acct fn_createView_globalsearch];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_db_acct fn_dropView_globalsearch];
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
-(void)fn_isLogin_crm{
    NSUserDefaults *user_isLogin=[NSUserDefaults standardUserDefaults];
    _flag_first_isLogin=[user_isLogin integerForKey:@"isLogin"];
    if (_flag_first_isLogin==1) {
        NSString *lang=[self fn_get_lang_code];
        [[MYLocalizedString getshareInstance]fn_setLanguage_type:lang];
    }
}
- (void)fn_present_loginView{
    LoginViewController *VC=(LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    if (_flag_first_isLogin==0) {
        [self presentViewController:VC animated:NO completion:^{}];
    }else{
        [self presentViewController:VC animated:YES completion:nil];
    }
    VC.callback=^(){
        [self fn_refresh_menu];
        _flag_first_isLogin=1;
    };
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
    UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:nil message:MYLocalizedString(@"msg_logout", nil) delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_cancel", nil) otherButtonTitles:MYLocalizedString(@"lbl_ok", nil), nil];
    [alerView show];
    alerView=nil;
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==[alertView firstOtherButtonIndex]) {
        [self fn_present_loginView];
        DB_RespLogin *db=[[DB_RespLogin alloc]init];
        [db fn_delete_all_data];
        db=nil;
        DB_systemIcon *dbSystemIcon=[[DB_systemIcon alloc]init];
        [dbSystemIcon fn_delete_systemIcon_data];
        dbSystemIcon=nil;
        DB_crmacct_browse *db_crmacct=[[DB_crmacct_browse alloc]init];
        [db_crmacct fn_delete_all_data];
        db_crmacct=nil;
        
        DB_crmcontact_browse *db_crmcontact=[[DB_crmcontact_browse alloc]init];
        [db_crmcontact fn_delete_all_crmcontact_data];
        db_crmacct=nil;
        
        DB_crmtask_browse *db_crmtask=[[DB_crmtask_browse alloc]init];
        [db_crmtask fn_delete_all_data];
        db_crmtask=nil;
        
        DB_crmquo_browse *db_crmquo=[[DB_crmquo_browse alloc]init];
        [db_crmquo fn_delete_all_crmquo_data];
        db_crmquo=nil;
        
        DB_crmopp_browse *db_crmopp=[[DB_crmopp_browse alloc]init];
        [db_crmopp fn_delete_all_data];
        db_crmopp=nil;
        
        DB_crmhbl_browse *db_crmhbl=[[DB_crmhbl_browse alloc]init];
        [db_crmhbl fn_delete_all_data];
        db_crmhbl=nil;
        
        NSUserDefaults *user_isLogin=[NSUserDefaults standardUserDefaults];
        [user_isLogin setInteger:0 forKey:@"isLogin"];
        [user_isLogin synchronize];
    }
}
#pragma mark -Quick globle search 
- (void)fn_addChildViewController:(UIViewController *)controller {
    [controller beginAppearanceTransition:YES animated:NO];
    [controller willMoveToParentViewController:self];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:controller];
    [controller endAppearanceTransition];
}

- (void)fn_removeChildViewController:(UIViewController *)controller {
    if ([self.childViewControllers containsObject:controller]) {
        [controller beginAppearanceTransition:NO animated:NO];
        [controller willMoveToParentViewController:nil];
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
        [controller didMoveToParentViewController:nil];
        [controller endAppearanceTransition];
    }
}
#pragma mark -UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self fn_addChildViewController:_quickSearchVC];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self fn_removeChildViewController:_quickSearchVC];
    [_iSearchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _quickSearchVC.alist_browse_data=[_db_acct fn_global_quick_search:searchBar.text];
    [_quickSearchVC.tableView reloadData];
    [_iSearchBar resignFirstResponder];
}

@end
