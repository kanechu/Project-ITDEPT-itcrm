//
//  SKSTableView.m
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import "SKSTableView.h"
#import "SKSTableViewCell.h"
//#import "SKSTableViewCellIndicator.h"
#import <objc/runtime.h>

static NSString * const kIsExpandedKey = @"isExpanded";
static NSString * const kSubrowsKey = @"subrowsCount";
//下拉的行高
CGFloat const kDefaultCellHeight = 60.0f;

#pragma mark - SKSTableView

@interface SKSTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSMutableDictionary *expandableCells;


- (NSInteger)numberOfExpandedSubrowsInSection:(NSInteger)section;

- (NSIndexPath *)correspondingIndexPathForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)setExpanded:(BOOL)isExpanded forCellAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction)expandableButtonTouched:(id)sender event:(id)event;

- (NSInteger)numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation SKSTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _shouldExpandOnlyOneCell = NO;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _shouldExpandOnlyOneCell = NO;
    }
    
    return self;
}

- (void)setSKSTableViewDelegate:(id<SKSTableViewDelegate>)SKSTableViewDelegate
{
    self.dataSource = self;
    self.delegate = self;
    
    //设置sub的分线颜色
    [self setSeparatorColor:[UIColor whiteColor]];
    
    if (SKSTableViewDelegate)
        _SKSTableViewDelegate = SKSTableViewDelegate;
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    [super setSeparatorColor:separatorColor];
   
}

- (NSMutableDictionary *)expandableCells
{
    if (!_expandableCells)
    {
        _expandableCells = [NSMutableDictionary dictionary];
        
        NSInteger numberOfSections = [self.SKSTableViewDelegate numberOfSectionsInTableView:self];
        for (NSInteger section = 0; section < numberOfSections; section++)
        {
            NSInteger numberOfRowsInSection = [self.SKSTableViewDelegate tableView:self
                                                             numberOfRowsInSection:section];
            
            NSMutableArray *rows = [NSMutableArray array];
            for (NSInteger row = 0; row < numberOfRowsInSection; row++)
            {
                NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                NSInteger numberOfSubrows = [self.SKSTableViewDelegate tableView:self
                                                      numberOfSubRowsAtIndexPath:rowIndexPath];
                NSMutableDictionary *rowInfo = [NSMutableDictionary dictionaryWithObjects:@[@(NO), @(numberOfSubrows)]
                                                                                  forKeys:@[kIsExpandedKey, kSubrowsKey]];

                [rows addObject:rowInfo];
            }
            
            [_expandableCells setObject:rows forKey:@(section)];
        }
    }
    
    return _expandableCells;
}

#pragma mark - UITableViewDataSource

#pragma mark - Required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_SKSTableViewDelegate tableView:tableView numberOfRowsInSection:section] + [self numberOfExpandedSubrowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
    if ([correspondingIndexPath subRow] == 0)
    {
        SKSTableViewCell *expandableCell = (SKSTableViewCell *)[_SKSTableViewDelegate tableView:tableView cellForRowAtIndexPath:correspondingIndexPath];
        expandableCell.selectionStyle=UITableViewCellSelectionStyleNone;
        if ([expandableCell respondsToSelector:@selector(setSeparatorInset:)])
        {
            expandableCell.separatorInset = UIEdgeInsetsZero;
        }
        
        BOOL isExpanded = [self.expandableCells[@(correspondingIndexPath.section)][correspondingIndexPath.row][kIsExpandedKey] boolValue];
        
        if (expandableCell.isExpandable)
        {
            expandableCell.expanded = isExpanded;
            
            UIButton *expandableButton = (UIButton *)expandableCell.accessoryView;
            [expandableButton addTarget:tableView
                                 action:@selector(expandableButtonTouched:event:)
                       forControlEvents:UIControlEventTouchUpInside];
            
            if (isExpanded)
            {
                expandableCell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
            }
            else
            {
                if ([expandableCell containsIndicatorView])
                {
                    [expandableCell removeIndicatorView];
                }
            }
        }
        else
        {
            expandableCell.expanded =NO;
            expandableCell.accessoryView = nil;
            [expandableCell removeIndicatorView];
        }
        
       return expandableCell;
    }
    else
    {
        UITableViewCell *cell = [_SKSTableViewDelegate tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:correspondingIndexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.indentationLevel = 2;
        
        return cell;
    }
}

#pragma mark - Optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_SKSTableViewDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        return [_SKSTableViewDelegate numberOfSectionsInTableView:tableView];
    }
    
    return 1;
}


#pragma mark - UITableViewDelegate

#pragma mark - Optional

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SKSTableViewCell *cell = (SKSTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(isExpandable)])
    {
        if (cell.isExpandable)
        {
            cell.expanded = !cell.isExpanded;
        
            NSIndexPath *_indexPath = indexPath;
            NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
            if (cell.isExpanded && _shouldExpandOnlyOneCell)
            {
                _indexPath = correspondingIndexPath;
                [self collapseCurrentlyExpandedIndexPaths];
            }
        
            if (_indexPath)
            {
                NSInteger numberOfSubRows = [self numberOfSubRowsAtIndexPath:correspondingIndexPath];
            
                NSMutableArray *expandedIndexPaths = [NSMutableArray array];
                NSInteger row = _indexPath.row;
                NSInteger section = _indexPath.section;
            
                for (NSInteger index = 1; index <= numberOfSubRows; index++)
                {
                    NSIndexPath *expIndexPath = [NSIndexPath indexPathForRow:row+index inSection:section];
                    [expandedIndexPaths addObject:expIndexPath];
                }
            
                if (cell.isExpanded)
                {
                    [self setExpanded:YES forCellAtIndexPath:correspondingIndexPath];
                    [self insertRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                }
                else
                {
                    [self setExpanded:NO forCellAtIndexPath:correspondingIndexPath];
                    [self deleteRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                }
            
                [cell accessoryViewAnimation];
            }
        }
        
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
            
            if (correspondingIndexPath.subRow == 0)
            {
                [_SKSTableViewDelegate tableView:tableView didSelectRowAtIndexPath:correspondingIndexPath];
            }
            else
            {
                [_SKSTableViewDelegate tableView:self didSelectSubRowAtIndexPath:correspondingIndexPath];
            }
        }
    }
    else
    {
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didSelectSubRowAtIndexPath:)])
        {
            NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
            
            [_SKSTableViewDelegate tableView:self didSelectSubRowAtIndexPath:correspondingIndexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
        [_SKSTableViewDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
    if ([correspondingIndexPath subRow] == 0)
    {
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
        {
            return [_SKSTableViewDelegate tableView:tableView heightForRowAtIndexPath:correspondingIndexPath];
        }
        
        return kDefaultCellHeight;
    }
    else
    {
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForSubRowAtIndexPath:)])
        {
            return [_SKSTableViewDelegate tableView:self heightForSubRowAtIndexPath:correspondingIndexPath];
        }
        
        return kDefaultCellHeight;
    }
}

#pragma mark - SKSTableViewUtils

- (NSInteger)numberOfExpandedSubrowsInSection:(NSInteger)section
{
    NSInteger totalExpandedSubrows = 0;
    
    NSArray *rows = self.expandableCells[@(section)];
    for (id row in rows)
    {
        if ([row[kIsExpandedKey] boolValue] == YES)
        {
            totalExpandedSubrows += [row[kSubrowsKey] integerValue];
        }
    }
    
    return totalExpandedSubrows;
}

- (IBAction)expandableButtonTouched:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
    
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath)
        [self tableView:self accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (NSInteger)numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [_SKSTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:indexPath];
}

- (NSIndexPath *)correspondingIndexPathForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block NSIndexPath *correspondingIndexPath = nil;
    __block NSInteger expandedSubrows = 0;
    
    NSArray *rows = self.expandableCells[@(indexPath.section)];
    [rows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        BOOL isExpanded = [obj[kIsExpandedKey] boolValue];
        NSInteger numberOfSubrows = 0;
        if (isExpanded)
        {
            numberOfSubrows = [obj[kSubrowsKey] integerValue];
        }
        
        NSInteger subrow = indexPath.row - expandedSubrows - idx;
        if (subrow > numberOfSubrows)
        {
            expandedSubrows += numberOfSubrows;
        }
        else
        {
             correspondingIndexPath = [NSIndexPath indexPathForSubRow:subrow
                                                                inRow:idx
                                                            inSection:indexPath.section];
            
            *stop = YES;
        }
    }];
    
    return correspondingIndexPath;
}

- (void)setExpanded:(BOOL)isExpanded forCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *cellInfo = self.expandableCells[@(indexPath.section)][indexPath.row];
    [cellInfo setObject:@(isExpanded) forKey:kIsExpandedKey];
}

- (void)collapseCurrentlyExpandedIndexPaths
{
    NSMutableArray *totalExpandedIndexPaths = [NSMutableArray array];
    NSMutableArray *totalExpandableIndexPaths = [NSMutableArray array];
    
    [self.expandableCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        __block NSInteger totalExpandedSubrows = 0;
        
        [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            NSInteger currentRow = idx + totalExpandedSubrows;
            
            BOOL isExpanded = [obj[kIsExpandedKey] boolValue];
            if (isExpanded)
            {
                NSInteger expandedSubrows = [obj[kSubrowsKey] integerValue];
                for (NSInteger index = 1; index <= expandedSubrows; index++)
                {
                    NSIndexPath *expandedIndexPath = [NSIndexPath indexPathForRow:currentRow + index
                                                                        inSection:[key integerValue]];
                    [totalExpandedIndexPaths addObject:expandedIndexPath];
                }
                
                [obj setObject:@(NO) forKey:kIsExpandedKey];
                totalExpandedSubrows += expandedSubrows;
                
                [totalExpandableIndexPaths addObject:[NSIndexPath indexPathForRow:currentRow inSection:[key integerValue]]];
            }
        }];
    }];
    
    for (NSIndexPath *indexPath in totalExpandableIndexPaths)
    {
        SKSTableViewCell *cell = (SKSTableViewCell *)[self cellForRowAtIndexPath:indexPath];
        cell.expanded = NO;
        [cell accessoryViewAnimation];
    }
    
    [self deleteRowsAtIndexPaths:totalExpandedIndexPaths withRowAnimation:UITableViewRowAnimationTop];
}
- (void)fn_expandall
{
    for (NSInteger j = 0; j < [self numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self numberOfRowsInSection:j]; ++i)
        {
            
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:i inSection:j];
            SKSTableViewCell *cell = (SKSTableViewCell *)[self cellForRowAtIndexPath:indexPath];
            
            if ([cell respondsToSelector:@selector(isExpandable)])
            {
                if (cell.isExpandable)
                {
                    cell.expanded = !cell.isExpanded;
                    
                    NSIndexPath *_indexPath = indexPath;
                    NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
                    if (cell.isExpanded && _shouldExpandOnlyOneCell)
                    {
                        _indexPath = correspondingIndexPath;
                        [self collapseCurrentlyExpandedIndexPaths];
                    }
                    
                    if (_indexPath)
                    {
                        NSInteger numberOfSubRows = [self numberOfSubRowsAtIndexPath:correspondingIndexPath];
                        
                        NSMutableArray *expandedIndexPaths = [NSMutableArray array];
                        NSInteger row = _indexPath.row;
                        NSInteger section = _indexPath.section;
                        
                        for (NSInteger index = 1; index <= numberOfSubRows; index++)
                        {
                            NSIndexPath *expIndexPath = [NSIndexPath indexPathForRow:row+index inSection:section];
                            [expandedIndexPaths addObject:expIndexPath];
                        }
                        
                        if (cell.isExpanded)
                        {
                            [self setExpanded:YES forCellAtIndexPath:correspondingIndexPath];
                            [self insertRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                        }
                        else
                        {
                            [self setExpanded:NO forCellAtIndexPath:correspondingIndexPath];
                            [self deleteRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                        }
                        
                        [cell accessoryViewAnimation];
                    }
                }
                
                if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
                {
                    NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
                    
                    if (correspondingIndexPath.subRow == 0)
                    {
                        [_SKSTableViewDelegate tableView:self didSelectRowAtIndexPath:correspondingIndexPath];
                    }
                    else
                    {
                        [_SKSTableViewDelegate tableView:self didSelectSubRowAtIndexPath:correspondingIndexPath];
                    }
                }
            }
            else
            {
                if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didSelectSubRowAtIndexPath:)])
                {
                    NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
                    
                    [_SKSTableViewDelegate tableView:self didSelectSubRowAtIndexPath:correspondingIndexPath];
                }
            }
            
        }
    }
}

@end

#pragma mark - NSIndexPath (SKSTableView)

static void *SubRowObjectKey;

@implementation NSIndexPath (SKSTableView)

@dynamic subRow;

- (NSInteger)subRow
{
    id subRowObj = objc_getAssociatedObject(self, SubRowObjectKey);
    return [subRowObj integerValue];
}

- (void)setSubRow:(NSInteger)subRow
{
    id subRowObj = [NSNumber numberWithInteger:subRow];
    objc_setAssociatedObject(self, SubRowObjectKey, subRowObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    indexPath.subRow = subrow;
    
    return indexPath;
}

@end

