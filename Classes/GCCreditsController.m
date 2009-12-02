//
//  GCCreditsController.m
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/24/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCCreditsController.h"


@implementation GCCreditsController


- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		self.title = @"Gamesman Credits";
		self.tableView.allowsSelection = NO;
		
		headers = [[NSArray alloc] initWithObjects: @"GamesmanMobile", @"Project Lead", @"Team Lead",
				   @"Connect-4", @"GamesmanJava Team\n(Connect-4 Databases)", nil];
		NSArray *java = [NSArray arrayWithObjects: @"Alex Trofimov", @"David Spies", 
						 @"James Yeh", @"Jason Davidson", @"Jeremy Fleischman", @"Jin-Su Oh", 
						 @"Patrick Horn", @"Steven Schlansker", @"Wesley Hart", nil];
		info    = [[NSArray alloc] initWithObjects: @"Version 0.5.7", @"Dan Garcia", @"Kevin Jorgensen", 
				   @"Kevin Jorgensen", java, nil];
    }
    return self;
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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
    return MIN([headers count], [info count]);
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([[info objectAtIndex: section] isKindOfClass: [NSString class]])
		return 1;
	else
		return [[info objectAtIndex: section] count];
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [headers objectAtIndex: section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		cell.backgroundColor = [UIColor colorWithRed: 234.0/255 green: 234.0/255 blue: 255.0/255 alpha: 1];
		
		UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(20, 0, 280, 44)];
		label.tag = 111;
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize: 16.0];
		[cell addSubview: label];
    }
    
    // Set up the cell...
	UILabel *label = (UILabel *) [cell viewWithTag: 111];
	if ([[info objectAtIndex: indexPath.section] isKindOfClass: [NSString class]])
		label.text = [info objectAtIndex: indexPath.section];
	else
		label.text = [[info objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
	
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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


- (void)dealloc {
    [super dealloc];
}


@end

