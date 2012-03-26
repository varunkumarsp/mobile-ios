//
//  GadgetButton.m
//  HKAF
//
//  Created by Tran Hoai Son on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GadgetButton.h"
#import "GadgetViewController.h"
#import "Gadget.h"

@implementation GadgetButton

- (id)initWithFrame:(CGRect)rect
{
	self = [super initWithFrame:rect];
	if(self)
	{
		_btnGadget = [[UIButton alloc] initWithFrame:CGRectMake(11, 5, 50, 50)];
		[_btnGadget addTarget:self action:@selector(onBtnGadget:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_btnGadget];
		_gadget = [[Gadget alloc] init];
		_lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 72, 42)];
		[_lbName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
		[_lbName setNumberOfLines:3];
		[_lbName setTextAlignment:UITextAlignmentCenter];
		[_lbName setBackgroundColor:[UIColor clearColor]];
		[self addSubview:_lbName];
	}
	return self;
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)setGadget:(Gadget*)gadget
{
	_gadget = gadget;
}

- (Gadget*)getGadget
{
	return _gadget;
}

- (void)setName:(NSString*)name
{
	_lbName.text = name;
}

- (void)setIcon:(UIImage*)icon
{
	_imgIcon = icon;
	[_btnGadget setBackgroundImage:_imgIcon forState:UIControlStateNormal];
}

- (void)setUrl:(NSURL*)url
{
	_url = url;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//	AudioServicesPlaySystemSound(1000);
//	AudioServicesPlaySystemSound(1105);
	
//	if(!_bTouched)
//	{
//		_bTouched = YES;
//		[self setBackgroundImage:[UIImage imageNamed:@"radioselected.png"] forState:UIControlStateNormal];
//		[_delegate changeLanguage:_languageId];
//	}
}

- (void)onBtnGadget:(id)sender
{
	[_delegate onGadgetButton:self];	
}
@end