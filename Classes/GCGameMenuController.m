//
//  GCGameMenuController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/14/09.
//  Copyright 2009 Gamesman. All rights reserved.
//

#import "GCGameMenuController.h"
#import "GCGameViewController.h"
#import "GCNameChangeController.h"


@implementation GCGameMenuController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


/**
 The designated initializer
 
 @param game the game object (currently unused)
 @param gameName the name of the game
 */
- (id)initWithGame: (id) game andName: (NSString *) gameName {
	if (self = [super initWithStyle: UITableViewStyleGrouped]) {
		self.title = gameName;
		
		NSArray *play = [[NSArray alloc] initWithObjects: @"Play solved game\n(Web connection required)", nil];
		NSArray *options = [[NSArray alloc] initWithObjects: @"Change rules", 
							@"Player 1 Name", @"Player 2 Name", nil];
		cellLabels = [[NSArray alloc] initWithObjects: play, options, nil];
		[play release];
		[options release];
		
		p1Name = @"Player 1";
		p2Name = @"Player 2";
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
    return [cellLabels count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[cellLabels objectAtIndex: section] count];
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
    cell.textLabel.text = [[cellLabels objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
	cell.textLabel.numberOfLines = 2;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	if (indexPath.section == 1 && indexPath.row > 0) {
		cell.textLabel.textColor = [UIColor lightGrayColor];
		cell.textLabel.font = [UIFont systemFontOfSize: 16.0];
	}
	
	if (indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2)) {
		CGSize S = [cell.textLabel.text sizeWithFont: cell.textLabel.font];
		UILabel *name = [[UILabel alloc] initWithFrame: 
						 CGRectMake(S.width + 30, 10, cell.bounds.size.width - S.width - 40, cell.bounds.size.height - 20)];
		if (indexPath.row == 1)
			name.text = p1Name;
		else
			name.text = p2Name;
		
		[cell addSubview: name];
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		GCGameViewController *viewControl = [[GCGameViewController alloc] initWithNibName: @"GameView" bundle:nil];
		viewControl.delegate = self;
		viewControl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[self presentModalViewController: viewControl animated: YES];
		[viewControl release];
	} else if (indexPath.row == 1 || indexPath.row == 2) {
		GCNameChangeController *nameChanger = [[GCNameChangeController alloc] initWithNibName: @"NameChanger" 
																					   bundle: nil];
		nameChanger.delegate = self;
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: nameChanger];
		[nameChanger release];
		[self presentModalViewController: nav animated: YES];
		[nav release];
	} else
		[tableView deselectRowAtIndexPath: indexPath animated: YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0)
		return 66.0;
	else
		return 44.0;
}


/** Flipside delegate method. Dismisses the game view. */
- (void) flipsideViewControllerDidFinish: (GCGameViewController *) controller {
	[self dismissModalViewControllerAnimated: YES];
}


- (void) nameChangerDidCancel {
	[self dismissModalViewControllerAnimated: YES];
}


- (void)dealloc {
	[cellLabels release];
    [super dealloc];
}


@end

