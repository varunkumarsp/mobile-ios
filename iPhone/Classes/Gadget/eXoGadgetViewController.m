//
//  eXoGadgetViewController.m
//  eXoMobile
//
//  Created by Mai Thanh Xuyen on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "eXoGadgetViewController.h"
#import "Gadget_iPhone.h"
#import "eXoApplicationsViewController.h"
#import "eXoWebViewController.h"
#import "GadgetDisplayViewController.h"

@implementation eXoGadgetViewController


#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style delegate:(eXoApplicationsViewController *)delegate 
						gadgetTab:(GateInDbItem_iPhone *)gagetTab {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		
		_delegate = delegate;
		_gadgetTab = gagetTab;
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = _gadgetTab._strDbItemName;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_gadgetTab._arrGadgetsInItem count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		//Configure the cell
#define TAG_FOR_TITLE_LABEL 97
#define TAG_FOR_DESCRIPTION_LABEL 98
#define TAG_FOR_IMGVIEW_LABEL 99
		
		//Add the title label
		UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 5.0, 210.0, 20.0)];
		titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
		titleLabel.tag = TAG_FOR_TITLE_LABEL;
		[cell addSubview:titleLabel];	
		
		//Add the description label
		UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 23.0, 210.0, 33.0)];
		descriptionLabel.numberOfLines = 2;
		descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		descriptionLabel.tag = TAG_FOR_DESCRIPTION_LABEL;
		[cell addSubview:descriptionLabel];
		
		//Add the imageview
		UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 50, 50)];
		imgView.tag = TAG_FOR_IMGVIEW_LABEL;
		[cell addSubview:imgView];

    } 

    
	Gadget_iPhone *gadget = [_gadgetTab._arrGadgetsInItem objectAtIndex:indexPath.row];
  
	//Add values...
	UILabel* titleLabel = (UILabel *)[cell viewWithTag:TAG_FOR_TITLE_LABEL];
	titleLabel.text = gadget._strName;

	UILabel* descriptionLabel = (UILabel *)[cell viewWithTag:TAG_FOR_DESCRIPTION_LABEL];
	descriptionLabel.text = gadget._strDescription;
	
	UIImageView* imgView = (UIImageView *)[cell viewWithTag:TAG_FOR_IMGVIEW_LABEL];
	imgView.image = gadget._imgIcon;			
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	Gadget_iPhone *gadget = [_gadgetTab._arrGadgetsInItem objectAtIndex:indexPath.row];
	NSURL *tmpURL = gadget._urlContent;
	
	if (_gadgetDisplayViewController == nil) 
	{
		_gadgetDisplayViewController = [[GadgetDisplayViewController alloc] initWithNibAndUrl:@"GadgetDisplayViewController" bundle:nil url:tmpURL];
	}
	
	[_gadgetDisplayViewController setUrl:tmpURL];
	if ([self.navigationController.viewControllers containsObject:_gadgetDisplayViewController]) 
	{
		[self.navigationController popToViewController:_gadgetDisplayViewController animated:YES];
	}
	else 
	{
		[self.navigationController pushViewController:_gadgetDisplayViewController animated:YES];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
