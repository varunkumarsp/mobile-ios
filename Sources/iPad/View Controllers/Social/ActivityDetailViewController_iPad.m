//
//  ActivityDetailViewController_iPad.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailViewController_iPad.h"
#import "MessageComposerViewController_iPad.h"
#import "SocialActivityStream.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "ActivityLinkDisplayViewController_iPad.h"
#import "defines.h"

@implementation ActivityDetailViewController_iPad

- (void)onBtnMessageComposer
{
    
    MessageComposerViewController_iPad* messageComposerViewController = [[MessageComposerViewController_iPad alloc] initWithNibName:@"MessageComposerViewController_iPad" bundle:nil];
     
    messageComposerViewController.delegate = self;    
    messageComposerViewController.tblvActivityDetail = _tblvActivityDetail;
    messageComposerViewController.isPostMessage = NO;
    messageComposerViewController.strActivityID = _socialActivityStream.activityId;
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    [messageComposerViewController release];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [[AppDelegate_iPad instance].rootViewController.menuViewController presentModalViewController:navController animated:YES];
    
    int x, y;
    
    if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || 
       [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown )
    {
        x = 114;
        y = 300;
    }
    else 
    {
        x = 242;
        y = 70;
    }
    
    navController.view.superview.autoresizingMask = UIViewAutoresizingNone;
    navController.view.superview.frame = CGRectMake(x,y, 540.0f, 265.0f);    
}


- (void)setHudPosition {
    _hudActivityDetails.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}


#pragma mark - UIWebViewDelegateMethod 
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //CAPTURE USER LINK-CLICK.
    NSURL *url = [request URL];
    
    
    if (!([[url absoluteString] isEqualToString:[NSString stringWithFormat:@"%@/",[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]])) {
        
        
        ActivityLinkDisplayViewController_iPad* linkWebViewController = [[ActivityLinkDisplayViewController_iPad alloc] initWithNibAndUrl:@"ActivityLinkDisplayViewController_iPad"
                                                                                                                           bundle:nil 
                                                                                                                              url:url];
		
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:linkWebViewController invokeByController:self isStackStartView:FALSE];
        
        [linkWebViewController release];
                
        return NO;
    }
    
    
    return YES;   
}



@end
