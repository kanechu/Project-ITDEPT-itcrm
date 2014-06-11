//
//  Format_conversion.m
//  itcrm
//
//  Created by itdept on 14-6-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Format_conversion.h"
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
    for (NSDictionary *dic in arr_browse) {
        NSString *joint_str=[NSString string];
        t_title=[self fn_replaceString:t_title withParameter:arr_t_title atString:@"%s" :dic];
        t_desc1=[self fn_replaceString:t_desc1 withParameter:arr_v_desc1 atString:@"%s" :dic];
        
        t_desc2=[self fn_replaceString:t_desc2 withParameter:arr_v_desc2 atString:@"%s" :dic];
        
        t_desc3=[self fn_replaceString:t_desc3 withParameter:arr_v_desc3 atString:@"%s" :dic];
        
        t_desc4=[self fn_replaceString:t_desc4 withParameter:arr_v_desc4 atString:@"%s" :dic];
        
        t_desc5=[self fn_replaceString:t_desc5 withParameter:arr_v_desc5 atString:@"%s" :dic];
        if ([t_title length]!=0) {
            joint_str=[joint_str stringByAppendingFormat:@"%@\n\n",t_title];
        }
        if ([t_desc1 length]!=0) {
            joint_str=[joint_str stringByAppendingFormat:@"%@\n",t_desc1];
        }
        if ([t_desc2 length]!=0) {
            joint_str=[joint_str stringByAppendingFormat:@"%@\n",t_desc2];
        }
        if ([t_desc3 length]!=0) {
            joint_str=[joint_str stringByAppendingFormat:@"%@\n",t_desc3];
        }
        if ([t_desc4 length]!=0) {
            joint_str=[joint_str stringByAppendingFormat:@"%@\n",t_desc4];
        }
        if ([t_desc5 length]!=0) {
            joint_str=[joint_str stringByAppendingFormat:@"%@\n",t_desc5];
        }
        [alist_crm_browse addObject:joint_str];
        
    }
    return alist_crm_browse;
    
}
#pragma mark 格式转换 %s用参数里面的值来替换
-(NSString*)fn_replaceString:(NSString*)string withParameter:(NSArray*)parameter atString:(NSString*)key :(NSDictionary*)dic{
    NSMutableString *resultString = [[NSMutableString alloc]initWithString:string];
    NSRange range ;
    range = [string rangeOfString:key];
    int i = 0;
    while (range.length>0&&i<[parameter count]) {
        if ([dic valueForKey:[parameter objectAtIndex:i]]==nil) {
            [resultString replaceCharactersInRange:range withString:@""];
        }else{
            [resultString replaceCharactersInRange:range withString:[dic valueForKey:[parameter objectAtIndex:i]]];
        }
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


@end
