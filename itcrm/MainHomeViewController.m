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

#import "DB_RespLogin.h"
#import "DB_Login.h"
#import "DB_crmacct_browse.h"
#import "DB_formatlist.h"
#import "DB_searchCriteria.h"
#import "DB_systemIcon.h"
#import "DB_crmtask_browse.h"
#import "DB_crmopp_browse.h"
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
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    if ([[db fn_get_all_data]count]==0) {
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
    
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    [db fn_delete_all_data];
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
    DB_systemIcon *dbSystemIcon=[[DB_systemIcon alloc]init];
    [dbSystemIcon fn_delete_systemIcon_data];
}



@end
