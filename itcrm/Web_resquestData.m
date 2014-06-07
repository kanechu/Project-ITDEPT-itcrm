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
#import "RespFormatlist.h"
#import "RespCrmacct_browse.h"
#import "RespRegion.h"
#import "RespSystemIcon.h"
#import "Web_base.h"
#import "NSArray.h"
#import "NSDictionary.h"
#import "DB_searchCriteria.h"
#import "DB_Login.h"
#import "DB_formatlist.h"
#import "DB_crmacct_browse.h"
#import "DB_Region.h"
#import "DB_systemIcon.h"
#import "SVProgressHUD.h"
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
#pragma mark 请求formatlist的数据
- (void) fn_get_formatlist_data:(NSString*)base_url{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"list_id";
    search.os_value = @"crm";
    req_form.SearchForm = [NSSet setWithObjects:search, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_FORMATLIST_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespFormatlist class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespFormatlist class]];
    web_base.iobj_target = self;
    web_base.isel_action = @selector(fn_save_formatlist_list:);
    [web_base fn_get_data:req_form];
}
- (void) fn_save_formatlist_list: (NSMutableArray *) alist_result {
    DB_formatlist *db=[[DB_formatlist alloc]init];
    [db fn_save_formatlist_data:alist_result];
}
#pragma mark 请求crmacct_browse的数据
- (void) fn_get_crmacct_browse_data:(NSString*)base_url{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_CRMACCT_BROWSE_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespCrmacct_browse class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespCrmacct_browse class]];
    web_base.iobj_target = self;
    web_base.isel_action = @selector(fn_save_crmacct_browse_list:);
    [web_base fn_get_data:req_form];
}
- (void) fn_save_crmacct_browse_list: (NSMutableArray *) alist_result {
 
    DB_crmacct_browse *db=[[DB_crmacct_browse alloc]init];
    [db fn_save_crmacct_browse:alist_result];
}


#pragma mark 请求region的数据
- (void) fn_get_region_data:(NSString*)base_url
{
    
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"form";
    search.os_value = @"crmregion";
    SearchFormContract *search1 = [[SearchFormContract alloc]init];
    search1.os_column = @"ms_code";
    search1.os_value = @"cn";
    SearchFormContract *search2 = [[SearchFormContract alloc]init];
    search2.os_column = @"ms_desc";
    search2.os_value = @"chin";
    req_form.SearchForm = [NSSet setWithObjects:search,search1,search2,nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_REGION_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespRegion class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespRegion class]];
    web_base.iobj_target = self;
    web_base.isel_action = @selector(fn_save_region_list:);
    [web_base fn_get_data:req_form];
    
}
- (void) fn_save_region_list: (NSMutableArray *) alist_result {
    
    DB_Region *db=[[DB_Region alloc]init];
    [db fn_save_region_data:alist_result];
    
}

#pragma mark 请求systemIcon的数据
- (void) fn_get_systemIcon_data:(NSString*)base_url
{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"rec_upd_date";
    search.os_value = @"1400231924493";
    req_form.SearchForm = [NSSet setWithObjects:search,nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_SYSTEMICON_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespSystemIcon class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespSystemIcon class]];
    web_base.iobj_target = self;
    web_base.isel_action = @selector(fn_save_systemIcon_list:);
    [web_base fn_get_data:req_form];
}
-(void)fn_save_systemIcon_list:(NSMutableArray*)ilist_result{
    DB_systemIcon *db=[[DB_systemIcon alloc]init];
    [db fn_save_systemIcon_data:ilist_result];
   
}

@end
