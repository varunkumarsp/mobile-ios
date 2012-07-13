//
//  SettingsViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginProxy.h"
#import "PlatformServerVersion.h"
#import "eXoTableViewController.h"
@class ServerManagerViewController;


@protocol SettingsDelegateProcotol

-(void)doneWithSettings;

@end

@interface SettingsViewController : eXoTableViewController <LoginProxyDelegate>{
    
    BOOL                            bRememberMe;
	BOOL                            bAutoLogin;
    BOOL                            bVersionServer;
	NSString*                       languageStr;
	
	UISwitch*                       rememberMe;
	UISwitch*                       autoLogin;
	
    ServerManagerViewController*    _serverManagerViewController;
    
    id<SettingsDelegateProcotol>    _settingsDelegate;
    
}

@property (assign) id<SettingsDelegateProcotol>    settingsDelegate;


-(void)startRetrieve;
-(void)loadSettingsInformations;
-(void)saveSettingsInformations;
-(void)reloadSettingsWithUpdate;


@end
