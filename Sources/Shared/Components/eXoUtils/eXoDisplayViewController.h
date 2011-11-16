//
//  eXoDisplayViewController.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "eXoViewController.h"
#import "LanguageHelper.h"

@interface eXoDisplayViewController : eXoViewController<UIWebViewDelegate, UIScrollViewDelegate>
{
    BOOL fullscreen;
    UIWebView*	_webView;	
	NSURL* _url;
    NSString *_fileName;
    ATMHud* _hudView;
    CGRect rect;
    UINavigationController *navigationBar;
}

@property (nonatomic, retain) IBOutlet NSURL* _url;
@property (nonatomic, retain) IBOutlet UIWebView* _webView;

- (void)setUrl:(NSURL*)url;	//Set gadget URL

- (void)setHudPosition;

@end
