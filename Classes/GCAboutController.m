//
//  GCAboutController.m
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/24/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCAboutController.h"
#import "GCCreditsController.h"


@implementation GCAboutController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"About";
		self.navigationItem.title = @"About Gamesman";
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Back"
																			 style: UIBarButtonItemStyleBordered
																			target: nil 
																			action: nil];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Credits" 
																			  style: UIBarButtonItemStyleDone 
																			 target: self 
																			 action: @selector(showCredits)];
}


- (void) showCredits {
	GCCreditsController *credits = [[GCCreditsController alloc] initWithStyle: UITableViewStyleGrouped];
	[self.navigationController pushViewController: credits animated: YES];
	[credits release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
