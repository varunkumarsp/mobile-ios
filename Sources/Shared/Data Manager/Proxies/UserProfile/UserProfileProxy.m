//
//  UserProfileProxy.m
//  eXo Platform
//
//  Created by Ta Minh Quan on 12/24/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "UserProfileProxy.h"

@implementation UserProfileProxy
@synthesize userProfile = _userProfile;
@synthesize delegate;

- (void) getUserProfileFromUserId:(NSString *)userId {
    // Load the object model via RestKit
    RKObjectManager* manager = [RKObjectManager sharedManager];
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[UserProfile class]];
    [mapping mapKeyPathsToAttributes:
     @"id",@"identity",
     @"profileUrl",@"profileUrl",
     @"avatarURL",@"avatarURL",
     @"activityTitle",@"activityTitle",
     @"fullName",@"fullName",
     @"position",@"position",
     @"relationshipType",@"relationshipStatus",
     
     nil];
    
    [manager loadObjectsAtResourcePath:[self createPathForUserId:userId] objectMapping:mapping delegate:self];
}

//Helper to create the path to get the ressources
- (NSString *)createPathForUserId:(NSString *)userId {
    
    return [NSString stringWithFormat:@"/private/social/people/getPeopleInfo/%@.json", userId ];
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"response code: %d", [response statusCode]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    if (delegate && [delegate respondsToSelector:@selector(UserProfileProxy:didFailWithError:)]) {
        [delegate UserProfileProxy:self didFailWithError:error];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    _userProfile = [objects objectAtIndex:0];
    if (delegate && [delegate respondsToSelector:@selector(UserProfileProxyDidFinish:)])  {
        [delegate UserProfileProxyDidFinish:self];
    }
}


@end
