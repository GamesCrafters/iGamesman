//
//  GCYOptionMenu.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCYOptionMenu.h"


@implementation GCYOptionMenu

@synthesize delegate;

- (id) initWithGame: (GCYGame *) _game {
	if (self = [super initWithStyle: UITableViewStyleGrouped]) {
		game = _game;
		layers = game.layers;
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
	game.layers = layers;
	[delegate rulesPanelDidFinish];
}

- (void) update: (UISegmentedControl *) sender{
	layers = [sender selectedSegmentIndex];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Y Rules";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Extra Layers";
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
    [segment insertSegmentWithTitle: @"0" atIndex: 0 animated: NO];
	[segment insertSegmentWithTitle: @"1" atIndex: 1 animated: NO];
	[segment insertSegmentWithTitle: @"2" atIndex: 2 animated: NO];
	
	[segment setSelectedSegmentIndex: layers];
	
	segment.segmentedControlStyle = UISegmentedControlStyleBar;
	segment.tintColor = [UIColor colorWithRed: 28.0/255 green: 127.0/255 blue: 189.0/255 alpha: 1.0];
	
	[segment addTarget: self action: @selector(update:) forControlEvents: UIControlEventValueChanged];
	
	[cell addSubview: segment];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}


- (void)dealloc {
    [super dealloc];
}


@end

