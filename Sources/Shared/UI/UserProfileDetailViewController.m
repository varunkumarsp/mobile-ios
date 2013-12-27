//
//  UserProfileDetailViewController.m
//  eXo Platform
//
//  Created by Ta Minh Quan on 12/24/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "UserProfileDetailViewController.h"

#import "AvatarView.h"
#import "EmptyView.h"
#import "defines.h"

@interface UserProfileDetailViewController ()

@end

@implementation UserProfileDetailViewController
@synthesize userId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _lastActivityDescription.layer.borderColor = [[UIColor blackColor]CGColor];
        _lastActivityDescription.layer.borderWidth =0.5;
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Default text"];
        [attributeString addAttribute:NSUnderlineStyleAttributeName
                                value:[NSNumber numberWithInt:1]
                                range:(NSRange){0,[attributeString length]}];
        _emailLbl.attributedText = [attributeString copy];
        _phoneLbl.attributedText = [attributeString copy];
        _skypeLbl.attributedText = [attributeString copy];
        
        _emailLbl.userInteractionEnabled = YES;
        _phoneLbl.userInteractionEnabled = YES;
        _skypeLbl.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *emailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTab:)];
        [_emailLbl addGestureRecognizer:emailTap];
        
        UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTab:)];
        [_phoneLbl addGestureRecognizer:phoneTap];
        
        UITapGestureRecognizer *skypeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTab:)];
        [_skypeLbl addGestureRecognizer:skypeTap];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"User profile";
    self.view.backgroundColor = EXO_BACKGROUND_COLOR;
    [self emptyState];
    
    [self.view addSubview:self.hudLoadWaitingWithPositionUpdated.view];
    [self displayHudLoader];
    
    UserProfileProxy *proxy = [[UserProfileProxy alloc] init];
    proxy.delegate = self;
    if (userId) {
        [proxy getUserProfileFromUserId:userId];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    [_avatar release];
    [_fullNameLbl release];
    [_positionLbl release];
    [_emailLbl release];
    [_lastActivityDescription release];
    [_phoneLbl release];
    [_skypeLbl release];
    [_relationshipStatus release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - handle tab
-(void) handleTab : (UITapGestureRecognizer*)tapGestureRecognizer {

    UILabel *currentLabel = (UILabel *)tapGestureRecognizer.view;
    
    if (currentLabel == _skypeLbl) {
        NSURL *skypeURL = [NSURL URLWithString:[NSString stringWithFormat:@"skype://%@?call", _skypeLbl.text]];
        if ([[UIApplication sharedApplication] canOpenURL:skypeURL]) {
            [[UIApplication sharedApplication] openURL:skypeURL];
        } else {
            // Display to the user how to install skype.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Can not call this skype id" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    
    if (currentLabel == _emailLbl) {
        NSURL *mailURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", _emailLbl.text]];
        if ([[UIApplication sharedApplication] canOpenURL:mailURL]) {
            [[UIApplication sharedApplication] openURL:mailURL];
        } else {
            // Display to the user how to install skype.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Can not open this email" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    }
    
    if (currentLabel == _phoneLbl) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _phoneLbl.text]];
        if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
            [[UIApplication sharedApplication] openURL:phoneURL];
        } else {
            // Display to the user how to install skype.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Can not call this number" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
}

#pragma mark - UserProfileDelegate
-(void) UserProfileProxyDidFinish:(UserProfileProxy *)userProfileProxy
{
    _fullNameLbl.text = userProfileProxy.userProfile.fullName;
    
    [self setTextForLabel:_positionLbl value:userProfileProxy.userProfile.position];
    
    [self setTextForLabel:_relationshipStatus value:userProfileProxy.userProfile.relationshipStatus];
    
    if ([self isExist:userProfileProxy.userProfile.activityTitle]) {
        _lastActivityDescription.text = [NSString stringWithFormat:@"%@ said : %@",userProfileProxy.userProfile.fullName,userProfileProxy.userProfile.activityTitle ];
    } else {
        _lastActivityDescription.text = @"No activity";
    }
    
    [self setTextForLabel:_emailLbl value:userProfileProxy.userProfile.email];
    [self setTextForLabel:_skypeLbl value:userProfileProxy.userProfile.skype];
    [self setTextForLabel:_phoneLbl value:userProfileProxy.userProfile.phone];
    NSString *avatarUrl = [NSString stringWithFormat:@"http://int.exoplatform.org:80%@",userProfileProxy.userProfile.avatarURL];
    [_avatar setImageURL:[NSURL URLWithString:avatarUrl]];
    
    //Remove empty view from superview
    for (UIView *view in [self.view subviews]) {
        if (view.tag == TAG_EMPTY) {
            [view removeFromSuperview];
        }
    }
    
    [self hideLoader:YES];
}

-(void) UserProfileProxy:(UserProfileProxy *)userProfileProxy didFailWithError:(NSError *)error
{
    
}

#pragma mark - function
-(BOOL) isExist: (id) object {
    if (object == nil) {
        return NO;
    }
    else {
        return YES;
    }
}

-(void) setTextForLabel: (UILabel *) alabel value: (NSString *) text{
    if ([self isExist:text]) {
        alabel.text = text;
        if (alabel == _relationshipStatus ) {
            if ([alabel.text  isEqual: @"NoAction"]) {
                _relationshipTitleLbl.hidden = YES;
                _relationshipStatus.hidden = YES;
            }
            if ([alabel.text isEqual:@"alien"]) {
                _relationshipStatus.text = @"Not connect";
            }
            if ([alabel.text isEqual:@"confirmed"]) {
                _relationshipStatus.text = @"Connected";
            }
            
        }
    }
    else {
        alabel.hidden = YES;
        if (alabel == _phoneLbl) {
            _phoneTitleLbl.hidden = YES;
        }
        if (alabel == _relationshipStatus) {
            _relationshipTitleLbl.hidden = YES;
        }
        if (alabel == _skypeLbl) {
            _skypeTitleLbl.hidden = YES;
        }
    }
}

#pragma mark - Loader Management
- (void)updateHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

// Empty State
-(void)emptyState {
    //add empty view to the view
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForEmptyFolder.png" andContent:@"EmptyProfile"];
    emptyView.backgroundColor = EXO_BACKGROUND_COLOR;
    emptyView.tag = TAG_EMPTY;
    [self.view addSubview:emptyView];
    [emptyView release];
}

@end
