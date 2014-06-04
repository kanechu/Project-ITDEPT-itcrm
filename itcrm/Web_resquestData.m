//
//  Web_resquestData.m
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_resquestData.h"
#import "AuthContract.h"
#import "AppConstants.h"
#import "RequestContract.h"
#import "SearchFormContract.h"
#import "RespPermit.h"
#import "RespSearchCriteria.h"
#import "Web_base.h"
#import "NSArray.h"
#import "NSDictionary.h"
#import "DB_searchCriteria.h"
#import "DB_Login.h"
@implementation Web_resquestData

#pragma mark 请求permit的数据
- (void) fn_get_permit_data:(NSString*)base_url
{
    
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
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
#pragma mark 请求searchCriteria的数据
- (void) fn_get_search_data:(NSString*)base_url
{
    
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"form";
    search.os_value = @"crm";
    req_form.SearchForm = [NSSet setWithObjects:search, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_SEARCHCRITERIA_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespSearchCriteria class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespSearchCriteria class]];
    web_base.iobj_target = self;
    web_base.isel_action = @selector(fn_save_searchCriteria_list:);
    [web_base fn_get_data:req_form];
    
}
- (void) fn_save_searchCriteria_list: (NSMutableArray *) alist_result {
    DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
    [db fn_save_searchCriteria_data:alist_result];
}

@end
