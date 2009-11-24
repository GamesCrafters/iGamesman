//
//  GCConnectFourOptionMenu.m
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/18/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCConnectFourOptionMenu.h"


@implementation GCConnectFourOptionMenu


- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		self.title = @"Connect-4 Rules";
		self.tableView.allowsSelection = NO;
		
		NSArray *keys = [NSArray arrayWithObjects: @"Width", @"Height", nil];
		NSArray *objs = [NSArray arrayWithObjects: [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 5], nil];
		currentlySelectedOptions = [[NSMutableDictionary alloc] initWithObjects: objs forKeys: keys];
	}
    return self;
}


- (int) getWidth {
	return [[currentlySelectedOptions objectForKey: @"Width"] intValue];
}


- (int) getHeight {
	return [[currentlySelectedOptions objectForKey: @"Height"] intValue];
}


- (void) setDelegate: (id <GCRulesDelegate>) del {
	delegate = del;
}


- (id <GCRulesDelegate>) delegate {
	return delegate;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone 
																						   target: self 
																						   action: @selector(done)];
}

- (void) done {
	[delegate rulesPanelDidFinish];
}

- (void) update: (UISegmentedControl *) sender {
	if (sender.tag == 1) 
		[currentlySelectedOptions setObject: [NSNumber numberWithInt: [sender selectedSegmentIndex] + 4] 
									 forKey: @"Width"];
	else
		[currentlySelectedOptions setObject: [NSNumber numberWithInt: [sender selectedSegmentIndex] + 4]
									 forKey: @"Height"];
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
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (section == 0) ? @"Width" : @"Height";
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithFrame: CGRectMake(20, 10, 280, 26)];
	[segment insertSegmentWithTitle: @"4" atIndex: 0 animated: NO];
	[segment insertSegmentWithTitle: @"5" atIndex: 1 animated: NO];
	[segment insertSegmentWithTitle: @"6" atIndex: 2 animated: NO];
	if (indexPath.section == 0)
		[segment insertSegmentWithTitle: @"7" atIndex: 3 animated: NO];
	int selected = [[currentlySelectedOptions objectForKey: [self tableView: tableView titleForHeaderInSection: indexPath.section]] intValue];
	[segment setSelectedSegmentIndex: selected - 4];
	segment.segmentedControlStyle = UISegmentedControlStyleBar;
	segment.tag = (indexPath.section == 0) ? 1 : 2;
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

