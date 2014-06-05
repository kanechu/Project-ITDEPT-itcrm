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
#import "Web_resquestData.h"
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
    [self fn_resquestAndsave_data];
    
	// Do any additional setup after loading the view.
}
-(void)fn_resquestAndsave_data{
    
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    NSMutableArray *arr=[db fn_get_all_data];
    Web_resquestData *data=[[Web_resquestData alloc]init];
    [data fn_get_search_data:[[arr objectAtIndex:0] valueForKey:@"web_addr"]];
    [data fn_get_formatlist_data:[[arr objectAtIndex:0] valueForKey:@"web_addr"]];
    [data fn_get_crmacct_browse_data:[[arr objectAtIndex:0] valueForKey:@"web_addr"]];
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
    return UIEdgeInsetsMake(15, 10, 0, 10);
    
}

- (IBAction)fn_menu_btn_clicked:(id)sender {
    UIButton *btn=(UIButton*)sender;
    //button.tag用来区分点击那个Item
    menu_item=[ilist_menu objectAtIndex:btn.tag];
    [self performSegueWithIdentifier:menu_item.is_segue sender:self];
}



@end
