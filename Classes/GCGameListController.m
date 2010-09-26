//
//  GCGameListController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/12/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCGameListController.h"
#import "GCGameMenuController.h"

#import "GCGame.h"
#import "GCConnectFour.h"
#import "GCConnections.h"
#import "GCTicTacToe.h"
#import "GCOthello.h"
#import "GCQuickCross.h"
#import "GCYGame.h"


@implementation GCGameListController


- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		self.title = @"Games";
		
		GCConnectFour *c4 = [[GCConnectFour alloc] init];
		GCConnections *con = [[GCConnections alloc] init];
		GCTicTacToe *ttt = [[GCTicTacToe alloc] init];
		GCOthello *othello = [[GCOthello alloc] init];
		GCQuickCross *qc = [[GCQuickCross alloc] init];
		GCYGame *y = [[GCYGame alloc] init];
		NSArray *objs = [[[NSArray alloc] initWithObjects: c4, con, othello, qc, ttt, y, nil] autorelease];
		
		NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
		if (stdDefaults) {
			for (GCGame *game in objs) {
				NSString *gameName = [game gameName];
				NSString *p1Name = [stdDefaults objectForKey: [NSString stringWithFormat: @"Player 1 %@", gameName]];
				NSString *p2Name = [stdDefaults objectForKey: [NSString stringWithFormat: @"Player 2 %@", gameName]];
				if (p1Name) [game setPlayer1Name: p1Name];
				if (p2Name) [game setPlayer2Name: p2Name];
			}
		}
		
		[c4 release];
		[con release];
		[othello release];
		[qc release];
		[ttt release];
		[y release];
		
		NSMutableArray *temp = [[NSMutableArray alloc] init];
		for (GCGame *G in objs)
			[temp addObject: [G gameName]];
		gameNames = temp;
		
		games = [[NSDictionary alloc] initWithObjects: objs forKeys: gameNames];
		
		self.tableView.backgroundColor = [UIColor colorWithRed: 234.0/255 green: 234.0/255 blue: 255.0/255 alpha: 1];
		self.tableView.separatorColor = [UIColor lightGrayColor];
	}
    return self;
}


- (void) saveNames {
	NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
	if (stdDefaults) {
		for (NSString *name in games) {
			GCGame *game = [games objectForKey: name];
			NSString *p1Name = [game player1Name];
			NSString *p2Name = [game player2Name];
			[stdDefaults setObject: p1Name forKey: [NSString stringWithFormat: @"Player 1 %@", name]];
			[stdDefaults setObject: p2Name forKey: [NSString stringWithFormat: @"Player 2 %@", name]];
		}
		[stdDefaults synchronize];
	}
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

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [gameNames count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame: CGRectZero reuseIdentifier: CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.textLabel.text = [gameNames objectAtIndex: indexPath.row];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *gameName = [tableView cellForRowAtIndexPath: indexPath].textLabel.text;
	
	GCGame *game = (GCGame *) [games objectForKey: gameName];
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	GCGameMenuController *menuControl = [[GCGameMenuController alloc] initWithGame: game andName: gameName];
	[self.navigationController pushViewController: menuControl animated: YES];
	[menuControl release];
}


- (void)dealloc {
	[gameNames release];
	[games release];
    [super dealloc];
}


@end

