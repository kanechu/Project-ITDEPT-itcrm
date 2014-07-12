//
//  expand_helper.h
//  itcrm
//
//  Created by itdept on 14-7-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface expand_helper : NSObject
+(void)setExtraCellLineHidden: (UITableView *)tableView;
#pragma mark 对数组进行过滤
+(NSArray*)fn_filtered_criteriaData:(NSString*)key arr:(NSMutableArray*)alist_will_filter;
@end
