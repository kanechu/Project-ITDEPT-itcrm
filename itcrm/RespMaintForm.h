//
//  RespMaintForm.h
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RespMaintForm : NSObject

@property(nonatomic,copy)NSString *form_id;
@property(nonatomic,copy)NSString *seq;
@property(nonatomic,copy)NSString *col_code;
@property(nonatomic,copy)NSString *col_label;
@property(nonatomic,copy)NSString *col_type;
@property(nonatomic,copy)NSString *col_option;
@property(nonatomic,copy)NSString *col_def;
@property(nonatomic,copy)NSString *group_name;
@property(nonatomic,copy)NSString *is_mandatory;
@property(nonatomic,copy)NSString *is_enable;
@property(nonatomic,copy)NSString *icon_name;

@end
