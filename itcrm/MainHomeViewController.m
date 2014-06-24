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

#import "DB_RespLogin.h"
#import "DB_Login.h"
#import "DB_crmacct_browse.h"
#import "DB_formatlist.h"
#import "DB_searchCriteria.h"
#import "DB_systemIcon.h"
#import "DB_crmtask_browse.h"
#import "DB_crmopp_browse.h"
#import "DB_MaintForm.h"
@interface MainHomeViewController ()

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
    [self fn_isLogin_crm];
    [self fn_refresh_menu];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_isLogin_crm{
    NSUserDefaults *user_isLogin=[NSUserDefaults standardUserDefaults];
    NSInteger flag_isLogin=[user_isLogin integerForKey:@"isLogin"];
    if (flag_isLogin==0) {
        LoginViewController *VC=(LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        PopViewManager *popV=[[PopViewManager alloc]init];
        [popV PopupView:VC Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
    }
}

//初始化Item
- (void) fn_refresh_menu;
{
    ilist_menu = [[NSMutableArray alloc] init];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Account" image:@"ic_menu1"segue:@"segue_account"]];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Activity" image:@"ic_menu2" segue:@"segue_activity"]];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Contact" image:@"ic_menu3" segue:@"segue_contactList"]];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Quotation" image:@"ic_menu3" segue:@"segue_Quotation"]];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Attachment" image:@"ic_menu3" segue:@"segue_Attachment"]];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Opportunity" image:@"ic_menu3" segue:@"segue_opportunities"]];
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
    PopViewManager *popV=[[PopViewManager alloc]init];
    [popV PopupView:VC Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
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
    
    DB_formatlist *db_formtlist=[[DB_formatlist alloc]init];
    [db_formtlist fn_delete_all_data];
    
    DB_MaintForm *db_MaintForm=[[DB_MaintForm alloc]init];
    [db_MaintForm fn_delete_all_data];
}

- (IBAction)fn_Refresh_data:(id)sender {
    [self fn_delete_all_data];
    [SVProgressHUD showWithStatus:@"Loading, please wait!"];
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
    [data fn_get_region_data:base_url];
    [data fn_get_crmopp_browse_data:base_url];
    [data fn_get_maintForm_data:base_url];
    [data fn_get_crmtask_browse_data:base_url];
    DB_systemIcon *db_systemIcon=[[DB_systemIcon alloc]init];
    NSString *recentDate=nil;
    if ([[db_systemIcon fn_get_last_update_time] count]!=0) {
        recentDate=[[[db_systemIcon fn_get_last_update_time]objectAtIndex:0]valueForKey:@"recent_date"];
    }
    
    [data fn_get_systemIcon_data:base_url os_value:recentDate];
}



@end
