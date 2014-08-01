//
//  Custom_datePicker.m
//  itcrm
//
//  Created by itdept on 14-7-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Custom_datePicker.h"
#define currentMonth [is_currentMonth integerValue]
@implementation Custom_datePicker{
    UIPickerView  *customDatePicker;
    NSMutableArray *alist_years;
    NSArray *alist_months;
    NSMutableArray *alist_days;
    NSArray *alist_amPm;
    NSMutableArray *alist_hours;
    NSMutableArray *alist_minutes;
    NSMutableArray *alist_seconds;
    NSString *is_currentMonth;
    int selectedYearRow;
    int selectedMonthRow;
    int selectedDayRow;
    BOOL firstTimeLoad;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self fn_create_toolbar];
        [self fn_create_titleLabel];
        [self fn_create_pickerView];
        [self fn_get_dataSource];
        NSDate *date=[NSDate date];
        [self fn_get_current_datetime:date];
    }
    return self;
}
-(void)fn_create_titleLabel{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width,21)];
    title.text=@"  year    month    day    hour   minute   second";
    title.font=[UIFont systemFontOfSize:15.0f];
    title.textColor=COLOR_LIGTH_GREEN;
    [self addSubview:title];
}
-(void)fn_create_pickerView{
    customDatePicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height)];
    customDatePicker.delegate=self;
    customDatePicker.dataSource=self;
    [self addSubview:customDatePicker];
}
-(void)fn_create_toolbar{
    UIToolbar *toobar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [toobar setBarStyle:UIBarStyleBlackTranslucent];
    [toobar setBarTintColor:COLOR_LIGTH_GREEN];
    [toobar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *buttonCancel=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(fn_Click_Cancel)];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(fn_Click_done:)];
    
    [toobar setItems:[NSArray arrayWithObjects:buttonCancel,buttonflexible,buttonDone, nil]];
    
    [self addSubview:toobar];
}
-(void)fn_Click_done:(id)sender{
    NSString *str=[NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@ ",[alist_years objectAtIndex:[customDatePicker selectedRowInComponent:0]],[alist_months objectAtIndex:[customDatePicker selectedRowInComponent:1]],[alist_days objectAtIndex:[customDatePicker selectedRowInComponent:2]],[alist_hours objectAtIndex:[customDatePicker selectedRowInComponent:3]],[alist_minutes objectAtIndex:[customDatePicker selectedRowInComponent:4]],[alist_seconds objectAtIndex:[customDatePicker selectedRowInComponent:5]]];
    
    if ([delegate respondsToSelector:@selector(fn_Clicked_done:)]) {
        [delegate fn_Clicked_done:str];
    }
    
}
-(void)fn_Click_Cancel{
    if ([delegate respondsToSelector:@selector(fn_Clicked_cancel)]) {
        [delegate fn_Clicked_cancel];
    }
}
- (void)fn_get_dataSource{

    // PickerView -  Years data
    alist_years=[[NSMutableArray alloc]init];
    for (int i=1970; i<=2050;i++) {
        [alist_years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    // PickerView -  Months data
     alist_months=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    // PickerView -  Hours data
    alist_hours = [[NSMutableArray alloc]init];
    for (int i=1; i<=24; i++) {
        [alist_hours addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    // PickerView -  minutes data
    alist_minutes = [[NSMutableArray alloc]init];
    for (int i = 0; i < 60; i++)
    {
        
        [alist_minutes addObject:[NSString stringWithFormat:@"%02d",i]];
        
    }
    
    //PickerView - seconds data
    alist_seconds = [[NSMutableArray alloc]init];
    
    for (int i=0; i<60; i++) {
        [alist_seconds addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    // PickerView -  days data
    alist_days = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 31; i++)
    {
        [alist_days addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
   
}
-(void)fn_get_current_datetime:(NSDate*)date{
    firstTimeLoad=YES;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    //Get Current year
    [formatter setDateFormat:@"yyyy"];
    NSString *is_currentyear = [NSString stringWithFormat:@"%@",
                                [formatter stringFromDate:date]];
    
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    is_currentMonth = [NSString stringWithFormat:@"%d",[[formatter stringFromDate:date]integerValue]];
    
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *is_currentDay = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    /**
     *Get Current  Hour hh表示12小时制 HH表示24小时制
     */
    [formatter setDateFormat:@"HH"];
    NSString *is_currentHour = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Minutes
    [formatter setDateFormat:@"mm"];
    NSString *is_currentMinute = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    //Get current Seconds
    [formatter setDateFormat:@"ss"];
    NSString *is_currentSecond=[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // PickerView - Default Selection as per current Date
    
    [customDatePicker selectRow:[alist_years indexOfObject:is_currentyear] inComponent:0 animated:YES];
    
    [customDatePicker  selectRow:[alist_months indexOfObject:is_currentMonth] inComponent:1 animated:YES];
    
    [customDatePicker  selectRow:[alist_days indexOfObject:is_currentDay] inComponent:2 animated:YES];
    
    [customDatePicker  selectRow:[alist_hours indexOfObject:is_currentHour] inComponent:3 animated:YES];
    
    [customDatePicker  selectRow:[alist_minutes indexOfObject:is_currentMinute] inComponent:4 animated:YES];
    
    [customDatePicker selectRow:[alist_seconds indexOfObject:is_currentSecond] inComponent:5 animated:YES];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        selectedYearRow = row;
        [pickerView reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [pickerView reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [pickerView
         reloadAllComponents];
    }
}

#pragma mark - UIPickerViewDataSource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    if (component == 0)
    {
        pickerLabel.text =  [alist_years objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [alist_months objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [alist_days objectAtIndex:row]; // Date
        
    }
    else if (component == 3)
    {
        pickerLabel.text =  [alist_hours objectAtIndex:row]; // Hours
    }
    else if (component == 4)
    {
        pickerLabel.text =  [alist_minutes objectAtIndex:row]; // Mins
    }else {
        pickerLabel.text=   [alist_seconds objectAtIndex:row];//seconds
    }
    
    return pickerLabel;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [alist_years count];
        
    }
    else if (component == 1)
    {
        return [alist_months count];
    }
    else if (component == 2)
    { // day
        
        if (firstTimeLoad)
        {
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
            {
                return 31;
            }
            else if (currentMonth == 2)
            {
                int yearint = [[alist_years objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
            }
            else
            {
                return 30;
            }
        }
        else
        {
            
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[alist_years objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
        }
    }
    else if (component == 3)
    { // hour
        
        return 24;
    }
    else if (component == 4)
    { // min
        return 60;
    }else {
        //seconds
        return 60;
    }
}

@end
