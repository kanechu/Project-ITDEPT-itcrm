//
//  AuthContract.h
//  worldtrans
//
//  Created by itdept on 2/18/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthContract : NSObject

@property(nonatomic, strong) NSString *user_code;

@property(nonatomic, copy) NSString *password;

@property(nonatomic, copy) NSString *system;

@property(nonatomic, copy) NSString *version;

@property(nonatomic, copy) NSString *com_sys_code;

@property(nonatomic, copy) NSString *app_code;

@end
