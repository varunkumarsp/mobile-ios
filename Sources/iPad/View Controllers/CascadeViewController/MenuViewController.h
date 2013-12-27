//
//  MenuViewController.h
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "SettingsViewController_iPad.h"
#import "eXoNavigationController.h"
#import "UserProfileViewController.h"
#import "UserProfileDetailViewController_iPad.h"

#define EXO_ACTIVITY_STREAM_ROW 0
#define EXO_DOCUMENTS_ROW 1
#define EXO_DASHBOARD_ROW 2



@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SettingsDelegateProcotol,UserProfileDelegate,UserProfileDetailIpadDelegate> {
	
    
	UITableView*  _tableView;
	NSMutableArray* _cellContents;

    eXoNavigationController*         _modalNavigationSettingViewController;
    
	int									_intSelectedLanguage;

    int                             _intIndex;
    
    BOOL                            _isCompatibleWithSocial;
    
}
@property(nonatomic, retain)UITableView* tableView;
@property BOOL isCompatibleWithSocial;
@property (nonatomic, retain) UserProfileViewController *userProfileViewController;

- (id)initWithFrame:(CGRect)frame isCompatibleWithSocial:(BOOL)compatibleWithSocial;
- (void) updateLabelsWithNewLanguage;

@end
