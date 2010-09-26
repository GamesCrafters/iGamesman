//
//  GCTicTacToeOptionMenu.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 9/22/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCTicTacToeOptionMenu.h"


@implementation GCTicTacToeOptionMenu

@synthesize delegate;


#pragma mark -
#pragma mark Initialization

- (id) initWithGame: (GCTicTacToe *) _game {
	if (self = [super initWithStyle: UITableViewStyleGrouped]) {
		game = _game;
		
		rows = game.rows;
		cols = game.cols;
		inarow = game.inarow;
		misere = game.misere;
		
		self.tableView.allowsSelection = NO;
	}
	return self;
}

- (void) update: (UISegmentedControl *) sender {
	if (sender.tag == 100)
		cols = sender.selectedSegmentIndex + 3;
	if (sender.tag == 101)
		rows = sender.selectedSegmentIndex + 3;
	if (sender.tag == 102)
		inarow = sender.selectedSegmentIndex + 3;
	if (sender.tag == 103)
		misere = (sender.selectedSegmentIndex == 1);
}

- (void) cancel {
	[delegate rulesPanelDidFinish];
}


- (void) done {
	game.rows = rows;
	game.cols = cols;
	game.inarow = inarow;
	game.misere = misere;
	
	[game resetBoard];
	
	[delegate rulesPanelDidFinish];
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"TicTacToe Rules";
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
																						  target: self
																						  action: @selector(cancel)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
																						   target: self 
																						   action: @selector(done)];
}


#pragma mark -
#pragma mark Table view data source

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[NSArray arrayWithObjects: @"Width", @"Height", @"In-a-Row", @"Misère", nil] objectAtIndex: section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		cell.backgroundColor = [UIColor colorWithRed: 234.0/255 green: 234.0/255 blue: 255.0/255 alpha: 1];
    }

    // Configure the cell...
	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithFrame: CGRectMake(20, 10, 280, 26)];
	if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
		[segment insertSegmentWithTitle: @"3" atIndex: 0 animated: NO];
		[segment insertSegmentWithTitle: @"4" atIndex: 1 animated: NO];
		[segment insertSegmentWithTitle: @"5" atIndex: 2 animated: NO];
	} else {
		[segment insertSegmentWithTitle: @"Standard" atIndex: 0 animated: NO];
		[segment insertSegmentWithTitle: @"Misère" atIndex: 1 animated: NO];
	}
	
	int selected;
	if (indexPath.section == 0) selected = game.rows - 3;
	if (indexPath.section == 1) selected = game.cols - 3;
	if (indexPath.section == 2) selected = game.inarow - 3;
	if (indexPath.section == 3) selected = game.misere ? 1 : 0;
	[segment setSelectedSegmentIndex: selected];
	
	segment.segmentedControlStyle = UISegmentedControlStyleBar;
	segment.tintColor = [UIColor colorWithRed: 28.0/255 green: 127.0/255 blue: 189.0/255 alpha: 1.0];
	segment.tag = 100 + indexPath.section;
	[segment addTarget: self action: @selector(update:) forControlEvents: UIControlEventValueChanged];
	[cell addSubview: segment];
	[segment release];
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
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

