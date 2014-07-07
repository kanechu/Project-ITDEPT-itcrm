//
//  Web_base.h
//  worldtrans
//
//  Created by itdept on 3/25/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestContract.h"
//定义回调函数
typedef void (^CallBack_resp_result)(NSMutableArray* arr_resp_result);
@interface Web_base : NSObject

@property (strong,nonatomic)CallBack_resp_result callback;

@property (copy,nonatomic) NSString *il_url;
@property (copy,nonatomic) NSString *base_url;
@property (strong,nonatomic) Class iresp_class;
@property (strong,nonatomic) NSMutableArray *ilist_resp_result;
@property (strong,nonatomic) NSArray *ilist_resp_mapping;
@property (strong,nonatomic) NSArray *ilist_search_mapping;

- (void) fn_get_data:(RequestContract*)ao_form ;

@end
