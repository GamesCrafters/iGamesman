//
//  GCGameOptionsController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/30/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCGameOptionsController.h"


@implementation GCGameOptionsController

@synthesize delegate;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void) done {
	UISwitch *s1 = (UISwitch *) [self.tableView viewWithTag: 1];
	UISwitch *s2 = (UISwitch *) [self.tableView viewWithTag: 2];
	[delegate optionPanelDidFinish: self predictions: s1.on	moveValues: s2.on];
}


- (void) cancel {
	[delegate optionPanelDidCancel: self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Options";
	self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel 
																						   target: self 
																						   action: @selector(cancel)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone 
																						   target: self 
																						   action: @selector(done)];
}

/*
- (void)viewWillAppear:(BOOL)animated { [super viewWillAppear:animated]; }
- (void)viewDidAppear:(BOOL)animated { [super viewDidAppear:animated]; }
- (void)viewWillDisappear:(BOOL)animated { [super viewWillDisappear:animated]; }
- (void)viewDidDisappear:(BOOL)animated { [super viewDidDisappear:animated]; }
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell
	BOOL switchOn;
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Show Predictions";
		switchOn = [delegate showingPredictions];
	}
	if (indexPath.row == 1) {
		cell.textLabel.text = @"Show Move Values";
		switchOn = [delegate showingMoveValues];
	}
	CGRect switchFrame = CGRectMake(200.0, 9.0, 95.0, 20.0);
	UISwitch *pSwitch = [[UISwitch alloc] initWithFrame: switchFrame];
	pSwitch.on = switchOn;
	pSwitch.tag = indexPath.row + 1;
	[cell addSubview: pSwitch];
	[pSwitch release];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}


- (void)dealloc {
    [super dealloc];
}


@end

