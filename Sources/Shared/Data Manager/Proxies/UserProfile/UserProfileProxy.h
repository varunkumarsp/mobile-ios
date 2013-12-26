//
//  UserProfileProxy.h
//  eXo Platform
//
//  Created by Ta Minh Quan on 12/24/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "UserProfile.h"

@protocol UserProfileProxyDelegate;

@interface UserProfileProxy : NSObject<RKObjectLoaderDelegate> {
    UserProfile *_userProfile;
}
@property (nonatomic, retain) UserProfile* userProfile;
@property (nonatomic, assign) id<UserProfileProxyDelegate> delegate;
- (void) getUserProfileFromUserId:(NSString *)userId;
@end

@protocol UserProfileProxyDelegate <NSObject>

-(void) UserProfileProxyDidFinish:(UserProfileProxy *) userProfileProxy;
-(void) UserProfileProxy:(UserProfileProxy *) userProfileProxy didFailWithError:(NSError *) error;


@end