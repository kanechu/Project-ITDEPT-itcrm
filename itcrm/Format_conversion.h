//
//  Format_conversion.h
//  itcrm
//
//  Created by itdept on 14-6-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Format_conversion : NSObject
-(NSMutableArray*)fn_format_conersion:(NSMutableArray*)arr_format browse:(NSMutableArray*)arr_browse;
-(CGFloat)fn_heightWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width;
-(UIImage*)fn_binaryData_convert_image:(NSString*)binary_str;
-(NSString*)fn_get_binaryData:(NSString*)iconName;
-(NSString*)fn_convert_display_status:(NSString*)data col_option:(NSString*)option_type;
-(NSDate*)dateFromUnixTimestamp:(NSString*)millisecond;
/**
 *  排序
 *
 *  @param alist_source 需要排序的数组
 *  @param sortBy_name  根据key排序
 *
 *  @return 返回排序好的数组
 */
-(NSMutableArray*)fn_sort_the_array:(NSMutableArray*)alist_source  key:(NSString*)sortBy_name;
-(BOOL)fn_isContain_a_character:(NSString*)_parentString substring:(NSString*)_substring;

@end
