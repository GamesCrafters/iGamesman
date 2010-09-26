//
//  GCOthelloOptionMenu.m
//  GamesmanMobile
//
//  Created by Class Account on 9/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCOthelloOptionMenu.h"


@implementation GCOthelloOptionMenu
@synthesize delegate;

#pragma mark -
#pragma mark Initialization

-(id) initWithGame: (GCOthello *) _game {
	if (self = [super initWithStyle: UITableViewStyleGrouped]) {
		game = _game;
	}
	return self;
}

- (void) cancel {
	[delegate rulesPanelDidFinish];
}


- (void) done {
	game.cols = cols;
	game.rows = rows;
	game.misere = misere;
	[game resetBoard];
	[delegate rulesPanelDidFinish];
}

- (void) update: (UISegmentedControl *) sender {
	int tag = sender.tag;
	if (tag == 2) cols = [sender selectedSegmentIndex] + 4;
	else if (tag == 1) rows = [sender selectedSegmentIndex] + 4;
	else misere = [sender selectedSegmentIndex] == 0 ? NO : YES;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Othello Rules";
	
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


#pragma mark -
#pragma mark Table view data source

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[NSArray arrayWithObjects: @"Width", @"Height", @"Misère", nil] objectAtIndex: section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
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
	if (indexPath.section == 0 || indexPath.section == 1) {
		[segment insertSegmentWithTitle: @"4" atIndex: 0 animated: NO];
		[segment insertSegmentWithTitle: @"5" atIndex: 1 animated: NO];
		[segment insertSegmentWithTitle: @"6" atIndex: 2 animated: NO];
		[segment insertSegmentWithTitle: @"7" atIndex: 3 animated: NO];
		[segment insertSegmentWithTitle: @"8" atIndex: 4 animated: NO];
	} else {
		[segment insertSegmentWithTitle: @"Standard" atIndex: 0 animated: NO];
		[segment insertSegmentWithTitle: @"Misère" atIndex: 1 animated: NO];
	}
	
	int selected;
	if (indexPath.section == 0) selected = game.rows - 4;
	if (indexPath.section == 1) selected = game.cols - 4;
	if (indexPath.section == 2) selected = game.misere ? 1 : 0;
	[segment setSelectedSegmentIndex: selected];
	
	segment.segmentedControlStyle = UISegmentedControlStyleBar;
	segment.tintColor = [UIColor colorWithRed: 28.0/255 green: 127.0/255 blue: 189.0/255 alpha: 1.0];
	segment.tag = indexPath.section + 1;
	[segment addTarget: self action: @selector(update:) forControlEvents: UIControlEventValueChanged];
	[cell addSubview: segment];
	[segment release];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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

