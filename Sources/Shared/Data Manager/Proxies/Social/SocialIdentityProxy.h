//
//  SocialIdentityProxy.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SocialIdentity.h"



@interface SocialIdentityProxy : NSObject<RKObjectLoaderDelegate> {
 
    SocialIdentity* _socialIdentity;
    
}

- (void)getIdentityFromUser;

@end