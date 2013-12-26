//
//  UserProfileDetailViewController.h
//  eXo Platform
//
//  Created by Ta Minh Quan on 12/24/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoViewController.h"
#import "UserProfileProxy.h"

@class AvatarView;

@interface UserProfileDetailViewController : eXoViewController<UserProfileProxyDelegate> {
    IBOutlet AvatarView *_avatar;
    IBOutlet UILabel *_fullNameLbl;
    IBOutlet UILabel *_positionLbl;
    IBOutlet UILabel *_emailLbl;
    IBOutlet UILabel *_lastActivityDescription;
    IBOutlet UILabel *_phoneLbl;
    IBOutlet UILabel *_skypeLbl;
    IBOutlet UILabel *_relationshipStatus;
    IBOutlet UILabel *_relationshipTitleLbl;
    IBOutlet UILabel *_phoneTitleLbl;
    IBOutlet UILabel *_skypeTitleLbl;
    
}

@property (nonatomic,retain) NSString *userId;

@end
