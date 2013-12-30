//
//  UserProfileDetailViewController_iPad.h
//  eXo Platform
//
//  Created by Ta Minh Quan on 12/27/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "UserProfileDetailViewController.h"

@protocol UserProfileDetailIpadDelegate;

@interface UserProfileDetailViewController_iPad : UserProfileDetailViewController

@property (nonatomic, assign) id<UserProfileDetailIpadDelegate> delegate;
@property (nonatomic, assign) UIViewController *invoker;
@property (nonatomic) BOOL isMenu;

@end

@protocol UserProfileDetailIpadDelegate <NSObject>
@required
-(void) exitProfileView;

@end
