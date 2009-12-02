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
		
		headings = [[NSArray alloc] initWithObjects: @"Width", @"Height", @"Pieces", nil];
		NSArray *objs = [NSArray arrayWithObjects: [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 4], nil];
		currentlySelectedOptions = [[NSMutableDictionary alloc] initWithObjects: objs forKeys: headings];
	}
    return self;
}


- (int) getWidth {
	return [[currentlySelectedOptions objectForKey: @"Width"] integerValue];
}


- (int) getHeight {
	return [[currentlySelectedOptions objectForKey: @"Height"] integerValue];
}


- (int) getPieces {
	return [[currentlySelectedOptions objectForKey: @"Pieces"] integerValue];
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
	else if (sender.tag == 2)
		[currentlySelectedOptions setObject: [NSNumber numberWithInt: [sender selectedSegmentIndex] + 4]
									 forKey: @"Height"];
	else
		[currentlySelectedOptions setObject: [NSNumber numberWithInt: [sender selectedSegmentIndex] + 3]
									 forKey: @"Pieces"];
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
    return 3;
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
	if (indexPath.section == 2) {
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
	int selected = [[currentlySelectedOptions objectForKey: [self tableView: tableView titleForHeaderInSection: indexPath.section]] intValue];
	if (indexPath.section == 2)
		[segment setSelectedSegmentIndex: 1];
	else
		[segment setSelectedSegmentIndex: selected - 4];
	segment.segmentedControlStyle = UISegmentedControlStyleBar;
	segment.tintColor = [UIColor colorWithRed: 26.0/255 green: 120.0/255 blue: 179.0/255 alpha: 1.0];
	segment.tag = indexPath.section + 1;
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

