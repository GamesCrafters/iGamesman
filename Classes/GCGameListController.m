//
//  GCGameListController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/12/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCGameListController.h"
#import "GCGameMenuController.h"


@implementation GCGameListController


- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		self.title = @"Games";
		games = [[NSArray alloc] initWithObjects: @"1 to 10", @"Connect-4", @"Tic-Tac-Toe", nil];
	}
    return self;
}


#pragma mark View controller delegate methods
/*
- (void)viewDidLoad { [super viewDidLoad]; }
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
    return [games count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
	// Cell reuse stuff
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Set up the cell
    cell.textLabel.text = [games objectAtIndex: indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *gameName = [tableView cellForRowAtIndexPath: indexPath].textLabel.text;
	
	id game;
	game = nil;
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	if ([gameName isEqualToString: @"Connect-4"]) {
		GCGameMenuController *menuControl = [[GCGameMenuController alloc] initWithGame: nil	andName: gameName];
		[self.navigationController pushViewController: menuControl animated: YES];
		[menuControl release];
	}
}


- (void)dealloc {
	[games release];
    [super dealloc];
}


@end

