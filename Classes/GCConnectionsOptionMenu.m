//
//  GCConnectionsOptionMenu.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/12/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCConnectionsOptionMenu.h"


@implementation GCConnectionsOptionMenu

@synthesize delegate;

- (id) initWithGame: (GCConnections *) _game {
	if (self = [super initWithStyle: UITableViewStyleGrouped]) {
		self.tableView.allowsSelection = NO;
		game = _game;
		size = game.size;
		misere = game.misere;
		circling = game.circling;
	}
	return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void) cancel {
	[delegate rulesPanelDidFinish];
}


- (void) done {
	game.size = size;
	game.misere = misere;
	game.circling = circling;
	[delegate rulesPanelDidFinish];
}

- (void) update: (UISegmentedControl *) sender{
	if(sender.tag == 1)
		size = ([sender selectedSegmentIndex] * 2) + 5;
	else if(sender.tag == 2)
		misere = [sender selectedSegmentIndex] == 0 ? NO : YES;
	else{
		circling = [sender selectedSegmentIndex] == 0 ? NO: YES;
		[self.tableView reloadData];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Connections Rules";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
																						  target: self
																						  action: @selector(cancel)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
																						   target: self
																						   action: @selector(done)];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (section == 0 ? @"Size" : (section == 1 ? @"Misère" : @"To Win"));
}


- (NSString *) tableView: (UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (section == 2 && circling) return @"Win by going across or forming a loop\nwith your pieces.";
	else if (section == 2) return @"Win by making a connection between\nopposite sides.";
	else return @"";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		cell.backgroundColor = [UIColor colorWithRed: 234.0/255 green: 234.0/255 blue: 255.0/255 alpha: 1];
    }
    
    // Set up the cell...
	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithFrame: CGRectMake(20, 10, 280, 26)];
	if(indexPath.section == 0){
		[segment insertSegmentWithTitle: @"3x3" atIndex: 0 animated: NO];
		[segment insertSegmentWithTitle: @"4x4" atIndex: 1 animated: NO];
		[segment insertSegmentWithTitle: @"5x5" atIndex: 2 animated: NO];
		[segment insertSegmentWithTitle: @"6x6" atIndex: 3 animated: NO];
		[segment setSelectedSegmentIndex: (size - 5) / 2];
		segment.tag = 1;
	}
	else if(indexPath.section == 1) {
		[segment insertSegmentWithTitle: @"Standard" atIndex: 0 animated: NO];
		[segment insertSegmentWithTitle: @"Misère" atIndex: 1 animated: NO];
		[segment setSelectedSegmentIndex: (misere ? 1 : 0)];
		segment.tag = 2;
	}
	else{
		[segment insertSegmentWithTitle: @"No Circling" atIndex: 0 animated: NO];
		[segment insertSegmentWithTitle: @"Circling" atIndex: 1 animated: NO];
		[segment setSelectedSegmentIndex: (circling ? 1 : 0)];
		segment.tag = 3;
	}
	segment.segmentedControlStyle = UISegmentedControlStyleBar;
	segment.tintColor = [UIColor colorWithRed: 28.0/255 green: 127.0/255 blue: 189.0/255 alpha: 1.0];
	
	[segment addTarget: self action: @selector(update:) forControlEvents: UIControlEventValueChanged];
	
	[cell addSubview: segment];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
}


- (void)dealloc {
    [super dealloc];
}


@end

