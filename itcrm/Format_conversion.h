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
-(NSString*)fn_get_current_date_millisecond;

+(NSString*)fn_get_lang_code;
/**
 *  图片转换为base64
 *
 *  @param image 图片
 *
 *  @return 转换后的base64
 */
+ (NSString*)fn_image_convert_base64Str:(UIImage*)image;
+ (NSString*)fn_saveImage:(UIImage*)tempImg WithName:(NSString*)imageName;
/**
 *  给一个label显示两种不同颜色
 *
 *  @param parentString    父字符串
 *  @param subString 需要改变颜色的子字符串
 *  @param color     颜色
 *
 *  @return 处理后带属性的字符串
 */
+ (NSMutableAttributedString*)fn_get_different_color_inLabel:(NSString*)parentString colorString:(NSString*)subString color:(UIColor*)color;
@end
