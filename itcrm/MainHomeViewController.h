//
//  MainHomeViewController.h
//  itcrm
//
//  Created by itdept on 14-5-27.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Menu_home;
@interface MainHomeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(strong,nonatomic)NSMutableArray *ilist_menu;
@property(weak,nonatomic) Menu_home *menu_item;
@property (weak, nonatomic) IBOutlet UICollectionView *iui_collectionview;
- (IBAction)fn_menu_btn_clicked:(id)sender;

@end