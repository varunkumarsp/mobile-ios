//
//  ActivityLinkDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityLinkDetailMessageTableViewCell.h"
#import "SocialActivityDetails.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "EGOImageView.h"
#import "ActivityHelper.h"
#import "LanguageHelper.h"

#define WIDTH_FOR_CONTENT_IPHONE 237
#define WIDTH_FOR_CONTENT_IPAD 409

@implementation ActivityLinkDetailMessageTableViewCell

@synthesize htmlLinkTitle = _htmlLinkTitle;
@synthesize htmlLinkMessage = _htmlLinkMessage;
@synthesize htmlActivityMessage = _htmlActivityMessage;

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
    CGRect tmpFrame = CGRectZero;
    
    if (fWidth > 320) {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPHONE, 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
        
    //_webViewComment.contentMode = UIViewContentModeScaleAspectFit;
    [[_webViewComment.subviews objectAtIndex:0] setScrollEnabled:NO];
    [_webViewComment setBackgroundColor:[UIColor clearColor]];
    UIScrollView *scrollView = (UIScrollView *)[[_webViewComment subviews] objectAtIndex:0];
    scrollView.bounces = NO;
    [scrollView flashScrollIndicators];
    _webViewComment.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypeAddress;

    [_webViewComment setOpaque:NO];
}

#define kFontForLink [UIFont fontWithName:@"Helvetica" size:15]
- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    NSString *type = [socialActivityDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityDetail.activityStream valueForKey:@"fullName"];
    }
    NSString *title = [NSString stringWithFormat:@"%@%@", [socialActivityDetail.posterIdentity.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
    CGSize theSize = [title sizeWithFont:kFontForTitle constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                           lineBreakMode:UILineBreakModeWordWrap];
    CGRect rect = _lbName.frame;
    rect.size.height = theSize.height + 5;
    _lbName.frame = rect;
    
    //Set the UserName of the activity
    _lbName.text = title;
    
    // comment
    [_webViewForContent loadHTMLString:
     [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><body>%@</body></html>", [_templateParams valueForKey:@"comment"]?[_templateParams valueForKey:@"comment"]:@""] 
                               baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
     ];
    
    // Content
    [_webViewComment loadHTMLString:
     [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} p{color: #115EAD; text-decoration: none; font-weight: bold;}</style></head><body><a href=\"%@\">%@</a></br>%@Source : %@</body></html>",[_templateParams valueForKey:@"link"],[_templateParams valueForKey:@"title"],(![[[_templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText] isEqualToString:@""])?[NSString stringWithFormat:@"%@</br>", [[_templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText]]:@"",  [_templateParams valueForKey:@"link"]] 
                            baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
     ];
    
    NSString *textWithoutHtml = [[_templateParams valueForKey:@"comment"] stringByConvertingHTMLToPlainText];
    theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    
    rect = _webViewForContent.frame;
    rect.origin.y =  _lbName.frame.size.height + _lbName.frame.origin.y;
    rect.size.height =  theSize.height + 5;
    
    _webViewForContent.frame = rect;
    NSURL *url = [NSURL URLWithString:[_templateParams valueForKey:@"image"]];
    if (url && url.host && url.scheme){
        rect = self.imgvAttach.frame;
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"DocumentIconForUnknown.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[[_templateParams valueForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        rect.origin.y = _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y + 5;
        rect.origin.x = (width > 320)? (width/3 + 100) : (width/3 + 50);
        self.imgvAttach.frame = rect;
        
        rect = _webViewComment.frame;
        rect.origin.y = self.imgvAttach.frame.size.height + self.imgvAttach.frame.origin.y + 5;
    } else {
        rect = _webViewComment.frame;
        rect.origin.y = _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y;
    }
    
    textWithoutHtml = [[_templateParams valueForKey:@"title"] stringByConvertingHTMLToPlainText];
    theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    rect.size.height = theSize.height;
    //
    textWithoutHtml = [[_templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText];
    theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                              lineBreakMode:UILineBreakModeWordWrap];
    rect.size.height += theSize.height;
    
    textWithoutHtml = [NSString stringWithFormat:@"Source : %@",[[_templateParams valueForKey:@"link"] stringByConvertingHTMLToPlainText]];
    theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                              lineBreakMode:UILineBreakModeWordWrap];
    rect.size.height += theSize.height + 5;
    
    _webViewComment.frame = rect;
    
    [_webViewForContent sizeToFit];
    [_webViewComment sizeToFit];
}

- (void)dealloc {
    [_htmlLinkMessage release];
    _htmlLinkMessage = nil;
    
    [_htmlLinkTitle release];
    _htmlLinkTitle = nil;
    
    _webViewComment = nil;
    
    [super dealloc];
}


@end