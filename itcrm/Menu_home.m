//
//  Menu_home.m
//  worldtrans
//
//  Created by itdept on 28/3/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import "Menu_home.h"

@implementation Menu_home

@synthesize is_label;
@synthesize is_image;
@synthesize is_segue;


+ (id)fn_create_item:(NSString*)as_label image:(NSString*)as_image segue:(NSString*)as_segue;
{
    Menu_home *lobj_menu_item = [[self alloc] init];
    lobj_menu_item.is_label = as_label;
    lobj_menu_item.is_image = as_image;
    lobj_menu_item.is_segue = as_segue;
    return lobj_menu_item;
}

@end
