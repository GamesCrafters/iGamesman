//
//  GCQuickCrossOptionMenu.m
//  GamesmanMobile
//
//  Created by Andrew Zhai and Chih Hu on 9/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCQuickCrossOptionMenu.h"


@implementation GCQuickCrossOptionMenu

@synthesize delegate;


#pragma mark -
#pragma mark Initialization

- (id) initWithGame: (GCQuickCross *) _game {
	if (self = [super initWithStyle: UITableViewStyleGrouped]) {
		self.tableView.allowsSelection = NO;
		game = _game;
		width  = game.rows;
		height = game.cols;
		pieces = game.inalign;
		misere = [game isMisere];
		
		headings = [[NSArray alloc] initWithObjects: @"Width", @"Height", @"In-Align", @"Misère", nil];	}
	return self;
}

- (void) cancel {
	[delegate rulesPanelDidFinish];
}


- (void) done {
	game.rows = width;
	game.cols = height;
	game.inalign = pieces;
	game.misere = misere;
	
	[game resetBoard];
	
	[delegate rulesPanelDidFinish];
}


- (void) update: (UISegmentedControl *) sender {
	int tag = sender.tag;
	if (tag == 100) width = [sender selectedSegmentIndex] + 3;
	else if (tag == 101) height = [sender selectedSegmentIndex] + 3;
	else if (tag == 102)  pieces = [sender selectedSegmentIndex] + 3;
	else misere = [sender selectedSegmentIndex] == 0 ? NO : YES;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"QuickCross Rules";
	
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
	return [[NSArray arrayWithObjects: @"Width", @"Height", @"In-Align", @"Misère", nil] objectAtIndex: section];
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
	if (indexPath.section == 2) selected = game.inalign - 3;
	if (indexPath.section == 3) selected = game.misere ? 1 : 0;
	[segment setSelectedSegmentIndex: selected];
	
	segment.segmentedControlStyle = UISegmentedControlStyleBar;
	segment.tintColor = [UIColor colorWithRed: 28.0/255 green: 127.0/255 blue: 189.0/255 alpha: 1.0];
	segment.tag = 100 + indexPath.section;
	[segment addTarget:self action:@selector(update:) forControlEvents: UIControlEventValueChanged];
	[cell addSubview: segment];
	[segment release];
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
