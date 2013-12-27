//
//  ActivityStreamBrowseViewController_iPad.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 14/06/11.
//  Copyright 2011 eXo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityStreamBrowseViewController.h"
#import "eXoNavigationController.h"
#import "UserProfileDetailViewController_iPad.h"

@interface ActivityStreamBrowseViewController_iPad : ActivityStreamBrowseViewController<UserProfileDetailIpadDelegate> {
    
    //IBOutlet UINavigationBar*           _navigation;
    eXoNavigationController*         _modalNavigationProfileViewController;
}

@end
