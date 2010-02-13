//
//  GCNameChangeController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 11/10/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCNameChangeController.h"


@implementation GCNameChangeController

@synthesize delegate, nameField, typePicker;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (id) initWithPlayerNumber: (NSInteger) num andGame: (GCGame *) _game {
	if (self = [super initWithNibName: @"NameChanger" bundle: nil]) {
		playerNum = num;
		game = _game;
	}
	return self;
}

- (void) cancel {
	[nameField resignFirstResponder];
	[delegate nameChangerDidCancel];
}

- (void) done {
	[nameField resignFirstResponder];
	BOOL human = (0 == [typePicker selectedRowInComponent: 0]);
	[delegate nameChangerDidFinishWithPlayer: playerNum 
									 newName: [nameField text]
							   andPlayerType: (human ? HUMAN : COMPUTER)];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Hides the keyboard when the user taps the keyboard's "Done" button
- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {
	[theTextField resignFirstResponder];
	return YES;
}

// Picker view delegate methods
- (NSString *) pickerView: (UIPickerView *) pickerView titleForRow: (NSInteger) row forComponent: (NSInteger) component {
	return [[NSArray arrayWithObjects: @"Human", @"Computer", nil] objectAtIndex: row];
}

// Picker view data source methods

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView {
	return 1;
}

- (NSInteger) pickerView: (UIPickerView *) pickerView numberOfRowsInComponent: (NSInteger) component {
	return 2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Change Name";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel 
																						  target: self 
																						  action: @selector(cancel)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
																						   target: self 
																						   action: @selector(done)];
	nameField.text = ((playerNum == 1) ? [game player1Name] : [game player2Name]);
	
	BOOL hum = (playerNum == 1) ? [game isPlayer1Human] : [game isPlayer2Human];
	[typePicker selectRow: (hum ? 0 : 1) inComponent: 0 animated: NO];
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
