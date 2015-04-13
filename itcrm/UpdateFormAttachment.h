//
//  UpdateFormAttachment.h
//  itcrm
//
//  Created by itdept on 15/4/10.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateFormAttachment : NSObject

@property (nonatomic, copy) NSString *ls_acct_id;
@property (nonatomic, copy) NSString *ls_att_name;
@property (nonatomic, copy) NSString *ls_assign_to;
@property (nonatomic, copy) NSString *ldt_doc_recv_date;
@property (nonatomic, copy) NSString *ldt_effective_date;
@property (nonatomic, copy) NSString *ldt_expiry_date;
@property (nonatomic, copy) NSString *ls_att_desc;
@property (nonatomic, copy) NSString *ls_filedata_base64;

@end
