//
//  Web_base.m
//  worldtrans
//
//  Created by itdept on 3/25/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import "Web_base.h"
#import <RestKit/RestKit.h>
#import "AuthContract.h"
#import "RequestContract.h"
#import "SearchFormContract.h"
#import "SVProgressHUD.h"
#import "UploadingContract.h"
#import "UpdateFormAttachment.h"
#import "NSArray.h"
#import "Resp_crmacct_dowload.h"
#import "RespCrmcontact_browse.h"
#import "RespCrmhbl_browse.h"
#import "RespCrmopp_browse.h"
#import "RespCrmquo_browse.h"
#import "RespCrmtask_browse.h"
@implementation Web_base

@synthesize il_url;
@synthesize base_url;
@synthesize ilist_resp_result;
@synthesize iresp_class;
@synthesize ilist_resp_mapping;

- (void) fn_update_data:(UploadingContract*)ao_form updateform:(id)updateform
{
    RKObjectMapping *lo_updateMapping = [RKObjectMapping requestMapping];
    [lo_updateMapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[updateform class]]];
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    AuthContract *auth=ao_form.Auth;
    [lo_authMapping addAttributeMappingsFromDictionary:[NSDictionary dictionaryWithPropertiesOfObject_withoutNil:auth]];
    auth=nil;
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    
    RKRelationshipMapping *updateRelationship = [RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"UpdateForm"
                                                 toKeyPath:@"UpdateForm"
                                                 withMapping:lo_updateMapping];
    
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    
    [lo_reqMapping addPropertyMapping:authRelationship];
    [lo_reqMapping addPropertyMapping:updateRelationship];
    
    NSString* path = il_url;
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[UploadingContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping = [RKObjectMapping mappingForClass:iresp_class];
    
    [lo_response_mapping addAttributeMappingsFromArray:ilist_resp_mapping];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:base_url]];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    [manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    [manager postObject:ao_form path:path parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                    ilist_resp_result = [NSMutableArray arrayWithArray:result.array];
                    if (_callback) {
                        _callback(ilist_resp_result,NO);
                    }
                    
                } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    RKLogError(@"Operation failed with error: %@", error);
                    NSString *str_error=[NSString stringWithFormat:@"%@",error];
                    if ([str_error rangeOfString:@"Code=-1001"].location!=NSNotFound) {
                        if (_callback) {
                            _callback(ilist_resp_result,YES);
                        }
                    }else{
                        if (_callback) {
                            _callback(ilist_resp_result,NO);
                        }
                    }
                }];
}

- (void) fn_get_data:(RequestContract*)ao_form
{
    RKObjectMapping *lo_searchMapping = [RKObjectMapping requestMapping];
    [lo_searchMapping addAttributeMappingsFromArray:@[@"os_column",@"os_value"]];
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    AuthContract *auth=ao_form.Auth;
    [lo_authMapping addAttributeMappingsFromDictionary:[NSDictionary dictionaryWithPropertiesOfObject_withoutNil:auth]];
    auth=nil;
    
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    
    RKRelationshipMapping *searchRelationship = [RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"SearchForm"
                                                 toKeyPath:@"SearchForm"
                                                 withMapping:lo_searchMapping];
    
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    
    [lo_reqMapping addPropertyMapping:authRelationship];
    [lo_reqMapping addPropertyMapping:searchRelationship];
    
    NSString* path = il_url;
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[RequestContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping = [RKObjectMapping mappingForClass:iresp_class];
    
    [lo_response_mapping addAttributeMappingsFromArray:ilist_resp_mapping];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:base_url]];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    [manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    [manager postObject:ao_form path:path parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                    ilist_resp_result = [NSMutableArray arrayWithArray:result.array];
                    if (_callback) {
                        _callback(ilist_resp_result,NO);
                    }
                    
                } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    RKLogError(@"Operation failed with error: %@", error);
                    NSString *str_error=[NSString stringWithFormat:@"%@",error];
                    if ([str_error rangeOfString:@"Code=-1001"].location!=NSNotFound) {
                        if (_callback) {
                            _callback(ilist_resp_result,YES);
                        }
                    }else{
                        if (_callback) {
                            _callback(ilist_resp_result,NO);
                        }
                    }

                }];
    
}
- (void) fn_get_crmacct_download_data:(RequestContract*)ao_form auth:(AuthContract *)auth
{
    RKObjectMapping *lo_searchMapping = [RKObjectMapping requestMapping];
    [lo_searchMapping addAttributeMappingsFromArray:@[@"os_column",@"os_dyn_6"]];
   
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    [lo_authMapping addAttributeMappingsFromDictionary:[NSDictionary dictionaryWithPropertiesOfObject_withoutNil:auth]];
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    
    RKRelationshipMapping *searchRelationship = [RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"SearchForm"
                                                 toKeyPath:@"SearchForm"
                                                 withMapping:lo_searchMapping];
    
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    
    [lo_reqMapping addPropertyMapping:authRelationship];
    [lo_reqMapping addPropertyMapping:searchRelationship];
    
    NSString* path = il_url;
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[RequestContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping = [RKObjectMapping mappingForClass:[Resp_crmacct_dowload class]];
    [lo_response_mapping addAttributeMappingsFromArray:@[@"acct_id"]];
    
    RKObjectMapping* lo_crmacct_response_mapping=[RKObjectMapping mappingForClass:[RespCrmacct_browse class]];
    [lo_crmacct_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[RespCrmacct_browse class]]];
    
    RKObjectMapping* lo_contact_response_mapping=[RKObjectMapping mappingForClass:[RespCrmcontact_browse class]];
    [lo_contact_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[RespCrmcontact_browse class]]];
    
    RKObjectMapping* lo_hbl_response_mapping=[RKObjectMapping mappingForClass:[RespCrmhbl_browse class]];
    [lo_hbl_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[RespCrmhbl_browse class]]];
    
    
    RKObjectMapping* lo_opp_response_mapping=[RKObjectMapping mappingForClass:[RespCrmopp_browse class]];
    [lo_opp_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[RespCrmopp_browse class]]];
    
    RKObjectMapping* lo_quo_response_mapping=[RKObjectMapping mappingForClass:[RespCrmquo_browse class]];
    [lo_quo_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[RespCrmquo_browse class]]];
    
    RKObjectMapping* lo_task_response_mapping=[RKObjectMapping mappingForClass:[Respcrmtask_browse class]];
    [lo_task_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[Respcrmtask_browse class]]];
    
    [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"AccountResult" toKeyPath:@"AccountResult" withMapping:lo_crmacct_response_mapping]];
    [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ContactResult" toKeyPath:@"ContactResult" withMapping:lo_contact_response_mapping]];
    [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"HblResult" toKeyPath:@"HblResult" withMapping:lo_hbl_response_mapping]];
    
     [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"OppResult" toKeyPath:@"OppResult" withMapping:lo_opp_response_mapping]];
     [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"QuoResult" toKeyPath:@"QuoResult" withMapping:lo_quo_response_mapping]];
     [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ActivityResult" toKeyPath:@"ActivityResult" withMapping:lo_task_response_mapping]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:base_url]];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    [manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    [manager postObject:ao_form path:path parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                    ilist_resp_result = [NSMutableArray arrayWithArray:result.array];
                    if (_callback) {
                        _callback(ilist_resp_result,NO);
                    }
                    
                } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    RKLogError(@"Operation failed with error: %@", error);
                    NSString *str_error=[NSString stringWithFormat:@"%@",error];
                    if ([str_error rangeOfString:@"Code=-1001"].location!=NSNotFound) {
                        if (_callback) {
                            _callback(ilist_resp_result,YES);
                        }
                    }else{
                        if (_callback) {
                            _callback(ilist_resp_result,NO);
                        }
                    }

                }];
}
- (void) fn_upload_Attachment:(UploadingAttachmentContract*)ao_form Auth:(AuthContract*)auth{
    //upload form
    RKObjectMapping *lo_updateMapping = [RKObjectMapping requestMapping];
    [lo_updateMapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[UpdateFormAttachment class]]];
    //Auth
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    [lo_authMapping addAttributeMappingsFromDictionary:[NSDictionary dictionaryWithPropertiesOfObject_withoutNil:auth]];
    
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    
    RKRelationshipMapping *updateRelationship = [RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"UpdateForm"
                                                 toKeyPath:@"UpdateForm"
                                                 withMapping:lo_updateMapping];
    
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    
    [lo_reqMapping addPropertyMapping:authRelationship];
    [lo_reqMapping addPropertyMapping:updateRelationship];
    
    NSString* path = il_url;
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[UploadingAttachmentContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping = [RKObjectMapping mappingForClass:iresp_class];
    
    [lo_response_mapping addAttributeMappingsFromArray:ilist_resp_mapping];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:base_url]];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    [manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    [manager postObject:ao_form path:path parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                    ilist_resp_result = [NSMutableArray arrayWithArray:result.array];
                    if (_callback) {
                        _callback(ilist_resp_result,NO);
                    }
                    
                } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    RKLogError(@"Operation failed with error: %@", error);
                    NSString *str_error=[NSString stringWithFormat:@"%@",error];
                    if ([str_error rangeOfString:@"Code=-1001"].location!=NSNotFound) {
                        if (_callback) {
                            _callback(ilist_resp_result,YES);
                        }
                    }else{
                        if (_callback) {
                            _callback(ilist_resp_result,NO);
                        }
                    }
                }];
}

@end
