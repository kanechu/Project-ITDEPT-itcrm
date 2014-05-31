//
//  Web_base.h
//  worldtrans
//
//  Created by itdept on 3/25/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestContract.h"

@interface Web_base : NSObject

@property (copy,nonatomic) NSString *il_url;
@property (copy,nonatomic) NSString *base_url;

@property (strong,nonatomic) Class iresp_class;

@property (strong,nonatomic) NSMutableArray *ilist_resp_result;

@property (strong,nonatomic) NSArray *ilist_resp_mapping;

@property (strong,nonatomic) id iobj_target;

@property (nonatomic, assign) SEL isel_action;

- (void) fn_get_data:(RequestContract*)ao_form ;

@end
