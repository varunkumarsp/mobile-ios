//
//  UserProfile.h
//  eXo Platform
//
//  Created by Ta Minh Quan on 12/24/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject {
    NSString *_identity;
    NSString *_profileUrl;
    NSString *_avatarURL;
    NSString *_activityTitle;
    
    NSString *_fullName;
    NSString *_position;
    NSString *_relationshipStatus;
    NSString *_phone;
    NSString *_skype;
    NSString *_email;
}

@property (nonatomic, retain) NSString* identity;
@property (nonatomic, retain) NSString* profileUrl;
@property (nonatomic, retain) NSString* avatarURL;
@property (nonatomic, retain) NSString* activityTitle;
@property (nonatomic, retain) NSString* fullName;
@property (nonatomic, retain) NSString* position;
@property (nonatomic, retain) NSString* relationshipStatus;
@property (nonatomic, retain) NSString* phone;
@property (nonatomic, retain) NSString* skype;
@property (nonatomic, retain) NSString* email;



@end
