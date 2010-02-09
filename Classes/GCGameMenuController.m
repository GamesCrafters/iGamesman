//
//  GCGameMenuController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/14/09.
//  Copyright 2009 Gamesman. All rights reserved.
//

#import "GCGameMenuController.h"
#import "GCGame.h"


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
 
 @param game the game object
 @param gameName the name of the game
 */
- (id)initWithGame: (id) _game andName: (NSString *) gameName {
	if (self = [super initWithStyle: UITableViewStyleGrouped]) {
		self.title = gameName;
		
		NSArray *play = [[NSArray alloc] initWithObjects: @"Play solved game\n(Web connection required)", 
						 @"Play solved game offline\n(Solved database required)", 
						 @"Play unsolved game\nNo Web connection", nil];
		NSArray *options = [[NSArray alloc] initWithObjects: @"Change rules", 
							@"Player 1 Name", @"Player 2 Name", nil];
		cellLabels = [[NSArray alloc] initWithObjects: play, options, nil];
		[play release];
		[options release];
		
		if ([_game conformsToProtocol: @protocol(GCGame)])
			game = _game;
		
		p1Name = [game player1Name];
		p2Name = [game player2Name];
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
	if (section == 0) {
		int supported = 0;
		if ([game supportsGameMode: ONLINESOLVED]) supported += 1;
		if ([game supportsGameMode: OFFLINESOLVED]) supported += 1;
		if ([game supportsGameMode: OFFLINEUNSOLVED]) supported += 1;
		return supported;
	} else
		return [[cellLabels objectAtIndex: section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
	// Cell reuse stuff
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.backgroundColor = [UIColor colorWithRed: 234.0/255 green: 234.0/255 blue: 255.0/255 alpha: 1];
		
		int height = [self tableView: tableView heightForRowAtIndexPath: indexPath];
		UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(20, 0, 280, height)];
		label.font = [UIFont boldSystemFontOfSize: 17.0];
		label.tag = 111;
		label.backgroundColor = [UIColor clearColor];
		[cell addSubview: label];
		[label release];
	}
    
	// Set up the cell
	UILabel *label = (UILabel *) [cell viewWithTag: 111];
	if (indexPath.section == 0) {
		int r = 0;
		if ([game supportsGameMode: ONLINESOLVED]) {
			r += 1;
			label.text = [[cellLabels objectAtIndex: 0] objectAtIndex: 0];
		}
		if ([game supportsGameMode: OFFLINESOLVED]) {
			r += 1;
			label.text = [[cellLabels objectAtIndex: 0] objectAtIndex: 1];
		}
		if ([game supportsGameMode: OFFLINEUNSOLVED]) {
			r += 1;
			label.text = [[cellLabels objectAtIndex: 0] objectAtIndex: 2];
		}
	} else
		label.text = [[cellLabels objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
	label.numberOfLines = 2;
	
	if (indexPath.section == 1 && indexPath.row > 0) {
		label.textColor = [UIColor lightGrayColor];
		label.font = [UIFont systemFontOfSize: 16.0];
	}
	
	if (indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2)) {
		CGSize S = [label.text sizeWithFont: label.font];
		UILabel *name = [[UILabel alloc] initWithFrame: 
						 CGRectMake(S.width + 30, 10, cell.bounds.size.width - S.width - 40, cell.bounds.size.height - 20)];
		name.backgroundColor = [UIColor clearColor];
		if (indexPath.row == 1)
			name.text = p1Name;
		else
			name.text = p2Name;
		
		name.tag = 2;
		[cell addSubview: name];
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		GCGameViewController *viewControl = [[GCGameViewController alloc] initWithGame: game];
		viewControl.delegate = self;
		viewControl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[self presentModalViewController: viewControl animated: YES];
	} else if (indexPath.row == 0) {
		id menu = [game getOptionMenu];
		if ([menu conformsToProtocol: @protocol(GCOptionMenu)]) {
			[menu setDelegate: self];
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: menu];
			nav.navigationBar.tintColor = [UIColor colorWithRed: 0 green: 0 blue: 139.0/256.0 alpha: 1];
			[self presentModalViewController: nav animated: YES];
			[nav release];
		}
	} else if (indexPath.row == 1 || indexPath.row == 2) {
		GCNameChangeController *nameChanger = [[GCNameChangeController alloc] initWithPlayerNumber: indexPath.row];
		nameChanger.delegate = self;
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: nameChanger];
		nav.navigationBar.tintColor = [UIColor colorWithRed: 0 green: 0 blue: 139.0/256.0 alpha: 1];
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


- (void) nameChangerDidFinishWithPlayer:(NSInteger)playerNum andNewName: (NSString *) name {
	UILabel *nameLabel = (UILabel *) [[self.tableView cellForRowAtIndexPath: 
									   [NSIndexPath indexPathForRow: playerNum inSection: 1]] viewWithTag: 2];
	nameLabel.text = name;
	[self dismissModalViewControllerAnimated: YES];
	
	if (playerNum == 1)
		[game setPlayer1Name: name];
	else
		[game setPlayer2Name: name];
}


- (void) rulesPanelDidFinish {
	[self dismissModalViewControllerAnimated: YES];
}


- (void)dealloc {
	[cellLabels release];
    [super dealloc];
}


@end

