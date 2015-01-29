//
//  Resp_crmacct_dowload.h
//  itcrm
//
//  Created by itdept on 15/1/28.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resp_crmacct_dowload : NSObject
@property (nonatomic,copy) NSString *acct_id;
@property (nonatomic,strong) NSSet *ContactResult;
@property (nonatomic,strong) NSSet *HblResult;
@property (nonatomic,strong) NSSet *OppResult;
@property (nonatomic,strong) NSSet *QuoResult;
@property (nonatomic,strong) NSSet *ActivityResult;
@end
