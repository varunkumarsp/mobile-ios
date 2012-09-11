//
//  ActivityStreamTabbar.m
//  eXo Platform
//
//  Created by Le Thanh Quang on 7/20/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "ActivityStreamTabbar.h"
#import <QuartzCore/QuartzCore.h>
#import "LanguageHelper.h"

#define kFilterTabTopBottomPadding 5.0
#define kFilterTabLeftRightPadding 10.0
#define kFilterTabItemSeparateSpace 0.0
#define kFilterTabItemPadding (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 25. : 8.0)

#define kActivityStreamTabItemTitle @"item title"
#define kActivityStreamTabItem @"custom JMItem"
#define kActivityStreamTabItemFont (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [UIFont systemFontOfSize:11.] : [UIFont systemFontOfSize:10.])

@interface CustomFilterItem : JMTabItem

@property (nonatomic) CGSize itemSize;

@end

@implementation CustomFilterItem

@synthesize itemSize = _itemSize;

- (id)initWithTitle:(NSString *)title icon:(UIImage *)icon {
    if (self = [super initWithTitle:title icon:icon]) {
        self.showsTouchWhenHighlighted = YES;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize titleSize = [self.title sizeWithFont:kActivityStreamTabItemFont];
    return CGSizeMake(titleSize.width + kFilterTabItemPadding * 2, _itemSize.height);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIColor *textColor = self.isSelectedTabItem ? [UIColor colorWithRed:84./255 green:84./255 blue:84./255 alpha:1.] : [UIColor colorWithRed:122./255 green:122./255 blue:122./255 alpha:1.];
    [textColor set];
    CGSize titleSize = [self.title sizeWithFont:kActivityStreamTabItemFont];
    float xOffset = (rect.size.width - titleSize.width) / 2;
    float yOffset = (rect.size.height - titleSize.height) / 2;
    [self.title drawAtPoint:CGPointMake(xOffset, yOffset) withFont:kActivityStreamTabItemFont];
    CGContextRestoreGState(context);
}

@end

@interface CustomActivityFilterSelectionView : JMSelectionView

@end

@implementation CustomActivityFilterSelectionView 

- (void)drawRect:(CGRect)rect {
    UIImage *bgImage = [UIImage imageNamed:@"activity-stream-filter-item-active-state.png"];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
    [bgImage drawInRect:rect];
}

@end

@interface ActivityStreamTabbar () {
    BOOL _istranslucent;
}

- (void)initData;

@end

@implementation ActivityStreamTabbar

@synthesize tabView = _tabView;

#pragma mark - initilization

- (void)dealloc {
    [_listOfItems release];
    [_tabView release];
    [super dealloc];
}

- (void)initData {
    _listOfItems = [[NSMutableArray alloc] init];
    for (int i = 0; ;i++) {
        NSString *title = nil;
        if (i == ActivityStreamTabItemAllUpdate) {
            title = @"All Updates";
        } else if (i == ActivityStreamTabItemMyConnections) {
            title = @"My Connections";
        } else if (i == ActivityStreamTabItemMySpaces) {
            title = @"My Spaces";
        } else if (i == ActivityStreamTabItemMyStatus) {
            title = @"My Status";
        } else {
            break;
        }
        CustomFilterItem *item = [[[CustomFilterItem alloc] initWithTitle:Localize(title) icon:nil] autorelease];
        [self.tabView addTabItem:item];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:title, kActivityStreamTabItemTitle,
                              item, kActivityStreamTabItem, 
                              nil];
        [_listOfItems insertObject:dict atIndex:i];
        
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _istranslucent = NO;
        self.backgroundColor = [UIColor whiteColor];
        UIImage *image = [UIImage imageNamed:@"activity-stream-filter-tabbar-bg.png"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        UIImageView *backgroundView = [[[UIImageView alloc] initWithImage:image] autorelease];
        backgroundView.frame = self.bounds;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:backgroundView];
        
        self.tabView = [[[JMTabView alloc] initWithFrame:CGRectInset(self.bounds, kFilterTabLeftRightPadding, kFilterTabTopBottomPadding)] autorelease];
        [self initData];
        [self.tabView setSelectionView:[[[CustomActivityFilterSelectionView alloc] initWithFrame:CGRectZero] autorelease]];
        [self.tabView setBackgroundLayer:nil];
        CGRect contentRect = self.tabView.bounds;
        float itemSpacing = (contentRect.size.width - [self calculateItemSpacing]) / ([_listOfItems count] - 1);
        [self.tabView setItemSpacing:itemSpacing];
        float itemWidth = (contentRect.size.width - kFilterTabItemSeparateSpace * (_listOfItems.count - 1)) / (_listOfItems.count);
        for (NSDictionary *dict in _listOfItems) {
            CustomFilterItem *item = [dict objectForKey:kActivityStreamTabItem];
            item.itemSize = CGSizeMake(itemWidth, contentRect.size.height);
        }
        [self insertSubview:self.tabView aboveSubview:backgroundView];
        
    }
    return self;
}

- (float)calculateItemSpacing; 
{
    float itemsWidth = 0;
    for (NSDictionary *itemData in _listOfItems) {
        NSString *title = Localize([itemData objectForKey:kActivityStreamTabItemTitle]);
        CGSize titleSize = [title sizeWithFont:kActivityStreamTabItemFont];
        itemsWidth += titleSize.width + kFilterTabItemPadding * 2;
    }
    return itemsWidth;
}

#pragma mark - view management

- (void)translucentView:(BOOL)translucent {
    
    if (translucent ^ _istranslucent) {
        if (translucent) 
            self.backgroundColor = [UIColor clearColor];
        else 
            self.backgroundColor = [UIColor whiteColor];
        _istranslucent = translucent;
    }
}

- (void)selectTabItem:(ActivityStreamTabItem)selectedTabItem {
    [self.tabView setSelectedIndex:selectedTabItem];
    [self.tabView didSelectItemAtIndex:selectedTabItem];
}

#pragma mark - language change management

- (void)updateLabelsWithNewLanguage {
    for(int i=0; i<_listOfItems.count; i++) {
        // Update the title of each tab
        NSDictionary *dict = [_listOfItems objectAtIndex:i];
        CustomFilterItem* item = [dict objectForKey:kActivityStreamTabItem];
        if (i == ActivityStreamTabItemAllUpdate) {
            item.title = Localize(@"All Updates");
        } else if (i == ActivityStreamTabItemMyConnections) {
            item.title = Localize(@"My Connections");
        } else if (i == ActivityStreamTabItemMySpaces) {
            item.title = Localize(@"My Spaces");
        } else if (i == ActivityStreamTabItemMyStatus) {
            item.title = Localize(@"My Status");
        }
        [item setNeedsDisplay];
    }
}

@end