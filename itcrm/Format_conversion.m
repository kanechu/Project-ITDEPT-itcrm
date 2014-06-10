//
//  Format_conversion.m
//  itcrm
//
//  Created by itdept on 14-6-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Format_conversion.h"

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
    /*NSString *t_desc4=nil;
     NSString *v_desc4=nil;
     NSString *t_desc5=nil;
     NSString *v_desc5=nil;*/
    NSArray *arr_t_title=nil;
    NSArray *arr_v_desc1=nil;
    NSArray *arr_v_desc2=nil;
    NSArray *arr_v_desc3=nil;
    if (arr_format!=nil && [arr_format count]!=0) {
        t_title=[[arr_format objectAtIndex:0] valueForKey:@"t_title"];
        v_title=[[arr_format objectAtIndex:0] valueForKey:@"v_title"];
        t_desc1=[[arr_format objectAtIndex:0] valueForKey:@"t_desc1"];
        v_desc1=[[arr_format objectAtIndex:0] valueForKey:@"v_desc1"];
        
        t_desc2=[[arr_format objectAtIndex:0] valueForKey:@"t_desc2"];
        v_desc2=[[arr_format objectAtIndex:0] valueForKey:@"v_desc2"];
        t_desc3=[[arr_format objectAtIndex:0] valueForKey:@"t_desc3"];
        v_desc3=[[arr_format objectAtIndex:0] valueForKey:@"v_desc3"];
        arr_t_title=[v_title componentsSeparatedByString:@","];
        arr_v_desc1=[v_desc1 componentsSeparatedByString:@","];
        arr_v_desc2=[v_desc2 componentsSeparatedByString:@","];
        arr_v_desc3=[v_desc3 componentsSeparatedByString:@","];
    }
    
    NSMutableArray *alist_crm_browse=[[NSMutableArray alloc]initWithCapacity:10];
    NSMutableDictionary *dic_after_consert=[[NSMutableDictionary alloc]init];
    for (NSDictionary *dic in arr_browse) {
        t_title=[self fn_replaceString:t_title withParameter:arr_t_title atString:@"%s" :dic];
        [dic_after_consert setObject:t_title forKey:@"t_title"];
        t_desc1=[self fn_replaceString:t_desc1 withParameter:arr_v_desc1 atString:@"%s" :dic];
        [dic_after_consert setObject:t_desc1 forKey:@"t_desc1"];
        
        t_desc2=[self fn_replaceString:t_desc2 withParameter:arr_v_desc2 atString:@"%s" :dic];
        [dic_after_consert setObject:t_desc2 forKey:@"t_desc2"];
        
        t_desc3=[self fn_replaceString:t_desc3 withParameter:arr_v_desc3 atString:@"%s" :dic];
        [dic_after_consert setObject:t_desc3 forKey:@"t_desc3"];
        
        [alist_crm_browse addObject:dic_after_consert];
        
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

@end
