//
//  UserProfile.m
//  eXo Platform
//
//  Created by Ta Minh Quan on 12/24/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

@synthesize identity = _identity;
@synthesize profileUrl = _profileUrl;
@synthesize avatarURL = _avatarURL;
@synthesize activityTitle = _activityTitle;

@synthesize fullName = _fullName;
@synthesize position = _position;
@synthesize relationshipStatus = _relationshipStatus;
@synthesize phone = _phone;
@synthesize email = _email;
@synthesize skype = _skype;

-(void) dealloc {
    [_identity release];
    [_profileUrl release];
    [_avatarURL release];
    [_activityTitle release];
    
    [_fullName release];
    [_position release];
    [_relationshipStatus release];
    [_phone release];
    [_skype release];
    [_email release];
    [super dealloc];
}

@end
