//
//  GCConnectFourOptionMenu.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/31/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCConnectFourOptionMenu.h"


@implementation GCConnectFourOptionMenu

@synthesize delegate;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (id) initWithGame: (GCConnectFour *) _game {
	if (self = [super initWithStyle: UITableViewStyleGrouped]) {
		self.tableView.allowsSelection = NO;
		
		game = _game;
		width  = game.width;
		height = game.height;
		pieces = game.pieces;
		misere = [game isMisere];
		
		headings = [[NSArray alloc] initWithObjects: @"Width", @"Height", @"In-a-Row", @"Misère", nil];
	}
	return self;
}


- (void) cancel {
	[delegate rulesPanelDidCancel];
}


- (void) done {
	game.width  = width;
	game.height = height;
	game.pieces = pieces;
	game.misere = misere;
	
	[game resetBoard];
	
	[delegate rulesPanelDidFinish];
}


- (void) update: (UISegmentedControl *) sender {
	int tag = sender.tag;
	if (tag == 1) width = [sender selectedSegmentIndex] + 4;
	else if (tag == 2) height = [sender selectedSegmentIndex] + 4;
	else if (tag == 3) pieces = [sender selectedSegmentIndex] + 3;
	else misere = [sender selectedSegmentIndex] == 0 ? NO : YES;
	
	if (width == game.width && height == game.height && pieces == game.pieces && misere == game.misere)
		self.navigationItem.rightBarButtonItem.enabled = NO;
	else
		self.navigationItem.rightBarButtonItem.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Connect-4 Rules";
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
																						  target: self
																						  action: @selector(cancel)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
																						   target: self 
																						   action: @selector(done)];
	self.navigationItem.rightBarButtonItem.enabled = NO;
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [headings objectAtIndex: section];
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
	if (indexPath.section == 3) {
		[segment insertSegmentWithTitle: @"Standard" atIndex: 0 animated: NO];
		[segment insertSegmentWithTitle: @"Misère" atIndex: 1 animated: NO];
	} else if (indexPath.section == 2) {
		[segment insertSegmentWithTitle: @"3" atIndex: 0 animated: NO];
		[segment insertSegmentWithTitle: @"4" atIndex: 1 animated: NO];
		[segment insertSegmentWithTitle: @"5" atIndex: 2 animated: NO];
	} else {
		[segment insertSegmentWithTitle: @"4" atIndex: 0 animated: NO];
		[segment insertSegmentWithTitle: @"5" atIndex: 1 animated: NO];
		[segment insertSegmentWithTitle: @"6" atIndex: 2 animated: NO];
	}
	if (indexPath.section == 0)
		[segment insertSegmentWithTitle: @"7" atIndex: 3 animated: NO];
	
	int selected;
	if (indexPath.section == 0) selected = width - 4;
	else if (indexPath.section == 1) selected = height - 4;
	else if (indexPath.section == 2) selected = pieces - 3;
	else selected = [game isMisere] ? 1 : 0;
	[segment setSelectedSegmentIndex: selected];
	
	segment.segmentedControlStyle = UISegmentedControlStyleBar;
	segment.tintColor = [UIColor colorWithRed: 28.0/255 green: 127.0/255 blue: 189.0/255 alpha: 1.0];
	segment.tag = indexPath.section + 1;
	[segment addTarget: self action: @selector(update:) forControlEvents: UIControlEventValueChanged];
	[cell addSubview: segment];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)dealloc {
    [super dealloc];
}


@end

