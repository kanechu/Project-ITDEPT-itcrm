//
//  Web_updateData.m
//  itcrm
//
//  Created by itdept on 14-7-8.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_updateData.h"
#import "UploadingContract.h"
#import "RespUpdateStatus.h"
#import "DB_Login.h"
#import "DB_RespLogin.h"
#import "Web_base.h"
#import "NSArray.h"

@implementation Web_updateData

#pragma mark update
- (void) fn_get_updateStatus_data:(id)UpdateForm path:(NSString*)il_url :(CallBack_data)callback {
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    NSString* base_url=[db fn_get_field_content:kWeb_addr];
    db=nil;
    UploadingContract *req_form = [[UploadingContract alloc] init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    AuthContract *auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    dbLogin=nil;
    req_form.UpdateForm = [NSSet setWithObjects:UpdateForm, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=il_url;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespUpdateStatus class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespUpdateStatus class]];
    web_base.callback=^(NSMutableArray *arr_resp_result,BOOL isTimeOut){
        if (isTimeOut) {
            
        }else{
            callback(arr_resp_result);
        }
    };
    [web_base fn_update_data:req_form updateform:UpdateForm];
    req_form=nil;
    web_base=nil;
}
@end
