//
//  expand_helper.m
//  itcrm
//
//  Created by itdept on 14-7-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "expand_helper.h"
#import "Advance_SearchData.h"
@implementation expand_helper

#pragma mark 将额外的cell的线隐藏
+ (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark 对数组进行过滤
+(NSArray*)fn_filtered_criteriaData:(NSString*)key arr:(NSMutableArray*)alist_will_filter{
    NSArray *filtered=[alist_will_filter filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(group_name==%@)",key]];
    return filtered;
}
#pragma mark 进阶查询
+(Advance_SearchData*)fn_get_searchData:(NSString*)key idic_value:(NSMutableDictionary*)idic_value idic_parameter:(NSMutableDictionary*)idic_parameter{
    Advance_SearchData *searchData=[[Advance_SearchData alloc]init];
    if ([[idic_value valueForKey:key] length]!=0) {
        searchData.is_searchValue=[idic_value valueForKey:key];
        searchData.is_parameter=[idic_parameter valueForKey:key];
    }
    return searchData;
}
@end
