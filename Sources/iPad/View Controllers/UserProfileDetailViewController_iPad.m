//
//  UserProfileDetailViewController_iPad.m
//  eXo Platform
//
//  Created by Ta Minh Quan on 12/27/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "UserProfileDetailViewController_iPad.h"
#import "LanguageHelper.h"
#import "ActivityLinkDisplayViewController_iPad.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "ExoStackScrollViewController.h"

@interface UserProfileDetailViewController_iPad ()

@end

@implementation UserProfileDetailViewController_iPad
@synthesize delegate;
@synthesize isMenu;
@synthesize invoker;

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
    _navigation.topItem.title = self.title;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    //Add the Done button for exit Settings
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Localize(@"DoneButton") style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    _lastActivityTitle = [[RTLabel alloc] initWithFrame:CGRectMake(20, 278, 250, 205)];
    _lastActivityTitle.delegate = self;
    [self.view addSubview:_lastActivityTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    [invoker release];
    [super dealloc];
}

- (void)updateHudPosition {
    self.hudLoadWaiting.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}

- (void)doneAction {
    if (delegate && [delegate respondsToSelector:@selector(exitProfileView)]) {
        [delegate exitProfileView];
    }
}

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    [self doneAction];
	ActivityLinkDisplayViewController_iPad* linkWebViewController = [[[ActivityLinkDisplayViewController_iPad alloc]
                                                                     initWithNibAndUrl:@"ActivityLinkDisplayViewController_iPad"
                                                                     bundle:nil
                                                                     url:url] autorelease];
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:linkWebViewController invokeByController:invoker isStackStartView:isMenu];
    
    
}



@end
