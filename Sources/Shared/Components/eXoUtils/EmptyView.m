//
//  EmptyView.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EmptyView.h"


@implementation EmptyView

- (id)initWithFrame:(CGRect)frame withImageName:(NSString*)imageName andContent:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        // Initialization code
        //add empty image to the view
        imagename = imageName;
        UIImage *image = [UIImage imageNamed:imageName];
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(frame.size.width/2 - image.size.width/2, frame.size.height/2 - image.size.height/2 - 20, image.size.width, image.size.height);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:imageView];
        
        
        distance = 0;
        if([imageName isEqualToString:@"IconForEmptyFolder.png"]){
            distance = 80;
        } else if([imageName isEqualToString:@"IconForNoActivities.png"]){
            distance = 110;
        } else if([imageName isEqualToString:@"IconForNoContact.png"]){
            distance = 120;
        } else if([imageName isEqualToString:@"IconForNoGadgets.png"]){
            distance = 110;
        } else if([imageName isEqualToString:@"IconForUnreadableFile.png"]){
            distance = 110;
        }
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2 - image.size.height/2 + distance, frame.size.width, 40)];
        label.backgroundColor = [UIColor clearColor];//
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:112./255 green:112./255 blue:112./255 alpha:1.];
        label.numberOfLines = 2;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        label.text = content;
        label.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:label];
        
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)changeOrientation{
    UIImage *image = [UIImage imageNamed:imagename];
    imageView.frame = CGRectMake(self.frame.size.width/2 - image.size.width/2, self.frame.size.height/2 - image.size.height/2 - 20, image.size.width, image.size.height);
    label.frame = CGRectMake(0, self.frame.size.height/2 - image.size.height/2 + distance, self.frame.size.width, 40);
}

- (void)dealloc
{
    [super dealloc];
    [label release];
    [imageView release];
}

@end