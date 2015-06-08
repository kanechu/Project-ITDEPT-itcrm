//
//  Format_conversion.m
//  itcrm
//
//  Created by itdept on 14-6-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Format_conversion.h"
#import "DB_systemIcon.h"
#import "DB_Region.h"
#import "DB_Login.h"
#define ISIOS7      ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
@implementation Format_conversion

-(NSMutableArray*)fn_format_conersion:(NSMutableArray*)arr_format browse:(NSMutableArray*)arr_browse{
    NSString *t_title=nil;
    NSString *v_title=nil;
    NSString *t_desc1=nil;
    NSString *v_desc1=nil;
    NSString *t_desc2=nil;
    NSString *v_desc2=nil;
    NSString *t_desc3=nil;
    NSString *v_desc3=nil;
    NSString *t_desc4=nil;
    NSString *v_desc4=nil;
    NSString *t_desc5=nil;
    NSString *v_desc5=nil;
    NSArray *arr_t_title=nil;
    NSArray *arr_v_desc1=nil;
    NSArray *arr_v_desc2=nil;
    NSArray *arr_v_desc3=nil;
    NSArray *arr_v_desc4=nil;
    NSArray *arr_v_desc5=nil;
    if (arr_format!=nil && [arr_format count]!=0) {
        t_title=[[arr_format objectAtIndex:0] valueForKey:@"t_title"];
        v_title=[[arr_format objectAtIndex:0] valueForKey:@"v_title"];
        t_desc1=[[arr_format objectAtIndex:0] valueForKey:@"t_desc1"];
        v_desc1=[[arr_format objectAtIndex:0] valueForKey:@"v_desc1"];
        
        t_desc2=[[arr_format objectAtIndex:0] valueForKey:@"t_desc2"];
        v_desc2=[[arr_format objectAtIndex:0] valueForKey:@"v_desc2"];
        t_desc3=[[arr_format objectAtIndex:0] valueForKey:@"t_desc3"];
        v_desc3=[[arr_format objectAtIndex:0] valueForKey:@"v_desc3"];
        t_desc4=[[arr_format objectAtIndex:0] valueForKey:@"t_desc4"];
        v_desc4=[[arr_format objectAtIndex:0] valueForKey:@"v_desc4"];
        t_desc5=[[arr_format objectAtIndex:0] valueForKey:@"t_desc5"];
        v_desc5=[[arr_format objectAtIndex:0] valueForKey:@"v_desc5"];
        arr_t_title=[v_title componentsSeparatedByString:@","];
        arr_v_desc1=[v_desc1 componentsSeparatedByString:@","];
        arr_v_desc2=[v_desc2 componentsSeparatedByString:@","];
        arr_v_desc3=[v_desc3 componentsSeparatedByString:@","];
        arr_v_desc4=[v_desc4 componentsSeparatedByString:@","];
        arr_v_desc5=[v_desc5 componentsSeparatedByString:@","];
    }
    
    NSMutableArray *alist_crm_browse=[[NSMutableArray alloc]initWithCapacity:10];
    NSDateFormatter *_dateFormatter=[[NSDateFormatter alloc]init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    for (NSMutableDictionary *dic_old in arr_browse) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:dic_old];
        NSString *rec_upd_date=[dic_old valueForKey:@"rec_upd_date"];
        NSString *rec_crt_date=[dic_old valueForKey:@"rec_crt_date"];
        if ([[dic_old allKeys]containsObject:@"task_start_date"]) {
            NSString *task_start_date=[dic_old valueForKey:@"task_start_date"];
            NSDate *task_date=[self dateFromUnixTimestamp:task_start_date];
            NSString *str_task_date=[_dateFormatter stringFromDate:task_date];
            if ([task_start_date length]==0) {
                [dic setObject:@"" forKey:@"task_start_date"];
            }else{
                [dic setObject:str_task_date forKey:@"task_start_date"];
            }
        }
        NSDate *upd_date=[self dateFromUnixTimestamp:rec_upd_date];
        NSString *str_rec_upd_date=[_dateFormatter stringFromDate:upd_date];
        if ([rec_upd_date length]==0) {
            [dic setObject:@"" forKey:@"rec_upd_date"];
        }else{
            [dic setObject:str_rec_upd_date forKey:@"rec_upd_date"];
        }
        NSDate *crt_date=[self dateFromUnixTimestamp:rec_crt_date];
        NSString *str_rec_crt_date=[_dateFormatter stringFromDate:crt_date];
        if ([rec_crt_date length]==0) {
            [dic setObject:@"" forKey:@"rec_crt_date"];
        }else{
            [dic setObject:str_rec_crt_date forKey:@"rec_crt_date"];
        }
        str_rec_upd_date=nil;
        NSMutableDictionary *dic1=[NSMutableDictionary dictionary];
        NSString *joint_str=[NSString string];
        NSString *ist_title=[self fn_replaceString:t_title withParameter:arr_t_title atString:@"%s" :dic];
        NSString *ist_desc1=[self fn_replaceString:t_desc1 withParameter:arr_v_desc1 atString:@"%s" :dic];
        
        NSString *ist_desc2=[self fn_replaceString:t_desc2 withParameter:arr_v_desc2 atString:@"%s" :dic];
        
        NSString *ist_desc3=[self fn_replaceString:t_desc3 withParameter:arr_v_desc3 atString:@"%s" :dic];
        
        NSString *ist_desc4=[self fn_replaceString:t_desc4 withParameter:arr_v_desc4 atString:@"%s" :dic];
        
        NSString *ist_desc5=[self fn_replaceString:t_desc5 withParameter:arr_v_desc5 atString:@"%s" :dic];
        if ([ist_title length]!=0) {
            [dic1 setObject:ist_title forKey:@"title"];
        }
        if ([ist_desc1 length]!=0) {
            joint_str=[joint_str stringByAppendingFormat:@"%@\n",ist_desc1];
        }
        if ([ist_desc2 length]!=0) {
            joint_str=[joint_str stringByAppendingFormat:@"%@\n",ist_desc2];
        }
        if ([ist_desc3 length]!=0) {
            joint_str=[joint_str stringByAppendingFormat:@"%@\n",ist_desc3];
        }
        if ([ist_desc4 length]!=0) {
            joint_str=[joint_str stringByAppendingFormat:@"%@\n",ist_desc4];
        }
        if ([ist_desc5 length]!=0) {
            joint_str=[joint_str stringByAppendingFormat:@"%@\n",ist_desc5];
        }
        if ([joint_str length]!=0) {
            [dic1 setObject:joint_str forKey:@"body"];
        }
        if ([dic1 count]!=0) {
            [alist_crm_browse addObject:dic1];
        }
        
        
    }
    return alist_crm_browse;
    
}
#pragma mark 格式转换 %s用参数里面的值来替换
-(NSString*)fn_replaceString:(NSString*)string withParameter:(NSArray*)parameter atString:(NSString*)key :(NSDictionary*)dic{
    NSMutableString *resultString=nil;
    if ([string length]!=0) {
        resultString = [[NSMutableString alloc]initWithString:string];
    }
    NSRange range ;
    range = [string rangeOfString:key];
    int i = 0;
    while (range.length>0&&i<[parameter count]) {
        NSString *str_replace_key=[parameter objectAtIndex:i];
        str_replace_key=[str_replace_key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([dic valueForKey:str_replace_key]==nil || [dic valueForKey:str_replace_key]==[NSNull null]) {
            [resultString replaceCharactersInRange:range withString:@""];
        }else{
            [resultString replaceCharactersInRange:range withString:[dic valueForKey:str_replace_key]];
        }
        str_replace_key=nil;
        i++;
        range = [resultString rangeOfString:key];
    }
    return resultString;
}
-(CGFloat)fn_heightWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    CGSize rtSize;
    if(ISIOS7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        rtSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        return ceil(rtSize.height) + 0.5;
    } else {
        rtSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        return rtSize.height;
    }
}
-(UIImage*)fn_binaryData_convert_image:(NSString*)binary_str{
    UIImage *image=nil;
    if (binary_str!=nil || [binary_str length]!=0) {
        NSData *data=[[NSData alloc]initWithBase64EncodedString:binary_str options:0];
        image=[UIImage imageWithData:data];
        
    }
    return image;
}
-(NSString*)fn_get_binaryData:(NSString*)iconName{
    DB_systemIcon *db_icon=[[DB_systemIcon alloc]init];
    NSMutableArray *arr_icon=[db_icon fn_get_systemIcon_data:iconName];
    NSString *binary_str=nil;
    if ([arr_icon count]!=0) {
        binary_str=[[arr_icon objectAtIndex:0]valueForKey:@"ic_content"];
    }
    return binary_str;
}
-(NSString*)fn_convert_display_status:(NSString*)data col_option:(NSString*)option_type{
    NSString *display_str=[NSString string];
    DB_Region *db=[[DB_Region alloc]init];
    NSMutableArray  *arr_lookup=[db fn_get_region_data:option_type];
    db=nil;
    NSInteger flag=0;
    for (NSMutableDictionary *dic in arr_lookup) {
        if ([data isEqualToString:[dic valueForKey:@"data"]]) {
            display_str=[dic valueForKey:@"display"];
            flag=1;
        }
    }
    if (flag==0 || [display_str length]==0) {
        display_str=data;
    }
    return display_str;
}
#pragma mark 毫秒转换为日期格式
-(NSDate*)dateFromUnixTimestamp:(NSString*)millisecond{
    double millisecond_value=[millisecond doubleValue];
    NSTimeInterval timeinterval=millisecond_value/1000.0f;
    return [NSDate dateWithTimeIntervalSince1970:timeinterval];
}
#pragma mark -排序方法
-(NSMutableArray*)fn_sort_the_array:(NSMutableArray*)alist_source  key:(NSString*)sortBy_name{
    //如果需要降序，那么将ascending由YES改为NO
    NSSortDescriptor *sortDes=[NSSortDescriptor sortDescriptorWithKey:sortBy_name ascending:YES];
    NSArray *sortDescriptors=[NSArray arrayWithObject:sortDes];
    NSMutableArray *sortedArray=[[alist_source sortedArrayUsingDescriptors:sortDescriptors]mutableCopy];
    //重新排序后，返回
    return sortedArray;
}
//检测一个字符串中是否含有某个字符
-(BOOL)fn_isContain_a_character:(NSString*)_parentString substring:(NSString*)_substring{
    if ([_parentString rangeOfString:_substring].location!=NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}
-(NSString*)fn_get_current_date_millisecond{
    NSDate *date=[NSDate date];
    NSTimeInterval timeInterval=[date timeIntervalSince1970];
    NSTimeInterval milliseconds=timeInterval*1000.0f;
    NSString *str_milliseconds=[NSString stringWithFormat:@"%0.0lf",milliseconds];
    return str_milliseconds;
}
/**
 *  获取登录时候，选择的语言
 *
 *  @return 语言类型
 */
+(NSString*)fn_get_lang_code{
    DB_Login *db=[[DB_Login alloc]init];
    NSMutableArray *arr=[db fn_get_allData];
    NSString *lang_code=@"";
    if ([arr count]!=0) {
        lang_code=[[arr objectAtIndex:0]valueForKey:@"lang_code"];
        if ([lang_code isEqualToString:@"EN"]) {
            lang_code=@"en";
        }
        if ([lang_code isEqualToString:@"CN"]) {
            lang_code=@"zh-Hans";
        }
        if ([lang_code isEqualToString:@"TCN"]) {
            lang_code=@"zh-Hant";
        }
    }
    return lang_code;
}
+ (NSString*)fn_image_convert_base64Str:(UIImage*)image{
    NSData *data=UIImagePNGRepresentation(image);
    return [data base64EncodedStringWithOptions:0];
}
+ (NSString*)fn_saveImage:(UIImage*)tempImg WithName:(NSString*)imageName{
    NSData *data;
    if (UIImagePNGRepresentation(tempImg)==nil) {
        data=UIImageJPEGRepresentation(tempImg, 1);
    }else{
        data=UIImagePNGRepresentation(tempImg);
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    
    NSString *_filePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    // and then we write it out
    
    [data writeToFile:_filePath atomically:NO];
    return _filePath;
}
@end
