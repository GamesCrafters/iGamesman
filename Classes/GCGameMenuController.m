//
//  GCGameMenuController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCGameMenuController.h"
#import "GCOptionMenu.h"


@implementation GCGameMenuController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (id)initWithGame: (GCGame *) _game andName: (NSString *) gameName {
	if (self = [super initWithStyle: UITableViewStyleGrouped]) {
		self.title = gameName;
		
		game = _game;
		
		section0 = [[NSArray alloc] initWithObjects: @"Play solved game\n(Web connection required)",
					@"Play unsolved game\nNo Web connection", nil];

		section1 = [[NSArray alloc] initWithObjects: @"Change Rules", @"Player 1 Name\nPlayer Type", 
					@"Player 2 Name\nPlayer Type", nil];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
		int supported = 0;
		
		if ([game supportsPlayMode: ONLINE_SOLVED]) supported += 1;
		if ([game supportsPlayMode: OFFLINE_UNSOLVED]) supported += 1;
		
		return supported;
	} else
		return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0)
		return 66.0;
	else if (indexPath.row == 1 || indexPath.row == 2)
		return 62.0;
	else
		return 44.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
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
    
    // Set up the cell...
	UILabel *label = (UILabel *) [cell viewWithTag: 111];
	if (indexPath.section == 0) {
		label.numberOfLines = 2;
		int r = [tableView numberOfRowsInSection: indexPath.section];
		
		if (r == 2)
			label.text = [section0 objectAtIndex: indexPath.row];
		if (r == 1) {
			if ([game supportsPlayMode: ONLINE_SOLVED])
				label.text = [section0 objectAtIndex: 0];
			else if ([game supportsPlayMode: OFFLINE_UNSOLVED])
				label.text = [section0 objectAtIndex: 1];
		}
	} else {
		label.numberOfLines = 2;
		label.text = [section1 objectAtIndex: indexPath.row];
		
		if (indexPath.row > 0) {
			label.textColor = [UIColor lightGrayColor];
			label.font = [UIFont systemFontOfSize: 16.0];
			
			NSString *firstLine = [label.text substringToIndex: [label.text rangeOfString: @"\n"].location];
			
			CGSize S = [firstLine sizeWithFont: label.font];
			UILabel *name = [[UILabel alloc] initWithFrame: 
							 CGRectMake(S.width + 30, 10, cell.bounds.size.width - S.width - 40, cell.bounds.size.height)];
			name.backgroundColor = [UIColor clearColor];
			name.numberOfLines = 2;
			if (indexPath.row == 1) {
				PlayerType p1 = [game player1Type];
				NSString *type = (p1 == HUMAN) ? @"Human" : ( (p1 == COMPUTER_RANDOM) ? @"Computer (random)" : @"Computer (perfect");
				name.text = [NSString stringWithFormat: @"%@\n%@", [game player1Name], type];
			} else {
				PlayerType p2 = [game player2Type];
				NSString *type = (p2 == HUMAN) ? @"Human" : ( (p2 == COMPUTER_RANDOM) ? @"Computer (random)" : @"Computer (perfect");
				name.text = [NSString stringWithFormat: @"%@\n%@", [game player2Name], type];
			}
			
			name.tag = 222;
			[cell addSubview: name];
			[name release];
		}
	}
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		UILabel *L = (UILabel *) [[tableView cellForRowAtIndexPath: indexPath] viewWithTag: 111];
		int index = [section0 indexOfObject: L.text];
		PlayMode M = (index == 0) ? ONLINE_SOLVED : OFFLINE_UNSOLVED;
		GCGameViewController *gameView = [[GCGameViewController alloc] initWithGame: game andPlayMode: M];
		gameView.delegate = self;
		gameView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[self presentModalViewController: gameView animated: YES];
		[gameView release];
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		id menu = [game optionMenu];
		if ([menu conformsToProtocol: @protocol(GCOptionMenu)]) {
			[menu setDelegate: self];
			
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: menu];
			nav.navigationBar.tintColor = [UIColor colorWithRed: 0 green: 0 blue: 139.0/256.0 alpha: 1];
			
			[self presentModalViewController: nav animated: YES];
			[nav release];
		}
	} else if (indexPath.section == 1 && indexPath.row > 0) {
		GCPlayerChangeController *nameChanger = [[GCPlayerChangeController alloc] initWithPlayerNumber: indexPath.row
																						   andGame: game];
		nameChanger.delegate = self;
		
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: nameChanger];
		nav.navigationBar.tintColor = [UIColor colorWithRed: 0 green: 0 blue: 139.0/256.0 alpha: 1];
		
		[nameChanger release];
		[self presentModalViewController: nav animated: YES];
		[nav release];
	} else
		[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (void) nameChangerDidCancel {
	[self dismissModalViewControllerAnimated: YES];
}


- (void) nameChangerDidFinishWithPlayer:(NSInteger)playerNum 
								newName: (NSString *) name
						  andPlayerType: (PlayerType) type {
	UILabel *nameLabel = (UILabel *) [[self.tableView cellForRowAtIndexPath: 
									   [NSIndexPath indexPathForRow: playerNum inSection: 1]] viewWithTag: 222];
	NSString *_type = (type == HUMAN) ? @"Human" : ( (type == COMPUTER_RANDOM) ? @"Computer (random)" : @"Computer (perfect)");
	nameLabel.text = [NSString stringWithFormat: @"%@\n%@", [game player1Name], _type];
	
	[self dismissModalViewControllerAnimated: YES];
	
	if (playerNum == 1) {
		[game setPlayer1Name: name];
		[game setPlayer1Type: type];
	} else {
		[game setPlayer2Name: name];
		[game setPlayer2Type: type];
	}
}

- (void) rulesPanelDidFinish {
	[self dismissModalViewControllerAnimated: YES];
}

- (void) flipsideViewControllerDidFinish: (GCGameViewController *) controller {
	[self dismissModalViewControllerAnimated: YES];
}

- (void)dealloc {
	[section0 release];
	[section1 release];
    [super dealloc];
}


@end

