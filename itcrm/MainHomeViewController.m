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
#import "DB_RespLogin.h"
#import "AuthContract.h"
#import "AppConstants.h"
#import "RequestContract.h"
#import "SearchFormContract.h"
#import "RespPermit.h"
#import "Web_base.h"
#import "NSArray.h"
#import "NSDictionary.h"
#import "Cell_login.h"
#import "DB_RespLogin.h"
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
    [self fn_refresh_menu];
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    NSMutableArray *arr=[db fn_get_all_data];
    NSLog(@"%@",arr);
    [self fn_get_data:[[arr objectAtIndex:0] valueForKey:@"web_addr"]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化Item
- (void) fn_refresh_menu;
{
    ilist_menu = [[NSMutableArray alloc] init];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Account" image:@"ic_menu1" segue:@"segue_account"]];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Activity" image:@"ic_menu2" segue:@"segue_activity"]];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Contact" image:@"ic_menu3" segue:@"segue_contactList"]];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Quotation" image:@"ic_menu3" segue:@"segue_Quotation"]];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Attachment" image:@"ic_menu3" segue:@"segue_Attachment"]];
    [ilist_menu addObject:[Menu_home fn_create_item:@"Opportunity" image:@"ic_menu3" segue:@"segue_opportunity"]];
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
    return UIEdgeInsetsMake(15, 15, 0, 15);
    
}

- (IBAction)fn_menu_btn_clicked:(id)sender {
    UIButton *btn=(UIButton*)sender;
    //button.tag用来区分点击那个Item
    menu_item=[ilist_menu objectAtIndex:btn.tag];
    [self performSegueWithIdentifier:menu_item.is_segue sender:self];
}

#pragma mark 请求permit的数据
- (void) fn_get_data:(NSString*)base_url
{
    
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    auth.user_code=@"sa";
    auth.password=@"sa1";
    auth.system =@"ITNEW";
    auth.version=@"1.2";
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"app_code";
    search.os_value = @"ITNEW";
    SearchFormContract *search1 = [[SearchFormContract alloc]init];
    search1.os_column = @"type";
    search1.os_value = @"all";
    req_form.SearchForm = [NSSet setWithObjects:search1,search, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_PERMIT_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespPermit class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespPermit class]];
    web_base.iobj_target = self;
    web_base.isel_action = @selector(fn_save_login_list:);
    [web_base fn_get_data:req_form];
    
}
- (void) fn_save_login_list: (NSMutableArray *) alist_result {
    NSLog(@"成功获取数据");
    NSLog(@"%@",alist_result);
}

@end
