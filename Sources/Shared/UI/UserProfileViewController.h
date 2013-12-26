//
//  UserProfileViewController.h
//  eXo Platform
//
//  Created by exoplatform on 6/27/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocialUserProfile;
@class AvatarView;
@protocol UserProfileDelegate;


@interface UserProfileViewController : UIViewController {
    CGRect _viewFrame;
}

@property (nonatomic, retain) SocialUserProfile *userProfile;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) AvatarView *avatarView;
@property (nonatomic, retain) UILabel *fullNameLabel;
@property (nonatomic, assign) id<UserProfileDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)startUpdateCurrentUserProfile;

@end

@protocol UserProfileDelegate <NSObject>

-(void) showUserProfileDetailWithUserId : (NSString *) userId;

@end