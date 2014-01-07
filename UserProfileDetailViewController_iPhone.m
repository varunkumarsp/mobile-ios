//
//  UserProfileDetailViewController_iPhone.m
//  eXo Platform
//
//  Created by Ta Minh Quan on 12/24/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "UserProfileDetailViewController_iPhone.h"
#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"
#import "AppDelegate_iPhone.h"
#import "ActivityLinkDisplayViewController_iPhone.h"

@interface UserProfileDetailViewController_iPhone ()

@end

@implementation UserProfileDetailViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.title = self.title;
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationItem.rightBarButtonItem = nil;
    _lastActivityTitle = [[RTLabel alloc] initWithFrame:CGRectMake(30, 143, 280, 110 )];
    _lastActivityTitle.delegate = self;
    [self.view addSubview:_lastActivityTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
    self.hudLoadWaiting.center = self.view.center;
}

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
	ActivityLinkDisplayViewController_iPhone* linkWebViewController = [[[ActivityLinkDisplayViewController_iPhone alloc]
                                                                        initWithNibAndUrl:@"ActivityLinkDisplayViewController_iPhone"
                                                                        bundle:nil
                                                                        url:url] autorelease];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone pushViewController:linkWebViewController animated:YES];
}

-(void) UserProfileProxyDidFinish:(UserProfileProxy *)userProfileProxy
{
    [super UserProfileProxyDidFinish:userProfileProxy];
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationTitle:self.title];
}

@end
