//
//  GCNameChangeController.m
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/10/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCNameChangeController.h"


@implementation GCNameChangeController

@synthesize delegate, nameField;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (id) initWithPlayerNumber: (NSInteger) num {
	if (self = [super initWithNibName: @"NameChanger" bundle: nil]) {
		playerNum = num;
	}
	return self;
}

- (void) cancel {
	[nameField resignFirstResponder];
	[delegate nameChangerDidCancel];
}

- (void) done {
	[nameField resignFirstResponder];
	[delegate nameChangerDidFinishWithPlayer: playerNum andNewName: [nameField text]];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Change Name";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel 
																						  target: self 
																						  action: @selector(cancel)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
																						   target: self 
																						   action: @selector(done)];
	
	[nameField setPlaceholder: [NSString stringWithFormat: @"Player %d", playerNum]];
	[nameField becomeFirstResponder];
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
