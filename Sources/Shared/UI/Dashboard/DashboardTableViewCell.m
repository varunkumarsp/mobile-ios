//
//  DashboardTableViewCell.m
//  eXo Platform
//
//  Created by Mai Gia on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DashboardTableViewCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>


@implementation DashboardTableViewCell

@synthesize _lbName, _lbDescription, _imgvIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)dealloc
{
//    [_lbName release];
//    _lbName = nil;
//    
//    [_lbDescription release];
//    _lbDescription = nil;
//
//    [_imgvIcon release];
//    _imgvIcon = nil;
//    
//    [_ttLabelDescription release];
//    _ttLabelDescription = nil;
    
    [super dealloc];
}


#pragma mark - Activity Cell methods 

- (void)customizeAvatarDecorations {
    //Add the CornerRadius
    [[_imgvIcon layer] setCornerRadius:6.0];
    [[_imgvIcon layer] setMasksToBounds:YES];
    
    //Add the border
    [[_imgvIcon layer] setBorderColor:[UIColor colorWithRed:113./255 green:113./255 blue:113./255 alpha:1.].CGColor];
    CGFloat borderWidth = 1.0;
    [[_imgvIcon layer] setBorderWidth:borderWidth];
    
    //Add the inner shadow
    CALayer *innerShadowLayer = [CALayer layer];
    innerShadowLayer.contents = (id)[UIImage imageNamed: @"ActivityAvatarShadow.png"].CGImage;
    innerShadowLayer.contentsCenter = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    innerShadowLayer.frame = CGRectMake(borderWidth,borderWidth,_imgvIcon.frame.size.width-2*borderWidth, _imgvIcon.frame.size.height-2*borderWidth);
    [_imgvIcon.layer addSublayer:innerShadowLayer];
}

- (void)configureCell:(NSString*)name description:(NSString*)description icon:(NSString*)iconURL {
    
    [self customizeAvatarDecorations];
    
    _lbDescription.backgroundColor = [UIColor clearColor];
    
    _lbName.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    _lbName.textColor = [UIColor colorWithRed:106.0/255 green:109.0/255 blue:112.0/255 alpha:1];
    _lbName.backgroundColor = [UIColor clearColor];
    
    
    _ttLabelDescription = [[[TTStyledTextLabel alloc] initWithFrame:_lbDescription.frame] autorelease];
    _ttLabelDescription.userInteractionEnabled = NO;
    _ttLabelDescription.autoresizesSubviews = YES;
    _ttLabelDescription.backgroundColor = [UIColor clearColor];
    _ttLabelDescription.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    _ttLabelDescription.textColor = [UIColor colorWithRed:152.0/255 green:155.0/255 blue:160.0/255 alpha:1];
    
    _ttLabelDescription.autoresizingMask = UIViewAutoresizingFlexibleHeight | 
                                                UIViewAutoresizingFlexibleWidth;
    _ttLabelDescription.autoresizesSubviews = YES;
    
    [self.contentView addSubview:_ttLabelDescription];
    
 
    _lbName.text = name;
    _ttLabelDescription.html = description;
    _imgvIcon.imageURL = [NSURL URLWithString:iconURL];
    
}


@end