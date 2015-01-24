//
//  MainHomeViewController.h
//  itcrm
//
//  Created by itdept on 14-5-27.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHomeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *iui_collectionview;
@property (weak, nonatomic) IBOutlet UIImageView *user_logo;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_logout;

- (IBAction)fn_menu_btn_clicked:(id)sender;
- (IBAction)fn_Logout_crm:(id)sender;

@end
