//
//  ActivityLikersViewController.h
//  eXo Platform
//
//  Created by Le Thanh Quang on 5/23/12.
//  Copyright (c) 2012 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SocialProxy.h"
@protocol ActivityLikersDelegate;

@class SocialActivity;

@interface ActivityLikersViewController : UIViewController <SocialProxyDelegate>

@property (nonatomic, retain) SocialActivity *socialActivity;
@property (nonatomic, retain) UILabel *likersHeader;
@property (nonatomic, assign) id<ActivityLikersDelegate> delegate;

- (void)updateLikerViews;
- (void)updateListOfLikers;
-(void) showDetailUserProfile:(NSString *)userId;

@end

@protocol ActivityLikersDelegate <NSObject>

-(void) showDetailUserProfileFromLikerView :(NSString *) userId;

@end
